class ProgrammeOfficiel {
  static Map<String, List<String>> getNotions(String niveau, String serie, int trimestre) {
    if (niveau == '1ere') {
      if (serie == 'A1' || serie == 'A2') {
        return _premiereA(trimestre);
      } else if (serie == 'B') {
        return _premiereB(trimestre);
      } else if (serie == 'S' || serie == 'C' || serie == 'D') {
        return _premiereS(trimestre);
      }
    } else if (niveau == 'Tle') {
      if (serie == 'A1' || serie == 'A2') {
        return _terminaleA(trimestre);
      } else if (serie == 'B') {
        return _terminaleB(trimestre);
      } else if (serie == 'C' || serie == 'D' || serie == 'S') {
        return _terminaleCD(trimestre);
      }
    }
    return {};
  }

  // --- PROGRAMMES PREMIERE ---

  static Map<String, List<String>> _premiereA(int trimestre) {
    switch (trimestre) {
      case 1:
        return {
          'Mythe et Philosophie': ['Genèse de la philosophie : du mythe à la rationalité'],
          'Quelques grands courants philosophiques': ['Le matérialisme, l\'idéalisme, l\'empirisme et le rationalisme'],
          'Méthodologie': ['Le sujet-question'],
          'Croyance et Savoir': [
            'La sorcellerie et le fétiche',
            'Le rêve et la réalité',
            'La foi et la raison'
          ],
          'Être et Pensée': [
            'La nature et l\'écologie',
            'L\'homme : l\'âme et le corps'
          ]
        };
      case 2:
        return {
          'Méthodologie': [
            'Étude de l\'œuvre et contrôle de lecture',
            'Le sujet-citation'
          ],
          'Le Monde et les Valeurs': [
            'La conscience et la dignité',
            'Le bien',
            'La coutume et le sacré',
            'La démocratie'
          ]
        };
      case 3:
        return {
          'Science et Vérité': [
            'La théorie',
            'L\'expérimentation',
            'La logique'
          ],
          'Méthodologie': [
            'Renforcement des acquis méthodologiques (sujet-question, sujet-citation et sujet-texte)',
            'Évaluation type bac'
          ]
        };
      default:
        return {};
    }
  }

  static Map<String, List<String>> _premiereB(int trimestre) {
    switch (trimestre) {
      case 1:
        return {
          'Mythe et Philosophie': ['Genèse de la philosophie : du mythe à la rationalité'],
          'Quelques grands courants philosophiques': ['Le matérialisme, l\'idéalisme, l\'empirisme et le rationalisme'],
          'Méthodologie': ['Le sujet-question'],
          'Croyance et Savoir': [
            'La sorcellerie et le fétiche',
            'Le rêve et la réalité'
          ],
          'Être et Pensée': [
            'La nature et l\'écologie',
            'L\'homme : l\'âme et le corps'
          ]
        };
      case 2:
        return {
          'Méthodologie': [
            'Étude de l\'œuvre et contrôle de lecture',
            'Le sujet-citation'
          ],
          'Le Monde et les Valeurs': [
            'La conscience et la dignité',
            'La coutume',
            'La démocratie'
          ]
        };
      case 3:
        return {
          'Science et Vérité': [
            'La théorie',
            'L\'expérimentation',
            'La logique'
          ],
          'Méthodologie': [
            'Renforcement des acquis méthodologiques (sujet-question, sujet-citation et sujet-texte)',
            'Évaluation type bac'
          ]
        };
      default:
        return {};
    }
  }

  static Map<String, List<String>> _premiereS(int trimestre) {
    switch (trimestre) {
      case 1:
        return {
          'Mythe et Philosophie': ['Genèse de la philosophie : du mythe à la rationalité'],
          'Quelques grands courants philosophiques': ['Le matérialisme, l\'idéalisme, l\'empirisme et le rationalisme'],
          'Croyance et Savoir': [
            'La sorcellerie',
            'Le rêve et la réalité'
          ],
          'Méthodologie': ['Le sujet-question'],
          'Être et Pensée': [
            'La nature et l\'écologie',
            'L\'homme : l\'âme et le corps'
          ]
        };
      case 2:
        return {
          'Méthodologie': [
            'Étude de l\'œuvre et contrôle de lecture',
            'Le sujet-citation'
          ],
          'Le Monde et les Valeurs': [
            'La conscience et la dignité',
            'La démocratie'
          ],
          'Science et Vérité': ['La théorie']
        };
      case 3:
        return {
          'Science et Vérité': [
            'L\'expérimentation',
            'La logique'
          ],
          'Méthodologie': [
            'Renforcement des acquis méthodologiques (sujet-question, sujet-citation et sujet-texte)',
            'Évaluation type bac'
          ]
        };
      default:
        return {};
    }
  }

  // --- PROGRAMMES TERMINALE ---

