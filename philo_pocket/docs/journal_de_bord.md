# Journal de Bord - Philo Pocket

Ce document sert de mémoire pour suivre la progression du développement de l'application Philo Pocket. 
Il recense ce qui a été accompli et les étapes futures.

---

## 📅 Bilan de la session (Aujourd'hui)

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
- [ ] Connecter l'application à la base de données (basé sur le fichier `supabase_schema.sql` existant).
- [ ] Mettre en place l'authentification (Connexion/Inscription).
- [ ] Sauvegarder la progression réelle de l'élève (la "Jauge de progression" affiche 73% en dur pour le moment).

### 3. Fonctionnalités Cœur
- [ ] Implémenter l'Assistant IA **ALECKSE** pour qu'il donne de vrais conseils contextuels.
- [ ] Développer les écrans interactifs : **Quiz**, **TD (À revoir)**, et **TP**.
- [ ] Lier le système de "Paliers" (Tiers) pour débloquer les contenus (comme les TP) en fonction des points XP accumulés.
