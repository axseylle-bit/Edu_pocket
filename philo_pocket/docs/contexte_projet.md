# Contexte Global du Projet : Philo Pocket

## Vision
Philo Pocket est une plateforme éducative dédiée à l'enseignement de la philosophie (programme officiel du Gabon) pour les classes de Première et Terminale. 
Slogan : « Philo Pocket : la philosophie comme en classe, partout, pour tous. »

## Modèle Économique (Paliers / Abonnements)
Le cœur du savoir est gratuit, le confort et le suivi sont payants (Airtel Money, Moov Money, GIMACPAY).
1. **Gratuit** : Cours, méthodo IPN, 1 quiz par notion, ALECKSE basique.
2. **Essentiel** : Quiz illimités, suivi détaillé, bulletin hebdomadaire.
3. **Confort** : **TP/Ateliers**, dialogue avec philosophes, bac blanc, mode hors ligne, ALECKSE avancé.
4. **Famille** : Confort pour plusieurs enfants.

## Rôles Utilisateurs
- **V1 (MVP)** : Élève (suit les cours), Parent (sur invitation, suit la progression), Administrateur (gère le contenu).
- **V2** : Curieux (découverte libre), Enseignant (marketplace, classes virtuelles).

## ALECKSE (IA)
Assistant pédagogique virtuel (avatar 3D de professeure noire en toge avec pendentif flamme). Elle explique, guide, motive. Son niveau d'assistance dépend du palier d'abonnement.

## Design et UI/UX
- **Palette** : Blanc cassé (fond), Bleu nuit (primaire), Rose poudré (secondaire), Or poudré (accent).
- **Typographie** : Poppins.
- **Logo** : Flamme de connaissance sortant d'une poche.

## Architecture Base de Données
Relationnelle : `Utilisateur -> Niveau -> Cours -> Chapitre -> Notion -> (TP optionnel) -> Quiz -> Question -> Réponse -> Résultat`
