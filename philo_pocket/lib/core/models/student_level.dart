enum SubscriptionTier {
  gratuit(
    name: 'Socrate (Gratuit)',
    description: 'Programme officiel & Quiz limités',
    level: 1,
  ),
  essentiel(
    name: 'Platon (Essentiel)',
    description: 'Quiz illimités & Suivi détaillé',
    level: 2,
  ),
  confort(
    name: 'Aristote (Confort)',
    description: 'TP, Bac Blanc & ALECKSE Avancé',
    level: 3,
  );

  final String name;
  final String description;
  final int level;

  const SubscriptionTier({
    required this.name,
    required this.description,
    required this.level,
  });

  bool get canAccessTP => level >= 3;
}
