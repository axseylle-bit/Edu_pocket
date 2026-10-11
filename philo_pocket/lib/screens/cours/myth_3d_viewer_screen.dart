import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:go_router/go_router.dart';

class Myth3DViewerScreen extends StatelessWidget {
  final String notion;

  const Myth3DViewerScreen({Key? key, required this.notion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // URL temporaire pour la démonstration. 
    // À l'avenir, tu pourras charger tes propres modèles .glb depuis tes assets ou Supabase.
    const String defaultModelUrl =
        'https://modelviewer.dev/shared-assets/models/Astronaut.glb';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Animation 3D Interactive', style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.black87,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ]
            ),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  'Le Mythe de la Caverne',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '💡 Ceci est une démonstration technique.\nFais glisser ton doigt pour faire pivoter le modèle. Pince pour zoomer.',
                  style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.white.withOpacity(0.8)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const Expanded(
            child: ModelViewer(
              backgroundColor: Colors.black87,
              src: defaultModelUrl,
              alt: "Modèle 3D interactif",
              ar: true,
              autoRotate: true,
              cameraControls: true,
              disableZoom: false,
            ),
          ),
        ],
      ),
    );
  }
}
