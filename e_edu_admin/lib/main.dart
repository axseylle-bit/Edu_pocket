import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants/app_colors.dart';
import 'screens/layout/admin_layout.dart';
import 'screens/dashboard/admin_dashboard_screen.dart';

void main() {
  runApp(const EEduAdminApp());
}

class EEduAdminApp extends StatelessWidget {
  const EEduAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-edu.ga Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        useMaterial3: true,
      ),
      home: const AdminLayout(
        child: AdminDashboardScreen(),
      ),
    );
  }
}
