-- =====================================================================
-- MIGRATION SUPABASE : MODULE D'ORIENTATION INTELLIGENTE ALECKSE (EVA)
-- Lié à l'Identifiant Unique EduPocket (EP-AA-XXXX)
-- =====================================================================

-- 1. Table du profil d'aptitudes et d'orientation de l'apprenant
CREATE TABLE IF NOT EXISTS public.profils_orientation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id UUID NOT NULL REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    identifiant_edupocket TEXT REFERENCES public.profils_eleves(identifiant_edupocket) ON DELETE SET NULL,
    
    -- Pôles de compétences (Scores sur 100 calculés dynamiquement)
    score_sciences INTEGER DEFAULT 50,          -- Maths, Physique-Chimie, SVT
    score_technique INTEGER DEFAULT 50,         -- Mécanique, Électrotechnique, BTP, TP Labo
    score_litteraire INTEGER DEFAULT 50,        -- Français, Philo, Histoire-Géo, Langues
    score_gestion INTEGER DEFAULT 50,           -- SES, Comptabilité, Commerce, Organisation
    score_pratique INTEGER DEFAULT 50,          -- Atelier, Dessin technique, Manipulations
    
    -- Dominante actuelle calculée
    dominante_principale TEXT DEFAULT 'Polyvalent',
    
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(utilisateur_id)
);

-- Index pour recherche rapide par identifiant EduPocket
CREATE INDEX IF NOT EXISTS idx_orientation_id_edupocket 
ON public.profils_orientation (identifiant_edupocket);

-- 2. Table des bilans et suggestions d'orientation générées par Aleckse
CREATE TABLE IF NOT EXISTS public.recommandations_orientation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    utilisateur_id UUID NOT NULL REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    identifiant_edupocket TEXT,
    
    -- Palier d'orientation ciblé
    palier_scolaire TEXT NOT NULL,              -- Ex: 'Fin 3ème : Choix de Seconde', 'Terminale : Choix Supérieur'
    
    -- Filière recommandée principale et alternatives
    filiere_recommandee TEXT NOT NULL,         -- Ex: 'Série S (Scientifique)' ou 'Série STI / F3'
    score_affinite INTEGER NOT NULL DEFAULT 85, -- Pourcentage de correspondance (ex: 92%)
    filieres_alternatives JSONB DEFAULT '[]'::jsonb,
    
    -- Synthèse et conseils bienveillants formulés par Aleckse
    avis_aleckse TEXT NOT NULL,
    
    -- Débouchés et carrières suggérées
    metiers_horizons JSONB DEFAULT '[]'::jsonb,
    
    cree_le TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Fonction pour recalculer le profil d'orientation lors de la progression
CREATE OR REPLACE FUNCTION public.actualiser_profil_orientation(
    p_utilisateur_id UUID,
    p_score_sciences INT,
    p_score_technique INT,
    p_score_litteraire INT,
    p_score_gestion INT
)
RETURNS VOID AS $$
DECLARE
    v_id_edupocket TEXT;
    v_dominante TEXT := 'Polyvalent';
    v_max INT := p_score_sciences;
BEGIN
    -- Récupération de l'identifiant EduPocket
    SELECT identifiant_edupocket INTO v_id_edupocket 
    FROM public.profils_eleves 
    WHERE utilisateur_id = p_utilisateur_id;

    -- Détermination de la dominante principale
    IF p_score_technique > v_max THEN
        v_max := p_score_technique;
        v_dominante := 'Technologique & Industriel';
    END IF;
    IF p_score_gestion > v_max THEN
        v_max := p_score_gestion;
        v_dominante := 'Économie & Gestion Tertiaire';
    END IF;
    IF p_score_litteraire > v_max THEN
        v_max := p_score_litteraire;
        v_dominante := 'Lettres, Sciences Humaines & Droit';
    END IF;
    IF v_max = p_score_sciences AND p_score_sciences > 60 THEN
        v_dominante := 'Sciences & Ingénierie Pure';
    END IF;

    -- Upsert dans la table profils_orientation
    INSERT INTO public.profils_orientation (
        utilisateur_id,
        identifiant_edupocket,
        score_sciences,
        score_technique,
        score_litteraire,
        score_gestion,
        dominante_principale,
        updated_at
    ) VALUES (
        p_utilisateur_id,
        v_id_edupocket,
        p_score_sciences,
        p_score_technique,
        p_score_litteraire,
        p_score_gestion,
        v_dominante,
        timezone('utc'::text, now())
    )
    ON CONFLICT (utilisateur_id) DO UPDATE SET
        identifiant_edupocket = EXCLUDED.identifiant_edupocket,
        score_sciences = EXCLUDED.score_sciences,
        score_technique = EXCLUDED.score_technique,
        score_litteraire = EXCLUDED.score_litteraire,
        score_gestion = EXCLUDED.score_gestion,
        dominante_principale = EXCLUDED.dominante_principale,
        updated_at = EXCLUDED.updated_at;
END;
$$ LANGUAGE plpgsql;
