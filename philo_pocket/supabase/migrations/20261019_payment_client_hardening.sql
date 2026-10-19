-- Prevent client sessions from approving Mobile Money payments.
-- Payment rows submitted by an app are requests only; a trusted provider
-- callback/backend must be the only component that marks them validated.

ALTER TABLE public.paiements_mobile_money ENABLE ROW LEVEL SECURITY;

-- Remove every prior policy on this table so permissive policies from older
-- installations cannot combine with the restrictive policy below.
DO $$
DECLARE
    policy_row RECORD;
BEGIN
    FOR policy_row IN
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'paiements_mobile_money'
    LOOP
        EXECUTE format(
            'DROP POLICY %I ON public.paiements_mobile_money',
            policy_row.policyname
        );
    END LOOP;
END;
$$;

CREATE POLICY "Users read their own payment requests"
    ON public.paiements_mobile_money
    FOR SELECT
    TO authenticated
    USING (auth.uid() = utilisateur_id);

CREATE POLICY "Users can create pending payment requests"
    ON public.paiements_mobile_money
    FOR INSERT
    TO authenticated
    WITH CHECK (
        auth.uid() = utilisateur_id
        AND statut = 'en_attente'
        AND valide_le IS NULL
        AND montant > 0
    );

-- Remove any legacy client write policies from subscriptions as well. Reads
-- remain governed by the existing own-subscription SELECT policy.
DO $$
DECLARE
    policy_row RECORD;
BEGIN
    FOR policy_row IN
        SELECT policyname
        FROM pg_policies
        WHERE schemaname = 'public'
          AND tablename = 'abonnements'
          AND cmd IN ('INSERT', 'UPDATE', 'DELETE', 'ALL')
    LOOP
        EXECUTE format(
            'DROP POLICY %I ON public.abonnements',
            policy_row.policyname
        );
    END LOOP;
END;
$$;

-- No client write policy is intentionally created for either table. A trusted
-- payment backend must validate the provider callback and activate subscriptions.
