-- Migration : Déverrouillage National & Support Simulations 3D / Multimédia
-- Date : 18 Octobre 2026
-- Objectif : Supprimer les verrous rigides sur profils_eleves et abonnements,
-- et doter la structure pédagogique du support natif pour vidéos, modèles 3D et simulations virtuelles.

-- 1. DÉVERROUILLAGE DES NIVEAUX ET SÉRIES D'ÉLÈVES (COLLÈGE, LYCÉE GÉNÉRAL & TECHNIQUE)
ALTER TABLE IF EXISTS public.profils_eleves 
    DROP CONSTRAINT IF EXISTS profils_eleves_niveau_check;

ALTER TABLE IF EXISTS public.profils_eleves 
    DROP CONSTRAINT IF EXISTS profils_eleves_serie_check;

ALTER TABLE IF EXISTS public.profils_eleves
    ALTER COLUMN niveau TYPE VARCHAR(50),
    ALTER COLUMN serie TYPE VARCHAR(50);

-- 2. DÉVERROUILLAGE DE LA TABLE ABONNEMENTS
ALTER TABLE IF EXISTS public.abonnements 
    DROP CONSTRAINT IF EXISTS abonnements_palier_check;

ALTER TABLE IF EXISTS public.abonnements
    ALTER COLUMN palier TYPE VARCHAR(50);

-- 3. ENRICHISSEMENT PÉDAGOGIQUE : MODÈLES 3D, VIDÉOS & SIMULATIONS SCIENTIFIQUES
ALTER TABLE IF EXISTS public.notions
    ADD COLUMN IF NOT EXISTS model_3d_url TEXT,
    ADD COLUMN IF NOT EXISTS video_url TEXT,
    ADD COLUMN IF NOT EXISTS simulation_type VARCHAR(50), -- 'lab_chimie', 'circuit_elec', 'optique', 'mecanique', 'mythe_3d'
    ADD COLUMN IF NOT EXISTS simulation_config JSONB;

-- Table dédiée aux simulations interactives et expériences virtuelles (TP Virtuels de Sciences)
CREATE TABLE IF NOT EXISTS public.simulations_scientifiques (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    notion_id UUID REFERENCES public.notions(id) ON DELETE SET NULL,
    discipline VARCHAR(50) NOT NULL, -- 'maths', 'pc', 'svt', 'technologie'
    niveau VARCHAR(50) NOT NULL, -- '6eme', '5eme', '4eme', '3eme', '2nde', '1ere', 'Tle'
    titre VARCHAR(200) NOT NULL,
    description TEXT,
    type_simulation VARCHAR(50) NOT NULL, -- 'model_3d', 'interactive_lab', 'graph_plotter', 'canvas_anim'
    asset_3d_path TEXT, -- Chemin vers le fichier .glb / .gltf
    parametres_interactifs JSONB DEFAULT '{}'::jsonb,
    statut_actif BOOLEAN DEFAULT TRUE,
    date_creation TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

ALTER TABLE public.simulations_scientifiques ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Lecture publique des simulations actives" ON public.simulations_scientifiques;
CREATE POLICY "Lecture publique des simulations actives" 
    ON public.simulations_scientifiques 
    FOR SELECT 
    USING (statut_actif = TRUE);
