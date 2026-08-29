import 'package:flutter/material.dart';

class TdScreen extends StatelessWidget {
  const TdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À revoir (TD)')),
      body: const Center(
        child: Text('Travaux Dirigés (À venir)'),
      ),
    );
  }
}
