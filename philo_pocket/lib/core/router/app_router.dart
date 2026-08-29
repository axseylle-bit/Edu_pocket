import 'package:go_router/go_router.dart';
import '../../screens/onboarding/welcome_screen.dart';
import '../../screens/onboarding/aleckse_screen.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/auth/role_selection_screen.dart';
import '../../screens/chat/aleckse_chat_screen.dart';
import '../../screens/main/main_navigation_screen.dart';
import '../../screens/dashboard/parent_dashboard_screen.dart';
import '../../screens/cours/cours_screen.dart';
import '../../screens/quiz/quiz_screen.dart';
import '../../screens/td/td_screen.dart';
import '../../screens/tp/tp_screen.dart';
import '../../screens/citations/citations_screen.dart';
import '../../screens/parent/rapport_detaille_screen.dart';
import '../../screens/resources/ipn_resources_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/aleckse',
      builder: (context, state) => const AleckseScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/parent',
      builder: (context, state) => const ParentDashboardScreen(),
    ),
    GoRoute(
      path: '/cours',
      builder: (context, state) => const CoursScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/td',
      builder: (context, state) => const TdScreen(),
    ),
    GoRoute(
      path: '/tp',
      builder: (context, state) => const TpScreen(),
    ),
    GoRoute(
      path: '/citations',
      builder: (context, state) => const CitationsScreen(),
    ),
    GoRoute(
      path: '/rapport',
      builder: (context, state) => const RapportDetailleScreen(),
    ),
    GoRoute(
      path: '/ipn',
      builder: (context, state) => const IpnResourcesScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const AleckseChatScreen(),
    ),
  ],
);
