import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/constants/app_colors.dart';

class LegalDocumentViewerScreen extends StatelessWidget {
  final String title;
  final String assetPath;

  const LegalDocumentViewerScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  static void show(BuildContext context, {required String title, required String assetPath}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => LegalDocumentViewerScreen(
          title: title,
          assetPath: assetPath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: rootBundle.loadString(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Erreur lors du chargement du document légal.\n${snapshot.error ?? ""}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          return Markdown(
            data: snapshot.data!,
            padding: const EdgeInsets.all(20.0),
            selectable: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              h1: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              h2: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              h3: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
              p: const TextStyle(fontSize: 14, height: 1.5),
            ),
          );
        },
      ),
    );
  }
}
