# Stratégie de Lancement et Monétisation (MVP) - Philo Pocket

Ce document consigne la stratégie commerciale, technique et financière retenue pour le lancement de la version MVP (Minimum Viable Product) de Philo Pocket au Gabon.

## 1. Modèle Technique et Coûts de Lancement

L'objectif est d'avoir des coûts fixes quasi nuls pour tester le marché sans risque financier.

*   **Backend & Base de données (Supabase) :**
    *   **Choix :** Plan Gratuit (jusqu'à 50 000 utilisateurs actifs/mois).
    *   **Coût :** **0 FCFA**
*   **Intelligence Artificielle (Google Gemini) :**
    *   **Choix :** API Gemini 1.5 Flash en "Pay-as-you-go" pour éviter les blocages en classe.
    *   **Coût estimé :** ~210 FCFA par million de tokens. Prévoir un micro-budget de **~6 000 FCFA / mois** pour le confort des élèves.
*   **Site Web Vitrine :**
    *   **Choix :** Nom de domaine propre (ex: philopocket.com) pour la crédibilité, hébergé gratuitement (Vercel/Firebase).
    *   **Coût :** **~9 000 FCFA / an** (nom de domaine).

👉 **Budget total pour lancer l'application : ~ 15 000 FCFA le premier mois.**

## 2. Stratégie de Distribution et de Paiement (L'approche "Commando")

Pour contourner les contraintes de Google Play (qui prend 15% de commission et bloque les paiements locaux sans carte bancaire), la stratégie de distribution sera la suivante :

### A. Distribution par Téléchargement Direct (APK)
*   **Fonctionnement :** L'application ne sera pas sur le Google Play Store dans un premier temps. Elle sera disponible en téléchargement direct (fichier `.apk`) depuis le site vitrine officiel de Philo Pocket.
*   **Avantage Viralité :** Les élèves pourront se partager l'application instantanément sans consommer de données internet (via Xender, Bluetooth, WhatsApp). C'est le mode de distribution le plus puissant dans les lycées gabonais.

### B. Monétisation via Mobile Money (CinetPay / FedaPay)
*   **Fonctionnement :** L'intégration du paiement (Airtel Money, Moov Money) se fera **directement à l'intérieur de l'application**.
*   **Parcours Utilisateur :** Lorsqu'un élève voudra débloquer le **Palier Confort** (ex: pour voir les animations 3D ou utiliser l'IA de manière illimitée), il cliquera sur un bouton, entrera son numéro de téléphone, et le paiement sera validé en quelques secondes.
*   **Avantages :** Zéro friction. Les achats d'impulsion (la veille d'un devoir) explosent car l'élève n'a pas besoin de quitter l'application pour aller payer sur un site web externe.
*   **Coût d'intégration :** **0 FCFA**. CinetPay se rémunère uniquement au succès (~1.5% par transaction).

## 3. Évolution Post-Lancement (Phase 2)
Une fois que le MVP aura généré ses premiers revenus via Airtel/Moov Money, l'argent récolté servira à financer la Phase 2 :
*   Paiement de la licence développeur Apple (99$) pour sortir la version iPhone.
*   Création d'une version "Lite" (sans paiement intégré) sur le Google Play Store pour gagner en visibilité SEO, avec redirection vers le site web pour les abonnements.
*   Passage au plan Supabase Pro (25$/mois) si le trafic explose.
