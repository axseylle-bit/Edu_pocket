import 'package:flutter_test/flutter_test.dart';
import 'package:philo_pocket/core/models/quiz_model.dart';

void main() {
  test('every quiz question has a valid correct answer index', () {
    for (final entry in quizzesByNotion.entries) {
      expect(entry.value, isNotEmpty, reason: 'Quiz absent pour ${entry.key}');
      for (final question in entry.value) {
        expect(question.options, isNotEmpty);
        expect(
          question.correctOptionIndex,
          inInclusiveRange(0, question.options.length - 1),
        );
      }
    }
  });
}
