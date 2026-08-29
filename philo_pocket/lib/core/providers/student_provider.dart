import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_level.dart';

class StudentState {
  final SubscriptionTier tier;
  
  StudentState({
    this.tier = SubscriptionTier.gratuit,
  });

  StudentState copyWith({
    SubscriptionTier? tier,
  }) {
    return StudentState(
      tier: tier ?? this.tier,
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
