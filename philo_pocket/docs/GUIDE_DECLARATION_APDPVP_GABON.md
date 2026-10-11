# DOSSIER & GUIDE DE DÉCLARATION AUPRÈS DE L'APDPVP GABON

**PLATEFORME ÉDUCATIVE : EDUPOCKET GABON**  
*Autorité de tutelle : Autorité pour la Protection des Données à Caractère Personnel et de la Vie Privée (APDPVP)*  
*Siège : Haut de Gué-Gué, Libreville, République Gabonaise*  
*Cadre légal : Loi n° 001/2011 modifiée par la Loi n° 025/2023 du 9 juillet 2023*

---

> [!IMPORTANT]
> **Rappel Juridique Fondamental**  
> La simple publication d'une politique de confidentialité sur une application mobile ou un site web **ne remplace pas la déclaration légale obligatoire** auprès de l'APDPVP. Tout traitement automatisé de données personnelles en République Gabonaise doit faire l'objet soit d'une déclaration préalable, soit d'une demande d'autorisation (notamment pour les données de mineurs et les algorithmes d'IA).

---

## 1. CARTOGRAPHIE DES TRAITEMENTS À DÉCLARER

Pour EduPocket Gabon, le dossier administratif doit distinguer **trois (3) traitements distincts** afin de faciliter l'instruction par le collège des commissaires de l'APDPVP :

### Traitement N° 1 : Gestion des Comptes Élèves Mineurs et Supervision Parentale
* **Nature du traitement** : Traitement de données à caractère personnel de mineurs (dès la classe de 6e, 10 à 18 ans) et de candidats libres.
* **Finalité** : Création de profil scolaire, adaptation des cours au programme officiel IPN, suivi de la progression et des scores aux QCM, espace de supervision parentale.
* **Données traitées** : **Nom, prénom(s)** de l'élève, classe / niveau préparé, série / spécialité, établissement scolaire ou mention « Candidat Libre », **Nom, prénom(s)** et numéro de téléphone du parent/tuteur pour facturation Mobile Money.
* **Régime APDPVP applicable** : **Demande d'autorisation préalable** (du fait de la qualité de personnes mineures protégées - *Articles 190 et 195-199 de la Loi 025/2023*).

### Traitement N° 2 : Système Tuteur Intelligent « ALECKSE IA »
* **Nature du traitement** : Traitement algorithmique d'apprentissage automatisé et tuteur conversationnel d'orientation méthodologique.
* **Finalité** : Assistance scolaire interactive, explication guidée d'exercices, remédiation pédagogique.
* **Garantie majeure (*Privacy by Design*)** : Aucune donnée nominative (ni nom, ni prénom, ni numéro) n'est envoyée au moteur d'IA ; seules la question scolaire et la classe sont analysées. Pas de profilage psychologique ni comportemental (*Art. 175-178 et 193*).
* **Régime APDPVP applicable** : **Déclaration spécifique avec engagement de conformité éthique IA**.

### Traitement N° 3 : Gestion des Enseignants Partenaires et Reversements Financiers
* **Nature du traitement** : Gestion administrative, contractuelle et financière des créateurs de contenus pédagogiques.
* **Finalité** : Vérification des diplômes d'enseignement, suivi des royalties (partage 70/50), versements Mobile Money (Airtel/Moov).
* **Données traitées** : **Nom, prénom(s)**, civilité, numéro de téléphone Mobile Money, diplôme le plus élevé ou certification d'enseignement, relevé des reversements.
* **Régime APDPVP applicable** : **Déclaration normale de conformité contractuelle**.

---

## 2. COMPOSITION DU DOSSIER DE DÉPÔT À L'APDPVP

Le dossier complet à déposer physiquement au secrétariat de l'APDPVP (Haut de Gué-Gué, Libreville) comprend :

1. **Formulaire officiel APDPVP** de déclaration / demande d'autorisation dûment rempli et signé.
2. **Courrier d'accompagnement officiel** adressé à Monsieur/Madame le Président de l'APDPVP (modèle ci-dessous).
3. **Copie de la Politique de Confidentialité** (`POLITIQUE_CONFIDENTIALITE_APDPVP.md`).
4. **Copie des CGU / CGV** de l'application (`CGU_CGV_EDUPOCKET.md`).
5. **Modèle de Contrat Partenaire Enseignant** (`CONTRAT_PARTENARIAT_ENSEIGNANT_EDUPOCKET.md`).
6. **Notice technique de sécurité** décrivant :
   * Le chiffrement des données (TLS 1.3 / HTTPS / AES-256).
   * L'architecture RLS (*Row Level Security*) sous Supabase.
   * L'absence de stockage local de codes PIN bancaires ou Mobile Money.
7. **Justificatif de paiement de la redevance légale de traitement** (selon le barème en vigueur fixé par décret).

---

## 3. MODÈLE DE COURRIER OFFICIEL POUR L'APDPVP

```text
À l'attention de :
Monsieur / Madame le Président de l'Autorité pour la Protection des Données
à Caractère Personnel et de la Vie Privée (APDPVP)
Siège : Haut de Gué-Gué
Libreville, République Gabonaise

Objet : Dépôt du dossier de déclaration et demande d'autorisation préalable
Projet : Plateforme Éducative Numérique EDUPOCKET GABON
Cadre légal : Loi n° 001/2011 modifiée par la Loi n° 025/2023 du 9 juillet 2023

Monsieur / Madame le Président,

J'ai l'honneur de soumettre à votre haute et bienveillante attention le dossier de déclaration et de demande d'autorisation préalable relatif aux traitements de données à caractère personnel mis en œuvre dans le cadre de la plateforme éducative mobile « EDUPOCKET GABON ».

EDUPOCKET GABON est une solution numérique d'accompagnement scolaire conçue pour soutenir les élèves gabonais du secondaire général (de la 6e à la Terminale) et de l'enseignement technique et professionnel (CET, CAP et lycées techniques dès la 4e), en conformité stricte avec les programmes officiels de l'Institut Pédagogique National (IPN).

Conscients de la sensibilité des traitements impliquant des élèves mineurs et l'utilisation d'outils d'assistance pédagogique par intelligence artificielle (tuteur méthodologique ALECKSE IA), nous avons conçu notre plateforme selon les standards les plus exigeants de la Loi n° 025/2023 :
- Recueil obligatoire du consentement parental pour les élèves mineurs dès la classe de 6e (Articles 190 et 195 à 199) ;
- Interdiction stricte de tout profilage publicitaire, psychologique ou comportemental (Article 193) ;
- Anonymisation totale des requêtes scolaires soumises au tuteur IA sans aucune donnée nominative transmise (Articles 175 à 178) ;
- Sécurisation des transactions de paiement par monnaie électronique opérées exclusivement via Airtel Money et Moov Money sous réglementation CEMAC/COBAC.

Vous trouverez sous ce pli l'ensemble des pièces constitutives de notre dossier :
1. Le formulaire officiel de déclaration et d'autorisation ;
2. La Politique de Confidentialité intégrale et la Charte Éthique IA ;
3. Les Conditions Générales d'Utilisation et de Vente (CGU/CGV) ;
4. Le modèle de contrat de partenariat avec les enseignants certifiés ;
5. La note technique d'architecture et de sécurisation des données.

Nous nous tenons à l'entière disposition de vos services techniques pour tout audit ou entretien complémentaire, et vous prions d'agréer, Monsieur / Madame le Président, l'assurance de notre très haute considération.

Pour la Direction d'EDUPOCKET GABON,
[Signature & Nom du Responsable]
Libreville, le ______________________
```

---

## 4. CHECKLIST AVANT LE LANCEMENT OFFICIEL (JANVIER)

- [x] Contrat Enseignant finalisé (partage 70/50, diplôme/certification requis, sans matricule FP).
- [x] CGU / CGV rédigées (paliers pionniers, packages, Airtel/Moov Money, protection mineurs dès la 6e).
- [x] Politique de Confidentialité rédigée (Articles 190, 195-199 Loi 025/2023, éthique IA ALECKSE).
- [x] Mentions Légales et Charte Éthique rédigées.
- [ ] Dépôt du dossier physique ou prise de contact avec le greffe de l'APDPVP à Libreville.
- [ ] Recueil du récépissé de déclaration / numéro de dossier APDPVP à faire figurer dans les mentions légales de l'application mobile avant la soumission sur le Google Play Store.
