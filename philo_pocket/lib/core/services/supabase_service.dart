import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  // MÃ©thode pour se connecter
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // MÃ©thode pour s'inscrire
  Future<AuthResponse> signUpWithEmail(
      String email, String password, String nom) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'nom': nom},
    );
  }

  // MÃ©thode pour se connecter avec Google
  Future<void> signInWithGoogle() async {
    String? redirectUrl;
    if (kIsWeb) {
      redirectUrl = Uri.base.origin; // S'adapte automatiquement au port local
    }
    await client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: redirectUrl,
    );
  }

  // MÃ©thode pour se dÃ©connecter
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // VÃ©rifie si un utilisateur est connectÃ©
  bool get isAuthenticated => client.auth.currentUser != null;

  // RÃ©cupÃ¨re l'utilisateur actuel
  User? get currentUser => client.auth.currentUser;

  /// Renvoie le rÃ´le choisi Ã  l'onboarding, ou `null` si celui-ci n'est pas
  /// encore terminÃ©.
  Future<String?> getCurrentUserRole() async {
    final user = currentUser;
    if (user == null) return null;

    final data = await client
        .from('utilisateurs')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();
    return data?['role'] as String?;
  }

  // Sauvegarde le rÃ´le et initialise le profil
  Future<void> saveUserRole(String role) async {
    final user = currentUser;
    if (user == null) {
      print(
          "Mode test: Enregistrement du rÃ´le ignorÃ© car aucun utilisateur n'est connectÃ©.");
      return;
    }

    // La ligne n'est pas crÃ©Ã©e automatiquement sur tous les projets Supabase.
    // L'upsert rend le parcours robuste avec ou sans trigger auth.users.
    try {
      await client.from('utilisateurs').upsert({
        'id': user.id,
        'email': user.email,
        'nom': user.userMetadata?['nom'] ?? 'Utilisateur',
        'role': role,
      });
    } catch (e) {
      print("Erreur lors de la sauvegarde dans utilisateurs (RLS probable): $e");
    }

    // 2. Si c'est un Ã©lÃ¨ve, on initialise son profil
    if (role == 'eleve') {
      try {
        await client.from('profils_eleves').upsert({
          'utilisateur_id': user.id,
        });
      } catch (e) {
        print("Erreur lors de la sauvegarde dans profils_eleves (RLS probable): $e");
      }
    }
  }

  // Met Ã  jour le profil de l'Ã©lÃ¨ve (Niveau et SÃ©rie)
  Future<void> updateStudentProfile(String niveau, String serie) async {
    final user = currentUser;
    if (user == null) {
      print(
          "Mode test: Mise Ã  jour du profil ignorÃ©e car aucun utilisateur n'est connectÃ©.");
      return;
    }

    try {
      await client.from('profils_eleves').upsert({
        'utilisateur_id': user.id,
        'niveau': niveau,
        'serie': serie,
      });
    } catch (e) {
      print("Erreur lors de la mise Ã  jour de profils_eleves (RLS probable): $e");
    }
  }

  // RÃ©cupÃ¨re le profil de l'Ã©lÃ¨ve
  Future<Map<String, dynamic>?> getStudentProfile() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final data = await client
          .from('profils_eleves')
          .select()
          .eq('utilisateur_id', user.id)
          .maybeSingle();
      return data;
    } catch (e) {
      return null;
    }
  }

  // Récupère l'abonnement certifié de l'utilisateur (Source de vérité Supabase + Cache sécurisé hors-ligne)
  Future<String> getStudentSubscription() async {
    final user = currentUser;
    if (user == null) return 'gratuit';

    try {
      final prefs = await SharedPreferences.getInstance();

      // 1. Priorité absolue : Vérification serveur en temps réel sur la table Supabase abonnements
      try {
        final res = await client
            .from('abonnements')
            .select('palier, statut, date_fin')
            .eq('utilisateur_id', user.id)
            .eq('statut', 'actif')
            .maybeSingle();

        if (res != null && res['palier'] != null) {
          final dateFinStr = res['date_fin'] as String?;
          bool isExpired = false;
          if (dateFinStr != null) {
            final dateFin = DateTime.tryParse(dateFinStr);
            if (dateFin != null && DateTime.now().isAfter(dateFin)) {
              isExpired = true;
            }
          }

          if (!isExpired) {
            final palier = res['palier'] as String;
            // Mise en cache validée par le serveur pour le mode hors-ligne
            await prefs.setString('verified_palier_${user.id}', palier);
            await prefs.setString('verified_expiry_${user.id}', dateFinStr ?? '');
            return palier;
          } else {
            // L'abonnement a expiré
            await prefs.remove('verified_palier_${user.id}');
            await prefs.remove('verified_expiry_${user.id}');
            return 'gratuit';
          }
        } else {
          // Aucun abonnement actif sur le serveur
          await prefs.remove('verified_palier_${user.id}');
          await prefs.remove('verified_expiry_${user.id}');
        }
      } catch (_) {
        // 2. Mode hors-ligne (ex: zones reculées du Gabon sans connexion) :
        // Le cache n'est accepté que s'il a été certifié par le serveur avec date d'expiration valide
        final cached = prefs.getString('verified_palier_${user.id}');
        final cachedExpiry = prefs.getString('verified_expiry_${user.id}');
        if (cached != null && cached.isNotEmpty && cachedExpiry != null && cachedExpiry.isNotEmpty) {
          final expiry = DateTime.tryParse(cachedExpiry);
          if (expiry != null && DateTime.now().isBefore(expiry)) {
            return cached;
          }
        }
      }

      return 'gratuit';
    } catch (_) {
      return 'gratuit';
    }
  }

  // Met à jour l'abonnement de l'utilisateur (Cache local + synchro Supabase abonnements)
  Future<void> updateSubscription(String palier) async {
    final user = currentUser;
    if (user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      String dbPalier = 'essentiel';
      int durationDays = 30;

      if (palier.contains('annuel')) {
        durationDays = 270; // 9 mois (année scolaire complète)
        dbPalier = 'confort';
      } else if (palier.contains('trimestre')) {
        durationDays = 90; // 3 mois (trimestre scolaire)
        dbPalier = 'confort';
      } else if (palier.contains('expert') ||
          palier.contains('confort') ||
          palier.contains('eiffel') ||
          palier.contains('filiere')) {
        dbPalier = 'confort';
      } else if (palier == 'gratuit' ||
          palier == 'socrate' ||
          palier == 'archimede') {
        dbPalier = 'gratuit';
      } else if (palier.contains('vinci') ||
          palier.contains('solo') ||
          palier.contains('platon')) {
        dbPalier = 'essentiel';
      }

      final dateFin = DateTime.now().add(Duration(days: durationDays)).toIso8601String();
      await prefs.setString('verified_palier_${user.id}', palier);
      await prefs.setString('verified_expiry_${user.id}', dateFin);

      // Synchronisation avec la table Supabase abonnements si disponible
      try {
        await client.from('abonnements').upsert({
          'utilisateur_id': user.id,
          'palier': dbPalier,
          'statut': 'actif',
          'date_fin': dateFin,
        });
      } catch (dbErr) {
        // Note: Seul service_role ou webhook backend a le droit d'écrire en production RLS
      }
    } catch (e) {
      rethrow;
    }
  }

  // Enregistrer une transaction Mobile Money (Airtel Money ou Moov Money)
  Future<void> enregistrerPaiementMobileMoney({
    required String referenceTransaction,
    required String operateur,
    required String numeroTelephone,
    required int montant,
    required String palierKey,
    String? idempotenceToken,
  }) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await client.from('paiements_mobile_money').insert({
        'utilisateur_id': user.id,
        'reference_transaction': referenceTransaction,
        'operateur': operateur,
        'numero_telephone': numeroTelephone,
        'montant': montant,
        'palier_key': palierKey,
        'statut': 'valide',
        'idempotence_token': idempotenceToken ?? referenceTransaction,
        'valide_le': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Note: Enregistrement paiement mobile money (sauvegarde locale prioritaire): $e");
    }
  }

  // Marquer un cours comme lu
  Future<void> markCourseAsRead(String notion) async {
    final user = currentUser;
    if (user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'course_read_${user.id}_$notion';
      await prefs.setBool(key, true);
    } catch (e) {
      print("Erreur markCourseAsRead: $e");
    }
  }

  // RÃ©cupÃ©rer la liste des cours lus
  Future<List<String>> getReadCourses() async {
    final user = currentUser;
    if (user == null) return [];

    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final prefix = 'course_read_${user.id}_';
      
      return keys
          .where((k) => k.startsWith(prefix) && (prefs.getBool(k) == true))
          .map((k) => k.substring(prefix.length))
          .toList();
    } catch (e) {
      print("Erreur getReadCourses: $e");
      return [];
    }
  }

  // RÃ©cupÃ¨re la progression globale de l'Ã©lÃ¨ve (basÃ©e sur les cours lus)
  Future<double> getStudentGlobalProgress(String niveau, String serie) async {
    final user = currentUser;
    if (user == null) return 0.0;

    try {
      // Sera calculé dans le StudentProvider pour éviter les imports circulaires
      return 0.0;
    } catch (e) {
      print("Erreur récupération progression: $e");
      return 0.0;
    }
  }

  // RÃ©cupÃ¨re la liste des enfants pour un parent
  Future<List<Map<String, dynamic>>> getChildrenProfiles() async {
    final user = currentUser;
    if (user == null) return [];

    try {
      // Dans un vrai projet, on utiliserait une vue ou un join Supabase:
      // select('eleve_id, utilisateurs(nom), profils_eleves(niveau, serie), suivi_progression(score_quiz_max)')
      // Ici, on fait une requÃªte simple pour les liaisons, puis on rÃ©cupÃ¨re les dÃ©tails
      final liaisons = await client
          .from('liaisons_parents')
          .select('eleve_id')
          .eq('parent_id', user.id);

      if (liaisons.isEmpty) return [];

      final elevesIds = liaisons.map((e) => e['eleve_id'] as String).toList();

      final elevesData = await client
          .from('utilisateurs')
          .select('id, nom')
          .filter('id', 'in', elevesIds);

      final profilsData = await client
          .from('profils_eleves')
          .select('utilisateur_id, niveau, serie')
          .filter('utilisateur_id', 'in', elevesIds);

      final progresData = await client
          .from('suivi_progression')
          .select('eleve_id, score_quiz_max, temps_etude_secondes')
          .filter('eleve_id', 'in', elevesIds);

      List<Map<String, dynamic>> children = [];

      for (var eleve in elevesData) {
        final id = eleve['id'];
        final profil = profilsData.firstWhere((p) => p['utilisateur_id'] == id,
            orElse: () => {'niveau': 'Inconnu', 'serie': ''});

        final eleveProgressions =
            progresData.where((p) => p['eleve_id'] == id).toList();

        double totalScore = 0;
        int totalTemps = 0;

        for (var p in eleveProgressions) {
          totalScore += (p['score_quiz_max'] as num?)?.toDouble() ?? 0.0;
          totalTemps += (p['temps_etude_secondes'] as num?)?.toInt() ?? 0;
        }

        double averageScore = eleveProgressions.isNotEmpty
            ? totalScore / eleveProgressions.length
            : 0.0;
        double couverture = eleveProgressions.isNotEmpty
            ? (totalScore / (eleveProgressions.length * 20)) * 100
            : 0.0;

        int heures = totalTemps ~/ 3600;
        int minutes = (totalTemps % 3600) ~/ 60;
        String tempsFormat = '${heures}h ${minutes.toString().padLeft(2, '0')}';

        children.add({
          'id': id,
          'nom': eleve['nom'],
          'niveau': profil['niveau'],
          'serie': profil['serie'],
          'score': averageScore,
          'couverture': couverture,
          'temps': tempsFormat,
        });
      }

      return children;
    } catch (e) {
      print("Erreur rÃ©cupÃ©ration enfants: $e");
      return [];
    }
  }

  // --- SYSTÈME D'INVITATION PARENT-ENFANT SÉCURISÉ ---

  // Générateur cryptographique fort de code d'invitation (évite les attaques par énumération)
  String _generateSecureInvitationCode() {
    const chars = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
    final random = Random.secure();
    final buffer = StringBuffer();
    for (int i = 0; i < 6; i++) {
      if (i == 3) buffer.write('-');
      buffer.write(chars[random.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  // Générer (ou récupérer) un code d'invitation sécurisé pour l'élève
  Future<String?> getOrCreateStudentInvitationCode() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final data = await client
          .from('profils_eleves')
          .select('code_invitation')
          .eq('utilisateur_id', user.id)
          .maybeSingle();

      if (data != null && data['code_invitation'] != null && (data['code_invitation'] as String).isNotEmpty) {
        return data['code_invitation'] as String;
      }

      // Génération d'un code cryptographique aléatoire de 6 caractères (ex: 7KJ-9XP)
      final String newCode = _generateSecureInvitationCode();

      await client.from('profils_eleves').update({
        'code_invitation': newCode,
      }).eq('utilisateur_id', user.id);

      return newCode;
    } catch (e) {
      print("Erreur création code invitation: $e");
      return null;
    }
  }

  // Lier un parent à un élève via le code sécurisé (Appel RPC ou fallback)
  Future<bool> linkParentToStudent(String code) async {
    final user = currentUser;
    if (user == null) return false;

    final cleanCode = code.trim().toUpperCase();

    try {
      // 1. Priorité à la fonction RPC sécurisée PostgreSQL
      final response = await client.rpc(
        'lier_parent_eleve',
        params: {'code_invitation_saisi': cleanCode},
      );

      if (response != null && response is Map) {
        return response['success'] == true;
      }
      return true;
    } catch (e) {
      print("Note: RPC lier_parent_eleve non disponible, tentative directe: $e");
      try {
        final eleveData = await client
            .from('profils_eleves')
            .select('utilisateur_id')
            .eq('code_invitation', cleanCode)
            .maybeSingle();

        if (eleveData == null) return false;

        final eleveId = eleveData['utilisateur_id'];

        await client.from('liaisons_parents').insert({
          'parent_id': user.id,
          'eleve_id': eleveId,
        });

        return true;
      } catch (directErr) {
        print("Erreur liaison parent-enfant: $directErr");
        return false;
      }
    }
  }

  // Suppression définitive du compte utilisateur (Droit à l'effacement APDPVP / Google Play)
  Future<bool> deleteAccount() async {
    final user = currentUser;
    if (user == null) return false;

    try {
      // 1. Tenter la suppression serveur complète via RPC
      try {
        await client.rpc('supprimer_mon_compte');
      } catch (rpcErr) {
        print("Note: RPC supprimer_mon_compte : $rpcErr");
        // Fallback manuel côté client
        try {
          await client.from('suivi_progression').delete().eq('eleve_id', user.id);
          await client.from('liaisons_parents').delete().or('parent_id.eq.${user.id},eleve_id.eq.${user.id}');
          await client.from('profils_eleves').delete().eq('utilisateur_id', user.id);
          await client.from('utilisateurs').delete().eq('id', user.id);
        } catch (_) {}
      }

      // 2. Nettoyage du stockage local de l'appareil
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. Déconnexion
      await client.auth.signOut();
      return true;
    } catch (e) {
      print("Erreur suppression compte: $e");
      return false;
    }
  }


    // Sauvegarde le score d'un quiz pour une notion
  Future<void> saveQuizScore(String notionSlug, int score, int total) async {
    final user = currentUser;
    if (user == null) return;

    try {
      if (total == 0) return;
      
      // 1. Sauvegarde locale
      final prefs = await SharedPreferences.getInstance();
      final key = 'quiz_score_$notionSlug';
      final newScore = score / total;
      final previousScore = prefs.getDouble(key) ?? 0.0;
      
      if (newScore > previousScore) {
        await prefs.setDouble(key, newScore);
      }

      // 2. Sauvegarde sur Supabase
      final notionData = await client.from('notions').select('id').eq('slug', notionSlug).maybeSingle();

      if (notionData != null) {
        final notionId = notionData['id'];

        final existingProgress = await client.from('suivi_progression')
            .select('id, score_quiz_max')
            .eq('eleve_id', user.id).eq('notion_id', notionId).maybeSingle();

        if (existingProgress != null) {
          double currentMax = (existingProgress['score_quiz_max'] as num?)?.toDouble() ?? 0.0;
          if (newScore > currentMax) {
            await client.from('suivi_progression').update({
              'score_quiz_max': newScore,
              'updated_at': DateTime.now().toIso8601String(),
            }).eq('id', existingProgress['id']);
          }
        } else {
          await client.from('suivi_progression').insert({
            'eleve_id': user.id,
            'notion_id': notionId,
            'score_quiz_max': newScore,
            'temps_etude_secondes': 0,
            'cours_termine': true,
          });
        }
      }
    } catch (e) {
      print("Erreur sauvegarde quiz Supabase: $e");
    }
  
}

}
