import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_colors.dart';

class AdminCoursesScreen extends StatefulWidget {
  const AdminCoursesScreen({Key? key}) : super(key: key);

  @override
  State<AdminCoursesScreen> createState() => _AdminCoursesScreenState();
}

class _AdminCoursesScreenState extends State<AdminCoursesScreen> {
  bool _isLoading = true;
  List<dynamic> _courses = [];
  String _selectedFilter = 'all'; // 'all', 'general', 'technique_pro'

  List<dynamic> get _filteredCourses {
    if (_selectedFilter == 'all') return _courses;
    return _courses.where((c) {
      final type = c['type_enseignement'] ?? 'general';
      return type == _selectedFilter;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await Supabase.instance.client
          .from('courses')
          .select()
          .order('created_at', ascending: false);
          
      setState(() {
        _courses = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erreur lors de la récupération des cours: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCourses;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gestion des Cours',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Organisez les cours par Enseignement Général et Technique & Professionnel',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Naviguer vers la création de cours
                },
                icon: const Icon(Icons.add),
                label: const Text('Nouveau Cours'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Filtres d'enseignement
          Row(
            children: [
              _buildFilterChip('Tous les cours (${_courses.length})', 'all'),
              const SizedBox(width: 10),
              _buildFilterChip('🎓 Enseignement Général', 'general'),
              const SizedBox(width: 10),
              _buildFilterChip('⚙️ Technique & Professionnel', 'technique_pro'),
            ],
          ),
          const SizedBox(height: 20),

          // Tableau de bord
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? Center(
                          child: Text(
                            _selectedFilter == 'all'
                                ? 'Aucun cours trouvé. Ajoutez-en un !'
                                : 'Aucun cours dans cette section d\'enseignement.',
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                        )
                      : _buildCoursesTable(filtered),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _selectedFilter = value);
        }
      },
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textDark,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        fontSize: 13,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildCoursesTable(List<dynamic> coursesList) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        DataTable(
          headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMuted),
          columns: const [
            DataColumn(label: Text('Titre')),
            DataColumn(label: Text('Filière / Enseignement')),
            DataColumn(label: Text('Auteur')),
            DataColumn(label: Text('Statut')),
            DataColumn(label: Text('Date de création')),
            DataColumn(label: Text('Actions')),
          ],
          rows: coursesList.map((course) {
            final isTech = (course['type_enseignement'] == 'technique_pro');
            final isPublished = (course['is_published'] == true || course['statut_publication'] == true);

            return DataRow(
              cells: [
                DataCell(Text(course['title'] ?? course['titre'] ?? 'Sans titre', style: const TextStyle(fontWeight: FontWeight.bold))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isTech
                          ? Colors.blue.withValues(alpha: 0.12)
                          : Colors.purple.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isTech ? '⚙️ Technique & Pro' : '🎓 Général',
                      style: TextStyle(
                        color: isTech ? Colors.blue.shade800 : Colors.purple.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(course['author_name'] ?? 'Équipe Pédagogique')),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPublished ? AppColors.success.withValues(alpha: 0.1) : AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPublished ? 'Publié' : 'Brouillon',
                      style: TextStyle(
                        color: isPublished ? AppColors.success : AppColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                DataCell(Text(_formatDate(course['created_at'] ?? course['date_creation']))),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                        onPressed: () {
                          // TODO: Editer
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.error),
                        onPressed: () {
                          // TODO: Supprimer
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return '-';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
