import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? _selectedNiveau;
  String? _selectedSerie;
  bool _isLoading = false;

  final List<String> _niveaux = ['1ere', 'Tle'];
  final List<String> _series = ['A1', 'A2', 'B', 'C', 'D', 'S'];

  Future<void> _submit() async {
    if (_selectedNiveau == null || _selectedSerie == null) return;

    setState(() => _isLoading = true);

    try {
      await SupabaseService().updateStudentProfile(_selectedNiveau!, _selectedSerie!);
      if (mounted) context.go('/subscription');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration du profil'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Afin de personnaliser vos cours et quiz, dites-nous en plus sur vous.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Colonne Classe
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Classe',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _niveaux.map((niveau) {
                              final isSelected = _selectedNiveau == niveau;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ChoiceChip(
                                  label: Center(child: Text(niveau)),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() => _selectedNiveau = selected ? niveau : null);
                                  },
                                  selectedColor: AppColors.primary,
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Colonne Série
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Série',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: _series.map((serie) {
                              final isSelected = _selectedSerie == serie;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: ChoiceChip(
                                  label: Center(child: Text(serie)),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() => _selectedSerie = selected ? serie : null);
                                  },
                                  selectedColor: AppColors.primary,
                                  labelStyle: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.textDark,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              ElevatedButton(
                onPressed: (_selectedNiveau != null && _selectedSerie != null && !_isLoading)
                    ? _submit
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text(
                        'Commencer à apprendre',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
