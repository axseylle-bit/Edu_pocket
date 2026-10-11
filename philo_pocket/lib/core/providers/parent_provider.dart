import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

class ParentState {
  final bool isLoading;
  final String userName;
  final List<Map<String, dynamic>> children;

  ParentState({
    this.isLoading = false,
    this.userName = 'Parent',
    this.children = const [],
  });

  ParentState copyWith({
    bool? isLoading,
    String? userName,
    List<Map<String, dynamic>>? children,
  }) {
    return ParentState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      children: children ?? this.children,
    );
  }
}

class ParentNotifier extends StateNotifier<ParentState> {
  ParentNotifier() : super(ParentState()) {
    loadParentData();
  }

  Future<void> loadParentData() async {
    state = state.copyWith(isLoading: true);

    final supabase = SupabaseService();
    if (!supabase.isAuthenticated) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final user = supabase.currentUser;
    final String name = user?.userMetadata?['nom'] ?? 'Parent';

    final children = await supabase.getChildrenProfiles();

    state = state.copyWith(
      userName: name,
      children: children,
      isLoading: false,
    );
  }
}

final parentProvider =
    StateNotifierProvider<ParentNotifier, ParentState>((ref) {
  return ParentNotifier();
});
