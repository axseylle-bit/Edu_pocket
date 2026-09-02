import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  final SupabaseClient client = Supabase.instance.client;

  // Méthode pour se connecter
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Méthode pour s'inscrire
  Future<AuthResponse> signUpWithEmail(String email, String password, String nom) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: {'nom': nom},
    );
  }

  // Méthode pour se déconnecter
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Vérifie si un utilisateur est connecté
  bool get isAuthenticated => client.auth.currentUser != null;

  // Récupère l'utilisateur actuel
  User? get currentUser => client.auth.currentUser;

  // Sauvegarde le rôle et initialise le profil
  Future<void> saveUserRole(String role) async {
    final user = currentUser;
    if (user == null) {
      print("Mode test: Enregistrement du rôle ignoré car aucun utilisateur n'est connecté.");
      return;
    }

    // 1. Enregistre dans la table utilisateurs
    await client.from('utilisateurs').upsert({
      'id': user.id,
      'email': user.email,
      'nom': user.userMetadata?['nom'] ?? 'Utilisateur',
      'role': role,
    });

    // 2. Si c'est un élève, on initialise son profil
    if (role == 'eleve') {
      await client.from('profils_eleves').upsert({
        'utilisateur_id': user.id,
      });
    }
  }

  // Met à jour le profil de l'élève (Niveau et Série)
  Future<void> updateStudentProfile(String niveau, String serie) async {
    final user = currentUser;
    if (user == null) {
      print("Mode test: Mise à jour du profil ignorée car aucun utilisateur n'est connecté.");
      return;
    }

    await client.from('profils_eleves').update({
      'niveau': niveau,
      'serie': serie,
    }).eq('utilisateur_id', user.id);
  }

  // Récupère le profil de l'élève
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
}
