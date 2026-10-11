-- Supabase SQL Schema for Philo Pocket

-- ==========================================
-- 1. EXTENSIONS
-- ==========================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS vector; -- Pour le RAG de Gemini (Recherche vectorielle)

-- ==========================================
-- 2. TABLES DES UTILISATEURS
-- ==========================================

CREATE TABLE IF NOT EXISTS public.utilisateurs (
    id UUID PRIMARY KEY REFERENCES auth.users(id), -- Lié au système d'authentification Supabase
    nom VARCHAR(100),
    prenom VARCHAR(100),
    email VARCHAR(150) UNIQUE,
    telephone VARCHAR(20) UNIQUE,
    role VARCHAR(20) CHECK (role IN ('eleve', 'parent', 'admin', 'enseignant', 'curieux')),
    date_creation TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.profils_eleves (
    utilisateur_id UUID PRIMARY KEY REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    etablissement VARCHAR(150),
    niveau VARCHAR(20) CHECK (niveau IN ('1ere', 'Tle')),
    serie VARCHAR(10) CHECK (serie IN ('A1', 'A2', 'B', 'C', 'D', 'S')),
    code_invitation_parent VARCHAR(10) UNIQUE,
    date_expiration_code TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS public.liaisons_parents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eleve_id UUID REFERENCES public.profils_eleves(utilisateur_id) ON DELETE CASCADE,
    parent_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    statut VARCHAR(20) DEFAULT 'actif',
    date_liaison TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    UNIQUE(eleve_id, parent_id)
);

-- ==========================================
-- 3. STRUCTURE PÉDAGOGIQUE
-- ==========================================

CREATE TABLE IF NOT EXISTS public.disciplines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(20) UNIQUE NOT NULL, -- ex: 'philo'
    libelle VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.cours (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    discipline_id UUID REFERENCES public.disciplines(id) ON DELETE CASCADE,
    niveau VARCHAR(20),
    titre VARCHAR(200) NOT NULL,
    introduction TEXT,
    problematique TEXT,
    statut_publication BOOLEAN DEFAULT FALSE,
    date_creation TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

CREATE TABLE IF NOT EXISTS public.notions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    cours_id UUID REFERENCES public.cours(id) ON DELETE CASCADE,
    titre VARCHAR(200) NOT NULL,
    contenu_texte TEXT,
    embedding vector(768), -- Vecteur pour la recherche sémantique RAG (Gemini)
    ordre INT
);

CREATE TABLE IF NOT EXISTS public.travaux_diriges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    notion_id UUID REFERENCES public.notions(id) ON DELETE CASCADE,
    titre VARCHAR(200),
    type_epreuve VARCHAR(50), -- 'dissertation', 'commentaire'
    grille_methodologique JSONB,
    etapes_guidees JSONB
);

CREATE TABLE IF NOT EXISTS public.travaux_pratiques (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    notion_id UUID REFERENCES public.notions(id) ON DELETE CASCADE,
    titre VARCHAR(200),
    materiel_requis TEXT[],
    consignes_modelisation TEXT,
    modele_rendu_attendu TEXT
);

CREATE TABLE IF NOT EXISTS public.quiz (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    notion_id UUID REFERENCES public.notions(id) ON DELETE CASCADE,
    titre VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS public.questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    quiz_id UUID REFERENCES public.quiz(id) ON DELETE CASCADE,
    enonce TEXT,
    explication TEXT
);

CREATE TABLE IF NOT EXISTS public.reponses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question_id UUID REFERENCES public.questions(id) ON DELETE CASCADE,
    texte TEXT,
    est_correcte BOOLEAN
);

-- ==========================================
-- 4. SUIVI ET TRANSACTIONS
-- ==========================================

CREATE TABLE IF NOT EXISTS public.suivi_progression (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eleve_id UUID REFERENCES public.profils_eleves(utilisateur_id) ON DELETE CASCADE,
    notion_id UUID REFERENCES public.notions(id) ON DELETE CASCADE,
    cours_termine BOOLEAN DEFAULT FALSE,
    score_quiz_max INT DEFAULT 0,
    temps_etude_secondes INT DEFAULT 0,
    date_derniere_activite TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    UNIQUE(eleve_id, notion_id)
);

CREATE TABLE IF NOT EXISTS public.abonnements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    utilisateur_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    palier VARCHAR(20) CHECK (palier IN ('socrate', 'platon', 'aristote')),
    date_debut TIMESTAMP WITH TIME ZONE,
    date_fin TIMESTAMP WITH TIME ZONE,
    statut VARCHAR(20) DEFAULT 'actif'
);

CREATE TABLE IF NOT EXISTS public.transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    utilisateur_id UUID REFERENCES public.utilisateurs(id),
    reference_externe VARCHAR(100) UNIQUE,
    montant DECIMAL(10,2),
    operateur VARCHAR(50), -- 'airtel_money', 'moov_money', 'carte'
    statut VARCHAR(20) CHECK (statut IN ('initie', 'en_attente', 'succes', 'echec', 'expire')),
    date_creation TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- ==========================================
-- 5. ROW LEVEL SECURITY (RLS)
-- ==========================================
ALTER TABLE public.utilisateurs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profils_eleves ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.suivi_progression ENABLE ROW LEVEL SECURITY;

-- Les utilisateurs peuvent voir leur propre profil
CREATE POLICY "Voir son propre profil" ON public.utilisateurs 
FOR SELECT USING (auth.uid() = id);

-- Un élève voit sa propre progression
CREATE POLICY "Progression eleve" ON public.suivi_progression 
FOR SELECT USING (auth.uid() = eleve_id);

-- Un parent peut voir la progression de son enfant (via liaisons_parents)
CREATE POLICY "Progression parent" ON public.suivi_progression 
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.liaisons_parents 
        WHERE parent_id = auth.uid() AND eleve_id = public.suivi_progression.eleve_id
    )
);

-- Permettre aux utilisateurs d'insérer et modifier leur propre profil
CREATE POLICY "Inserer son profil" ON public.utilisateurs 
FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Mettre a jour son profil" ON public.utilisateurs 
FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Inserer profil eleve" ON public.profils_eleves 
FOR INSERT WITH CHECK (auth.uid() = utilisateur_id);

CREATE POLICY "Mettre a jour profil eleve" ON public.profils_eleves 
FOR UPDATE USING (auth.uid() = utilisateur_id);

