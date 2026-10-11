-- ==============================================================================
-- MIGRATION OFFICIELLE : ENSEIGNEMENT TECHNIQUE ET PROFESSIONNEL DU GABON
-- Référentiel Officiel du Baccalauréat Technologique (CGBT - DGEC)
-- Établissements : LTNOB, Léconi, Bikélé, Nyonda Makita, LTAO, LTK, Paul Kouya, CIMFEP Nkok, Port-Gentil
-- ==============================================================================

-- 1. Table des disciplines : Création ou ajout sécurisé des colonnes
CREATE TABLE IF NOT EXISTS public.disciplines (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code TEXT UNIQUE NOT NULL,
    libelle TEXT NOT NULL,
    icone TEXT,
    type_enseignement TEXT DEFAULT 'general',
    secteur TEXT DEFAULT 'general',
    etablissements_phares TEXT
);

-- Si la table existait déjà avec un schéma antérieur, on garantit la présence de chaque colonne
ALTER TABLE IF EXISTS public.disciplines ADD COLUMN IF NOT EXISTS code TEXT;
ALTER TABLE IF EXISTS public.disciplines ADD COLUMN IF NOT EXISTS libelle TEXT;
ALTER TABLE IF EXISTS public.disciplines ADD COLUMN IF NOT EXISTS icone TEXT;
ALTER TABLE IF EXISTS public.disciplines ADD COLUMN IF NOT EXISTS type_enseignement TEXT DEFAULT 'general';
ALTER TABLE IF EXISTS public.disciplines ADD COLUMN IF NOT EXISTS secteur TEXT DEFAULT 'general';
ALTER TABLE IF EXISTS public.disciplines ADD COLUMN IF NOT EXISTS etablissements_phares TEXT;

-- Index unique sur code pour garantir le bon fonctionnement de ON CONFLICT (code)
CREATE UNIQUE INDEX IF NOT EXISTS disciplines_code_idx ON public.disciplines (code);

-- Ajout des colonnes sur la table cours (si elle existe)
ALTER TABLE IF EXISTS public.cours ADD COLUMN IF NOT EXISTS type_enseignement TEXT DEFAULT 'general';
ALTER TABLE IF EXISTS public.cours ADD COLUMN IF NOT EXISTS filiere TEXT;

-- 2. Harmonisation des disciplines d'Enseignement Général existantes
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('philo', 'Philosophie', 'local_fire_department_rounded', 'general', 'Enseignement Général', 'Tous les lycées généraux du Gabon'),
('maths', 'Mathématiques Générales', 'calculate_rounded', 'general', 'Enseignement Général', 'Lycées d''État (Séries C, D, B)'),
('pc', 'Physique - Chimie', 'science_rounded', 'general', 'Enseignement Général', 'Lycées d''État (Séries C, D)'),
('ses', 'Sciences Économiques et Sociales', 'trending_up_rounded', 'general', 'Enseignement Général', 'Lycées Léon Mba, Paul Indjendjet Gondjout (Série B)'),
('francais', 'Français & Littérature', 'menu_book_rounded', 'general', 'Enseignement Général', 'Tous les lycées généraux du Gabon (Séries A1, A2)')
ON CONFLICT (code) DO UPDATE 
SET type_enseignement = 'general',
    secteur = 'Enseignement Général';

UPDATE public.cours 
SET type_enseignement = 'general' 
WHERE type_enseignement IS NULL;

