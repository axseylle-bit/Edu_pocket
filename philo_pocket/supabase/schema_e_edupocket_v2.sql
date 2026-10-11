-- Schéma Supabase V2 pour l'écosystème e-eduPocket (Académie EVA)
-- Conçu pour gérer de multiples disciplines (Philo, SES, Maths, PC...)

-----------------------------------------------------------
-- 1. UTILISATEURS ET PROFILS
-----------------------------------------------------------

CREATE TABLE public.utilisateurs (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    nom TEXT NOT NULL,
    role TEXT CHECK (role IN ('eleve', 'parent', 'professeur', 'admin')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE public.profils_eleves (
    utilisateur_id UUID PRIMARY KEY REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    niveau_id UUID, -- Référence au niveau scolaire (ex: Terminale B)
    credits_eva INTEGER DEFAULT 0, -- Le score global transversal pour la gamification
    statut_eva TEXT DEFAULT 'Initié', -- Grade dans l'Académie EVA
    code_invitation TEXT UNIQUE, -- Code unique généré par l'élève pour ses parents
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE TABLE public.liaisons_parents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    eleve_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(parent_id, eleve_id)
);

CREATE TABLE public.abonnements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    utilisateur_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    statut TEXT NOT NULL DEFAULT 'inactif' CHECK (statut IN ('actif', 'inactif', 'annule')),
    palier TEXT NOT NULL DEFAULT 'gratuit' CHECK (palier IN ('gratuit', 'essentiel', 'confort', 'famille')),
    date_fin TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-----------------------------------------------------------
-- 2. STRUCTURE DU CATALOGUE SCOLAIRE (PROGRESSIONS)
-----------------------------------------------------------

CREATE TABLE public.disciplines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nom TEXT NOT NULL UNIQUE, -- 'Philosophie', 'Mathématiques', 'SES', 'Physique-Chimie'
    icone TEXT
);

CREATE TABLE public.niveaux (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nom TEXT NOT NULL UNIQUE, -- '6ème', '5ème', ..., 'Terminale A1', 'Terminale B'
    cycle TEXT -- 'Collège', 'Lycée'
);

-- Fait le lien entre une discipline et un niveau (Ex: Programme de Maths 3ème)
CREATE TABLE public.programmes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    discipline_id UUID REFERENCES public.disciplines(id) ON DELETE CASCADE,
    niveau_id UUID REFERENCES public.niveaux(id) ON DELETE CASCADE,
    annee_scolaire TEXT DEFAULT '2026-2027',
    UNIQUE(discipline_id, niveau_id)
);

-- Themes ou Trimestres (selon le découpage)
CREATE TABLE public.themes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    programme_id UUID REFERENCES public.programmes(id) ON DELETE CASCADE,
    titre TEXT NOT NULL,
    ordre INTEGER NOT NULL
);

CREATE TABLE public.chapitres (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    theme_id UUID REFERENCES public.themes(id) ON DELETE CASCADE,
    titre TEXT NOT NULL,
    ordre INTEGER NOT NULL
);

CREATE TABLE public.sequences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chapitre_id UUID REFERENCES public.chapitres(id) ON DELETE CASCADE,
    titre TEXT NOT NULL,
    ordre INTEGER NOT NULL
);

-- Les leçons constituent la granularité fine (l'équivalent de la "notion")
CREATE TABLE public.lecons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    sequence_id UUID REFERENCES public.sequences(id) ON DELETE CASCADE,
    titre TEXT NOT NULL,
    duree_indicative_heures NUMERIC(3,1),
    contenu_markdown TEXT, -- Le cours brut ou le lien vers l'asset
    ordre INTEGER NOT NULL
);

-----------------------------------------------------------
-- 3. PROGRESSION DE L'ÉLÈVE
-----------------------------------------------------------

-- Remplace l'ancienne table "suivi_progression" plate
CREATE TABLE public.suivi_progression (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eleve_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    notion_id UUID REFERENCES public.lecons(id) ON DELETE CASCADE, -- Lien direct vers le point du programme
    temps_etude_secondes INTEGER DEFAULT 0,
    score_quiz_max NUMERIC(4,1) DEFAULT 0,
    statut_cours_lu BOOLEAN DEFAULT FALSE,
    statut_td_fait BOOLEAN DEFAULT FALSE,
    statut_tp_fait BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(eleve_id, notion_id)
);

-----------------------------------------------------------
-- 4. SÉCURITÉ ET POLITIQUES (ROW LEVEL SECURITY)
-----------------------------------------------------------
-- (Des politiques RLS devront être ajoutées pour sécuriser les accès :
-- Les élèves voient leurs progressions, les parents voient les progressions de leurs enfants liés,
-- Le catalogue (disciplines, chapitres...) est en lecture seule pour tous).
