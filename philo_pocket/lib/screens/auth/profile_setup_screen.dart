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
  String? _selectedCycle;
  String? _selectedNiveau;
  String? _selectedSerie;
  bool _isLoading = false;

  final List<String> _cycles = [
    'Collège Général',
    'Collège Technique (CET / CAP)',
    'Lycée Général',
    'Lycée Technique & Professionnel'
  ];
  final List<String> _niveauxCollegeGeneral = ['6ème', '5ème', '4ème', '3ème'];
  final List<String> _niveauxCollegeTechnique = ['4ème Année CET', '3ème Année CET (CAP)'];
  final List<String> _niveauxLycee = ['2nde', '1ère', 'Tle'];

  List<String> get _currentNiveaux {
    if (_selectedCycle == 'Collège Général') return _niveauxCollegeGeneral;
    if (_selectedCycle == 'Collège Technique (CET / CAP)') return _niveauxCollegeTechnique;
    return _niveauxLycee;
  }

  List<String> get _availableSeries {
    if (_selectedCycle == 'Collège Technique (CET / CAP)') {
      return [
        'Électricité Bâtiment',
        'Mécanique Automobile',
        'Menuiserie & Bois',
        'Maçonnerie / Construction',
        'Construction Métallique',
        'Secrétariat / Bureautique',
        'Coupe & Couture'
      ];
    } else if (_selectedCycle == 'Lycée Général') {
      if (_selectedNiveau == '2nde') return ['LE', 'S'];
      if (_selectedNiveau == '1ère') return ['A', 'B', 'S'];
      if (_selectedNiveau == 'Tle') return ['A1', 'A2', 'B', 'C', 'D'];
    } else if (_selectedCycle == 'Lycée Technique & Professionnel') {
      if (_selectedNiveau == '2nde') {
        return [
          '2nde STMG',
          '2nde Industrielle (STI)',
          '2nde STL (Laboratoire)',
          '2nde Pro (TCG / TGA)',
        ];
      }
      if (_selectedNiveau == '1ère') {
        return [
          '1ère STMG',
          '1ère F1-F4 (Génie Industriel)',
          '1ère SI (Sciences Ingénierie)',
          '1ère MVA (Automobile)',
          '1ère STL (Laboratoire)',
          '1ère Pro (TCG / TGA)',
        ];
      }
      if (_selectedNiveau == 'Tle') {
        return [
          'Tle Mercatique (STMG)',
          'Tle RHC (STMG)',
          'Tle GSI (STMG)',
          'Tle CFE (STMG)',
          'Tle F1 (Mécanique)',
          'Tle F2 (Électronique)',
          'Tle F3 (Électrotech)',
          'Tle F4 (Génie Civil)',
          'Tle SI (Sciences de l\'Ingénierie)',
          'Tle MVA (Automobile)',
          'Tle MI (Maintenance)',
          'Tle Biomédical',
          'Tle STL (BGB / CLPI)',
          'Tle Pro (TCG / TGA)',
        ];
      }
    }
    return [];
  }

  bool get _isFormValid {
    if (_selectedCycle == null) return false;
    if (_selectedNiveau == null) return false;
    if (_selectedCycle == 'Collège Général') return true;
    if (_selectedSerie == null) return false;
    return true;
  }

  Future<void> _submit() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      final serieToSave = _selectedCycle == 'Collège Général' ? 'Générale' : _selectedSerie!;

      
      await SupabaseService()
          .updateStudentProfile(_selectedNiveau!, serieToSave);
      if (mounted) {
        context.go(Uri(
          path: '/progression-setup',
          queryParameters: {
            'niveau': _selectedNiveau,
            'serie': serieToSave,
          },
        ).toString());
      }
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
      ),
    );
  }

  Widget _buildChips(List<String> options, String? selectedValue, Function(String) onSelected) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return ChoiceChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) onSelected(option);
          },
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.textDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration du profil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Se déconnecter / Réinitialiser',
            onPressed: () async {
              await SupabaseService().signOut();
              if (context.mounted) context.go('/welcome');
            },
          ),
        ],
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CYCLE
                      _buildSectionTitle('Cycle'),
                      _buildChips(_cycles, _selectedCycle, (val) {
                        setState(() {
                          _selectedCycle = val;
                          _selectedNiveau = null;
                          _selectedSerie = null;
                        });
                      }),
                      const SizedBox(height: 24),

                      // CLASSE
                      if (_selectedCycle != null) ...[
                        _buildSectionTitle('Classe'),
                        _buildChips(
                          _currentNiveaux,
                          _selectedNiveau,
                          (val) {
                            setState(() {
                              _selectedNiveau = val;
                              _selectedSerie = null;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                      ],

                      // SERIE / FILIERE / SPECIALITE
                      if (_selectedCycle != null && _selectedCycle != 'Collège Général' && _selectedNiveau != null) ...[
                        _buildSectionTitle(_selectedCycle == 'Lycée Général'
                            ? 'Série'
                            : 'Filière / Métier préparé'),
                        _buildChips(_availableSeries, _selectedSerie, (val) {
                          setState(() {
                            _selectedSerie = val;
                          });
                        }),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (_isFormValid && !_isLoading) ? _submit : null,
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
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text(
                        'Commencer à apprendre',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
