# Journal de Bord - EduPocket Gabon (ex-Philo Pocket)

Ce document sert de mémoire centrale pour suivre la progression du développement technique, juridique et stratégique d'EduPocket Gabon.

---

## 📅 Session du 11 - 12 Octobre 2026 : Sécurité, Conformité Juridique, Verrouillage Pilote & Stratégie Recrutement

### 1. 🛡️ Cybersécurité & Verrouillage Git (Secrets & Leak Prevention)
- ✅ **Exclusion des secrets de production** : Inscription stricte de `.env`, `*.env`, `*.jks`, `*.keystore`, et `key.properties` dans `.gitignore` (au niveau du projet Flutter et à la racine).
- ✅ **Nettoyage de l'historique d'index** : Suppression du fichier `.env` de l'index Git (`git rm --cached`).
- ✅ **Migration du dépôt distant** : Renommage propre et synchronisation vers le nouveau dépôt GitHub public : `https://github.com/axseylle-bit/Edu_pocket.git`.

### 2. 🔐 Sécurisation de la Base de Données (Supabase RLS & Fonctions RPC)
- ✅ **Déploiement de la migration `20261011_security_and_privacy_hardening.sql`** :
  - **Correction de la faille de lecture publique** : Suppression de la clause permissive `OR (auth.role() = 'authenticated')` sur la table `profils_eleves`.
  - **Création de la fonction RPC sécurisée `lier_parent_eleve`** : Utilisation d'un code d'invitation parent généré cryptographiquement (`Random.secure()`).
  - **Création de la fonction RPC `supprimer_mon_compte`** : Droit à l'oubli et purge irréversible des données conformément à la Loi APDPVP n° 025/2023.
  - **Verrouillage anti-fraude des abonnements** : Restriction stricte des insertions/mises à jour dans la table `abonnements` au seul rôle serveur (`service_role`).

