import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class SubscriptionChoiceScreen extends StatelessWidget {
  const SubscriptionChoiceScreen({Key? key}) : super(key: key);

  Widget _buildSubscriptionCard(BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required Color color,
    required IconData icon,
    bool isPopular = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPopular ? color : AppColors.border.withOpacity(0.5),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Dans un vrai flux, on sauvegarderait ce choix en mémoire locale
            // puis on l'attacherait au compte après l'inscription.
            context.go('/progression-setup');
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'LE PLUS CHOISI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            price,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, color: AppColors.border),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: color, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Choisissez votre formule'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              'Débloquez tout le potentiel de la philosophie avec la formule qui vous correspond.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            _buildSubscriptionCard(
              context,
              title: 'Socrate',
              price: 'Gratuit',
              color: AppColors.primary,
              icon: Icons.menu_book_rounded,
              features: [
                'Accès aux fiches de cours',
                'Méthodologie IPN de base',
                '1 quiz d\'évaluation par notion',
                'ALECKSE basique',
              ],
            ),
            
            _buildSubscriptionCard(
              context,
              title: 'Platon',
              price: 'Essentiel (Abonnement)',
              color: AppColors.accent,
              icon: Icons.psychology_rounded,
              isPopular: true,
              features: [
                'Tout le contenu Socrate',
                'Quiz illimités pour s\'entraîner',
                'Suivi détaillé de la progression',
                'Bulletin hebdomadaire pour les parents',
              ],
            ),
            
            _buildSubscriptionCard(
              context,
              title: 'Aristote',
              price: 'Confort (Premium)',
              color: const Color(0xFF6A4C93), // Un violet premium
              icon: Icons.workspace_premium_rounded,
              features: [
                'Tout le contenu Platon',
                'TP et Ateliers pratiques',
                'Dialogue direct avec les grands philosophes',
                'Bac blanc corrigé par ALECKSE avancé',
                'Mode hors ligne',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
