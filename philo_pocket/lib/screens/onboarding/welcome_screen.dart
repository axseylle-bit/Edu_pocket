import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

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
              // Header (Numéro + Titre)
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'ACCUEIL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Carte Principale
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: AppColors.border.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Titre Philo Pocket et Cloche
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  fontFamily: 'Serif', // Optionnel
                                ),
                                children: [
                                  TextSpan(text: 'PHILO ', style: TextStyle(color: AppColors.primary)),
                                  TextSpan(text: 'POCKET', style: TextStyle(color: Color(0xFFE5989B))),
                                ],
                              ),
                            ),
                            const Icon(Icons.notifications_none, color: AppColors.primary),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Texte Bienvenue
                        const Text(
                          'Bienvenue !',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Sous-titre
                        const Text(
                          'La philosophie en poche,\npour éclairer votre esprit\nau quotidien.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textLight,
                            height: 1.5,
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Image retirée
                        const Spacer(flex: 4),
                        
                        const SizedBox(height: 24),
                        
                        // Bouton Commencer
                        ElevatedButton(
                          onPressed: () {
                            context.go('/aleckse');
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
                            'Commencer',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
}
