import 'package:flutter/material.dart';

class CitationsScreen extends StatelessWidget {
  const CitationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Citations')),
      body: const Center(
        child: Text('Liste des Citations (À venir)'),
      ),
    );
  }
}
