-- ==============================================================================
-- Migration Supabase : Durcissement Majeur de la Sécurité & Conformité APDPVP
-- Date : 11 Octobre 2026
-- Application : Philo Pocket / e-eduPocket
-- ==============================================================================

-- 1. Activation stricte de Row Level Security (RLS) sur toutes les tables
ALTER TABLE IF EXISTS public.utilisateurs ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.profils_eleves ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.liaisons_parents ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.suivi_progression ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.abonnements ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.disciplines ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.cours ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.notions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.quiz ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.reponses ENABLE ROW LEVEL SECURITY;

-- ------------------------------------------------------------------------------
-- 2. POLITIQUES POUR 'utilisateurs'
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS "utilisateurs_select_policy" ON public.utilisateurs;
CREATE POLICY "utilisateurs_select_policy" ON public.utilisateurs
    FOR SELECT USING (
        -- L'utilisateur peut voir son propre profil
        auth.uid() = id
        -- Un parent peut voir le nom et infos de ses enfants liés
        OR EXISTS (
            SELECT 1 FROM public.liaisons_parents lp 
            WHERE lp.parent_id = auth.uid() AND lp.eleve_id = public.utilisateurs.id
        )
    );

DROP POLICY IF EXISTS "utilisateurs_insert_policy" ON public.utilisateurs;
CREATE POLICY "utilisateurs_insert_policy" ON public.utilisateurs
    FOR INSERT WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "utilisateurs_update_policy" ON public.utilisateurs;
CREATE POLICY "utilisateurs_update_policy" ON public.utilisateurs
    FOR UPDATE USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- ------------------------------------------------------------------------------
-- 3. POLITIQUES POUR 'profils_eleves' (CORRECTION FAILLE DE CONFIDENTIALITÉ)
-- ------------------------------------------------------------------------------
-- SUPPRESSION du `OR (auth.role() = 'authenticated')` qui fuyait les données de tous les élèves !
DROP POLICY IF EXISTS "profils_eleves_select_policy" ON public.profils_eleves;
CREATE POLICY "profils_eleves_select_policy" ON public.profils_eleves
    FOR SELECT USING (
        -- L'élève voit son propre profil
        auth.uid() = utilisateur_id
        -- Un parent voit uniquement le profil de ses enfants formellement liés
        OR EXISTS (
            SELECT 1 FROM public.liaisons_parents lp 
            WHERE lp.parent_id = auth.uid() AND lp.eleve_id = public.profils_eleves.utilisateur_id
        )
    );

DROP POLICY IF EXISTS "profils_eleves_insert_policy" ON public.profils_eleves;
CREATE POLICY "profils_eleves_insert_policy" ON public.profils_eleves
    FOR INSERT WITH CHECK (auth.uid() = utilisateur_id);

DROP POLICY IF EXISTS "profils_eleves_update_policy" ON public.profils_eleves;
CREATE POLICY "profils_eleves_update_policy" ON public.profils_eleves
    FOR UPDATE USING (auth.uid() = utilisateur_id) WITH CHECK (auth.uid() = utilisateur_id);

-- ------------------------------------------------------------------------------
-- 4. POLITIQUES POUR 'liaisons_parents'
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS "liaisons_parents_select_policy" ON public.liaisons_parents;
CREATE POLICY "liaisons_parents_select_policy" ON public.liaisons_parents
    FOR SELECT USING (auth.uid() = parent_id OR auth.uid() = eleve_id);

DROP POLICY IF EXISTS "liaisons_parents_delete_policy" ON public.liaisons_parents;
CREATE POLICY "liaisons_parents_delete_policy" ON public.liaisons_parents
    FOR DELETE USING (auth.uid() = parent_id OR auth.uid() = eleve_id);

-- Suppression de l'INSERT direct libre : la création de liaison passe OBLIGATOIREMENT 
-- par la fonction RPC `lier_parent_eleve` pour valider le code d'invitation secret !
DROP POLICY IF EXISTS "liaisons_parents_insert_policy" ON public.liaisons_parents;

-- ------------------------------------------------------------------------------
-- 5. FONCTION RPC SÉCURISÉE : LIAISON PARENT-ÉLÈVE
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.lier_parent_eleve(code_invitation_saisi TEXT)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER -- Exécutée avec les privilèges du créateur pour valider le code sans exposer toute la table
SET search_path = public, auth
AS $$
DECLARE
    v_parent_id UUID := auth.uid();
    v_code_clean TEXT;
    v_eleve_id UUID;
    v_nom_eleve TEXT;
