class TdSubject {
  final String type;
  final String content;
  final String? extraContext;
  final String methodologyId;

  const TdSubject({
    required this.type,
    required this.content,
    required this.methodologyId,
    this.extraContext,
  });
}

// Map liant les notions à leurs exercices de TD (Travaux Dirigés)
final Map<String, List<TdSubject>> tdsByNotion = {
  'Genèse de la philosophie : du mythe à la rationalité': [
    const TdSubject(
      type: 'Sujet Question',
      content: 'La philosophie marque-t-elle la ruine de la pensée mythique ?',
      methodologyId: 'methodologie_dissertation.md',
    ),
    const TdSubject(
      type: 'Sujet Citation',
      content:
          'Commentez et discutez cette affirmation d\'Aristote : « Celui qui aime les mythes est en quelque sorte philosophe. »',
      methodologyId: 'methodologie_dissertation.md',
    ),
    const TdSubject(
      type: 'Sujet Texte',
      content:
          'Dégager l\'intérêt philosophique du texte de Jean-Pierre Vernant (Texte 1) à partir de son étude ordonnée.',
      methodologyId: 'sujet_texte.md',
      extraContext:
          'Rappel (Texte 1) : Le texte de Vernant explique que la raison grecque naît d\'une rupture avec la parole magique/mythique et d\'une laïcisation de la parole politique.',
    ),
  ],
  'Le matérialisme, l\'idéalisme, l\'empirisme et le rationalisme': [
    const TdSubject(
      type: 'Sujet Question',
      content:
          'L\'expérience est-elle la seule et unique source de nos connaissances ?',
      methodologyId: 'methodologie_dissertation.md',
    ),
    const TdSubject(
      type: 'Sujet Citation',
      content:
          'Discutez cette affirmation de Karl Marx : « Ce n\'est pas la conscience des hommes qui détermine leur existence, c\'est au contraire leur existence sociale qui détermine leur conscience. »',
      methodologyId: 'methodologie_dissertation.md',
    ),
    const TdSubject(
      type: 'Sujet Texte',
      content:
          'Dégager l\'intérêt philosophique du texte de René Descartes (Texte 1) à partir de son étude ordonnée.',
      methodologyId: 'sujet_texte.md',
      extraContext:
          'Rappel (Texte 1) : Descartes y applique le doute méthodique, rejetant les sens trompeurs pour trouver une vérité purement rationnelle indubitable (le Je pense, donc je suis).',
    ),
  ],
  'La sorcellerie et le fétiche': [
    const TdSubject(
      type: 'Sujet Question',
      content:
          'Le fétiche est-il la preuve matérielle de l\'existence de la sorcellerie ?',
      methodologyId: 'methodologie_dissertation.md',
    ),
    const TdSubject(
      type: 'Sujet Citation',
      content:
          'Discutez cette affirmation de Spinoza : « Recourir aux causes occultes, c\'est se réfugier dans l\'asile de l\'ignorance. »',
      methodologyId: 'methodologie_dissertation.md',
    ),
    const TdSubject(
      type: 'Sujet Texte',
      content:
          'Dégager l\'intérêt philosophique du texte de Claude Lévi-Strauss (Texte 2) à partir de son étude ordonnée.',
      methodologyId: 'sujet_texte.md',
      extraContext:
          'Rappel (Texte 2) : Lévi-Strauss soutient que l\'efficacité de la magie repose sur la croyance psychologique et sociale partagée, ce qu\'il nomme l\'efficacité symbolique.',
    ),
  ],
};
