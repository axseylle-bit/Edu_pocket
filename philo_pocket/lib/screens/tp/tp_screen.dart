import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';

class TpScreen extends StatefulWidget {
  const TpScreen({Key? key}) : super(key: key);

  @override
  State<TpScreen> createState() => _TpScreenState();
}

class _TpScreenState extends State<TpScreen> {
  bool _isLoading = true;
  String _tier = 'gratuit';

  @override
  void initState() {
    super.initState();
    _fetchTier();
  }

  Future<void> _fetchTier() async {
    final tier = await SupabaseService().getStudentSubscription();
    if (mounted) {
      setState(() {
        _tier = tier;
        _isLoading = false;
      });
    }
  }

  Widget _buildLockedState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_rounded, size: 80, color: AppColors.border),
            const SizedBox(height: 24),
            Text(
              'Contenu Premium',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Les Ateliers Pratiques et Simulateurs de Bac sont réservés aux abonnés Platon ou Aristote.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.workspace_premium_rounded),
              label: const Text('Voir les offres'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              onPressed: () {
                context.push('/subscription');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumState() {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          'Ateliers & Simulateurs',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Mettez en pratique vos connaissances avec ces outils interactifs.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        _buildTpCard(
          title: 'Atelier de Rédaction',
          description: 'Rédigez pas à pas avec ALECKSE qui corrige votre structure.',
          icon: Icons.edit_note_rounded,
          color: Colors.blueAccent,
          onTap: () {
            context.push('/chat?mode=td&type=Dissertation&subject=La conscience exclut-elle l\'inconscient ?');
          },
        ),
        _buildTpCard(
          title: 'Simulateur Bac Blanc',
          description: 'Sujets chronométrés et correction détaillée selon les grilles de l\'IPN.',
          icon: Icons.timer_rounded,
          color: Colors.redAccent,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Simulateur en cours de construction...')),
            );
          },
        ),
        _buildTpCard(
          title: 'Mythes Interactifs',
          description: 'Plongez dans l\'Allégorie de la Caverne et autres mythes.',
          icon: Icons.auto_awesome_rounded,
          color: Colors.purpleAccent,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mythes 3D en cours de construction...')),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTpCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
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
        title: const Text('Travaux Pratiques (TP)'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : (_tier == 'gratuit' ? _buildLockedState() : _buildPremiumState()),
      ),
    );
  }
}
