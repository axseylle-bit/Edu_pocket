import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/student_provider.dart';

class MainDashboardScreen extends ConsumerWidget {
  const MainDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentState = ref.watch(studentProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(context, ref, studentState)
                  .animate()
                  .fade(duration: 600.ms)
                  .slideY(begin: -0.1, end: 0, curve: Curves.easeOutQuad),

              const SizedBox(height: 32),

              Text(
                'MatiÃ¨res',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fade(delay: 200.ms).slideX(begin: -0.1),

              const SizedBox(height: 20),

              // Subjects Grid
              _buildSubjectsGrid(context)
                  .animate()
                  .fade(delay: 300.ms)
                  .scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 32),
              
              Text(
                'Outils Transversaux',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fade(delay: 400.ms).slideX(begin: -0.1),
              
              const SizedBox(height: 16),
              
              _buildToolsSection(context)
                  .animate()
                  .fade(delay: 500.ms)
                  .slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, WidgetRef ref, StudentState studentState) {
    final userName = studentState.userName;
    final globalProgress = studentState.globalProgress;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark slate premium feel
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour,',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    Text(
                      '$userName ðŸ‘‹',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('ðŸ”¥', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '${studentState.streak}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ).animate().scale(delay: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/logo.jpg'), // Ou profile pic
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progression Globale',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
              ),
              Text(
                '${(globalProgress * 100).toInt()}%',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: globalProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Niveau ${studentState.niveau} ${studentState.serie}',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsGrid(BuildContext context) {
    return Column(
      children: [
        // Section AsymÃ©trique : Philo Pocket (Grand) Ã  gauche, Maths et Physique Ã  droite
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Philo Pocket (Gauche)
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Philo Pocket',
                subtitle: 'Vaisseau amiral',
                icon: Icons.menu_book_rounded,
                color: AppColors.primary,
                gradient: AppColors.primaryGradient,
                isActive: true,
                isLarge: true,
                height: 376, // 180 + 16 + 180 = 376
                onTap: () => context.push('/philo-pocket'),
              ),
            ),
            const SizedBox(width: 16),
            // Colonne de droite (Maths et Physique)
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildSubjectCard(
                    context,
                    title: 'MathÃ©matiques',
                    subtitle: 'AlgÃ¨bre & Analyse',
                    icon: Icons.calculate_rounded,
                    color: Colors.blueGrey.shade800,
                    isActive: false,
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _buildSubjectCard(
                    context,
                    title: 'Physique-Chimie',
                    subtitle: 'Sciences Physiques',
                    icon: Icons.science_rounded,
                    color: Colors.blueGrey.shade800,
                    isActive: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Grille des autres matiÃ¨res en bas
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'FranÃ§ais',
                subtitle: 'LittÃ©rature',
                icon: Icons.edit_document,
                color: Colors.blueGrey.shade800,
                isActive: false,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'S.V.T.',
                subtitle: 'Sciences de la Vie',
                icon: Icons.eco_rounded,
                color: Colors.blueGrey.shade800,
                isActive: false,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Histoire-GÃ©o',
                subtitle: 'Sciences Humaines',
                icon: Icons.public_rounded,
                color: Colors.blueGrey.shade800,
                isActive: false,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Anglais',
                subtitle: 'Langue Vivante 1',
                icon: Icons.language_rounded,
                color: Colors.blueGrey.shade800,
                isActive: false,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Espagnol',
                subtitle: 'Langue Vivante 2',
                icon: Icons.translate_rounded,
                color: Colors.blueGrey.shade800,
                isActive: false,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Ã‰conomie',
                subtitle: 'SÃ©rie B (S.E.S)',
                icon: Icons.trending_up_rounded,
                color: Colors.blueGrey.shade800,
                isActive: false,
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Allemand',
                subtitle: 'Langue Vivante 2',
                icon: Icons.record_voice_over_rounded,
                color: Colors.blueGrey.shade800,
                isActive: false,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            const Spacer(flex: 1), // Espace vide pour Ã©quilibrer la derniÃ¨re ligne
          ],
        ),
      ],
    );
  }

  Widget _buildSubjectCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    Gradient? gradient,
    required bool isActive,
    bool isLarge = false,
    double? height,
    required VoidCallback onTap,
  }) {
    return Container(
      height: height ?? (isLarge ? 200 : 180),
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        border: isActive
            ? Border.all(color: AppColors.secondary.withValues(alpha: 0.5), width: 2)
            : Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: isActive ? onTap : null,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: isActive ? 0.2 : 0.05),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, 
                        color: isActive ? Colors.white : Colors.white38, 
                        size: isLarge ? 40 : 32
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isActive ? Colors.white : Colors.white54,
                                fontWeight: FontWeight.bold,
                                fontSize: isLarge ? 24 : null,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: isActive ? Colors.white70 : Colors.white38,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isActive)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                    ),
                    child: const Text(
                      'BIENTÃ”T',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildToolButton(
            context,
            icon: Icons.smart_toy_rounded,
            label: 'ALECKSE (IA)',
            color: const Color(0xFF6366F1),
            onTap: () => context.push('/chat'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildToolButton(
            context,
            icon: Icons.picture_as_pdf_rounded,
            label: 'IPN Docs',
            color: const Color(0xFF9C3B3B),
            onTap: () => context.push('/ipn'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildToolButton(
            context,
            icon: Icons.person_rounded,
            label: 'Profil',
            color: AppColors.textDark,
            onTap: () {
                // Future profile screen
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildToolButton(
            context,
            icon: Icons.grading_rounded,
            label: 'Correction (IA)',
            color: Colors.orange.shade700,
            onTap: () => context.push('/grading'),
          ),
        ),
      ],
    );
  }

  Widget _buildToolButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

