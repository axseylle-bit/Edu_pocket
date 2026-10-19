-- Server-owned roles, editorial publication transitions, teacher application
-- authorization and atomic daily AI quotas.

-- Keep the role vocabulary used by the current clients and legacy schemas.
DO $$
DECLARE
    role_constraint RECORD;
BEGIN
    FOR role_constraint IN
        SELECT conname
        FROM pg_constraint
        WHERE conrelid = 'public.utilisateurs'::regclass
          AND contype = 'c'
          AND pg_get_constraintdef(oid) ILIKE '%role%'
    LOOP
        EXECUTE format('ALTER TABLE public.utilisateurs DROP CONSTRAINT %I', role_constraint.conname);
    END LOOP;
END;
$$;

ALTER TABLE public.utilisateurs
    ADD CONSTRAINT utilisateurs_role_allowed_check
    CHECK (role IN ('eleve', 'parent', 'enseignant', 'professeur', 'curieux', 'admin', 'superadmin', 'coordinator'));

CREATE OR REPLACE FUNCTION public.prevent_client_privileged_role()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, auth
AS $$
BEGIN
    IF auth.role() = 'authenticated'
       AND NEW.role IN ('admin', 'superadmin', 'coordinator')
       AND (TG_OP = 'INSERT' OR NEW.role IS DISTINCT FROM OLD.role) THEN
        RAISE EXCEPTION 'Les rôles privilégiés sont attribués uniquement côté serveur.';
    END IF;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS utilisateurs_prevent_client_privileged_role ON public.utilisateurs;
CREATE TRIGGER utilisateurs_prevent_client_privileged_role
    BEFORE INSERT OR UPDATE ON public.utilisateurs
    FOR EACH ROW
    EXECUTE FUNCTION public.prevent_client_privileged_role();

REVOKE ALL ON FUNCTION public.prevent_client_privileged_role() FROM PUBLIC, anon, authenticated;

-- Rebuild policies instead of relying on policy names from earlier revisions.
DO $$
DECLARE
    policy_row RECORD;
BEGIN
    FOR policy_row IN
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'cours_soumis_enseignants'
    LOOP
        EXECUTE format('DROP POLICY %I ON public.cours_soumis_enseignants', policy_row.policyname);
    END LOOP;
END;
$$;

CREATE POLICY "Teacher reads own submissions"
    ON public.cours_soumis_enseignants
    FOR SELECT TO authenticated
    USING (auth.uid() = enseignant_id);

CREATE POLICY "Authenticated users read published submissions"
    ON public.cours_soumis_enseignants
    FOR SELECT TO authenticated
    USING (statut_editorial = 'publie');

CREATE POLICY "Teacher edits unpublished drafts"
    ON public.cours_soumis_enseignants
    FOR UPDATE TO authenticated
    USING (
        auth.uid() = enseignant_id
        AND statut_editorial IN ('brouillon', 'rejete_avec_commentaires')
    )
    WITH CHECK (
        auth.uid() = enseignant_id
        AND statut_editorial IN ('brouillon', 'rejete_avec_commentaires')
    );

-- Fix the role lookup to use the identity table provided by this project and
-- remove unknown permissive policies that could override the intended rules.
ALTER TABLE public.teacher_applications ENABLE ROW LEVEL SECURITY;
DO $$
DECLARE
    policy_row RECORD;
BEGIN
    FOR policy_row IN
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'teacher_applications'
    LOOP
        EXECUTE format('DROP POLICY %I ON public.teacher_applications', policy_row.policyname);
    END LOOP;
END;
$$;

CREATE POLICY "Anyone can submit an application"
    ON public.teacher_applications
    FOR INSERT TO public
    WITH CHECK (user_id IS NULL OR user_id = auth.uid());

CREATE POLICY "Applicants and administrators read applications"
    ON public.teacher_applications
    FOR SELECT TO authenticated
    USING (
        auth.uid() = user_id
        OR EXISTS (
            SELECT 1
            FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    );

CREATE POLICY "Administrators update applications"
    ON public.teacher_applications
    FOR UPDATE TO authenticated
    USING (
        EXISTS (
            SELECT 1
            FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1
            FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    );

-- A client cannot publish or alter its own AI quota. Only the SECURITY
-- DEFINER RPC below can increment the server-side usage counter.
CREATE TABLE IF NOT EXISTS public.ai_usage_daily (
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    usage_date DATE NOT NULL,
    request_count INTEGER NOT NULL DEFAULT 0 CHECK (request_count >= 0),
    last_request_at TIMESTAMPTZ,
    PRIMARY KEY (user_id, usage_date)
);

ALTER TABLE public.ai_usage_daily ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON TABLE public.ai_usage_daily FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.consume_daily_ai_quota()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = pg_catalog, public, auth
AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_limit INTEGER := 5;
    v_usage_date DATE := timezone('utc', now())::date;
    v_count INTEGER := 0;
    v_last_request TIMESTAMPTZ;
    v_subscription TEXT;
BEGIN
    IF v_user_id IS NULL THEN
        RETURN jsonb_build_object('allowed', false, 'reason', 'authentication_required');
    END IF;

    SELECT palier
      INTO v_subscription
      FROM public.abonnements
     WHERE utilisateur_id = v_user_id
       AND statut = 'actif'
       AND (date_fin IS NULL OR date_fin > now())
     ORDER BY date_fin DESC NULLS LAST
     LIMIT 1;

    IF coalesce(v_subscription, '') ILIKE ANY (ARRAY['%confort%', '%aristote%', '%eiffel%', '%expert%', '%filiere%', '%trimestre%', '%annuel%']) THEN
        v_limit := 150;
    ELSIF coalesce(v_subscription, '') ILIKE ANY (ARRAY['%essentiel%', '%platon%', '%vinci%', '%solo%', '%premium%', '%technique_essentiel%']) THEN
        v_limit := 40;
    END IF;

    PERFORM pg_advisory_xact_lock(hashtextextended(v_user_id::text, 0));

    SELECT request_count, last_request_at
      INTO v_count, v_last_request
      FROM public.ai_usage_daily
     WHERE user_id = v_user_id AND usage_date = v_usage_date
     FOR UPDATE;

    v_count := coalesce(v_count, 0);

    IF v_count >= v_limit THEN
        RETURN jsonb_build_object('allowed', false, 'reason', 'daily_quota', 'remaining', 0);
    END IF;

    IF v_last_request IS NOT NULL AND v_last_request > now() - interval '1500 milliseconds' THEN
        RETURN jsonb_build_object('allowed', false, 'reason', 'rate_limit', 'remaining', v_limit - v_count);
    END IF;

    INSERT INTO public.ai_usage_daily (user_id, usage_date, request_count, last_request_at)
    VALUES (v_user_id, v_usage_date, 1, now())
    ON CONFLICT (user_id, usage_date)
    DO UPDATE SET request_count = public.ai_usage_daily.request_count + 1,
                  last_request_at = EXCLUDED.last_request_at;

    RETURN jsonb_build_object('allowed', true, 'remaining', v_limit - v_count - 1);
END;
$$;

REVOKE ALL ON FUNCTION public.consume_daily_ai_quota() FROM PUBLIC, anon;
GRANT EXECUTE ON FUNCTION public.consume_daily_ai_quota() TO authenticated;
