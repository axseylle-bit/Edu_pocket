import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_level.dart';

class StudentState {
  final SubscriptionTier tier;
  final double globalProgress; // 0.0 à 1.0
  
  StudentState({
    this.tier = SubscriptionTier.gratuit,
    this.globalProgress = 0.73, // Par défaut pour la démo
  });

  StudentState copyWith({
    SubscriptionTier? tier,
    double? globalProgress,
  }) {
    return StudentState(
      tier: tier ?? this.tier,
      globalProgress: globalProgress ?? this.globalProgress,
    );
  }
}

class StudentNotifier extends StateNotifier<StudentState> {
  StudentNotifier() : super(StudentState());

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

final studentProvider = StateNotifierProvider<StudentNotifier, StudentState>((ref) {
  return StudentNotifier();
});
