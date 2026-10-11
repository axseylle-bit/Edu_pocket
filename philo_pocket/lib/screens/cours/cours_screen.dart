import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/programmes_officiels.dart';
import '../../core/services/supabase_service.dart';
import '../../core/constants/app_colors.dart';

class CoursScreen extends StatefulWidget {
  const CoursScreen({Key? key}) : super(key: key);

  @override
  State<CoursScreen> createState() => _CoursScreenState();
}

class _CoursScreenState extends State<CoursScreen> {
  String _niveau = '1ere';
  String _serie = 'A1';
  bool _isLoading = true;
  List<String> _readCourses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await SupabaseService().getStudentProfile();
      if (data != null) {
        if (mounted) {
          setState(() {
            _niveau = data['niveau'] ?? '1ere';
            _serie = data['serie'] ?? 'A1';
          });
        }
      }
      
      final readCourses = await SupabaseService().getReadCourses();
      if (mounted) {
        setState(() {
          _readCourses = readCourses;
        });
      }
    } catch (e) {
      debugPrint('Erreur de chargement du profil: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Mes Cours')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final t1 = ProgrammeOfficiel.getNotions(_niveau, _serie, 1);
    final t2 = ProgrammeOfficiel.getNotions(_niveau, _serie, 2);
    final t3 = ProgrammeOfficiel.getNotions(_niveau, _serie, 3);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Cours ($_niveau $_serie)'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildTrimestreSection(context, '1er Trimestre', t1),
          _buildTrimestreSection(context, '2e Trimestre', t2),
          _buildTrimestreSection(context, '3e Trimestre', t3),
        ],
      ),
    );
  }

  Widget _buildTrimestreSection(BuildContext context, String title,
      Map<String, List<String>> segmentsMap) {
    if (segmentsMap.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
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

          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              shape: const Border(),
              title: Text(
                segment,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              children: notions.map((notion) {
                return InkWell(
                  onTap: () async {
                    await context.push(Uri(
                        path: '/course-viewer',
                        queryParameters: {'notion': notion}).toString());
                    // Recharger après retour pour mettre à jour la coche
                    _loadData();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          _readCourses.contains(notion) ? Icons.check_circle : Icons.menu_book_rounded,
                          size: 20, 
                          color: _readCourses.contains(notion) ? Colors.green : AppColors.accent
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notion,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Icon(Icons.chevron_right,
                            size: 20, color: Colors.grey.shade400),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }
}
