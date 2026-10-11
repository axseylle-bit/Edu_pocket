enum SubscriptionTier {
  gratuit(
    name: 'Socrate (Gratuit)',
    description: 'Programme officiel & Quiz limités',
    level: 1,
    dbValue: 'socrate',
  ),
  essentiel(
    name: 'Platon (Essentiel)',
    description: 'Quiz illimités & Suivi détaillé',
    level: 2,
    dbValue: 'platon',
  ),
  confort(
    name: 'Aristote (Confort)',
    description: 'TP, Bac Blanc & ALECKSE Avancé',
    level: 3,
    dbValue: 'aristote',
  );

  final String name;
  final String description;
  final int level;
  final String dbValue;

  const SubscriptionTier({
    required this.name,
    required this.description,
    required this.level,
    required this.dbValue,
  });

  bool get canAccessTP => level >= 3;

  static SubscriptionTier fromDbValue(String? value) {
    final v = value?.toLowerCase().trim() ?? '';
    if (v.contains('confort') ||
        v.contains('aristote') ||
        v.contains('eiffel') ||
        v.contains('expert') ||
        v.contains('filiere') ||
        v.contains('trimestre') ||
        v.contains('annuel')) {
      return SubscriptionTier.confort;
    }
    if (v.contains('essentiel') ||
        v.contains('platon') ||
        v.contains('vinci') ||
        v.contains('solo') ||
        v.contains('premium') ||
        v.contains('technique_essentiel')) {
      return SubscriptionTier.essentiel;
    }
    return SubscriptionTier.gratuit;
  }
}