### 3. ⚖️ Conformité Juridique, Éthique & APDPVP (Gabon)
- ✅ **Rédaction des Mentions Légales & Charte Éthique** (`docs/MENTIONS_LEGALES_ET_CHARTE_ETHIQUE.md`) intégrant l'éthique de l'IA ALECKSE et le cadre légal gabonais (Ordonnance n° 0011/PR/2024 sur les droits d'auteur).
- ✅ **Rédaction des CGU / CGV** (`docs/CGU_CGV_EDUPOCKET.md`) avec encadrement des micro-paiements Mobile Money (Airtel Money / Moov Money, réglementation CEMAC / COBAC).
- ✅ **Rédaction de la Politique de Confidentialité APDPVP** (`docs/POLITIQUE_CONFIDENTIALITE_APDPVP.md`) et de la page web déployable (`docs/privacy.html`).
- ✅ **Guide de formalisation administrative APDPVP** (`docs/GUIDE_DECLARATION_APDPVP_GABON.md`) pour le dépôt du dossier à Libreville.
- ✅ **Modèle de contrat de partenariat enseignant** (`docs/CONTRAT_PARTENARIAT_ENSEIGNANT_EDUPOCKET.md`) sécurisant les 70 % de royalties sans requalification en contrat de travail.

### 4. 📱 Application Mobile Flutter : Intégrations & Déploiement de l'Option B
- ✅ **Composant visualiseur de documents in-app** (`LegalDocumentViewerScreen`) avec support Markdown et copie des fichiers légaux dans les assets de l'application.
- ✅ **Écran d'authentification (`auth_screen.dart`)** : Ajout d'une case obligatoire d'acceptation des CGU et de la Politique de Confidentialité avec mention spéciale pour le consentement parental des mineurs et liens cliquables.
- ✅ **Écran de profil (`profile_screen.dart`)** : Ajout de la section des documents légaux et du bouton de suppression irréversible du compte utilisateur connecté à la RPC Supabase.
- ✅ **Verrouillage Phase Pilote (Option B) dans `role_selection_screen.dart`** :
  - **Enseignant / Collègue** : Mis en avant tout en haut avec badge vert `ACCÈS OUVERT`, bouton interactif menant directement à l'espace enseignant (`/teacher-partner`).
  - **Élève / Étudiant**, **Parent / Tuteur** et **Curieux** : Verrouillés avec cadenas et badge `OUVERTURE PROCHAINE`. Boîte modale explicative de la phase pilote et collecte d'intérêt sans frustration.
- ✅ **Tests de non-régression** : `flutter test` validé à 100 %.

### 5. 🎯 Stratégie de Recrutement des Enseignants & Quotas Provinciaux (606 Places)
- ✅ **Élaboration du document stratégique** (`docs/STRATEGIE_RECRUTEMENT_ENSEIGNANTS_PIONNIERS.md`).
- ✅ **Calibrage officiel du Grand Libreville (150 places)** :
  - **100 places pour l'Enseignement Général** :
    - *Piliers transversaux (6e ➔ Tle - 88 places)* : Français (18), Mathématiques (18), Physique-Chimie (14), SVT (14), Histoire-Géo/ÉC (14), Anglais (10).
    - *Second cycle & Langues (12 places)* : Philosophie (4), Espagnol LV2 (4), SES Série B (4).
  - **50 places pour l'Enseignement Technique & Professionnel** :
    - *Tertiaire (20 places)* : G2 Compta (8), G3 Commerce (6), G1 Secrétariat (6).
    - *Industriel (20 places)* : F3 Électrotech (6), F4 BTP (6), F2/TI Numérique (5), F1 Mécanique (3).
    - *Filières stratégiques (10 places)* : Bois/Nkok (4), Maintenance (3), Transit (3).
- ✅ **Grille nationale sur les 9 provinces du Gabon** : Application de la dégressivité démographique (Total national : **405 Général + 201 Technique = 606 places**).
- ✅ **Kit de conviction rédigé** : Speech oral de 90 secondes en salle des profs, modèle de message WhatsApp prêt à copier-coller et argumentaire par matière.
- ✅ **Méthode commando anti-goulot d'étranglement (Objectif Fin Décembre)** :
  - Règle « 1 Enseignant = 1 Chapitre Officiel » (zéro travail perdu, couverture intégrale du programme en parallèle).
  - Sélection sur « Micro-Test d'Éligibilité » (1 fiche + 5 QCM seulement) pour ne léser aucun candidat.
- ✅ **Critères académiques obligatoires définis** : Un cours complet doit comprendre :
  1. Une mini fiche pédagogique (objectifs et compétences du programme national).
  2. Le cours rédigé selon la méthodologie officielle gabonaise.
  3. Des Travaux Dirigés (TD) avec exercices d'application corrigés.
  4. Des extraits de textes d'auteurs ou schémas cotés.
  5. Une bibliographie conforme aux exigences de la discipline.

### 6. 🏛️ Restructuration du Dashboard & Architecture "Vaisseau Amiral"
- ✅ **Rétablissement de l'ergonomie originelle** :
  - **Philo Pocket** mis en valeur en grand « Vaisseau Amiral » à gauche (15 notions IPN intégrales pour le Bac).
  - Grille des autres disciplines à droite, toutes actives, colorées et accessibles (Maths, Physique-Chimie, Français & Lettres, SVT, Histoire-Géo, SES, Anglais, Espagnol, Allemand).
  - Élimination de tout bandeau payant sur les cours de base : affichage permanent du macaron **« Gratuit IPN »**.
- ✅ **Intégration d'un accès de test administrateur/fondateur** : Permet à la fondatrice de tester et revivre chaque parcours élève/parent/enseignant sans être redirigée automatiquement.

### 7. 📚 Intégration Massive des 28 Documents Officiels IPN (2026-2027)
- ✅ **Téléchargement et intégration locale dans `assets/ipn/`** :
  - **Mathématiques (10 documents)** : 6e, 5e, 4e, 3e, 2de S/STI, 2de LE/STMG, 1ère S/SI, Terminale A1/B, Référentiel d'évaluation BEPC, Banque d'épreuves.
  - **Physique-Chimie (8 documents)** : 6e, 5e, 4e, 3e, 2nde S/STI, 1ère S/SI, Terminale D, Terminale C/SI.
  - **Français & Lettres (1 document intégral de 94 Ko)** : Progressions officielles complètes du Collège (6e, 5e, 4e, 3e).
  - **S.E.S (3 documents)** : Seconde, 1ère B, Terminale B.
  - **Philosophie & Textes Cadres IPN (6 documents officiels PDF)** : Progressions nationales (2,4 Mo), Méthodologies nationales v2, Épreuve orale, Grilles d'évaluation harmonisées, Critères d'élaboration des épreuves, Étude d'une œuvre.
- ✅ **Déclaration complète des répertoires d'assets** dans `pubspec.yaml`.
- ✅ **Création de la Bibliothèque des Progressions & IPN (`IpnResourcesScreen`)** : Filtrage dynamique par onglets thématiques, visionneuse Markdown pour les progressions et visionneuse PDF (`SfPdfViewer`) pour les textes réglementaires.
- ✅ **Grande Bannière VIP d'accès direct sur le Dashboard** :
  - Mise en évidence de l'archive de **28 documents certifiés IPN 2026-2027**.
  - Boutons d'accès directs par discipline depuis les fiches de cours et depuis les outils transversaux.

### 8. 💡 Clarification Stratégique Fondamentale : Modèle Économique en PACKAGES (Pas par Matière)
- ✅ **Prise de conscience & arbitrage de la fondatrice** :
  - **Problème identifié** : Une tarification individuelle par matière (ex: 2 500 F x 9 matières = 22 500 F/mois) ruinerait les parents gabonais et trahirait la mission sociale d'EduPocket.
  - **Solution EduPocket** : **Les cours officiels sont 100% GRATUITS (Socle IPN à 0 FCFA)**, et les offres de renforcement sont structurées en **PACKAGES & FORMULES TRANSVERSALES GLOBALES** :
    1. **Pack Trimestre Réussite (6 500 FCFA / 3 mois)** : Couvre l'intégralité des matières pour sécuriser les compositions trimestrielles (soit ~2 160 F/mois).
    2. **Pack Annuel Examen d'État (19 000 FCFA / 9 mois)** : Pass complet pour l'année scolaire incluant toutes les annales officielles, corrections méthodologiques pas-à-pas et tuteur IA ALECKSE illimité.
    3. **Pack Filière Complète All-in-One (Technique & Pro : 6 000 FCFA / mois)** : Débloque toutes les matières d'atelier, de technologie et d'enseignement général de la série (STI, STMG, CET).
    4. **Paliers Pionniers transversaux** : Palier 1 (2 500 FCFA/mois) et Palier 2 (5 000 FCFA/mois) comme contributions de renforcement finançant les 70% de royalties aux enseignants.
- ✅ **Bénéfices majeurs** :
  - Protection absolue du pouvoir d'achat des familles gabonaises.
  - Immunité totale contre tout grief de "mercantilisme scolaire" devant le Ministère de l'Éducation Nationale.
  - Rémunération juste, transparente et automatisée des 606 enseignants partenaires.

### 9. 🚀 Validation Technique & Déploiement Continu
- ✅ **Analyse statique Flutter** : 0 erreur, 0 avertissement (`flutter analyze` passé avec succès).
- ✅ **Tests unitaires et de composants** : 100% des tests validés (`flutter test`).
- ✅ **Synchronisation Git & Dépôt distant** : Commits structurés et push direct sur la branche `main` du dépôt GitHub officiel `axseylle-bit/Edu_pocket`.

### 10. 🛡️ Traitement Exhaustif des Résultats de l'Audit (Cybersécurité, Paiements & Ergonomie)
- ✅ **Moteur de recherche temps réel dans la Bibliothèque IPN** (`ipn_resources_screen.dart`) :
  - Filtrage instantané des programmes, méthodologies et fiches pédagogiques par mots-clés sur l'ensemble des onglets.
  - Compteur dynamique de résultats et écran d'état vide interactif avec bouton de réinitialisation.
- ✅ **Sécurisation & Traçabilité Mobile Money CEMAC / Gabon** :
  - Validation stricte des numéros selon le plan officiel de numérotation ARCEP Gabon (9 chiffres, préfixes Airtel `074`, `076`, `077` et Moov `062`, `065`, `066`).
  - Génération de références de transaction uniques et jetons d'idempotence (`TXN-EDUPOCKET-...`).
  - Nouvelle table Supabase `paiements_mobile_money` avec politiques RLS strictes et enregistrement direct dans `SupabaseService`.
- ✅ **Durcissement du Tuteur IA ALECKSE (`ai_service.dart`)** :
  - Rate-limiting anti-flood (délai minimal de 1 500 ms entre deux messages avec rappel pédagogique de relecture).
  - Gestion élégante des ruptures réseau locales (Airtel/Moov/Wi-Fi) sans aucune fuite de détails techniques ou de stack traces.
- ✅ **Workflow Éditorial des Enseignants Pionniers (`20261012_editorial_workflow_and_transactions.sql`)** :
  - Modélisation de la table `cours_soumis_enseignants` avec cycle de validation officiel : `brouillon` ➔ `en_relecture_ipn` ➔ `valide_pedagogique` ➔ `publie`.
  - Politiques RLS garantissant que seuls les cours officiellement validés et publiés sont diffusés aux élèves et parents.
- ✅ **Zéro Régression & Zéro Warning** :
  - Suppression des variables inutilisées dans `supabase_service.dart`.
  - Validation sans faute de `flutter test` et `flutter analyze`.

---

## 📅 Sessions Précédentes

### 1. Création de l'application d'administration (e-eduPocket)
- ✅ Création complète du projet Flutter Web **e_edu_admin**.
- ✅ Intégration de Supabase (Copie du `.env`, initialisation).
- ✅ Mise en place du routage sécurisé avec `go_router`.
- ✅ Création de l'interface de connexion et du Layout administrateur (`AdminDashboardScreen`).
- ✅ Choix stratégique du nom : **"e-eduPocket"**.

### 2. Pédagogie : Cours "L'Art et la Technique"
- ✅ Intégration du cours `art_et_technique.md` dans la base de données locale (`assets/courses/`).
- ✅ Respect absolu du canevas méthodologique de dissertation pour les Terminales.

### 3. Intégration des Ressources Officielles (IPN) & Identité Visuelle
- ✅ Intégration du document "Progressions Nationales 2025-2026" via `SfPdfViewer`.
- ✅ Validation et intégration du logo officiel Version 2 (Poche/bouclier bleu nuit avec flamme dorée).

---

## 🚀 Prochaines Étapes Opérationnelles (Octobre - Décembre 2026)

### 1. Déploiement & Tests Pilotes Immédiats
- [ ] Compiler l'APK Android Release (`flutter build apk --release`) pour distribution directe aux premiers collègues testeurs.
- [ ] Activer GitHub Pages sur la branche `main` dossier `/docs` pour mise en ligne de la page de confidentialité.
- [ ] Dépôt du dossier de déclaration préalable à l'APDPVP (Libreville).

### 2. Recrutement & Production Pédagogique (Novembre 2026)
- [ ] Lancer l'appel à candidature WhatsApp avec la formule du micro-test (1 fiche + 5 QCM).
- [ ] Attribuer les chapitres découpés aux enseignants retenus (1 prof = 1 chapitre).
- [ ] Automatiser l'ingestion des cours Word dans la base de données Supabase.

### 3. Lancement Public (Janvier 2027)
- [ ] Déverrouiller les profils Élève et Parent dans `role_selection_screen.dart`.
- [ ] Raccorder les passerelles marchandes Airtel Money / Moov Money pour les abonnements.
