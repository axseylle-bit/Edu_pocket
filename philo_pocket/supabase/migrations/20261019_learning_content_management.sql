-- Cloud-managed pedagogical documents and per-user course completion.

CREATE TABLE IF NOT EXISTS public.education_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL DEFAULT '',
    subject TEXT NOT NULL DEFAULT 'francais',
    level TEXT NOT NULL DEFAULT '',
    category TEXT NOT NULL DEFAULT 'progression',
    file_name TEXT NOT NULL,
    storage_path TEXT NOT NULL UNIQUE,
    mime_type TEXT NOT NULL,
    size_bytes BIGINT NOT NULL DEFAULT 0 CHECK (size_bytes >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS education_documents_subject_active_idx
    ON public.education_documents (subject, is_active, level);

ALTER TABLE public.education_documents ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Published education documents are readable" ON public.education_documents;
CREATE POLICY "Published education documents are readable"
    ON public.education_documents
    FOR SELECT TO anon, authenticated
    USING (is_active = TRUE);

DROP POLICY IF EXISTS "Administrators manage education documents" ON public.education_documents;
CREATE POLICY "Administrators manage education documents"
    ON public.education_documents
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    );

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'education-documents',
    'education-documents',
    TRUE,
    26214400,
    ARRAY['application/pdf', 'text/markdown', 'text/plain']
)
ON CONFLICT (id) DO UPDATE
SET public = EXCLUDED.public,
    file_size_limit = EXCLUDED.file_size_limit,
    allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "Education documents are publicly readable" ON storage.objects;
CREATE POLICY "Education documents are publicly readable"
    ON storage.objects
    FOR SELECT TO anon, authenticated
    USING (bucket_id = 'education-documents');

DROP POLICY IF EXISTS "Administrators upload education documents" ON storage.objects;
CREATE POLICY "Administrators upload education documents"
    ON storage.objects
    FOR INSERT TO authenticated
    WITH CHECK (
        bucket_id = 'education-documents'
        AND EXISTS (
            SELECT 1 FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    );

DROP POLICY IF EXISTS "Administrators replace education documents" ON storage.objects;
CREATE POLICY "Administrators replace education documents"
    ON storage.objects
    FOR UPDATE TO authenticated
    USING (
        bucket_id = 'education-documents'
        AND EXISTS (
            SELECT 1 FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    )
    WITH CHECK (
        bucket_id = 'education-documents'
        AND EXISTS (
            SELECT 1 FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    );

DROP POLICY IF EXISTS "Administrators delete education documents" ON storage.objects;
CREATE POLICY "Administrators delete education documents"
    ON storage.objects
    FOR DELETE TO authenticated
    USING (
        bucket_id = 'education-documents'
        AND EXISTS (
            SELECT 1 FROM public.utilisateurs AS u
            WHERE u.id = auth.uid()
              AND u.role IN ('admin', 'superadmin', 'coordinator')
        )
    );

CREATE TABLE IF NOT EXISTS public.student_course_progress (
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    discipline TEXT NOT NULL,
    level TEXT NOT NULL DEFAULT '',
    course_key TEXT NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, discipline, level, course_key)
);

ALTER TABLE public.student_course_progress ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Students read their course progress" ON public.student_course_progress;
CREATE POLICY "Students read their course progress"
    ON public.student_course_progress
    FOR SELECT TO authenticated
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Students create their course progress" ON public.student_course_progress;
CREATE POLICY "Students create their course progress"
    ON public.student_course_progress
    FOR INSERT TO authenticated
    WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Students update their course progress" ON public.student_course_progress;
CREATE POLICY "Students update their course progress"
    ON public.student_course_progress
    FOR UPDATE TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);
