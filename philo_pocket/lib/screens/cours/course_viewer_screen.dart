import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';
import '../../core/providers/student_provider.dart';
import '../../core/models/student_level.dart';
import '../../core/services/course_cache_service.dart';

class CourseViewerScreen extends ConsumerStatefulWidget {
  final String notion;

  const CourseViewerScreen({Key? key, required this.notion}) : super(key: key);

  @override
  ConsumerState<CourseViewerScreen> createState() => _CourseViewerScreenState();
}

class _CourseViewerScreenState extends ConsumerState<CourseViewerScreen> {

  // Dictionnaire temporaire pour lier une notion Ã  son fichier MD
  // Ã€ terme, ceci pourrait Ãªtre gÃ©rÃ© par Supabase ou un provider.
  static const Map<String, String> courseAssets = {
    'genÃ¨se de la philosophie : du mythe Ã  la rationalitÃ©':
        'assets/courses/genese_de_la_philosophie.md',
    'le matÃ©rialisme, l\'idÃ©alisme, l\'empirisme et le rationalisme':
        'assets/courses/grands_courants.md',
    'la sorcellerie et le fÃ©tiche': 'assets/courses/sorcellerie_fetiche.md',
    'le sujet-question': 'assets/courses/le_sujet_question.md',
    'la nature et l\'Ã©cologie': 'assets/courses/etre_et_pensee.md',
    'l\'homme : l\'Ã¢me et le corps': 'assets/courses/etre_et_pensee.md',
    'la conscience et la dignitÃ©': 'assets/courses/le_monde_et_les_valeurs.md',
    'le bien': 'assets/courses/le_monde_et_les_valeurs.md',
    'la coutume et le sacrÃ©': 'assets/courses/le_monde_et_les_valeurs.md',
    'la dÃ©mocratie': 'assets/courses/le_monde_et_les_valeurs.md',
    'la thÃ©orie': 'assets/courses/science_et_verite.md',
    'l\'expÃ©rimentation': 'assets/courses/science_et_verite.md',
    'la logique': 'assets/courses/science_et_verite.md',
    'la conscience et l\'inconscient': 'assets/courses/individu_et_societe.md',
    'les passions': 'assets/courses/individu_et_societe.md',
    'autrui': 'assets/courses/individu_et_societe.md',
    'l\'ethnie et la nation': 'assets/courses/ethnie_et_nation.md',
  };

  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    _checkIfRead();
  }

  Future<void> _checkIfRead() async {
    final readCourses = await SupabaseService().getReadCourses();
    if (mounted) {
      setState(() {
        _isRead = readCourses.contains(widget.notion);
      });
    }
  }

  Future<void> _markAsRead() async {
    await SupabaseService().markCourseAsRead(widget.notion);
    if (mounted) {
      setState(() {
        _isRead = true;
      });
      // Mettre Ã  jour la jauge de progression globale
      ref.read(studentProvider.notifier).reloadProgress();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cours marquÃ© comme terminÃ© ! ðŸŽ‰'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Normaliser la chaÃ®ne pour Ã©viter les problÃ¨mes d'espaces ou de majuscules
    final normalizedNotion = widget.notion.trim().toLowerCase();

    // Rechercher dans les clÃ©s en normalisant Ã©galement
    final matchingKey = courseAssets.keys.firstWhere(
      (key) => key.toLowerCase() == normalizedNotion,
      orElse: () => '',
    );

    final assetPath = matchingKey.isNotEmpty 
        ? courseAssets[matchingKey]! 
        : 'assets/courses/placeholder.md';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.notion,
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<String>(
              future: CourseCacheService().getCourseContent(widget.notion, assetPath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Erreur lors du chargement du cours:\n${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Le cours est vide.'));
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MarkdownBody(
                        data: snapshot.data!,
                        styleSheet: MarkdownStyleSheet(
                          h1: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                          h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold),
                          h3: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          p: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(height: 1.5),
                          blockquote: const TextStyle(
                              color: Colors.grey, fontStyle: FontStyle.italic),
                          blockquoteDecoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: AppColors.accent, width: 4)),
                            color: Colors.grey.shade100,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.push(Uri(
                                        path: '/quiz',
                                        queryParameters: {'notion': widget.notion})
                                    .toString());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.quiz),
                              label: const Text('Le Quiz',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.push(Uri(
                                        path: '/td',
                                        queryParameters: {'notion': widget.notion})
                                    .toString());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.edit_note),
                              label: const Text('Les TD',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      
                      // Bouton d'animation 3D (visible sur les notions Ã©ligibles)
                      if (['mythe', 'Ã©tat', 'bien', 'conscience', 'art', 'temps', 'langage']
                          .any((k) => normalizedNotion.contains(k))) ...[
                        const SizedBox(height: 16),
                        Builder(
                          builder: (context) {
                            final tier = ref.watch(studentProvider).tier;
                            final isConfort = tier == SubscriptionTier.confort;
                            
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: isConfort ? () {
                                  context.push(Uri(
                                    path: '/myth-3d',
                                    queryParameters: {'notion': widget.notion},
                                  ).toString());
                                } : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ðŸ”’ Les animations 3D sont rÃ©servÃ©es au palier Confort.'),
                                      backgroundColor: Colors.orange,
                                    )
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isConfort ? Colors.purple.shade700 : Colors.grey.shade400,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: Icon(isConfort ? Icons.view_in_ar : Icons.lock),
                                label: Text(
                                  isConfort ? 'Voir l\'animation 3D' : 'Animation 3D (Palier Confort)',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          }
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      
                      // Bouton "Marquer comme terminÃ©"
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isRead ? null : _markAsRead,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isRead ? Colors.green : AppColors.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: Icon(_isRead ? Icons.check_circle : Icons.radio_button_unchecked),
                          label: Text(
                            _isRead ? 'Cours terminÃ© !' : 'Marquer comme terminÃ©',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
    );
  }

}

