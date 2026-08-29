import 'package:flutter/material.dart';

class RapportDetailleScreen extends StatelessWidget {
  const RapportDetailleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rapport détaillé')),
      body: const Center(
        child: Text('Statistiques et Rapport Parent (À venir)'),
      ),
    );
  }
}