  static Map<String, List<String>> _terminaleA(int trimestre) {
    switch (trimestre) {
      case 1:
        return {
          'L\'Individu et la Société': [
            'La conscience et l\'inconscient',
            'Les passions',
            'Autrui',
            'L\'ethnie et la nation'
          ],
          'Méthodologie': ['Le sujet-question'],
          'Culture et Civilisation (Partie 1)': [
            'Le langage',
            'Les médias',
            'Le travail et les échanges'
          ],
          'Méthodologie ': [
            'Le sujet-citation',
            'Étude intégrale d\'une œuvre'
          ],
          'Culture et Civilisation (Partie 1) ': [
            'L\'art et la technique',
            'La religion'
          ],
          'Méthodologie  ': ['Le sujet-texte']
        };
      case 2:
        return {
          'Culture et Civilisation (Partie 2)': [
            'La tradition',
            'Le développement et le progrès'
          ],
          'Le Relatif et L\'Absolu': [
            'L\'existence et la mort',
            'Le temps et la mémoire',
            'L\'histoire'
          ],
          'Méthodologie   ': ['Étude d\'une œuvre en partie'],
          'La Raison et le Réel': [
            'La démonstration',
            'Les sciences de la matière',
            'Les sciences du vivant',
            'La vérité'
          ],
          'La Politique et la Morale (Partie 1)': [
            'L\'État et le droit',
            'La justice',
            'La citoyenneté'
          ]
        };
      case 3:
        return {
          'La Politique et la Morale (Partie 2)': [
            'La violence',
            'La liberté',
            'Le bonheur'
          ],
          'Méthodologie    ': ['La question au choix'],
          'Évaluations et Révisions': [
            'L\'épreuve orale au baccalauréat',
            'Les récapitulatifs de la préparation à l\'oral du bac',
            'Les révisions générales'
          ]
        };
      default:
        return {};
    }
  }

  static Map<String, List<String>> _terminaleB(int trimestre) {
    switch (trimestre) {
      case 1:
        return {
          'L\'Individu et la Société': [
            'La conscience et l\'inconscient',
            'Les passions',
            'Autrui',
            'L\'ethnie et la nation'
          ],
          'Méthodologie': ['Le sujet-question'],
          'Culture et Civilisation (Partie 1)': [
            'Le langage',
            'Les médias',
            'Le travail et les échanges'
          ],
          'Méthodologie ': ['Le sujet-citation'],
          'Culture et Civilisation (Partie 1) ': [
            'La technique',
            'La religion',
            'La tradition'
          ],
          'Méthodologie  ': ['Le sujet-texte']
        };
      case 2:
        return {
          'Culture et Civilisation (Partie 2)': [
            'Le développement et le progrès'
          ],
          'Le Relatif et L\'Absolu': [
            'L\'existence et la mort',
            'L\'histoire'
          ],
          'Méthodologie   ': ['Étude d\'une œuvre en partie'],
          'La Raison et le Réel': [
            'La démonstration',
            'Les sciences du vivant',
            'La vérité'
          ],
          'La Politique et la Morale (Partie 1)': [
            'L\'État',
            'La justice',
            'La citoyenneté'
          ]
        };
      case 3:
        return {
          'La Politique et la Morale (Partie 2)': [
            'La violence',
            'La liberté',
            'Le bonheur'
          ],
          'Méthodologie    ': ['La question au choix'],
          'Évaluations et Révisions': [
            'L\'épreuve orale au baccalauréat',
            'Les récapitulatifs de la préparation à l\'oral du bac',
            'Les révisions générales'
          ]
        };
      default:
        return {};
    }
  }

  static Map<String, List<String>> _terminaleCD(int trimestre) {
    switch (trimestre) {
      case 1:
        return {
          'L\'Individu et la Société': [
            'La conscience et l\'inconscient',
            'Les passions'
          ],
          'Méthodologie': ['Le sujet-question'],
          'L\'Individu et la Société ': [
            'Autrui',
            'L\'ethnie et la nation'
          ],
          'Méthodologie ': ['Le sujet-citation'],
          'Culture et Civilisation (Partie 1)': [
            'Le langage',
            'Le travail'
          ],
          'Méthodologie  ': ['Le sujet-texte']
        };
      case 2:
        return {
          'Culture et Civilisation (Partie 2)': [
            'La technique',
            'La religion',
            'La tradition'
          ],
          'Le Relatif et L\'Absolu': [
            'L\'existence et la mort',
            'Le temps et la mémoire'
          ],
          'Méthodologie   ': ['Étude d\'une œuvre en partie'],
          'La Raison et le Réel': [
            'La démonstration',
            'Les sciences de la matière',
            'Les sciences du vivant',
            'La vérité'
          ],
          'La Politique et la Morale (Partie 1)': [
            'L\'État'
          ]
        };
      case 3:
        return {
          'La Politique et la Morale (Partie 2)': [
            'La justice',
            'La citoyenneté',
            'La liberté'
          ],
          'Méthodologie    ': ['La question au choix'],
          'Évaluations et Révisions': [
            'L\'épreuve orale au baccalauréat',
            'Les récapitulatifs de la préparation à l\'oral du bac',
            'Les révisions générales'
          ]
        };
      default:
        return {};
    }
  }
}
