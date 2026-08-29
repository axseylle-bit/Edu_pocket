________________________________________
PROMPT POUR GOOGLE AI STUDIO — PHILO POCKET (version consolidée)
________________________________________

## Contexte du projet

Je souhaite développer une application mobile (Android et iOS) ainsi qu'une version Web appelée **Philo Pocket**.

Philo Pocket est une plateforme éducative dédiée à l'enseignement de la philosophie selon le programme officiel du Gabon. L'objectif est de rendre la philosophie plus accessible, plus concrète et plus attractive grâce à une expérience pédagogique moderne, tout en respectant le programme officiel, la méthodologie nationale et les critères d'évaluation.

L'application doit donner à l'utilisateur l'impression de disposer d'une véritable salle de classe de philosophie dans sa poche.

**Slogan** : « Philo Pocket : la philosophie comme en classe, partout, pour tous. »

**Problème résolu** : (1) l'accès difficile à un enseignement de qualité en philosophie conforme au programme officiel, (2) le coût élevé ou l'indisponibilité des cours de soutien pour les élèves éloignés ou à moyens limités.

**Positionnement** : l'application ne remplace pas le professeur, elle démocratise l'accès à l'enseignement philosophique.

________________________________________

## Objectifs

L'application doit permettre :
- d'apprendre la philosophie de manière progressive ;
- de réviser efficacement ;
- d'évaluer les connaissances ;
- de mesurer la progression réelle de chaque élève ;
- d'accompagner les parents dans le suivi scolaire ;
- de proposer ultérieurement des cours de soutien.

Le MVP concerne les classes de **Première et Terminale**. La langue principale est le français. L'architecture doit permettre l'ajout rapide d'une version anglaise et, à terme, d'autres disciplines que la philosophie.

Pas de gamification (points, badges) — l'attractivité repose sur une interface soignée, pas sur des mécaniques de jeu.

________________________________________

## Utilisateurs

### MVP (V1)

**Élève**
- crée un compte, choisit son niveau scolaire et son établissement ;
- suit les cours, consulte les documents officiels ;
- réalise les quiz et, quand disponibles, les travaux pratiques (TP) ;
- suit sa progression ;
- dialogue avec ALECKSE.

**Parent**
- ne crée pas directement un lien avec un enfant : l'élève invite son parent via un **code d'invitation** ;
- consulte uniquement les informations autorisées sur la progression de son enfant ;
- peut suivre plusieurs enfants sur un même compte.

**Administrateur**
- gère les utilisateurs, les contenus, les quiz, les statistiques, la publication des cours, la validation des TP.

### Prévu pour la V2 (l'architecture doit anticiper leur arrivée sans les développer en V1)

**Curieux** : découvre librement une partie du contenu (citations, podcasts, quelques cours, débats, accès communauté), sans suivre un parcours scolaire complet.

**Enseignant** : publie des cours, suit ses élèves, crée des quiz et des TP, anime des classes virtuelles, vend des cours de soutien individuels sur la marketplace.

> Note pour Google AI Studio : même si Curieux et Enseignant ne sont pas développés en V1, prévoir dès la conception de la base de données un champ de rôle extensible (`role: eleve | parent | admin | enseignant | curieux`) pour éviter une refonte du modèle de données en V2.

________________________________________

## Fonctionnalités principales (MVP)

- authentification par email ou téléphone ;
- choix du niveau scolaire et de l'établissement ;
- accès aux cours (programme officiel) ;
- documents officiels ;
- méthodologie nationale (dissertation, commentaire) et grille de notation officielle du Gabon ;
- **travaux pratiques (TP) / ateliers** : exercices pratiques qui amènent une notion abstraite vers le concret (esprit du mythe de la caverne), **proposés notion par notion mais consultables librement, sans être imposés** — certaines notions n'en ont pas encore, c'est un contenu évolutif ;
- quiz ;
- tableau de bord personnalisé (vue différente selon le rôle : élève / parent) ;
- suivi de progression ;
- consultation hors connexion après téléchargement (fonctionnalité premium, voir modèle économique) ;
- assistance par ALECKSE ;
- dialogue façon chat avec des philosophes classés par courants et grandes idées (fonctionnalité premium, voir modèle économique) ;
- paiement des abonnements et des services premium.

