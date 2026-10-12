import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../legal/legal_document_viewer_screen.dart';

class TeacherPartnerScreen extends StatelessWidget {
  const TeacherPartnerScreen({Key? key}) : super(key: key);

  Future<void> _launchWhatsApp(BuildContext context) async {
    const phoneNumber = '+24177141912';
    const message = 'Bonjour, je suis enseignant et je souhaite échanger sur le partenariat pédagogique EduPocket.';
    
    final url = Uri.parse('https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d\'ouvrir WhatsApp.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Espace Enseignant'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Illustration ou Icône
              const Center(
                child: Icon(
                  Icons.handshake_rounded,
                  size: 80,
                  color: AppColors.primary,
                ),
              ).animate().fade().scale(delay: 100.ms),
              const SizedBox(height: 24),
              
              Text(
                'Devenez Créateur Partenaire eduPocket',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 24),
              
              // Le Pitch
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 1. LE PATRIMOINE EN PREMIER
                    _buildFeatureRow(
                      context,
                      icon: Icons.history_edu_rounded,
                      title: 'Bâtissez le patrimoine éducatif gabonais',
                      description: 'Vos cours ne meurent plus à la fin de l\'année : ils deviennent des références durables pour les élèves et collègues de tout le Gabon.',
                    ),
                    const Divider(height: 32),
                    // 2. ZÉRO STRESS EN 2E
                    _buildFeatureRow(
                      context,
                      icon: Icons.edit_document,
                      title: 'Zéro stress technique',
                      description: 'Transmettez-nous vos cours sous format Word. Nous nous occupons de l\'intégration pédagogique selon la méthodologie nationale.',
                    ),
                    const Divider(height: 32),
                    // 3. RÉMUNÉRATION EN AVANT-DERNIER (Jusqu'à 70%)
                    _buildFeatureRow(
                      context,
                      icon: Icons.monetization_on_rounded,
                      title: 'Rémunération équitable de vos œuvres',
                      description: 'Partagez vos modules et touchez jusqu\'à 70% des revenus générés par vos élèves sur la plateforme.',
                    ),
                    const Divider(height: 32),
                    // 4. CODE PROMO EN DERNIER
                    _buildFeatureRow(
                      context,
                      icon: Icons.campaign_rounded,
                      title: 'Code Promo Personnel',
                      description: 'Distribuez votre code parrain à vos élèves en classe. S\'ils s\'abonnent aux modules de perfectionnement, vous gagnez une commission supplémentaire.',
                    ),
                  ],
                ),
              ).animate().fade(delay: 400.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 16),
              
              TextButton.icon(
                onPressed: () => LegalDocumentViewerScreen.show(
                  context,
                  title: 'Manifeste & Vision Fondatrice',
                  assetPath: 'assets/legal/manifeste_vision.md',
                ),
                icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 20),
                label: const Text(
                  'Lire notre Manifeste Fondateur pour le Gabon',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ).animate().fade(delay: 450.ms),

              TextButton.icon(
                onPressed: () => LegalDocumentViewerScreen.show(
                  context,
                  title: 'Quotas Officiels par Province',
                  assetPath: 'assets/legal/quotas_provinciaux.md',
                ),
                icon: const Icon(Icons.table_chart_rounded, color: AppColors.primary, size: 20),
                label: const Text(
                  'Consulter les Quotas par Matière & Province',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ).animate().fade(delay: 480.ms),

              const SizedBox(height: 16),
              
              ElevatedButton.icon(
                onPressed: () => _launchWhatsApp(context),
                icon: const Icon(Icons.chat_rounded, color: Colors.white),
                label: const Text(
                  'Nous contacter sur WhatsApp',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366), // Vert WhatsApp
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ).animate().fade(delay: 500.ms).scale(),
              
              const SizedBox(height: 16),
              
              OutlinedButton.icon(
                onPressed: () {
                  // Redirige directement vers le tableau de bord principal de l'application
                  context.go('/main');
                },
                icon: const Icon(Icons.phone_android_rounded),
                label: const Text(
                  'Tester l\'application (Mode Éditeur)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ).animate().fade(delay: 600.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, {required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
