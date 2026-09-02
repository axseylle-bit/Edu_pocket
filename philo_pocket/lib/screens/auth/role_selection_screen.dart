import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  Widget _buildRoleCard(BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.border),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final supabase = SupabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qui êtes-vous ?'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              'Choisissez votre profil pour personnaliser votre expérience.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            _buildRoleCard(
              context,
              title: 'Élève / Étudiant',
              description: 'Apprendre, progresser et préparer le BAC.',
              icon: Icons.school_rounded,
              onTap: () async {
                try {
                  await supabase.saveUserRole('eleve');
                  if (context.mounted) context.go('/profile-setup');
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              },
            ),
            
            _buildRoleCard(
              context,
              title: 'Parent',
              description: 'Suivre la progression de votre enfant.',
              icon: Icons.family_restroom_rounded,
              onTap: () async {
                try {
                  await supabase.saveUserRole('parent');
                  if (context.mounted) context.go('/parent');
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              },
            ),
            
            _buildRoleCard(
              context,
              title: 'Enseignant',
              description: 'Accompagner vos élèves (Bientôt disponible).',
              icon: Icons.menu_book_rounded,
              onTap: () {
                // TODO: Message V2
              },
            ),
            
            _buildRoleCard(
              context,
              title: 'Curieux',
              description: 'Explorer la philosophie librement.',
              icon: Icons.explore_rounded,
              onTap: () {
                // TODO: Message V2
              },
            ),
          ],
        ),
      ),
    );
  }
}
