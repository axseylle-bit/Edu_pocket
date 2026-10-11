import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

class CourseCacheService {
  static const String _cachePrefix = 'course_cache_';

  /// Récupère le contenu Markdown d'un cours.
  /// 1. Cherche dans le cache local (Mode Hors Ligne)
  /// 2. S'il n'y est pas, tente de le télécharger (ici simulé par le chargement d'un asset local ou via Supabase dans le futur)
  /// 3. Sauvegarde en cache pour la prochaine lecture hors ligne.
  Future<String> getCourseContent(String notion, String defaultAssetPath) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$notion';

    // 1. Vérifier si le cours est déjà en cache (Mode Hors Ligne)
    final cachedContent = prefs.getString(cacheKey);
    if (cachedContent != null && cachedContent.isNotEmpty) {
      print('Chargement depuis le cache local (Hors ligne) : $notion');
      return cachedContent;
    }

    // 2. Si non présent, le "télécharger"
    // Dans une version cloud, on ferait une requête Supabase ici (ex: Supabase.instance.client.storage...)
    // Pour l'instant, on lit le fichier local qui sert de base de données initiale.
    try {
      print('Téléchargement du cours (Réseau) : $notion');
      final content = await rootBundle.loadString(defaultAssetPath);
      
      // 3. Sauvegarder dans le cache pour les prochaines lectures hors connexion
      await prefs.setString(cacheKey, content);
      
      return content;
    } catch (e) {
      throw Exception('Erreur lors de la récupération du cours : $e');
    }
  }

  /// Permet de forcer la mise à jour d'un cours mis en cache
  Future<void> clearCache(String notion) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cachePrefix$notion';
    await prefs.remove(cacheKey);
  }
}
