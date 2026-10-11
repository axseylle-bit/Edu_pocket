import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/parent_provider.dart';
import '../../core/services/supabase_service.dart';

class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentState = ref.watch(parentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Espace de ${parentState.userName}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_rounded),
            onPressed: () {
              _showAddChildDialog(context, ref);
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await SupabaseService().signOut();
              if (context.mounted) context.go('/auth');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: parentState.isLoading 
          ? const Center(child: CircularProgressIndicator())
          : parentState.children.isEmpty 
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Aucun enfant lié à ce compte.",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/grading'),
                      icon: const Icon(Icons.grading_rounded),
                      label: const Text("Aller au Correcteur IA (Espace Prof)"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  Text(
                    'Suivi de vos enfants',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 24),

                  ...parentState.children.map((child) => _buildChildCard(context, child)),
                ],
              ),
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, Map<String, dynamic> child) {
    final name = child['nom'] as String;
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final niveau = child['niveau'];
    final serie = child['serie'];
    final score = child['score'];
    final couverture = child['couverture'];
    final temps = child['temps'];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 0,
        color: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(firstLetter, style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$name ($niveau $serie)',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        'Lycée National Léon Mba',
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(color: AppColors.border),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatColumn('Couverture', '${couverture.toInt()}%', AppColors.primary),
                  _buildStatColumn('Temps/sem', temps.toString(), Colors.blue.shade700),
                  _buildStatColumn('Score Quiz', '${score.toInt()}/20', AppColors.success),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/rapport', extra: child),
                  icon: const Icon(Icons.analytics_rounded),
                  label: const Text('Voir le rapport détaillé'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showAddChildDialog(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Lier un enfant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Entrez le code d\'invitation généré depuis le profil de votre enfant :'),
              const SizedBox(height: 16),
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Code d\'invitation',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final code = codeController.text;
                if (code.isNotEmpty) {
                  Navigator.of(ctx).pop();
                  final success =
                      await SupabaseService().linkParentToStudent(code);
                  if (success) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enfant lié avec succès !')),
                      );
                      // Rafraîchir la liste
                      ref.read(parentProvider.notifier).loadParentData();
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Code invalide ou erreur de liaison.')),
                      );
                    }
                  }
                }
              },
              child: const Text('Lier'),
            ),
          ],
        );
      },
    );
  }
}
