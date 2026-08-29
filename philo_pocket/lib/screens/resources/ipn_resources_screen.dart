import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class IpnResourcesScreen extends StatelessWidget {
  const IpnResourcesScreen({Key? key}) : super(key: key);

  // Pour l'instant, nous listons les fichiers locaux en dur.
  // Une fois Supabase configuré, cette liste proviendra de la base de données.
  final List<Map<String, String>> _documents = const [
    {
      'title': 'L\'Épreuve Orale de Philosophie',
      'path': 'assets/ipn/epreuve_orale_philosophie.pdf',
    },
    {
      'title': 'Méthodologies Nationales',
      'path': 'assets/ipn/methodologies_nationales_philosophie.pdf',
    },
    {
      'title': 'Progressions Nationales 2025-2026',
      'path': 'assets/ipn/progressions_nationales.pdf',
    },
    {
      'title': 'Grilles d\'Évaluation',
      'path': 'assets/ipn/grilles_evaluation_philosophie.pdf',
    },
    {
      'title': 'Critères d\'Élaboration',
      'path': 'assets/ipn/criteres_elaboration_epreuves.pdf',
    },
    {
      'title': 'Étude d\'une Œuvre',
      'path': 'assets/ipn/etude_oeuvre_philosophique.pdf',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ressources IPN')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _documents.length,
        itemBuilder: (context, index) {
          final doc = _documents[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
              title: Text(doc['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(
                      title: doc['title']!,
                      pdfPath: doc['path']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String pdfPath;

  const PdfViewerScreen({
    Key? key,
    required this.title,
    required this.pdfPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.asset(pdfPath),
    );
  }
}
