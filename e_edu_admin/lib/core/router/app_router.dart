import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/dashboard/admin_dashboard_screen.dart';
import '../../screens/layout/admin_layout.dart';
import '../../screens/courses/admin_courses_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  redirect: (BuildContext context, GoRouterState state) {
    final session = Supabase.instance.client.auth.currentSession;
    final isLoggedIn = session != null;
    final isGoingToLogin = state.matchedLocation == '/login';

    if (!isLoggedIn && !isGoingToLogin) {
      return '/login';
    }

    if (isLoggedIn && isGoingToLogin) {
      return '/dashboard';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AdminLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        // Other routes like /cours, /users, etc. will go here
        GoRoute(
          path: '/cours',
          builder: (context, state) => const AdminCoursesScreen(),
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) => const Center(child: Text('Gestion des utilisateurs (À venir)')),
        ),
        GoRoute(
          path: '/disciplines',
          builder: (context, state) => const Center(child: Text('Gestion des disciplines (À venir)')),
        ),
        GoRoute(
          path: '/modules',
          builder: (context, state) => const Center(child: Text('Modules Futurs (À venir)')),
        ),
      ],
    ),
  ],
);
