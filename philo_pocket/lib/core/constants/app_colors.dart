import 'package:flutter/material.dart';

/// Charte Graphique Officielle et Moderne de Philo Pocket
class AppColors {
  // Couleurs de marque (Brand Colors)
  static const Color primary =
      Color(0xFF1B4D3E); // Vert forÃªt profond et premium
  static const Color primaryLight = Color(0xFF2A7A62);

  static const Color secondary = Color(0xFFE9C46A); // Or moutarde élégant
  static const Color accent = Color(0xFFE06D53); // Orange un peu rose (Platon)

  // Couleurs Officielles des Paliers Philo Pocket
  static const Color socrateGreen = Color(0xFF1B5E20); // Vert foncé (Socrate Gratuit)
  static const Color platonCoral = Color(0xFFE06D53);  // Orange un peu rose / Corail (Platon Essentiel)
  static const Color aristoteViolet = Color(0xFF6A4C93); // Violet (Aristote Confort)

  // Fonds (Backgrounds)
  static const Color backgroundLight =
      Color(0xFFF8F9FA); // Gris perle trÃ¨s lÃ©ger
  static const Color surface = surfaceLight;
  static const Color surfaceLight =
      Color(0xFFFFFFFF); // Blanc pur pour les cartes

  static const Color backgroundDark =
      Color(0xFF0F172A); // Bleu nuit profond (Slate 900)
  static const Color surfaceDark = Color(0xFF1E293B); // Slate 800

  // Typographie & Bordures
  static const Color textDark = Color(0xFF0F172A); // Texte principal sombre
  static const Color textLight = Color(0xFFF8F9FA); // Texte principal clair
  static const Color textMuted =
      Color(0xFF64748B); // Slate 500 pour sous-titres
  static const Color border = Color(0xFFE2E8F0); // Slate 200

  // Couleurs sÃ©mantiques (UI)
  static const Color error = Color(0xFFEF4444); // Rouge moderne
  static const Color success = Color(0xFF22C55E); // Vert moderne
  static const Color info = Color(0xFF3B82F6); // Bleu vif

  // Gradients Premium
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6366F1),
      Color(0xFF8B5CF6),
      Color(0xFFD946EF)
    ], // DÃ©gradÃ© "Aristote"
  );

  // Effet Glassmorphism (Fonds translucides)
  static Color glassBackground = Colors.white.withValues(alpha: 0.7);
  static Color glassBorder = Colors.white.withValues(alpha: 0.4);
}

