-- Schéma Supabase pour Philo Pocket
-- A copier/coller dans l'éditeur SQL de votre projet Supabase.

-- 1. Table Utilisateurs (Extension de auth.users)
CREATE TABLE public.utilisateurs (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    nom TEXT NOT NULL,
    role TEXT CHECK (role IN ('eleve', 'parent', 'professeur', 'admin')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Active RLS
ALTER TABLE public.utilisateurs ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Les utilisateurs peuvent lire leur propre profil" ON public.utilisateurs FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Les utilisateurs peuvent modifier leur propre profil" ON public.utilisateurs FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Les utilisateurs peuvent insérer leur propre profil" ON public.utilisateurs FOR INSERT WITH CHECK (auth.uid() = id);

-- 2. Table Profils Elèves
CREATE TABLE public.profils_eleves (
    utilisateur_id UUID PRIMARY KEY REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    niveau TEXT,
    serie TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Active RLS
ALTER TABLE public.profils_eleves ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Les élèves peuvent lire leur profil" ON public.profils_eleves FOR SELECT USING (auth.uid() = utilisateur_id);
CREATE POLICY "Les élèves peuvent modifier leur profil" ON public.profils_eleves FOR UPDATE USING (auth.uid() = utilisateur_id);
CREATE POLICY "Les élèves peuvent insérer leur profil" ON public.profils_eleves FOR INSERT WITH CHECK (auth.uid() = utilisateur_id);

-- 3. Table de liaison Parents-Enfants
CREATE TABLE public.parents_eleves (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    parent_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    eleve_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(parent_id, eleve_id)
);

-- Active RLS
ALTER TABLE public.parents_eleves ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Les parents voient leurs liaisons" ON public.parents_eleves FOR SELECT USING (auth.uid() = parent_id);
CREATE POLICY "Les élèves voient leurs parents" ON public.parents_eleves FOR SELECT USING (auth.uid() = eleve_id);

-- 4. Table Abonnements
CREATE TABLE public.abonnements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    utilisateur_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    statut TEXT NOT NULL DEFAULT 'inactif' CHECK (statut IN ('actif', 'inactif', 'annule')),
    palier TEXT NOT NULL DEFAULT 'gratuit' CHECK (palier IN ('gratuit', 'essentiel', 'confort', 'famille', 'professeur_premium')),
    date_fin TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Active RLS
ALTER TABLE public.abonnements ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Lecture abonnement personnel" ON public.abonnements FOR SELECT USING (auth.uid() = utilisateur_id);

-- 5. Table Suivi Progression
CREATE TABLE public.suivi_progression (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    eleve_id UUID REFERENCES public.utilisateurs(id) ON DELETE CASCADE,
    notion TEXT NOT NULL,
    score_quiz_max NUMERIC(4,1) DEFAULT 0,
    temps_passe_minutes INTEGER DEFAULT 0,
    chapitre_lu BOOLEAN DEFAULT FALSE,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Active RLS
ALTER TABLE public.suivi_progression ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Les élèves voient leur propre progression" ON public.suivi_progression FOR SELECT USING (auth.uid() = eleve_id);
CREATE POLICY "Les élèves peuvent modifier leur propre progression" ON public.suivi_progression FOR UPDATE USING (auth.uid() = eleve_id);
CREATE POLICY "Les élèves peuvent insérer leur progression" ON public.suivi_progression FOR INSERT WITH CHECK (auth.uid() = eleve_id);

-- Politique pour que le parent puisse voir la progression de son enfant
CREATE POLICY "Les parents peuvent voir la progression de leurs enfants" ON public.suivi_progression 
FOR SELECT USING (
    auth.uid() IN (
        SELECT parent_id FROM public.parents_eleves WHERE eleve_id = suivi_progression.eleve_id
    )
);

-- Trigger pour créer automatiquement une ligne dans 'utilisateurs' lors de l'inscription via auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user() 
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.utilisateurs (id, email, nom, role)
  VALUES (new.id, new.email, COALESCE(new.raw_user_meta_data->>'nom', 'Utilisateur'), 'eleve'); -- Role par defaut
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