### Prévu pour la V2
- marketplace de cours de soutien individuels avec un enseignant ;
- profils enseignants complets (classes virtuelles, statistiques par élève).

________________________________________

## ALECKSE

ALECKSE est l'assistant pédagogique de Philo Pocket. Il accueille l'utilisateur dès l'écran d'accueil, se présente, l'interroge sur son profil (élève, curieux...) puis l'oriente vers l'espace correspondant.

Il peut :
- expliquer une notion ;
- répondre aux questions ;
- encourager l'élève ;
- proposer des révisions et un plan de révision personnalisé ;
- orienter vers un cours ;
- aider à comprendre une erreur après un quiz.

ALECKSE s'appuie en priorité sur les contenus validés de Philo Pocket. Il peut enrichir ses réponses avec des exemples et des analogies, sans jamais contredire les contenus pédagogiques officiels.

**Différenciation par palier** (voir modèle économique) : au niveau gratuit, ALECKSE répond aux questions de base avec un nombre d'échanges limité par jour. Au niveau payant, il propose un accompagnement illimité et un plan de révision personnalisé adaptatif.

________________________________________

## Modèle économique

**Principe directeur** : le programme officiel complet reste accessible gratuitement à tous les élèves — c'est le cœur de la mission de Philo Pocket. Le paiement finance le confort, l'approfondissement et le suivi, pas l'accès au savoir lui-même.

### Paliers (freemium échelonné)

| Palier | Prix indicatif | Contenu |
|---|---|---|
| **Gratuit** | 0 FCFA | Programme officiel complet, méthodologie nationale, 1 quiz par notion, ALECKSE en usage limité |
| **Essentiel** | ~2 500 FCFA/mois | + quiz illimités, suivi de progression détaillé, bulletin hebdomadaire envoyé au parent |
| **Confort** | ~4 500 FCFA/mois | + TP/ateliers, dialogue avec les philosophes par courants et grandes idées, bac blanc chronométré et noté selon la grille officielle, annales corrigées, téléchargement hors ligne, ALECKSE avancé (plan de révision personnalisé) |
| **Famille** | palier Confort + tarif dégressif par enfant supplémentaire | Vue parent consolidée pour plusieurs enfants |

