import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class AleckseScreen extends StatelessWidget {
  const AleckseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Text(
                'ALECKSE - VOTRE PROFESSEURE VIRTUELLE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Contenu principal (Image + Liste)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Aleckse
                    Expanded(
                      flex: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.asset(
                          'assets/images/aleckse.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Text('Image aleckse.png manquante', textAlign: TextAlign.center,),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Liste des caractéristiques
                    Expanded(
                      flex: 5,
                      child: ListView(
                        children: [
                          _buildFeatureItem(
                            icon: Icons.menu_book_outlined,
                            title: 'Explique',
                            subtitle: 'Clair et simplement',
                          ),
                          _buildFeatureItem(
                            icon: Icons.chat_bubble_outline,
                            title: 'Répond',
                            subtitle: 'À toutes vos questions',
                          ),
                          _buildFeatureItem(
                            icon: Icons.trending_up,
                            title: 'Guide',
                            subtitle: 'Votre progression',
                          ),
                          _buildFeatureItem(
                            icon: Icons.favorite_outline,
                            title: 'Motive',
                            subtitle: 'En toute bienveillance',
                          ),
                          _buildFeatureItem(
                            icon: Icons.local_fire_department_outlined,
                            title: 'Inspire',
                            subtitle: 'Votre réflexion',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bouton Continuer
              ElevatedButton(
                onPressed: () {
                  context.go('/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Continuer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFE5989B), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
