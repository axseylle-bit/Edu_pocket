import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';
import '../../core/models/programmes_officiels.dart';

class ProgressionSetupScreen extends StatefulWidget {
  const ProgressionSetupScreen({Key? key}) : super(key: key);

  @override
  State<ProgressionSetupScreen> createState() => _ProgressionSetupScreenState();
}

class _ProgressionSetupScreenState extends State<ProgressionSetupScreen> {
  String _niveau = '1ere';
  String _serie = 'A1';
  bool _isLoadingProfile = true;

  final Set<String> _selectedNotions = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await SupabaseService().getStudentProfile();
      if (data != null) {
        setState(() {
          _niveau = data['niveau'] ?? '1ere';
          _serie = data['serie'] ?? 'A1';
        });
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  Widget _buildTrimestreSection(String title, Map<String, List<String>> segmentsMap) {
    if (segmentsMap.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        ...segmentsMap.entries.map((entry) {
          final segment = entry.key;
          final notions = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                    child: Text(
                      segment,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: notions.map((notion) {
                      final isSelected = _selectedNotions.contains(notion);
                      return FilterChip(
                        label: Text(
                          notion,
                          style: const TextStyle(fontSize: 13),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedNotions.add(notion);
                            } else {
                              _selectedNotions.remove(notion);
                            }
                          });
                        },
                        selectedColor: AppColors.secondary,
                        checkmarkColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.textDark,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        const Divider(height: 32),
      ],
    );
  }

  Future<void> _submit() async {
    if (_selectedNotions.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // Dans une version complète, on sauvegarderait cela dans Supabase
      // await SupabaseService().updateStudentNotions(_selectedNotions.toList());
      
      // On redirige vers le cours de la première notion sélectionnée
      final premiereNotion = _selectedNotions.first;
      if (mounted) {
        // Envoi vers le cours avec le nom de la notion
        context.go('/cours');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Votre programme'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  Text(
                    'Quelles notions étudiez-vous actuellement en classe ?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sélectionnez au moins une notion pour générer votre premier cours.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  if (_isLoadingProfile)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    _buildTrimestreSection('Trimestre 1', ProgrammeOfficiel.getNotions(_niveau, _serie, 1)),
                    _buildTrimestreSection('Trimestre 2', ProgrammeOfficiel.getNotions(_niveau, _serie, 2)),
                    _buildTrimestreSection('Trimestre 3', ProgrammeOfficiel.getNotions(_niveau, _serie, 3)),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: (_selectedNotions.isNotEmpty && !_isLoading)
                    ? _submit
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      )
                    : const Text(
                        'Lire mon premier cours',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
