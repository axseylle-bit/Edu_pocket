import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/student_provider.dart';

class StudentDashboardScreen extends ConsumerWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentState = ref.watch(studentProvider);
    final tier = studentState.tier;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Logo de l'application
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // En-tête Salutation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Bonjour Axelle 👋',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Bouton de triche pour dev
                      IconButton(
                        icon: const Icon(Icons.upgrade, size: 20, color: Colors.grey),
                        onPressed: () {
                          ref.read(studentProvider.notifier).levelUp();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Abonnement : ${tier.name} (${tier.description})',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Jauge de progression globale
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Progression Globale',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '73%',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 0.73,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '12 notions maîtrisées sur 18 au programme.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bouton IPN (remonté pour plus de visibilité)
          ElevatedButton.icon(
            onPressed: () => context.push('/ipn'),
            icon: const Icon(Icons.library_books),
            label: const Text('Ressources Officielles (IPN)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Message d'encouragement ALECKSE
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondary),
            ),
            child: Row(
              children: [
                const Icon(Icons.tips_and_updates_rounded, color: AppColors.accent, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Conseil d\'ALECKSE : N\'oubliez pas de revoir la définition de la "Conscience" avant votre prochain quiz !',
                    style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Grille de raccourcis
          Text(
            'Raccourcis rapides',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildShortcutCard(context, Icons.menu_book_rounded, 'Reprendre le cours', Colors.blue.shade100, '/cours', true),
              _buildShortcutCard(context, Icons.quiz_rounded, 'S\'entraîner (Quiz)', Colors.green.shade100, '/quiz', true),
              _buildShortcutCard(context, Icons.psychology_rounded, 'À revoir (TD)', Colors.orange.shade100, '/td', true),
              _buildShortcutCard(context, Icons.science_rounded, 'Travaux Pratiques (TP)', Colors.teal.shade100, '/tp', tier.canAccessTP),
              _buildShortcutCard(context, Icons.format_quote_rounded, 'Citations', Colors.purple.shade100, '/citations', true),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildShortcutCard(BuildContext context, IconData icon, String title, Color color, String route, bool isUnlocked) {
    return Card(
      elevation: 0,
      color: isUnlocked ? color : Colors.grey.shade200,
      child: InkWell(
        onTap: isUnlocked ? () => context.push(route) : () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ce raccourci est verrouillé à votre palier actuel.')),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUnlocked ? icon : Icons.lock_rounded, 
                color: isUnlocked ? AppColors.primary : Colors.grey.shade500, 
                size: 32
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600, 
                  fontSize: 13, 
                  color: isUnlocked ? AppColors.primary : Colors.grey.shade500
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
