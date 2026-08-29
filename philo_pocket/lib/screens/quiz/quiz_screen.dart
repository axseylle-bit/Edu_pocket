import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('S\'entraîner (Quiz)')),
      body: const Center(
        child: Text('Module de Quiz (À venir)'),
      ),
    );
  }
}
