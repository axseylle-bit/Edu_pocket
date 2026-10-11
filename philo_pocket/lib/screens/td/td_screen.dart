import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/td_model.dart';
import '../../core/constants/app_colors.dart';

class TdScreen extends StatelessWidget {
  final String? notion;

  const TdScreen({Key? key, this.notion}) : super(key: key);

  List<TdSubject> _getSubjects() {
    if (notion != null && tdsByNotion.containsKey(notion)) {
      return tdsByNotion[notion]!;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final subjects = _getSubjects();

    return Scaffold(
      appBar: AppBar(
        title: Text(notion ?? 'Travaux Dirigés (TD)',
            maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: subjects.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit_note,
                        size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'Veuillez sélectionner un cours pour accéder à ses exercices d\'approfondissement.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            subject.type,
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          subject.content,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        if (subject.extraContext != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey.shade400, width: 4)),
                            ),
                            child: Text(
                              subject.extraContext!,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.push(Uri(path: '/chat', queryParameters: {
                                'mode': 'td',
                                'notion': notion,
                                'subject': subject.content,
                                'type': subject.type,
                                'methodologyId': subject.methodologyId,
                              }).toString());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.smart_toy),
                            label: const Text('S\'entraîner avec ALECKSE'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