**Options additionnelles** :
- abonnement annuel à prix réduit (paiement de 10 mois pour 12 mois d'accès) ;
- offre saisonnière « spécial bac » (annales et bac blanc illimités), vendue dans les 2-3 mois précédant l'examen ;
- licences institutionnelles B2B (établissements scolaires, ministère, ONG partenaires) — revenu principal et stable, permettant de maintenir l'accès gratuit ou quasi-gratuit côté élève.

### Fonctionnalités qui incitent le parent à payer
- bulletin hebdomadaire automatique sur la progression de l'enfant ;
- indicateur de préparation au bac (score de couverture du programme) ;
- bac blanc noté selon la grille officielle ;
- annales corrigées des années précédentes ;
- plan de révision personnalisé avec rappels.

### Moyens de paiement (Gabon)
- **Airtel Money** et **Moov Money** (moyens dominants, y compris pour les familles peu bancarisées) ;
- interopérabilité via une infrastructure régionale de type **GIMACPAY** (supervisée par la BEAC, zone CEMAC) ou un agrégateur de paiement (ex. CinetPay) qui unifie plusieurs opérateurs derrière une seule API — à privilégier plutôt qu'une intégration directe et séparée avec chaque opérateur télécom ;
- virement bancaire et carte bancaire, surtout pour les paiements B2B (établissements, institutions).

### Sécurité des paiements
- ne jamais stocker les identifiants ou numéros de compte mobile money dans l'application : toutes les données sensibles transitent uniquement par l'agrégateur de paiement ;
- confirmation de paiement uniquement via webhook signé côté serveur (jamais de confirmation déclarée côté client) ;
- chiffrement TLS/HTTPS sur toutes les communications ;
- journalisation complète des transactions et limitation du taux de requêtes sur les endpoints de paiement ;
- détection d'anomalies (tentatives répétées, montants incohérents).

________________________________________

## Données à gérer

- utilisateurs (avec rôle extensible : élève, parent, admin, enseignant, curieux) ;
- établissements scolaires ;
- parents ;
- invitations parent-enfant ;
- niveaux scolaires ;
- cours ;
- chapitres ;
- notions ;
- travaux pratiques / ateliers (liés à une notion, optionnels) ;
- quiz ;
- questions ;
- réponses ;
- résultats ;
- progression ;
- temps d'étude ;
- abonnements et paliers ;
- transactions de paiement.

________________________________________

## Règles métier

- un élève appartient à un niveau scolaire et à un établissement ;
- un parent peut suivre plusieurs enfants ;
- un enfant peut inviter un ou plusieurs parents via un code d'invitation ;
- les quiz sont associés à une notion ;
- les TP sont associés à une notion mais ne sont pas obligatoires pour progresser ;
- chaque résultat met automatiquement à jour la progression ;
- les cours doivent pouvoir être consultés hors connexion après téléchargement (fonctionnalité du palier Confort) ;
- les contenus publiés doivent être validés par un administrateur avant leur mise en ligne ;
- l'accès aux fonctionnalités premium est déterminé par le palier d'abonnement actif de l'utilisateur.

________________________________________

## Écrans principaux

1. Accueil avec présentation de Philo Pocket et d'ALECKSE, qui interroge l'utilisateur puis l'oriente vers son espace.
2. Connexion / inscription.
3. Choix du profil, du niveau scolaire et de l'établissement.
4. Tableau de bord de l'élève.
5. Liste des cours.
6. Lecture d'un cours (documents officiels → cours avec problématique actuelle → notions → TP optionnel → quiz).
7. Quiz.
8. Résultats et progression.
9. Tableau de bord parent.
10. Abonnement / paliers / paiement.

________________________________________

## Tableau de bord

**Élève** — afficher : progression globale, notions maîtrisées, notions à revoir, prochains quiz recommandés, temps d'étude, historique.

**Parent** — afficher : résumé de la progression, temps d'étude, résultats récents, indicateur de préparation au bac, recommandations de révision.

________________________________________

## Intelligence artificielle

Utiliser l'IA pour : personnaliser les révisions, expliquer les notions, répondre aux questions, adapter les recommandations, motiver l'élève, générer les bulletins hebdomadaires et le plan de révision personnalisé.

________________________________________

## Expérience utilisateur (UX)

L'application doit être simple, élégante, chaleureuse, moderne, légèrement académique.

**Palette officielle** :
- ⚪ Blanc cassé — fond principal (confort de lecture) ;
- 🔵 Bleu nuit — couleur principale (navigation, en-têtes, boutons principaux — confiance, sérieux) ;
- 🌸 Rose poudré — couleur secondaire (chaleur, proximité — cartes, messages d'encouragement) ;
- ✨ Or poudré — couleur d'accent (progression, réussite, boutons d'action prioritaires).

Prévoir un mode sombre. Interface pensée d'abord pour mobile, puis adaptée au Web.

________________________________________

## Identité visuelle

Le logo doit évoquer l'idée de « la connaissance dans la poche ».

ALECKSE est un avatar 3D portant une tenue intemporelle inspirée du monde académique, avec un chignon afro, une toque discrète et un pendentif en forme de flamme représentant la connaissance.

________________________________________

## Contraintes techniques

- architecture évolutive, permettant l'ajout de nouveaux rôles (enseignant, curieux) et de nouvelles disciplines sans refonte majeure ;
- base de données relationnelle, avec la hiérarchie explicite : utilisateur → niveau → cours → chapitre → notion → (TP optionnel) → quiz → question → réponse → résultat ;
- code modulaire ;
- interface responsive ;
- intégration des paiements via un agrégateur (Airtel Money, Moov Money, cartes, virements) plutôt que des connexions directes par opérateur ;
- bonnes pratiques de sécurité, en particulier sur les données de paiement (voir section Modèle économique) ;
- possibilité d'ajouter facilement d'autres disciplines dans le futur.

________________________________________

## Demande finale

Avant de commencer le développement, analyse ce cahier des charges. Si certaines informations sont incomplètes, ambiguës ou incompatibles entre elles, pose toutes les questions nécessaires et propose des améliorations avant de générer la première version de l'application.
