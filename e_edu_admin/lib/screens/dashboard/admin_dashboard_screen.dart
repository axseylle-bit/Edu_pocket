import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32.0),
      children: [
        // En-tête de bienvenue
        const Text(
          'Vue Générale',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Voici les performances globales de e-edu.ga aujourd\'hui.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 16),
        ),
        const SizedBox(height: 32),

        // Ligne des KPIs (Statistiques clés)
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            _buildKpiCard('Élèves Actifs', '1,248', '+12%', Icons.school_rounded, AppColors.primary),
            _buildKpiCard('Parents Connectés', '432', '+5%', Icons.family_restroom_rounded, Colors.blue.shade700),
            _buildKpiCard('Taux de Réussite', '68%', '+2.4%', Icons.auto_graph_rounded, AppColors.accent),
            _buildKpiCard('Abonnements Premium', '156', '+8%', Icons.workspace_premium_rounded, Colors.purple.shade600),
          ],
        ),
        const SizedBox(height: 40),

        // Contenu Principal (Graphiques & Activités)
        LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 900;
            return Flex(
              direction: isDesktop ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Zone principale (Graphique ou raccourcis)
                Expanded(
                  flex: isDesktop ? 2 : 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Actions Rapides',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: _buildActionButton('Nouveau Cours', Icons.add_circle_outline, AppColors.primary)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildActionButton('Créer un Quiz', Icons.quiz_rounded, AppColors.accent)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildActionButton('Publier une Annonce', Icons.campaign_rounded, AppColors.secondary)),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Center(
                            child: Text(
                              '📊 Graphique d\'engagement des élèves (À venir avec les données réelles)',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: isDesktop ? 0 : 24, width: isDesktop ? 24 : 0),

                // Colonne latérale (Activités récentes)
                Expanded(
                  flex: isDesktop ? 1 : 0,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Activité Récente',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                        ),
                        const SizedBox(height: 24),
                        _buildActivityItem('Prof. Diallo a publié "La Conscience".', 'Il y a 2 heures', Icons.menu_book_rounded, Colors.blue),
                        _buildActivityItem('Nouvel abonnement Confort souscrit.', 'Il y a 4 heures', Icons.star_rounded, AppColors.accent),
                        _buildActivityItem('Signale d\'erreur sur le Quiz #4.', 'Hier', Icons.warning_rounded, AppColors.error),
                        _buildActivityItem('Mise à jour des Progressions IPN.', 'Hier', Icons.picture_as_pdf_rounded, AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, String growth, IconData icon, Color color) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: AppColors.success, size: 16),
              const SizedBox(width: 4),
              Text(growth, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
              const Text(' ce mois-ci', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActivityItem(String text, String time, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textDark)),
                const SizedBox(height: 4),
                Text(time, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