-- 3. Insertion exhaustive des filières d'actualité du Technique & Professionnel
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
-- =====================================================================
-- SECTEUR 1 : BAC STI (SCIENCES ET TECHNOLOGIES INDUSTRIELLES)
-- =====================================================================
('f1_meca', 'F1 : Génie Mécanique (Productique)', 'settings_suggest_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Nyonda Makita, LTK'),
('f1c_metal', 'F1C : Structures Métalliques & Chaudronnerie', 'construction_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, CIMFEP Nkok'),
('f2_elec', 'F2 : Génie Électronique', 'memory_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Nyonda Makita'),
('f3_electrotech', 'F3 : Génie Électrotechnique', 'bolt_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Nyonda Makita, LT Fulbert Bongotha'),
('f4_batiment', 'F4 : Génie Civil & Bâtiment', 'apartment_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Nyonda Makita, CFEP Bois-BTP'),
('sti_ac', 'AC : Architecture & Construction', 'home_work_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB'),
('mva_auto', 'MVA : Maintenance des Véhicules Automobiles & Industriels', 'directions_car_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, CIMFEP Nkok, Port-Gentil'),
('isec_clim', 'ISEC : Systèmes Énergétiques & Climatiques (Froid)', 'ac_unit_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, CIMFEP Nkok'),
('sti_er', 'ER : Énergies Renouvelables', 'solar_power_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Nkok (Transition Énergétique Gabon)'),
('sti_si', 'SI : Sciences de l''Ingénierie (STI)', 'architecture_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Lycée Technologique de Léconi'),
('maintenance_indus', 'Maintenance Industrielle (MI)', 'build_circle_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Nyonda Makita, Port-Gentil, Moanda'),
('biomedical', 'Maintenance des Équipements Biomédicaux', 'health_and_safety_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB (Filière hospitalière très demandée)'),
('info_indus', 'Informatique Industrielle & Systèmes Embarqués', 'computer_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB'),
('genie_bois', 'F1D : Génie Industriel Bois & Matériaux Associés', 'carpenter_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, CFEP Bois-BTP Nkok'),

-- =====================================================================
-- SECTEUR 2 : BAC STL (SCIENCES ET TECHNOLOGIES DE LABORATOIRE) & LÉCONI
-- =====================================================================
('stl_bgb', 'STL BGB : Biochimie - Génie Biologique', 'biotech_rounded', 'technique_pro', 'Laboratoire & STL', 'Examens CGBT - Laboratoires Médicaux & Agroalimentaires'),
('stl_clpi', 'STL CLPI : Chimie de Laboratoires et Procédés Industriels', 'science_rounded', 'technique_pro', 'Laboratoire & STL', 'Mines de Moanda, Raffinerie SOGARA, Pétrole'),
('si_leconi', 'Sciences de l''Ingénierie (SI)', 'precision_manufacturing_rounded', 'technique_pro', 'Lycée Technologique de Léconi', 'Léconi'),
('biothec', 'Bio Technologies (Bio Thec)', 'eco_rounded', 'technique_pro', 'Lycée Technologique de Léconi', 'Léconi'),
('spcl', 'Sciences Physiques et Chimie de Laboratoire (SPCL)', 'opacity_rounded', 'technique_pro', 'Lycée Technologique de Léconi', 'Léconi'),
('meh', 'Maintenance des Équipements Hospitaliers (MEH)', 'medical_services_rounded', 'technique_pro', 'Lycée Technologique de Léconi', 'Léconi'),
('cqa', 'Contrôle Qualité Agroalimentaire (CQA)', 'fact_check_rounded', 'technique_pro', 'Lycée Technologique de Léconi', 'Léconi'),

-- =====================================================================
-- SECTEUR 3 : CYCLE TECHNOLOGIQUE TERTIAIRE : STMG & CYCLE PRO
-- =====================================================================
('stmg_merca', 'STMG Mercatique (Marketing & Négociation)', 'campaign_rounded', 'technique_pro', 'Tertiaire & Management', 'LTNOB, Nyonda Makita, LTAO, Ntoum, Obendze'),
('stmg_rhc', 'STMG Ressources Humaines & Communication', 'people_alt_rounded', 'technique_pro', 'Tertiaire & Management', 'LTNOB, Nyonda Makita, LTAO, Ntoum, Obendze'),
('stmg_gsi', 'STMG Gestion & Systèmes d''Information', 'lan_rounded', 'technique_pro', 'Tertiaire & Management', 'LTNOB, Nyonda Makita, LTAO, Ntoum, Obendze'),
('stmg_cfe', 'STMG Comptabilité & Finance d''Entreprise', 'account_balance_rounded', 'technique_pro', 'Tertiaire & Management', 'LTNOB, Nyonda Makita, LTAO, Ntoum, Obendze'),
('cmfe_pk', 'CMFE : Comptabilité, Marketing & Finances d''Entreprises', 'analytics_rounded', 'technique_pro', 'Tertiaire & Management', 'Lycée Scientifique et Technologique Paul Kouya'),
('sb_cg', 'Cycle Modulaire : Secrétariat Bureautique (SB) & Comptabilité (CG)', 'assignment_rounded', 'technique_pro', 'Cycle Modulaire', 'Nyonda Makita, LTAO, LTK'),
('tcg_tga', 'Cycle Pro : TCG (Commerce) & TGA (Gestion Administrative)', 'business_center_rounded', 'technique_pro', 'Cycle Professionnel', 'Nyonda Makita, LTAO, LTK'),

