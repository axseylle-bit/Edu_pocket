import 'package:flutter/material.dart';

class CoursScreen extends StatelessWidget {
  const CoursScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reprendre le cours')),
      body: const Center(
        child: Text('Contenu du cours (À venir)'),
      ),
    );
  }
}
