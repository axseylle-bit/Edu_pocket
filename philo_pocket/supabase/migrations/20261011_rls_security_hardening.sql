-- ==============================================================================
-- Migration Supabase : Durcissement Global de la Sécurité (RLS & Droits d'Accès)
-- Date : 11 Octobre 2026
-- Application : Philo Pocket / e-eduPocket
-- ==============================================================================

-- 1. Activation de Row Level Security (RLS) sur TOUTES les tables
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
        -- Un parent peut voir le nom de ses enfants liés
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
-- 3. POLITIQUES POUR 'profils_eleves'
-- ------------------------------------------------------------------------------
DROP POLICY IF EXISTS "profils_eleves_select_policy" ON public.profils_eleves;
CREATE POLICY "profils_eleves_select_policy" ON public.profils_eleves
    FOR SELECT USING (
        auth.uid() = utilisateur_id
        OR EXISTS (
            SELECT 1 FROM public.liaisons_parents lp 
            WHERE lp.parent_id = auth.uid() AND lp.eleve_id = public.profils_eleves.utilisateur_id
        )
        -- Permettre la recherche lors de la saisie d'un code d'invitation par un parent
        OR (auth.role() = 'authenticated')
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

DROP POLICY IF EXISTS "liaisons_parents_insert_policy" ON public.liaisons_parents;
CREATE POLICY "liaisons_parents_insert_policy" ON public.liaisons_parents
    FOR INSERT WITH CHECK (auth.uid() = parent_id);

DROP POLICY IF EXISTS "liaisons_parents_delete_policy" ON public.liaisons_parents;
CREATE POLICY "liaisons_parents_delete_policy" ON public.liaisons_parents
    FOR DELETE USING (auth.uid() = parent_id OR auth.uid() = eleve_id);

-- ------------------------------------------------------------------------------
-- 5. POLITIQUES POUR 'suivi_progression'
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
-- 6. POLITIQUES POUR 'abonnements' ET 'transactions' (Paiements et Monétisation)
-- ------------------------------------------------------------------------------
-- Lecture autorisée uniquement pour le titulaire du compte
DROP POLICY IF EXISTS "abonnements_select_policy" ON public.abonnements;
CREATE POLICY "abonnements_select_policy" ON public.abonnements
    FOR SELECT USING (auth.uid() = utilisateur_id);

DROP POLICY IF EXISTS "transactions_select_policy" ON public.transactions;
CREATE POLICY "transactions_select_policy" ON public.transactions
    FOR SELECT USING (auth.uid() = utilisateur_id);

-- Interdiction FORMELLE d'écriture directe depuis le client (Mobile ou Web).
-- Seul le serveur sécurisé (Edge Function ou webhook CinetPay avec service_role) peut insérer/modifier.
-- Grâce à RLS, l'absence de politique INSERT/UPDATE/DELETE pour le rôle authentifié bloque toute fraude cliente.

-- ------------------------------------------------------------------------------
-- 7. POLITIQUES POUR LE CONTENU PÉDAGOGIQUE (Lecture Seule pour les élèves)
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
