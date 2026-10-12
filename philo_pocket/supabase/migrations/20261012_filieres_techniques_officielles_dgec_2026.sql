-- ==============================================================================
-- MIGRATION: 20261012_filieres_techniques_officielles_dgec_2026.sql
-- Harmonisation intégrale avec les arrêtés ministériels DGEC Gabon (Session 2026) :
-- 7 Filières de Baccalauréat (43 séries) et 5 Examens professionnels (21 options)
-- Répartis sur les 5 Zones Académiques du Gabon
-- ==============================================================================

-- 1. FILIÈRE N°1 : BACCALAURÉAT DES SCIENCES DE L'INGÉNIEUR (SI)
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('bac_si', 'Baccalauréat Sciences de l''Ingénieur (SI)', 'architecture_rounded', 'technique_pro', 'Filière SI (Sciences de l''Ingénieur)', 'LTNOB Libreville, Léconi, Port-Gentil, Oyem')
ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;

-- 2. FILIÈRE N°2 : BACCALAURÉAT SCIENCES ET TECHNOLOGIES DE L'INDUSTRIE (STI)
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('sti_f1', 'STI F1 : Génie Mécanique (Fabrication Mécanique)', 'settings_suggest_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB Libreville, Nyonda Makita'),
('sti_f1c', 'STI F1C : Productique Structure Métallique', 'construction_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, CIMFEP Nkok'),
('sti_f1d', 'STI F1D : Génie Mécanique (Bois et Matériaux Associés)', 'carpenter_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, CFEP Bois-BTP Nkok, Mouila'),
('sti_f2', 'STI F2 : Génie Électronique', 'memory_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LT Port-Gentil, Nyonda Makita'),
('sti_f3', 'STI F3 : Génie Électrotechnique', 'bolt_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Nyonda Makita, Port-Gentil'),
('sti_f4', 'STI F4 : Génie Civil', 'apartment_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Nyonda Makita, CFEP Nkok, Oyem'),
('sti_aec', 'STI AEC : Architecture Éco-Construction', 'home_work_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'Lycée Technologique de Léconi / Haut-Ogooué'),
('sti_ere', 'STI ERE : Énergies Renouvelables et Environnement', 'solar_power_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'Lycée Technologique de Léconi / Haut-Ogooué'),
('sti_mi', 'STI MI : Maintenance Industrielle', 'build_circle_rounded', 'technique_pro', 'Secteur Industriel (STI)', 'LTNOB, Port-Gentil, Moanda')
ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;

-- 3. FILIÈRE N°3 : BACCALAURÉAT SCIENCES ET TECHNOLOGIES DU TERTIAIRE (STT)
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('stt_aca', 'STT ACA : Action et Communication Administratives (ex-G1)', 'assignment_rounded', 'technique_pro', 'Secteur Tertiaire (STT)', 'LTNOB, LTAO, Nyonda Makita, Port-Gentil, Mouila'),
('stt_cg', 'STT CG : Comptabilité Gestion (ex-G2)', 'account_balance_rounded', 'technique_pro', 'Secteur Tertiaire (STT)', 'LTNOB, LTAO, Nyonda Makita, Port-Gentil, Mouila'),
('stt_acc', 'STT ACC : Action et Communication Commerciales (ex-G3)', 'campaign_rounded', 'technique_pro', 'Secteur Tertiaire (STT)', 'LTNOB, LTAO, Nyonda Makita, Port-Gentil, Mouila')
ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;

-- 4. FILIÈRE N°4 : SCIENCES ET TECHNOLOGIES DU MANAGEMENT ET DE LA GESTION (STMG)
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('stmg_cfe', 'STMG CFE : Comptabilité Finance d''Entreprise', 'account_balance_wallet_rounded', 'technique_pro', 'Management & Gestion (STMG)', 'LTNOB, LTAO, Léconi, Port-Gentil'),
('stmg_rhc', 'STMG RHC : Ressources Humaines et Communication', 'people_alt_rounded', 'technique_pro', 'Management & Gestion (STMG)', 'LTNOB, LTAO, Léconi, Port-Gentil'),
('stmg_gsi', 'STMG GSI : Gestion des Systèmes d''Information', 'lan_rounded', 'technique_pro', 'Management & Gestion (STMG)', 'LTNOB, LTAO, Léconi, Port-Gentil'),
('stmg_merca', 'STMG Mercatique (Marketing & Stratégie Commerciale)', 'trending_up_rounded', 'technique_pro', 'Management & Gestion (STMG)', 'LTNOB, LTAO, Léconi, Port-Gentil')
ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;

-- 5. FILIÈRE N°5 : BACCALAURÉAT DES SCIENCES ET TECHNOLOGIES DE LABORATOIRE (STL)
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('stl_biotech', 'STL BIOTECH : Biotechnologie', 'eco_rounded', 'technique_pro', 'Laboratoire & STL (Léconi)', 'Lycée Technologique de Léconi (Centre National)'),
('stl_spcl', 'STL SPCL : Sciences Physiques et Chimiques en Laboratoires', 'opacity_rounded', 'technique_pro', 'Laboratoire & STL (Léconi)', 'Lycée Technologique de Léconi'),
('stl_bgb', 'STL BGB : Biochimie Génie Biologique', 'biotech_rounded', 'technique_pro', 'Laboratoire & STL (Léconi)', 'Lycée Technologique de Léconi'),
('stl_clpi', 'STL CLPI : Chimie des Laboratoires et des Procédés Industriels', 'science_rounded', 'technique_pro', 'Laboratoire & STL (Léconi)', 'Léconi, Moanda, Port-Gentil')
ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;

-- 6. FILIÈRE N°6 : BACCALAURÉATS PROFESSIONNELS INDUSTRIELS & SERVICES (15 SÉRIES)
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('pro_mva_vp', 'Bac Pro MVA : Maintenance des Véhicules Automobiles (Option VP)', 'directions_car_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'LTNOB, CIMFEP Nkok, Port-Gentil, Oyem'),
('pro_mvi', 'Bac Pro MVI : Maintenance des Véhicules Industriels', 'local_shipping_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'LTNOB, Haut-Ogooué, Nkok'),
('pro_meni', 'Bac Pro Men.I : Menuiserie Industrielle', 'carpenter_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, Oyem, CFEP Bois Nkok'),
('pro_sd', 'Bac Pro SD : Sciage Déroulage (Filière Bois)', 'forest_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, CIMFEP Nkok'),
('pro_cbh', 'Bac Pro CBH : Construction Bois et Habitat', 'holiday_village_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, CFEP Bois-BTP Nkok'),
('pro_orgo', 'Bac Pro ORGO : Organisation et Réalisation du Gros Œuvre', 'foundation_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, Ngounié, Nyanga'),
('pro_isec', 'Bac Pro ISEC : Systèmes Énergétique et Climatique (Froid & Climatisation)', 'ac_unit_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, CIMFEP Nkok, Port-Gentil'),
('pro_ci', 'Bac Pro CI : Chaudronnerie Industrielle', 'precision_manufacturing_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, Port-Gentil, Nkok'),
('pro_meh', 'Bac Pro MEH : Maintenance des Équipements Hospitaliers', 'medical_services_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, Léconi / Haut-Ogooué'),
('pro_mei', 'Bac Pro MEI : Maintenance des Équipements Industriels', 'build_circle_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Port-Gentil, Moyen-Ogooué, Moanda'),
('pro_ei', 'Bac Pro EI : Électricité Industrielle', 'flash_on_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Ngounié, Nyanga, Estuaire'),
('pro_3i', 'Bac Pro 3I : Informatique et Internet Industriel', 'settings_ethernet_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, CFEP NTIC Nkok'),
('pro_dw', 'Bac Pro DW : Développement Multimédia ou Plateforme Web', 'web_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, CFEP NTIC Nkok'),
('pro_mmacm', 'Bac Pro MMACM : Maintenance Matériel Agricole & Manutention', 'agriculture_rounded', 'technique_pro', 'Baccalauréat Professionnel', 'Estuaire, CIMFEP Nkok')
ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;

-- 7. FILIÈRE N°7 : BACCALAURÉATS PROFESSIONNELS AGRICOLES, AGROALIMENTAIRES & TERTIAIRES
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('pro_sta_pa', 'Bac Pro STA PA : Production Animale (Élevage & Pastoralisme)', 'pets_rounded', 'technique_pro', 'Baccalauréat Professionnel Agricole', 'Estuaire, Ngounié, Nyanga'),
('pro_sta_pv', 'Bac Pro STA PV : Production Végétale (Agronomie Tropicale)', 'grass_rounded', 'technique_pro', 'Baccalauréat Professionnel Agricole', 'Estuaire, Ngounié, Nyanga'),
('pro_cqa', 'Bac Pro CQA : Contrôle Qualité Agro-alimentaire', 'fact_check_rounded', 'technique_pro', 'Baccalauréat Professionnel Qualité', 'Léconi, Haut-Ogooué'),
('pro_tcg', 'Bac Pro TCG : Techniques Comptables de Gestion', 'receipt_long_rounded', 'technique_pro', 'Baccalauréat Professionnel Tertiaire', 'Haut-Ogooué, Ogooué-Lolo'),
('pro_tga', 'Bac Pro TGA : Techniques de Gestion Administratives', 'contact_page_rounded', 'technique_pro', 'Baccalauréat Professionnel Tertiaire', 'Haut-Ogooué, Ogooué-Lolo')
ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;

-- 8. LES EXAMENS PROFESSIONNELS INTERMÉDIAIRES (ARTICLE 19) : BT, DENC, BPB, BEP, CAP
INSERT INTO public.disciplines (code, libelle, icone, type_enseignement, secteur, etablissements_phares) VALUES
('bt_fc', 'Brevet de Technicien (BT) : Froid et Climatisation (FC)', 'ac_unit_rounded', 'technique_pro', 'Brevet de Technicien (BT)', 'Port-Gentil, Moyen-Ogooué'),
('bt_mmd', 'Brevet de Technicien (BT) : Maintenance Moteur Diesel (MMD)', 'engineering_rounded', 'technique_pro', 'Brevet de Technicien (BT)', 'Port-Gentil, Moyen-Ogooué'),
('bpb_banque', 'Brevet Professionnel Bancaire (BPB) : Niveaux 1, 2, 3', 'account_balance_rounded', 'technique_pro', 'Brevet Bancaire (BPB)', 'Estuaire Libreville'),
('denc_cab_cgi', 'Diplôme ENC (DENC) : CAB, CGI, GCI', 'school_rounded', 'technique_pro', 'École Nationale de Commerce (DENC)', 'Port-Gentil'),
('bep_industriel', 'BEP Industriel : DCB, IS, OM, EB, MC, EAm, EAg, EM', 'construction_rounded', 'technique_pro', 'Brevet d''Études Professionnelles (BEP)', 'CET Libreville, Mouila, Port-Gentil, Oyem'),
('bep_tertiaire', 'BEP Tertiaire : Comptabilité-Gestion (CG) & Secrétariat-Bureautique (SB)', 'table_view_rounded', 'technique_pro', 'Brevet d''Études Professionnelles (BEP)', 'CET National (Toutes provinces)'),
('cap_industriel', 'CAP Industriel : Dessin Bâtiment (DCB), Chaudronnerie (ROC), Plomberie (IS)', 'handyman_rounded', 'technique_pro', 'Certificat d''Aptitude Pro (CAP)', 'CET Libreville, CET Intérieur'),
('cap_tertiaire', 'CAP Tertiaire : Aide-Comptable (AC) & Sténographie-Dactylographie (SD)', 'keyboard_rounded', 'technique_pro', 'Certificat d''Aptitude Pro (CAP)', 'CET National (Toutes provinces)')
ON CONFLICT (code) DO UPDATE 
SET libelle = EXCLUDED.libelle,
    icone = EXCLUDED.icone,
    type_enseignement = EXCLUDED.type_enseignement,
    secteur = EXCLUDED.secteur,
    etablissements_phares = EXCLUDED.etablissements_phares;
