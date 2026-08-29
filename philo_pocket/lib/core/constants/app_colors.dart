import 'package:flutter/material.dart';

/// Charte Graphique Officielle de Philo Pocket
class AppColors {
  // Couleur Principale (Navigation, en-têtes, boutons principaux)
  // Un vert d'apprentissage et de validation, vif mais doux pour les yeux
  static const Color primary = Color(0xFF1F7348); 

  // Couleur Secondaire (Cartes, encouragements, badges)
  static const Color secondary = Color(0xFFF7C6D7); // Rose poudré

  // Couleur d'Accent (Progression, flamme, réussite)
  static const Color accent = Color(0xFFD4AF37); // Or chaud

  // Fonds
  static const Color backgroundLight = Color(0xFFFAF6F0); // Blanc cassé / Ivoire
  static const Color backgroundDark = Color(0xFF121A15); // Mode Sombre

  // Typographie & Bordures
  static const Color textDark = Color(0xFF1B2A4A); // Bleu nuit très foncé pour le texte
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE6E2DC); // Gris chaud clair

  // Couleurs sémantiques (UI)
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
}
