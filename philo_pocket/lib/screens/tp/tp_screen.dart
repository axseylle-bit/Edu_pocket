import 'package:flutter/material.dart';

class TpScreen extends StatelessWidget {
  const TpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travaux Pratiques (TP)'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Écran des Travaux Pratiques (TP) - Placeholder'),
      ),
    );
  }
}
