import 'package:go_router/go_router.dart';
import '../../screens/onboarding/welcome_screen.dart';
import '../../screens/onboarding/aleckse_screen.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/auth/role_selection_screen.dart';
import '../../screens/auth/profile_setup_screen.dart';
import '../../screens/auth/progression_setup_screen.dart';
import '../../screens/auth/subscription_choice_screen.dart';
import '../../screens/auth/teacher_partner_screen.dart';
import '../../screens/chat/aleckse_chat_screen.dart';
import '../../screens/dashboard/discipline_selection_screen.dart';
import '../../screens/main/main_navigation_screen.dart';
import '../../screens/cours/philo_pocket_screen.dart';
import '../../screens/dashboard/parent_dashboard_screen.dart';
import '../../screens/cours/cours_screen.dart';
import '../../screens/cours/course_detail_screen.dart';
import '../../screens/cours/course_viewer_screen.dart';
import '../../screens/cours/myth_3d_viewer_screen.dart';
import '../../screens/quiz/quiz_screen.dart';
import '../../screens/td/td_screen.dart';
import '../../screens/tp/tp_screen.dart';
import '../../screens/citations/citations_screen.dart';
import '../../screens/parent/rapport_detaille_screen.dart';
import '../../screens/resources/ipn_resources_screen.dart';
import '../../screens/onboarding/general_intro_screen.dart';
import '../../screens/teacher/teacher_grading_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/grading',
      builder: (context, state) => const TeacherGradingScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/welcome',
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
      path: '/subscription',
      builder: (context, state) {
        final discipline = state.uri.queryParameters['discipline'] ?? 'philo';
        return SubscriptionChoiceScreen(targetDiscipline: discipline);
      },
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/teacher-partner',
      builder: (context, state) => const TeacherPartnerScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/progression-setup',
      builder: (context, state) {
        final niveau = state.uri.queryParameters['niveau'];
        final serie = state.uri.queryParameters['serie'];
        return ProgressionSetupScreen(
          initialNiveau: niveau,
          initialSerie: serie,
        );
      },
    ),
    GoRoute(
      path: '/hub',
      builder: (context, state) => const DisciplineSelectionScreen(),
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
      path: '/philo-pocket',
      builder: (context, state) => const PhiloPocketScreen(),
    ),
    GoRoute(
      path: '/cours',
      builder: (context, state) => const CoursScreen(),
    ),
    GoRoute(
      path: '/course-detail',
      builder: (context, state) {
        final title = state.extra as String? ?? 'Cours';
        return CourseDetailScreen(title: title);
      },
    ),
    GoRoute(
      path: '/course-viewer',
      builder: (context, state) {
        final notion = state.uri.queryParameters['notion'] ?? 'Notion';
        return CourseViewerScreen(notion: notion);
      },
    ),
    GoRoute(
      path: '/myth-3d',
      builder: (context, state) {
        final notion = state.uri.queryParameters['notion'] ?? 'Notion';
        return Myth3DViewerScreen(notion: notion);
      },
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) {
        final notion = state.uri.queryParameters['notion'];
        return QuizScreen(notion: notion);
      },
    ),
    GoRoute(
      path: '/td',
      builder: (context, state) {
        final notion = state.uri.queryParameters['notion'];
        return TdScreen(notion: notion);
      },
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
      builder: (context, state) {
        final childData = state.extra as Map<String, dynamic>?;
        return RapportDetailleScreen(childData: childData);
      },
    ),
    GoRoute(
      path: '/ipn',
      builder: (context, state) => const IpnResourcesScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final mode = state.uri.queryParameters['mode'];
        final notion = state.uri.queryParameters['notion'];
        final subject = state.uri.queryParameters['subject'];
        final type = state.uri.queryParameters['type'];
        final methodologyId = state.uri.queryParameters['methodologyId'];
        return AleckseChatScreen(
          mode: mode,
          notion: notion,
          subject: subject,
          type: type,
          methodologyId: methodologyId,
        );
      },
    ),
    GoRoute(
      path: '/general-intro',
      builder: (context, state) => const GeneralIntroScreen(),
    ),
  ],
);
