-- ==============================================================================
-- Migration Supabase : Harmonisation du Catalogue Pédagogique et Synchronisation
-- Date : 11 Octobre 2026
-- ==============================================================================

-- 1. Table des disciplines
CREATE TABLE IF NOT EXISTS public.disciplines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    libelle VARCHAR(100) NOT NULL,
    icone TEXT
);

INSERT INTO public.disciplines (code, libelle, icone) VALUES
('philo', 'Philosophie', 'menu_book_rounded'),
('maths', 'Mathématiques', 'calculate_rounded'),
('pc', 'Physique-Chimie', 'science_rounded'),
('ses', 'Sciences Économiques et Sociales', 'trending_up_rounded'),
('francais', 'Français / Lettres', 'edit_note_rounded')
ON CONFLICT (code) DO NOTHING;

-- 2. Table des notions (utilisée par les cours et quiz de l'application)
CREATE TABLE IF NOT EXISTS public.notions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT UNIQUE NOT NULL,
    titre TEXT NOT NULL,
    discipline TEXT DEFAULT 'philosophie',
    ordre INT DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Insertion exhaustive des notions du programme officiel du Gabon
INSERT INTO public.notions (slug, titre, ordre) VALUES
('genese_de_la_philosophie', 'Genèse de la philosophie : du mythe à la rationalité', 1),
('grands_courants', 'Le matérialisme, l''idéalisme, l''empirisme et le rationalisme', 2),
('sorcellerie_fetiche', 'La sorcellerie et le fétiche', 3),
('le_sujet_question', 'Le sujet-question', 4),
('art_et_technique', 'L''Art et la Technique', 5),
('conscience_et_inconscient', 'La conscience et l''inconscient', 6),
('culture_et_civilisation', 'Culture et civilisation', 7),
('ethnie_et_nation', 'L''ethnie et la nation', 8),
('etre_et_pensee', 'L''être et la pensée (L''homme, la nature et l''écologie)', 9),
('individu_et_societe', 'L''individu et la société (Les passions, Autrui)', 10),
('introduction_generale', 'Introduction générale à la philosophie', 11),
('le_monde_et_les_valeurs', 'Le monde et les valeurs (La démocratie, Le bien)', 12),
('les_medias', 'Les Médias', 13),
('science_et_verite', 'Science et vérité (La théorie, L''expérimentation, La logique)', 14),
('travail_echange', 'Le travail et l''échange', 15)
ON CONFLICT (slug) DO UPDATE SET titre = EXCLUDED.titre, ordre = EXCLUDED.ordre;

-- 3. Synchronisation de la colonne code_invitation sur profils_eleves
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'profils_eleves' AND column_name = 'code_invitation_parent') THEN
        ALTER TABLE public.profils_eleves RENAME COLUMN code_invitation_parent TO code_invitation;
    ELSE
        ALTER TABLE public.profils_eleves ADD COLUMN IF NOT EXISTS code_invitation TEXT UNIQUE;
    END IF;
END $$;

-- 4. Synchronisation des colonnes de suivi_progression
ALTER TABLE public.suivi_progression 
    ADD COLUMN IF NOT EXISTS notion_id UUID REFERENCES public.notions(id) ON DELETE CASCADE,
    ADD COLUMN IF NOT EXISTS temps_etude_secondes INTEGER DEFAULT 0,
    ADD COLUMN IF NOT EXISTS score_quiz_max NUMERIC(4,2) DEFAULT 0,
    ADD COLUMN IF NOT EXISTS cours_termine BOOLEAN DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now());

-- 5. Table des cours (pour l'administration Web)
CREATE TABLE IF NOT EXISTS public.cours (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titre VARCHAR(200) NOT NULL,
    niveau VARCHAR(50) DEFAULT 'Terminale',
    statut_publication BOOLEAN DEFAULT TRUE,
    introduction TEXT,
    date_creation TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Vue de compatibilité 'courses' pour l'admin si nécessaire
CREATE OR REPLACE VIEW public.courses AS 
SELECT 
    id, 
    titre AS title, 
    'Équipe Pédagogique' AS author_name,
    statut_publication AS is_published, 
    date_creation AS created_at
FROM public.cours;
