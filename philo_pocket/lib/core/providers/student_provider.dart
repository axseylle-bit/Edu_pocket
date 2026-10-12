import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_level.dart';
import '../models/programmes_officiels.dart';
import '../services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentState {
  final SubscriptionTier tier;
  final double globalProgress; // 0.0 à 1.0
  final bool isLoading;
  final String userName;
  final String niveau;
  final String serie;
  final int streak;
  final int creditsEva;
  final String statutEva;

  StudentState({
    this.tier = SubscriptionTier.gratuit,
    this.globalProgress = 0.0,
    this.isLoading = false,
    this.userName = 'Élève',
    this.niveau = '',
    this.serie = '',
    this.streak = 0,
    this.creditsEva = 120,
    this.statutEva = 'Initié',
  });

  StudentState copyWith({
    SubscriptionTier? tier,
    double? globalProgress,
    bool? isLoading,
    String? userName,
    String? niveau,
    String? serie,
    int? streak,
    int? creditsEva,
    String? statutEva,
  }) {
    return StudentState(
      tier: tier ?? this.tier,
      globalProgress: globalProgress ?? this.globalProgress,
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      niveau: niveau ?? this.niveau,
      serie: serie ?? this.serie,
      streak: streak ?? this.streak,
      creditsEva: creditsEva ?? this.creditsEva,
      statutEva: statutEva ?? this.statutEva,
    );
  }
}

class StudentNotifier extends StateNotifier<StudentState> {
  StudentNotifier() : super(StudentState()) {
    loadStudentData();
  }

  Future<void> loadStudentData() async {
    state = state.copyWith(isLoading: true);

    final supabase = SupabaseService();
    if (!supabase.isAuthenticated) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final user = supabase.currentUser;
    final String name = user?.userMetadata?['nom'] ?? 'Élève';

    final palierString = await supabase.getStudentSubscription();
    final tier = SubscriptionTier.fromDbValue(palierString);

    final profile = await supabase.getStudentProfile();
    final niveau = profile?['niveau'] as String? ?? '1ere';
    final serie = profile?['serie'] as String? ?? 'A1';

    final readCourses = await supabase.getReadCourses();
    
    // Calcul de la progression globale
    double progress = 0.0;
    int totalNotions = 0;
    
    for (int i = 1; i <= 3; i++) {
      final notionsTrimestre = ProgrammeOfficiel.getNotions(niveau, serie, i);
      for (var segment in notionsTrimestre.values) {
        totalNotions += segment.length;
      }
    }

    if (totalNotions > 0) {
      progress = (readCourses.length / totalNotions).clamp(0.0, 1.0);
    }

    // Calcul dynamique de l'Académie EVA (Excelle Virtual Academy)
    int dbCredits = (profile?['credits_eva'] as num?)?.toInt() ?? 0;
    int calculatedCredits = 50 + (readCourses.length * 25);
    if (tier == SubscriptionTier.essentiel) calculatedCredits += 100;
    if (tier == SubscriptionTier.confort) calculatedCredits += 250;
    int creditsEva = dbCredits > 0 ? dbCredits : calculatedCredits;

    String statutEva = profile?['statut_eva'] as String? ?? '';
    if (statutEva.isEmpty) {
      if (creditsEva >= 350) {
        statutEva = 'Maître';
      } else if (creditsEva >= 200) {
        statutEva = 'Disciple';
      } else if (creditsEva >= 100) {
        statutEva = 'Apprenti';
      } else {
        statutEva = 'Initié';
      }
    }

    state = state.copyWith(
      tier: tier,
      globalProgress: progress,
      userName: name,
      niveau: niveau,
      serie: serie,
      creditsEva: creditsEva,
      statutEva: statutEva,
      isLoading: false,
    );
    
    await _calculateStreak();
  }

  Future<void> _calculateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginStr = prefs.getString('last_login_date');
    int currentStreak = prefs.getInt('current_streak') ?? 0;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (lastLoginStr != null) {
      final lastLoginDate = DateTime.parse(lastLoginStr);
      final difference = today.difference(lastLoginDate).inDays;
      
      if (difference == 1) {
        currentStreak++;
      } else if (difference > 1) {
        currentStreak = 1; // Remise à zéro mais on compte aujourd'hui
      }
      // si difference == 0, on ne fait rien (même jour)
    } else {
      currentStreak = 1; // Première connexion
    }
    
    await prefs.setString('last_login_date', today.toIso8601String());
    await prefs.setInt('current_streak', currentStreak);
    
    state = state.copyWith(streak: currentStreak);
  }

  Future<void> reloadProgress() async {
    final supabase = SupabaseService();
    if (!supabase.isAuthenticated) return;
    
    final readCourses = await supabase.getReadCourses();
    double progress = 0.0;
    int totalNotions = 0;
    
    for (int i = 1; i <= 3; i++) {
      final notionsTrimestre = ProgrammeOfficiel.getNotions(state.niveau, state.serie, i);
      for (var segment in notionsTrimestre.values) {
        totalNotions += segment.length;
      }
    }

    if (totalNotions > 0) {
      progress = (readCourses.length / totalNotions).clamp(0.0, 1.0);
    }

    state = state.copyWith(globalProgress: progress);
  }

  void setTier(SubscriptionTier newTier) {
    state = state.copyWith(tier: newTier);
  }

  // Fonction utilitaire pour simuler la progression pendant le dev
  void levelUp() {
    if (state.tier == SubscriptionTier.gratuit) {
      setTier(SubscriptionTier.essentiel);
    } else if (state.tier == SubscriptionTier.essentiel) {
      setTier(SubscriptionTier.confort);
    } else {
      setTier(SubscriptionTier.gratuit); // Loop pour tester
    }
  }
}

final studentProvider =
    StateNotifierProvider<StudentNotifier, StudentState>((ref) {
  return StudentNotifier();
});
