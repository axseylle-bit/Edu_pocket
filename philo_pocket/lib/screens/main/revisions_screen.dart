import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class RevisionsScreen extends StatelessWidget {
  const RevisionsScreen({super.key});

  static const _notions = [
    'Genèse de la philosophie : du mythe à la rationalité',
    'Le matérialisme, l\'idéalisme, l\'empirisme et le rationalisme',
    'La sorcellerie et le fétiche',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Révisions')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Choisissez une notion à réviser',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
              'Chaque quiz enregistre votre meilleur résultat sur cet appareil.'),
          const SizedBox(height: 20),
          ..._notions.map(
            (notion) => Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: Icon(Icons.quiz_rounded, color: AppColors.primary),
                ),
                title: Text(notion,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Lancer le quiz'),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                onTap: () => context.push(
                  Uri(path: '/quiz', queryParameters: {'notion': notion})
                      .toString(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
