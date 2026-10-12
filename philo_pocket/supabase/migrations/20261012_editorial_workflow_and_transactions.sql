-- Migration Supabase : Workflow Éditorial des Enseignants et Traçabilité Mobile Money
-- Date : 12 Octobre 2026
-- Description : 
--   1. Sécurisation et idempotence des transactions Mobile Money (Airtel & Moov).
--   2. Chaîne de validation et modération éditoriale des cours rédigés par les enseignants pionniers.

-- ==============================================================================
-- 1. TABLE DES TRANSACTIONS MOBILE MONEY (AIRTEL & MOOV)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.paiements_mobile_money (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id UUID NOT NULL REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    reference_transaction TEXT NOT NULL UNIQUE,
    operateur TEXT NOT NULL CHECK (operateur IN ('airtel', 'moov')),
    numero_telephone TEXT NOT NULL,
    montant INTEGER NOT NULL,
    palier_key TEXT NOT NULL,
    statut TEXT NOT NULL DEFAULT 'en_attente' CHECK (statut IN ('en_attente', 'valide', 'echoue', 'rembourse')),
    idempotence_token TEXT UNIQUE,
    metadata JSONB DEFAULT '{}'::jsonb,
    cree_le TIMESTAMPTZ DEFAULT now(),
    valide_le TIMESTAMPTZ
);

ALTER TABLE public.paiements_mobile_money ENABLE ROW LEVEL SECURITY;

-- Les utilisateurs peuvent consulter uniquement leurs propres transactions
DROP POLICY IF EXISTS "Les utilisateurs voient leurs propres transactions" ON public.paiements_mobile_money;
CREATE POLICY "Les utilisateurs voient leurs propres transactions"
    ON public.paiements_mobile_money
    FOR SELECT
    TO authenticated
    USING (auth.uid() = utilisateur_id);

-- L'insertion est permise à l'utilisateur connecté pour initialiser sa demande
DROP POLICY IF EXISTS "L'utilisateur peut initialiser son paiement" ON public.paiements_mobile_money;
CREATE POLICY "L'utilisateur peut initialiser son paiement"
    ON public.paiements_mobile_money
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = utilisateur_id);

-- ==============================================================================
-- 2. TABLE DU WORKFLOW ÉDITORIAL DES ENSEIGNANTS PIONNIERS
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.cours_soumis_enseignants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    enseignant_id UUID NOT NULL REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    discipline_code TEXT NOT NULL,
    titre_cours TEXT NOT NULL,
    section_progression TEXT NOT NULL,
    classe_niveau TEXT NOT NULL,
    contenu_markdown TEXT NOT NULL,
    statut_editorial TEXT NOT NULL DEFAULT 'brouillon' CHECK (
        statut_editorial IN ('brouillon', 'en_relecture_ipn', 'valide_pedagogique', 'publie', 'rejete_avec_commentaires')
    ),
    commentaires_relecteur TEXT,
    inspecteur_relecteur_id UUID REFERENCES public.utilisateurs(id),
    version INTEGER NOT NULL DEFAULT 1,
    date_soumission TIMESTAMPTZ,
    date_publication TIMESTAMPTZ,
    cree_le TIMESTAMPTZ DEFAULT now(),
    mis_a_jour_le TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE public.cours_soumis_enseignants ENABLE ROW LEVEL SECURITY;

-- L'enseignant voit ses propres cours quel que soit le statut
DROP POLICY IF EXISTS "Enseignant voit ses propres cours" ON public.cours_soumis_enseignants;
CREATE POLICY "Enseignant voit ses propres cours"
    ON public.cours_soumis_enseignants
    FOR SELECT
    TO authenticated
    USING (auth.uid() = enseignant_id);

-- L'enseignant peut modifier ses cours en statut 'brouillon' ou 'rejete_avec_commentaires'
DROP POLICY IF EXISTS "Enseignant modifie ses brouillons" ON public.cours_soumis_enseignants;
CREATE POLICY "Enseignant modifie ses brouillons"
    ON public.cours_soumis_enseignants
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = enseignant_id AND statut_editorial IN ('brouillon', 'rejete_avec_commentaires'))
    WITH CHECK (auth.uid() = enseignant_id);

-- Les cours publiés sont lisibles par tous les utilisateurs connectés (élèves, parents, profs)
DROP POLICY IF EXISTS "Tout le monde lit les cours publiés" ON public.cours_soumis_enseignants;
CREATE POLICY "Tout le monde lit les cours publiés"
    ON public.cours_soumis_enseignants
    FOR SELECT
    TO authenticated
    USING (statut_editorial = 'publie');
