-- Migration 01: Création de la table notions et mise à jour du schéma

-- 1. Renommer parents_eleves en liaisons_parents si elle existe
ALTER TABLE IF EXISTS public.parents_eleves RENAME TO liaisons_parents;

-- 2. Création de la table notions
CREATE TABLE IF NOT EXISTS public.notions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT UNIQUE NOT NULL, -- ex: 'art_et_technique'
    titre TEXT NOT NULL,
    discipline TEXT DEFAULT 'philosophie',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Active RLS
ALTER TABLE public.notions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Lecture publique des notions" ON public.notions FOR SELECT USING (true);

-- 3. Mise à jour de la table suivi_progression
-- On remplace 'notion' par 'notion_id', 'temps_passe_minutes' par 'temps_etude_secondes'
ALTER TABLE public.suivi_progression 
    ADD COLUMN IF NOT EXISTS notion_id UUID REFERENCES public.notions(id) ON DELETE CASCADE,
    ADD COLUMN IF NOT EXISTS temps_etude_secondes INTEGER DEFAULT 0;

-- 4. Insertion des notions de base (Philo)
INSERT INTO public.notions (slug, titre) VALUES
('art_et_technique', 'L''Art et la Technique'),
('conscience_et_inconscient', 'La Conscience et l''Inconscient'),
('culture_et_civilisation', 'La Culture et la Civilisation'),
('ethnie_et_nation', 'L''Ethnie et la Nation'),
('etre_et_pensee', 'L''Être et la Pensée'),
('genese_de_la_philosophie', 'La Genèse de la Philosophie'),
('grands_courants', 'Les Grands Courants'),
('individu_et_societe', 'L''Individu et la Société'),
('introduction_generale', 'Introduction Générale'),
('les_medias', 'Les Médias'),
('le_monde_et_les_valeurs', 'Le Monde et les Valeurs'),
('le_sujet_question', 'Le Sujet (Question)'),
('science_et_verite', 'La Science et la Vérité'),
('sorcellerie_fetiche', 'Sorcellerie et Fétiche'),
('travail_echange', 'Le Travail et l''Échange')
ON CONFLICT (slug) DO NOTHING;
