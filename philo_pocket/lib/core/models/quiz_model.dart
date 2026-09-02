class QuizQuestion {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;

  const QuizQuestion({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
  });
}

// Quiz map by Notion
final Map<String, List<QuizQuestion>> quizzesByNotion = {
  'Genèse de la philosophie : du mythe à la rationalité': [
    const QuizQuestion(
      questionText: 'Selon la définition d\'André Lalande, quelle est la nature originelle du mythe ?',
      options: [
        'Une théorie scientifique démontrée',
        'Un récit fabuleux d\'origine populaire et non réfléchie',
        'Une doctrine philosophique rationnelle',
      ],
      correctOptionIndex: 1,
      explanation: 'Le mythe est un récit fabuleux qui personnifie les forces naturelles pour expliquer l\'univers de manière non réfléchie.',
    ),
    const QuizQuestion(
      questionText: 'Comment appelle-t-on la rupture brutale marquant le passage de la pensée mythique à la rationalité en Ionie ?',
      options: [
        'Le miracle grec',
        'Le mythe de la caverne',
        'La mutation allégorique',
      ],
      correctOptionIndex: 0,
      explanation: 'Le "miracle grec" désigne cette émergence soudaine de l\'exigence de rationalité, marquant la naissance de la philosophie.',
    ),
    const QuizQuestion(
      questionText: 'Quel philosophe antique s\'est beaucoup servi des mythes (comme outil pédagogique) tout en étant un pilier de la rationalité ?',
      options: [
        'Hésiode',
        'Platon',
        'Homère',
      ],
      correctOptionIndex: 1,
      explanation: 'Platon a abondamment utilisé le mythe (comme l\'allégorie de la caverne) pour illustrer ses concepts abstraits de manière pédagogique.',
    ),
    const QuizQuestion(
      questionText: 'Quelle est l\'une des fonctions principales du mythe pour les premières sociétés humaines ?',
      options: [
        'Exiger des démonstrations géométriques',
        'Sécuriser l\'existence face aux angoisses de l\'inconnu',
        'Favoriser le débat public sur l\'agora',
      ],
      correctOptionIndex: 1,
      explanation: 'Le mythe avait une fonction herméneutique (explicative) vitale pour apaiser l\'angoisse des premiers hommes face aux mystères de la nature.',
    ),
    const QuizQuestion(
      questionText: 'L\'émergence de la rationalité a-t-elle entraîné la disparition totale du mythe ?',
      options: [
        'Vrai',
        'Faux',
      ],
      correctOptionIndex: 1,
      explanation: 'Faux, le mythe subsiste au sein de la rationalité (outil pédagogique) et l\'homme moderne sécrète de nouveaux mythes.',
    ),
  ],
};
