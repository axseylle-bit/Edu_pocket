import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../legal/legal_document_viewer_screen.dart';

class TeacherPartnerScreen extends StatelessWidget {
  const TeacherPartnerScreen({super.key});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('$label copié : $text'),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _openWhatsApp(BuildContext context) {
    _copyToClipboard(context, '+24177141912', 'Numéro WhatsApp');
    final url = Uri.parse('https://wa.me/24177141912');
    launchUrl(url, mode: LaunchMode.externalNonBrowserApplication).catchError((_) {
      return launchUrl(url, mode: LaunchMode.platformDefault);
    });
  }

  void _openEmail(BuildContext context) {
    _copyToClipboard(context, 'axseylle@gmail.com', 'Email');
    final url = Uri.parse('mailto:axseylle@gmail.com');
    launchUrl(url).catchError((_) => false);
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
              
              // =======================================================
              // CONTACT DIRECT : NUMÉRO WHATSAPP & EMAIL EN CLAIR
              // =======================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade400, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.support_agent_rounded, color: Colors.green.shade800, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Contact Direct de la Coordination',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Échangez avec nous directement 7j/7 :',
                                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 1. BLOC WHATSAPP
                    InkWell(
                      onTap: () => _openWhatsApp(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF25D366),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chat_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'WhatsApp Officiel',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E7E34),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  SelectableText(
                                    '+241 77 14 19 12',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F5132),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copier le numéro WhatsApp',
                              icon: const Icon(Icons.copy_rounded, color: Color(0xFF1E7E34), size: 20),
                              onPressed: () => _copyToClipboard(context, '+24177141912', 'Numéro WhatsApp'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 2. BLOC EMAIL
                    InkWell(
                      onTap: () => _openEmail(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.email_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Courriel de Coordination',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  SelectableText(
                                    'axseylle@gmail.com',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copier l\'adresse email',
                              icon: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 20),
                              onPressed: () => _copyToClipboard(context, 'axseylle@gmail.com', 'Email'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      'Touchez directement pour ouvrir ou cliquez sur l\'icône pour copier.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                    ),
                  ],
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
