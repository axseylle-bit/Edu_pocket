# Passation — Philo Pocket

Dernière vérification : 10 septembre 2026.

## Ce qui fonctionne dans la version à compiler

- L'accueil utilise `assets/images/aleckse.png` et affiche la marque Philo Pocket.
- Les cours sont dans **Mes cours** ; les PDF sont séparés dans **Documents IPN**.
- Les documents IPN sont des assets locaux lus avec `SfPdfViewer.asset` depuis `lib/screens/resources/ipn_resources_screen.dart`.
- Les onglets Cours, Révisions et Profil ne sont plus des écrans vides.
- Les meilleurs scores des quiz sont temporairement sauvegardés sur l'appareil via `SharedPreferences`, car le catalogue local de notions n'a pas encore d'identifiants `notion_id` Supabase.

## Règles à conserver

- Ne jamais placer une clé `service_role` Supabase dans l'application.
- La clé Gemini actuellement présente dans `.env` est récupérable depuis un APK : déplacer l'appel IA vers une Supabase Edge Function avant publication publique.
- Le schéma actuellement fourni utilise les tables `liaisons_parents`, `profils_eleves` et `suivi_progression`, avec les colonnes `notion_id` et `temps_etude_secondes`. Ne pas employer `parents_eleves`, `notion` ou `temps_passe_minutes` sans migration SQL explicite.
- Garder les documents IPN séparés des cours ; les chemins des PDF sont déclarés dans `ipn_resources_screen.dart`.

## Travail restant, par ordre de priorité

1. Créer une migration Supabase pour importer les notions/cours locaux et relier chaque quiz à un vrai `notion_id`.
2. Déplacer Gemini dans une Edge Function puis révoquer la clé actuellement exposée.
3. Ajouter un vrai parcours de liaison parent-enfant (code d'invitation), au lieu de l'écran parent sans enfant lié.
4. Préparer une clé de signature Android et remplacer `com.example.philo_pocket` avant toute publication sur un store.

## Compilation Android locale

```powershell
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

Le fichier produit est `build/app/outputs/flutter-apk/app-release.apk`.
