import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Initialisation de Supabase avec les clés du .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? 'https://votre-projet.supabase.co',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'votre-anon-key',
  );

  runApp(
    const ProviderScope(
      child: PhiloPocketApp(),
    ),
  );
}

class PhiloPocketApp extends StatelessWidget {
  const PhiloPocketApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Philo Pocket',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
