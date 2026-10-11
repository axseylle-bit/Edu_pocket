import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/student_provider.dart';
import '../../core/models/student_level.dart';

class PhiloPocketScreen extends ConsumerWidget {
  const PhiloPocketScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentState = ref.watch(studentProvider);
    final tier = studentState.tier;

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
                'Actions Rapides',
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fade(delay: 200.ms).slideX(begin: -0.1),

              const SizedBox(height: 20),

              // Bento Box Layout
              _buildBentoBox(context, tier)
                  .animate()
                  .fade(delay: 300.ms)
                  .scale(begin: const Offset(0.95, 0.95)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, WidgetRef ref, StudentState studentState) {
    final tierName = studentState.tier.name;
    final userName = studentState.userName;
    final globalProgress = studentState.globalProgress;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
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
                      'Bonjour $userName 👋',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Abonnement $tierName',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  ref.read(studentProvider.notifier).levelUp();
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5), width: 2),
                  ),
                  child: const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/logo.jpg'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Progression Globale',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: globalProgress,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.secondary),
                    minHeight: 14,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${(globalProgress * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Niveau ${studentState.niveau} ${studentState.serie} • Prochain palier dans 350 pts',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoBox(BuildContext context, SubscriptionTier tier) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildBentoCard(
                    context,
                    title: 'Mes cours',
                    subtitle: 'Programme de classe',
                    icon: Icons.menu_book_rounded,
                    color: AppColors.primary,
                    gradient: AppColors.primaryGradient,
                    height: 180,
                    onTap: () => context.push('/cours'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildBentoCard(
                    context,
                    title: 'Quiz',
                    subtitle: 'Évalue-toi',
                    icon: Icons.quiz_rounded,
                    color: AppColors.accent,
                    height: 180,
                    onTap: () => context.push(
                        '/quiz?notion=Genèse de la philosophie : du mythe à la rationalité'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildBentoCard(
              context,
              title: 'Documents IPN',
              subtitle: 'Méthodologies, progressions et grilles officielles',
              icon: Icons.picture_as_pdf_rounded,
              color: const Color(0xFF9C3B3B),
              height: 124,
              onTap: () => context.push('/ipn'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildBentoCard(
                    context,
                    title: 'ALECKSE',
                    subtitle: 'Ton IA',
                    icon: Icons.smart_toy_rounded,
                    color: const Color(0xFF6366F1), // Violet premium
                    gradient: AppColors.premiumGradient,
                    height: 160,
                    onTap: () => context.push('/chat'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: _buildBentoCard(
                    context,
                    title: 'Citations',
                    subtitle: 'Auteurs & Phrases',
                    icon: Icons.format_quote_rounded,
                    color: AppColors.secondary,
                    textColor: AppColors.textDark,
                    height: 160,
                    isLocked: tier.level < 2, // Essentiel requis
                    onTap: () => context.push('/citations'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildBentoCard(
                    context,
                    title: 'TD & Bac',
                    subtitle: 'Pratique avec ALECKSE',
                    icon: Icons.school_rounded,
                    color: AppColors.textDark,
                    height: 140,
                    onTap: () => context.push('/td'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildBentoCard(
                    context,
                    title: 'TP & Ateliers',
                    subtitle: 'Pratique intensive',
                    icon: Icons.construction_rounded,
                    color: Colors.blueGrey,
                    height: 140,
                    isLocked: !tier.canAccessTP,
                    onTap: () => context.push('/tp'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBentoCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    Gradient? gradient,
    required double height,
    required VoidCallback onTap,
    Color textColor = Colors.white,
    bool isLocked = false,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: isLocked ? () => context.push('/subscription') : onTap,
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
                        color: textColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: textColor, size: 28),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (isLocked)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_rounded,
                        color: Colors.amber, size: 20),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
