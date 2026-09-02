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
      content: 'Commentez et discutez cette affirmation d\'Aristote : « Celui qui aime les mythes est en quelque sorte philosophe. »',
      methodologyId: 'methodologie_dissertation.md',
    ),
    const TdSubject(
      type: 'Sujet Texte',
      content: 'Dégager l\'intérêt philosophique du texte de Jean-Pierre Vernant (Texte 1) à partir de son étude ordonnée.',
      methodologyId: 'sujet_texte.md',
      extraContext: 'Rappel (Texte 1) : Le texte de Vernant explique que la raison grecque naît d\'une rupture avec la parole magique/mythique et d\'une laïcisation de la parole politique.',
    ),
  ],
};