BEGIN
    -- 1. Vérification de l'authentification
    IF v_parent_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'message', 'Vous devez être connecté.');
    END IF;

    -- 2. Nettoyage du code saisi
    v_code_clean := UPPER(TRIM(code_invitation_saisi));
    IF v_code_clean IS NULL OR LENGTH(v_code_clean) < 4 THEN
        RETURN jsonb_build_object('success', false, 'message', 'Code d''invitation invalide.');
    END IF;

    -- 3. Recherche de l'élève correspondant
    SELECT pe.utilisateur_id, u.nom
    INTO v_eleve_id, v_nom_eleve
    FROM public.profils_eleves pe
    JOIN public.utilisateurs u ON u.id = pe.utilisateur_id
    WHERE UPPER(pe.code_invitation) = v_code_clean;

    IF v_eleve_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'message', 'Aucun compte élève ne correspond à ce code d''invitation.');
    END IF;

    -- 4. Empêcher l'auto-liaison (un élève ne peut pas être son propre parent)
    IF v_eleve_id = v_parent_id THEN
        RETURN jsonb_build_object('success', false, 'message', 'Un compte ne peut pas être lié à lui-même.');
    END IF;

    -- 5. Création de la liaison dans liaisons_parents
    INSERT INTO public.liaisons_parents (parent_id, eleve_id, statut)
    VALUES (v_parent_id, v_eleve_id, 'actif')
    ON CONFLICT (parent_id, eleve_id) DO NOTHING;

    RETURN jsonb_build_object(
        'success', true, 
        'message', 'Liaison établie avec succès.',
        'eleve_nom', v_nom_eleve,
        'eleve_id', v_eleve_id
    );
END;
$$;

-- ------------------------------------------------------------------------------
-- 6. FONCTION RPC : SUPPRESSION DE COMPTE (Droit à l'oubli APDPVP & Google Play)
-- ------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.supprimer_mon_compte()
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public, auth
AS $$
DECLARE
    v_user_id UUID := auth.uid();
BEGIN
    IF v_user_id IS NULL THEN
        RETURN jsonb_build_object('success', false, 'message', 'Non authentifié.');
    END IF;

    -- Suppression en cascade des données associées
    DELETE FROM public.suivi_progression WHERE eleve_id = v_user_id;
    DELETE FROM public.liaisons_parents WHERE parent_id = v_user_id OR eleve_id = v_user_id;
    DELETE FROM public.profils_eleves WHERE utilisateur_id = v_user_id;
    DELETE FROM public.abonnements WHERE utilisateur_id = v_user_id;
    DELETE FROM public.transactions WHERE utilisateur_id = v_user_id;
    DELETE FROM public.utilisateurs WHERE id = v_user_id;

    -- Suppression du compte dans auth.users
    DELETE FROM auth.users WHERE id = v_user_id;

    RETURN jsonb_build_object('success', true, 'message', 'Compte et données supprimés définitivement.');
END;
$$;

-- ------------------------------------------------------------------------------
-- 7. POLITIQUES POUR 'suivi_progression'
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS "suivi_progression_select_policy" ON public.suivi_progression;
CREATE POLICY "suivi_progression_select_policy" ON public.suivi_progression
    FOR SELECT USING (
        auth.uid() = eleve_id
        OR EXISTS (
            SELECT 1 FROM public.liaisons_parents lp 
            WHERE lp.parent_id = auth.uid() AND lp.eleve_id = public.suivi_progression.eleve_id
        )
    );

DROP POLICY IF EXISTS "suivi_progression_insert_policy" ON public.suivi_progression;
CREATE POLICY "suivi_progression_insert_policy" ON public.suivi_progression
    FOR INSERT WITH CHECK (auth.uid() = eleve_id);

DROP POLICY IF EXISTS "suivi_progression_update_policy" ON public.suivi_progression;
CREATE POLICY "suivi_progression_update_policy" ON public.suivi_progression
    FOR UPDATE USING (auth.uid() = eleve_id) WITH CHECK (auth.uid() = eleve_id);

-- ------------------------------------------------------------------------------
-- 8. POLITIQUES POUR 'abonnements' ET 'transactions' (Paiements sécurisés)
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS "abonnements_select_policy" ON public.abonnements;
CREATE POLICY "abonnements_select_policy" ON public.abonnements
    FOR SELECT USING (auth.uid() = utilisateur_id);

DROP POLICY IF EXISTS "transactions_select_policy" ON public.transactions;
CREATE POLICY "transactions_select_policy" ON public.transactions
    FOR SELECT USING (auth.uid() = utilisateur_id);

-- Pas de politique INSERT/UPDATE pour authenticated : seul service_role (serveur/webhook) peut modifier !

-- ------------------------------------------------------------------------------
-- 9. POLITIQUES POUR LE CONTENU PÉDAGOGIQUE (Lecture seule pour tous)
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS "disciplines_read_policy" ON public.disciplines;
CREATE POLICY "disciplines_read_policy" ON public.disciplines FOR SELECT USING (true);

DROP POLICY IF EXISTS "cours_read_policy" ON public.cours;
CREATE POLICY "cours_read_policy" ON public.cours FOR SELECT USING (true);

DROP POLICY IF EXISTS "notions_read_policy" ON public.notions;
CREATE POLICY "notions_read_policy" ON public.notions FOR SELECT USING (true);

DROP POLICY IF EXISTS "quiz_read_policy" ON public.quiz;
CREATE POLICY "quiz_read_policy" ON public.quiz FOR SELECT USING (true);

DROP POLICY IF EXISTS "questions_read_policy" ON public.questions;
CREATE POLICY "questions_read_policy" ON public.questions FOR SELECT USING (true);

DROP POLICY IF EXISTS "reponses_read_policy" ON public.reponses;
CREATE POLICY "reponses_read_policy" ON public.reponses FOR SELECT USING (true);
