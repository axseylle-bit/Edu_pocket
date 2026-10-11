import 'package:flutter/material.dart';
import '../../core/models/quiz_model.dart';
import '../../core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/supabase_service.dart';

class QuizScreen extends StatefulWidget {
  final String? notion;

  const QuizScreen({Key? key, this.notion}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  int? _selectedOptionIndex;

  List<QuizQuestion> _getQuestions() {
    if (widget.notion != null && quizzesByNotion.containsKey(widget.notion)) {
      return quizzesByNotion[widget.notion]!;
    }
    // Fallback si la notion n'a pas de quiz ou n'est pas fournie
    if (quizzesByNotion.isNotEmpty) {
      return quizzesByNotion.values.first;
    }
    return [];
  }

  void _submitAnswer(int index, List<QuizQuestion> questions) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      _selectedOptionIndex = index;

      if (index == questions[_currentQuestionIndex].correctOptionIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion(List<QuizQuestion> questions) {
    setState(() {
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedOptionIndex = null;
      } else {
        if (widget.notion != null) {
          SupabaseService().saveQuizScore(widget.notion!, _score, questions.length);
        }
        _showResults(questions);
      }
    });
  }

  void _showResults(List<QuizQuestion> questions) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Terminé !', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 64),
            const SizedBox(height: 16),
            Text(
              'Votre score : $_score / ${questions.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Ferme la dialog
              if (widget.notion != null) {
                context.pop(); // Retour au cours si on vient du cours
              } else {
                context.go('/main'); // Retour au dashboard sinon
              }
            },
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }

  Color _getOptionColor(int index, int correctIndex) {
    if (!_isAnswered) return Colors.white;
    if (index == correctIndex) return Colors.green.shade100;
    if (index == _selectedOptionIndex && index != correctIndex)
      return Colors.red.shade100;
    return Colors.white;
  }

  Color _getOptionBorderColor(int index, int correctIndex) {
    if (!_isAnswered) return Colors.grey.shade300;
    if (index == correctIndex) return Colors.green;
    if (index == _selectedOptionIndex && index != correctIndex)
      return Colors.red;
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    final questions = _getQuestions();

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(
            child: Text('Aucun quiz disponible pour cette notion.')),
      );
    }

    final question = questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Question ${_currentQuestionIndex + 1}/${questions.length}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48.0), // -48 for padding
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        question.questionText,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ...List.generate(question.options.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: InkWell(
                            onTap: () => _submitAnswer(index, questions),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getOptionColor(
                                    index, question.correctOptionIndex),
                                border: Border.all(
                                  color: _getOptionBorderColor(
                                      index, question.correctOptionIndex),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                question.options[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      }),
                      const Spacer(),
                      if (_isAnswered) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Explication',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(question.explanation,
                                  style:
                                      const TextStyle(color: Colors.black87)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _nextQuestion(questions),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            _currentQuestionIndex < questions.length - 1
                                ? 'Question suivante'
                                : 'Voir les résultats',
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
