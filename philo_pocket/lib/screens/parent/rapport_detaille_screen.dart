import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RapportDetailleScreen extends StatelessWidget {
  final Map<String, dynamic>? childData;

  const RapportDetailleScreen({Key? key, this.childData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = childData?['nom'] as String? ?? 'Kévin Mba';
    final niveau = childData?['niveau'] as String? ?? 'Terminale';
    final serie = childData?['serie'] as String? ?? 'A1';
    final scoreMoyen = (childData?['score'] as num?)?.toDouble() ?? 15.5;
    final couverture = (childData?['couverture'] as num?)?.toDouble() ?? 68.0;
    final tempsEtude = childData?['temps'] as String? ?? '4h 30';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Bulletin & Suivi Scolaire'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Partager le bulletin',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bulletin exporté au format PDF pour partage ! 📄'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // 1. Carte Identité Élève
          _buildStudentHeader(context, name, niveau, serie, couverture),

          const SizedBox(height: 20),

          // 2. Chiffres clés hebdomadaires
          _buildWeeklyKpis(scoreMoyen, tempsEtude, couverture),

          const SizedBox(height: 24),

          // 3. Avis & Synthèse Pédagogique d'ALECKSE (IA)
          _buildAleckseInsightCard(name),

          const SizedBox(height: 24),

          // 4. Avancement par Trimestre
          _buildTrimestreProgressSection(context),

          const SizedBox(height: 24),

          // 5. Historique Récent des Quiz et TD
          _buildRecentQuizSection(context),

          const SizedBox(height: 32),

          // 6. Bouton d'encouragement
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Message d\'encouragement envoyé à $name ! 🎉'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            icon: const Icon(Icons.favorite_rounded),
            label: Text('Envoyer des félicitations à $name'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStudentHeader(
      BuildContext context, String name, String niveau, String serie, double couverture) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.secondary,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'E',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$niveau $serie • Lycée National Léon Mba',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: couverture / 100,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${couverture.toInt()}%',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyKpis(double score, String temps, double couverture) {
    return Row(
      children: [
        Expanded(
          child: _buildKpiBox(
            title: 'Moyenne Quiz',
            value: '${score.toStringAsFixed(1)}/20',
            color: AppColors.success,
            icon: Icons.emoji_events_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiBox(
            title: 'Temps cette sem.',
            value: temps,
            color: Colors.blue.shade700,
            icon: Icons.timer_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildKpiBox(
            title: 'Assiduité',
            value: 'Régulier',
            color: AppColors.accent,
            icon: Icons.local_fire_department_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiBox({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAleckseInsightCard(String studentName) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6E2), // Fond ivoire doux
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.accent,
                child: Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'L\'analyse d\'ALECKSE (Professeure IA)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '« $studentName fait preuve d\'une excellente régularité sur les notions d\'introduction et de mythologie. Ses arguments de dissertation sont bien structurés selon la méthode IPN. Pour le prochain devoir, je lui conseille d\'approfondir les citations de Dalí et Kant sur le cours "Art et Technique". »',
            style: const TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrimestreProgressSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progression par Trimestre (Programme Officiel)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
          ),
          const SizedBox(height: 16),
          _buildTrimestreRow('1er Trimestre : Initiation & Rationalité', 0.85, '85% assimilé', Colors.green),
          const SizedBox(height: 12),
          _buildTrimestreRow('2e Trimestre : L\'Homme, Société & Culture', 0.50, '50% en cours', Colors.orange),
          const SizedBox(height: 12),
          _buildTrimestreRow('3e Trimestre : Science, Vérité & Épreuves', 0.10, '10% à venir', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildTrimestreRow(String label, double value, String status, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              status,
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentQuizSection(BuildContext context) {
    final recentEvals = [
      {'titre': 'L\'Art et la Technique', 'type': 'Quiz Notion', 'note': '18/20', 'date': 'Hier', 'color': AppColors.success},
      {'titre': 'La conscience et l\'inconscient', 'type': 'Exercice TD', 'note': '15/20', 'date': 'Il y a 3 jours', 'color': AppColors.success},
      {'titre': 'Genèse de la philosophie', 'type': 'Quiz Révision', 'note': '14/20', 'date': 'La semaine passée', 'color': Colors.blue},
      {'titre': 'La sorcellerie et le fétiche', 'type': 'Quiz Notion', 'note': '11/20', 'date': 'Il y a 2 semaines', 'color': Colors.orange},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dernières Évaluations',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
              ),
              const Text(
                'Toutes >',
                style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recentEvals.map((eval) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: (eval['color'] as Color).withOpacity(0.12),
                      child: Icon(Icons.check_rounded, color: eval['color'] as Color, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eval['titre'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                          Text(
                            '${eval['type']} • ${eval['date']}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      eval['note'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: eval['color'] as Color,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
