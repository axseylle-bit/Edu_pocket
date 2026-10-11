import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _showPilotLockedDialog(BuildContext context, String roleTitle) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_clock_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Phase Pilote Exclusive',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'L\'accès « $roleTitle » ouvrira officiellement très prochainement.',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 12),
            const Text(
              'La plateforme EduPocket est actuellement en phase pilote fermée, réservée exclusivement aux enseignants partenaires référents de chaque province pour la validation pédagogique des programmes IPN.',
              style: TextStyle(color: Colors.black87, height: 1.4, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Colors.amber.shade900, size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Si vous êtes enseignant ou collègue, choisissez le profil « Enseignant Partenaire » ci-dessous pour tester.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    bool isFeatured = false,
    String? badgeText,
    Color? badgeColor,
    bool isLocked = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isFeatured ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isFeatured
            ? const BorderSide(color: AppColors.primary, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isLocked
            ? () => _showPilotLockedDialog(context, title)
            : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isFeatured
                      ? AppColors.primary
                      : (isLocked ? Colors.grey.shade200 : AppColors.secondary.withValues(alpha: 0.3)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isFeatured ? Colors.white : (isLocked ? Colors.grey.shade500 : AppColors.primary),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isLocked ? Colors.grey.shade700 : AppColors.primary,
                                ),
                          ),
                        ),
                        if (badgeText != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: badgeColor ?? (isFeatured ? Colors.green.shade100 : Colors.orange.shade100),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isFeatured ? Colors.green.shade800 : Colors.orange.shade900,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isLocked ? Colors.grey.shade500 : Colors.black87,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                isLocked ? Icons.lock_outline_rounded : Icons.arrow_forward_ios_rounded,
                color: isLocked ? Colors.grey.shade400 : AppColors.primary,
                size: isLocked ? 20 : 16,
              ),
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
        title: const Text('Accès Plateforme'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // Bandeau d'information Phase Pilote
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.stars_rounded, color: AppColors.primary, size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Phase Pilote active : Ouverture exclusive aux Enseignants Référents provinciaux.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 1. ENSEIGNANT PARTENAIRE (Mis en avant en haut - Ouvert)
            _buildRoleCard(
              context,
              title: 'Enseignant / Collègue',
              description: 'Accédez en avant-première pour tester l\'application et réserver votre quota provincial.',
              icon: Icons.workspace_premium_rounded,
              isFeatured: true,
              badgeText: 'ACCÈS OUVERT',
              badgeColor: Colors.green.shade100,
              isLocked: false,
              onTap: () async {
                try {
                  await supabase.saveUserRole('enseignant');
                  if (context.mounted) context.go('/teacher-partner');
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                }
              },
            ),

            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),

            // 2. ÉLÈVE (Verrouillé)
            _buildRoleCard(
              context,
              title: 'Élève / Étudiant',
              description: 'Apprendre, progresser et préparer les examens officiels du Gabon.',
              icon: Icons.school_rounded,
              isLocked: true,
              badgeText: 'OUVERTURE PROCHAINE',
              onTap: () {},
            ),

            // 3. PARENT (Verrouillé)
            _buildRoleCard(
              context,
              title: 'Parent / Tuteur',
              description: 'Suivre la progression et les notes de votre enfant.',
              icon: Icons.family_restroom_rounded,
              isLocked: true,
              badgeText: 'OUVERTURE PROCHAINE',
              onTap: () {},
            ),

            // 4. CURIEUX (Verrouillé)
            _buildRoleCard(
              context,
              title: 'Curieux / Visiteur',
              description: 'Explorer la plateforme librement.',
              icon: Icons.explore_rounded,
              isLocked: true,
              badgeText: 'BIENTÔT',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
