-- =============================================================================
-- Migration: 20261012_teacher_applications.sql
-- Description: Table de collecte et suivi des candidatures d'enseignants pionniers
--              (Nom, prénom, téléphone/WhatsApp, diplôme/certification, matière,
--               filière, établissement, ville, sections de progression souhaitées).
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.teacher_applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    full_name TEXT NOT NULL,
    phone_whatsapp TEXT NOT NULL,
    email TEXT,
    highest_degree TEXT NOT NULL,
    teaching_subject TEXT NOT NULL,
    education_order TEXT NOT NULL DEFAULT 'Général', -- 'Général', 'Technique (STI/STMG)', 'Professionnel (CET)'
    target_levels TEXT, -- Ex: 'Secondaire 2nd cycle (2nde, 1ère, Tle)', '1er cycle (6e-3e)'
    school_name TEXT NOT NULL,
    city TEXT NOT NULL,
    province TEXT,
    preferred_chapters TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'under_review', 'accepted', 'rejected')),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT timezone('utc'::text, now())
);

-- Index pour recherche rapide
CREATE INDEX IF NOT EXISTS idx_teacher_applications_subject ON public.teacher_applications (teaching_subject);
CREATE INDEX IF NOT EXISTS idx_teacher_applications_city ON public.teacher_applications (city);
CREATE INDEX IF NOT EXISTS idx_teacher_applications_status ON public.teacher_applications (status);

-- Activer Row Level Security
ALTER TABLE public.teacher_applications ENABLE ROW LEVEL SECURITY;

-- Politiques RLS :
-- 1. Tout enseignant (authentifié ou visiteur déposant sa candidature) peut insérer sa candidature
DROP POLICY IF EXISTS "Permettre l'insertion des candidatures" ON public.teacher_applications;
CREATE POLICY "Permettre l'insertion des candidatures"
    ON public.teacher_applications
    FOR INSERT
    TO public
    WITH CHECK (true);

-- 2. Seuls les administrateurs et la coordination peuvent lire l'ensemble des candidatures
DROP POLICY IF EXISTS "Lecture des candidatures par les admins et propriétaires" ON public.teacher_applications;
CREATE POLICY "Lecture des candidatures par les admins et propriétaires"
    ON public.teacher_applications
    FOR SELECT
    TO authenticated
    USING (
        auth.uid() = user_id 
        OR EXISTS (
            SELECT 1 FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
            AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    );

-- 3. Mise à jour réservée aux administrateurs
DROP POLICY IF EXISTS "Mise a jour par admin uniquement" ON public.teacher_applications;
CREATE POLICY "Mise a jour par admin uniquement"
    ON public.teacher_applications
    FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
            AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    );