-- =====================================================================
-- SECTEUR 4 : PÔLE MÉTIERS D'AVENIR & FORMATION PROFESSIONNELLE (NKOK / BIKÉLÉ)
-- =====================================================================
('froid_clim', 'Froid & Climatisation Industrielle', 'ac_unit_rounded', 'technique_pro', 'Métiers d''Avenir', 'CIMFEP Nkok, CFPP Bikélé'),
('ntic_reseaux', 'Réseaux Télécoms & Fibre Optique', 'settings_ethernet_rounded', 'technique_pro', 'Métiers d''Avenir', 'CFEP NTIC Nkok'),
('ntic_dev', 'Développement Web, Mobile & Cybersécurité', 'security_rounded', 'technique_pro', 'Métiers d''Avenir', 'CFEP NTIC Nkok'),
('agri_machines', 'Maintenance des Machines Agricoles & Engins Lourds', 'agriculture_rounded', 'technique_pro', 'Métiers d''Avenir', 'CIMFEP Nkok'),
('soudage_indus', 'Ingénierie & Technologie du Soudage Industriel', 'flash_on_rounded', 'technique_pro', 'Métiers d''Avenir', 'CIMFEP Nkok'),

-- =====================================================================
-- SECTEUR 5 : 1ER CYCLE TECHNIQUE : CET & CAP (DÈS LA 4E)
-- =====================================================================
('cet_elec', 'CET : Électricité du Bâtiment & Installations', 'electrical_services_rounded', 'technique_pro', '1er Cycle : CET & CAP', 'CET Libreville, CET Mouila (CAP)'),
('cet_meca', 'CET : Mécanique Automobile & Moteurs', 'car_repair_rounded', 'technique_pro', '1er Cycle : CET & CAP', 'CET Libreville, Port-Gentil (CAP)'),
('cet_bois', 'CET : Menuiserie, Ébénisterie & Bois', 'carpenter_rounded', 'technique_pro', '1er Cycle : CET & CAP', 'CET et Centres Professionnels'),
('cet_btp', 'CET : Maçonnerie & Gros Œuvre BTP', 'foundation_rounded', 'technique_pro', '1er Cycle : CET & CAP', 'CET Libreville, Oyem, Mouila (CAP)'),
('cet_metal', 'CET : Chaudronnerie & Serrurerie Métallique', 'construction_rounded', 'technique_pro', '1er Cycle : CET & CAP', 'CET et Pôles industriels'),
('cet_bureau', 'CET : Employé de Bureau, Secrétariat & Saisie', 'desk_rounded', 'technique_pro', '1er Cycle : CET & CAP', 'CET Tertiaire (CAP)'),
('cet_mode', 'CET : Coupe, Couture & Métiers de la Mode', 'styler_rounded', 'technique_pro', '1er Cycle : CET & CAP', 'Centres Féminins et CET')

ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;

-- 4. Sécurité RLS (Row Level Security) : activation et politique de lecture pour tous
ALTER TABLE public.disciplines ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "disciplines_read_all" ON public.disciplines;
CREATE POLICY "disciplines_read_all" ON public.disciplines FOR SELECT USING (true);

