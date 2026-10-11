# Journal de Bord - Philo Pocket

Ce document sert de mémoire pour suivre la progression du développement de l'application Philo Pocket. 
Il recense ce qui a été accompli et les étapes futures.

---

## 📅 Bilan de la session (Aujourd'hui)

### 1. Création de l'application d'administration (e-eduPocket)
- ✅ Création complète du projet Flutter Web **e_edu_admin**.
- ✅ Intégration de Supabase (Copie du `.env`, initialisation).
- ✅ Mise en place du routage sécurisé avec `go_router` (redirection automatique si non connecté).
- ✅ Création de l'interface de connexion et du Layout administrateur (`AdminDashboardScreen`).
- ✅ Choix stratégique du nom : Abandon de "e-edu.ga" (risque institutionnel) au profit de **"e-eduPocket"**.

### 2. Pédagogie : Cours "L'Art et la Technique"
- ✅ Intégration du cours `art_et_technique.md` dans la base de données locale (`assets/courses/`).
- ✅ Respect absolu du canevas méthodologique de dissertation pour les Terminales (Fiche pédagogique, [Amorce], [Problématique], [Thèse], [Argument], [Exemple], etc.).
- ✅ Fusion réussie de la philosophie classique (Kant, Alain, Dalí) et de la culture tech/gabonaise (Back-end/Front-end, Masque Punu).

### 3. Stratégie Produit (Espace Enseignants & EdTech)
- ✅ Analyse critique de l'ouverture de l'application aux professeurs externes.
- ✅ Validation du modèle **MVP d'abord** : Pas de développement complexe de CMS ou de rejet algorithmique des cours pour le moment.
- ✅ Validation de la règle d'or EdTech : **Ne jamais faire payer le professeur**. L'enseignant est l'hameçon (prescripteur gratuit), l'élève est le client final (Premium).

### 4. Intégration de l'Héritage "Excel Virtualis" (EVA)
- ✅ Repositionnement d'**Excel Virtualis Academy (EVA)** : Abandon de l'ancien format (tutorat live 1h30/soir très coûteux) au profit d'un écosystème asynchrone propulsé par l'IA (ALECKSE).
- ✅ **L'Écosystème e-eduPocket** : Philo Pocket n'est qu'une des disciplines. Le lancement de toutes les disciplines (Maths, Physique, Français, etc.) se fera en même temps.
- ✅ **EVA comme "Sceau d'Excellence"** : Le système de progression de l'élève devient transversal. On n'accumule plus de simples XP, on gagne des **"Crédits EVA"**. Le statut académique global (initié, érudit, maître) est certifié par l'Excel Virtualis Academy et englobe l'assimilation de toutes les matières.

---

## 📅 Bilan des sessions précédentes

### 1. Intégration des Ressources Officielles (IPN)
- ✅ Ajout du document clé **"Progressions Nationales 2025-2026"**.
- ✅ Modification du code (`ipn_resources_screen.dart`) pour rendre ce PDF accessible depuis la liste des ressources de l'application.
- ✅ Correction d'un bug de nommage du fichier (`Progression nationales.pdf.pdf` ➡️ `progressions_nationales.pdf`) pour que l'application puisse l'afficher sans erreur (écran vide corrigé).

### 2. Refonte et Intégration du Logo
- ✅ Création de plusieurs propositions de logos professionnels pour remplacer l'esquisse de départ (effet "poche de jean").
- ✅ Choix final et validation de la **Version 2 (Premium)** : une poche/bouclier bleu nuit élégante avec une flamme dorée sans coutures.
- ✅ Remplacement de l'icône temporaire sur l'écran de bienvenue (`main.dart`) par ce nouveau logo officiel.
- ✅ Ajout du logo en haut du tableau de bord de l'élève (`student_dashboard_screen.dart`).

---

## 🚀 Reste à faire (Prochaines étapes)

### 1. Finalisation UI / UX (Interface)
- [ ] Ajuster la taille et les marges du logo sur différents écrans (mobile vs web).
- [ ] Vérifier que tous les autres documents IPN s'ouvrent correctement via le `SfPdfViewer`.

### 2. Base de données et Backend (Supabase)
- ✅ Connecter l'application à la base de données (basé sur le fichier `supabase_schema.sql` existant).
- ✅ Mettre en place l'authentification (Connexion/Inscription).
- ✅ Sauvegarder la progression réelle de l'élève (dynamique depuis Supabase pour les tableaux de bord élève et parent).

### 3. Fonctionnalités Cœur
- [ ] Implémenter l'Assistant IA **ALECKSE** pour qu'il donne de vrais conseils contextuels (TD validé ✅).
- [ ] Développer les écrans interactifs : **Quiz** (Fait ✅), **TD** (Fait ✅), et **TP**.
- [ ] Lier le système de "Paliers" (Tiers) pour débloquer les contenus (comme les TP) en fonction des points XP accumulés.

### 5. Mod�le �conomique (Redistribution Professeurs)
- ? **Validation du Mod�le de Revenue Share** : Adoption d'un partage de revenus pour les professeurs contributeurs sur la marketplace e-eduPocket.
- ? **R�partition valid�e** : 50% pour la plateforme (frais de serveurs, IA Gemini, frais CinetPay) et 50% pour le professeur. Variante possible : 70% pour le professeur s'il apporte lui-m�me l'�l�ve (parrainage/code promo). Cela fait du professeur le premier ambassadeur de l'application sans risque financier initial pour la structure.
