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
      questionText:
          'Selon la définition d\'André Lalande, quelle est la nature originelle du mythe ?',
      options: [
        'Une théorie scientifique démontrée',
        'Un récit fabuleux d\'origine populaire et non réfléchie',
        'Une doctrine philosophique rationnelle',
      ],
      correctOptionIndex: 1,
      explanation:
          'Le mythe est un récit fabuleux qui personnifie les forces naturelles pour expliquer l\'univers de manière non réfléchie.',
    ),
    const QuizQuestion(
      questionText:
          'Comment appelle-t-on la rupture brutale marquant le passage de la pensée mythique à la rationalité en Ionie ?',
      options: [
        'Le miracle grec',
        'Le mythe de la caverne',
        'La mutation allégorique',
      ],
      correctOptionIndex: 0,
      explanation:
          'Le "miracle grec" désigne cette émergence soudaine de l\'exigence de rationalité, marquant la naissance de la philosophie.',
    ),
    const QuizQuestion(
      questionText:
          'Quel philosophe antique s\'est beaucoup servi des mythes (comme outil pédagogique) tout en étant un pilier de la rationalité ?',
      options: [
        'Hésiode',
        'Platon',
        'Homère',
      ],
      correctOptionIndex: 1,
      explanation:
          'Platon a abondamment utilisé le mythe (comme l\'allégorie de la caverne) pour illustrer ses concepts abstraits de manière pédagogique.',
    ),
    const QuizQuestion(
      questionText:
          'Quelle est l\'une des fonctions principales du mythe pour les premières sociétés humaines ?',
      options: [
        'Exiger des démonstrations géométriques',
        'Sécuriser l\'existence face aux angoisses de l\'inconnu',
        'Favoriser le débat public sur l\'agora',
      ],
      correctOptionIndex: 1,
      explanation:
          'Le mythe avait une fonction herméneutique (explicative) vitale pour apaiser l\'angoisse des premiers hommes face aux mystères de la nature.',
    ),
    const QuizQuestion(
      questionText:
          'L\'émergence de la rationalité a-t-elle entraîné la disparition totale du mythe ?',
      options: [
        'Vrai',
        'Faux',
      ],
      correctOptionIndex: 1,
      explanation:
          'Faux, le mythe subsiste au sein de la rationalité (outil pédagogique) et l\'homme moderne sécrète de nouveaux mythes.',
    ),
  ],
  'Le matérialisme, l\'idéalisme, l\'empirisme et le rationalisme': [
    const QuizQuestion(
      questionText:
          'Selon l\'empirisme de John Locke, à quoi ressemble l\'esprit humain à la naissance ?',
      options: [
        'À un intellect rempli d\'idées innées',
        'À un logiciel déjà programmé',
        'À une "table rase" vierge de toute idée',
      ],
      correctOptionIndex: 2,
      explanation:
          'Locke soutient que l\'esprit est une "tabula rasa" que seule l\'expérience vient remplir.',
    ),
    const QuizQuestion(
      questionText:
          'Quel grand courant s\'oppose directement à l\'Idéalisme sur la définition de ce qui constitue la réalité ?',
      options: [
        'Le Rationalisme',
        'Le Matérialisme',
        'L\'Empirisme',
      ],
      correctOptionIndex: 1,
      explanation:
          'L\'idéalisme postule la primauté de l\'Idée ou de l\'esprit, tandis que le matérialisme affirme que seule la matière existe indépendamment.',
    ),
    const QuizQuestion(
      questionText:
          'La démarche de Descartes dans le Discours de la méthode, rejetant les sens au profit de la déduction logique, illustre quelle doctrine ?',
      options: [
        'Le Rationalisme',
        'L\'Empirisme',
        'Le Matérialisme',
      ],
      correctOptionIndex: 0,
      explanation:
          'Descartes est la figure de proue du rationalisme, car il doute des sens pour s\'appuyer uniquement sur la raison et la logique (le Cogito).',
    ),
    const QuizQuestion(
      questionText:
          'Quelle est la démarche d\'Emmanuel Kant face au débat entre l\'empirisme et le rationalisme ?',
      options: [
        'Il rejette les deux pour créer le matérialisme',
        'Il affirme que l\'expérience seule suffit',
        'Il réalise une synthèse (criticisme) en montrant que l\'intuition sensible et le concept rationnel sont tous deux nécessaires',
      ],
      correctOptionIndex: 2,
      explanation:
          'Le criticisme de Kant démontre que "Des pensées sans contenu sont vides, des intuitions sans concepts, aveugles". Il allie ainsi expérience et raison.',
    ),
    const QuizQuestion(
      questionText:
          'Vrai ou Faux : Pour un matérialiste comme Karl Marx, les idées et la conscience des hommes sont produites par les conditions matérielles et économiques de leur vie.',
      options: [
        'Vrai',
        'Faux',
      ],
      correctOptionIndex: 0,
      explanation:
          'Karl Marx a développé le matérialisme historique, affirmant que c\'est l\'existence sociale et matérielle qui détermine la conscience.',
    ),
  ],
  'La sorcellerie et le fétiche': [
    const QuizQuestion(
      questionText:
          'Dans la conscience traditionnelle, par quoi la pérennité de la sorcellerie est-elle justifiée ?',
      options: [
        'Par des équations mathématiques',
        'Par les "fruits" et l\'efficacité empirique qu\'elle semble produire',
        'Par des décrets politiques',
      ],
      correctOptionIndex: 1,
      explanation:
          'Pour la conscience populaire, le fait que la pratique perdure et produise des résultats concrets (punir, protéger, guérir) justifie sa réalité.',
    ),
    const QuizQuestion(
      questionText:
          'Du point de vue rationaliste, croire qu\'un objet physique possède des pouvoirs magiques est considéré comme :',
      options: [
        'Une preuve empirique irréfutable',
        'Une illusion et un obstacle épistémologique',
        'Une vérité démontrée',
      ],
      correctOptionIndex: 1,
      explanation:
          'La rationalité considère que prêter des pouvoirs à la matière est illogique et empêche de rechercher les véritables causes d\'un mal (ex: causes médicales).',
    ),
    const QuizQuestion(
      questionText:
          'Selon Spinoza (Texte 1), à quoi recourt l\'homme superstitieux face à un événement qu\'il ne comprend pas ?',
      options: [
        'À la méthode expérimentale',
        'À "l\'asile de l\'ignorance" (la volonté occulte ou divine)',
        'Aux lois de la gravité',
      ],
      correctOptionIndex: 1,
      explanation:
          'Spinoza dénonce l\'utilisation de la "volonté divine" ou des forces occultes comme une solution de facilité qui masque simplement l\'ignorance humaine.',
    ),
    const QuizQuestion(
      questionText:
          'Qu\'appelle-t-on "l\'efficacité symbolique" de la magie selon Lévi-Strauss ?',
      options: [
        'La capacité du sorcier à violer les lois de la physique matérielle',
        'L\'impact psychologique et thérapeutique produit par la conviction partagée du groupe',
        'L\'art de fabriquer des amulettes en bois',
      ],
      correctOptionIndex: 1,
      explanation:
          'C\'est la croyance profonde du malade et de la société qui donne son efficacité au rite magique, produisant souvent un effet curatif réel (placebo).',
    ),
    const QuizQuestion(
      questionText:
          'Vrai ou Faux : Meinrad Hebga rejette catégoriquement tout témoignage empirique attestant des effets de la sorcellerie.',
      options: [
        'Vrai',
        'Faux',
      ],
      correctOptionIndex: 1,
      explanation:
          'Faux, le philosophe Meinrad Hebga soutient au contraire que la sorcellerie est une réalité vécue dont l\'efficacité se fait sentir dans certaines sociétés.',
    ),
  ],
};
