import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class CourseViewerScreen extends StatelessWidget {
  final String notion;

  const CourseViewerScreen({Key? key, required this.notion}) : super(key: key);

  // Dictionnaire temporaire pour lier une notion à son fichier MD
  // À terme, ceci pourrait être géré par Supabase ou un provider.
  static const Map<String, String> courseAssets = {
    'Genèse de la philosophie : du mythe à la rationalité': 'assets/courses/genese_de_la_philosophie.md',
  };

  @override
  Widget build(BuildContext context) {
    final assetPath = courseAssets[notion];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          notion,
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: assetPath == null
          ? _buildEmptyState(context)
          : FutureBuilder<String>(
              future: DefaultAssetBundle.of(context).loadString(assetPath),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erreur lors du chargement du cours:\n${snapshot.error}'),
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
                          h1: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          h2: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold),
                          h3: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          p: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                          blockquote: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                          blockquoteDecoration: BoxDecoration(
                            border: Border(left: BorderSide(color: AppColors.accent, width: 4)),
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
                                context.push(Uri(path: '/quiz', queryParameters: {'notion': notion}).toString());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.quiz),
                              label: const Text('Le Quiz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.push(Uri(path: '/td', queryParameters: {'notion': notion}).toString());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.edit_note),
                              label: const Text('Les TD', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Le cours pour "$notion" n\'est pas encore disponible.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Retour'),
            )
          ],
        ),
      ),
    );
  }
}
