class NotionPrompts {
  static const Map<String, String> prompts = {
    'Genèse de la philosophie : du mythe à la rationalité':
        "Rappelle la transition entre la pensée mythique (croyances, dieux, cosmogonies) et la pensée rationnelle (Logos, Thalès, Socrate). Insiste sur l'étonnement (Platon, Aristote) comme point de départ de la philosophie.",
    'La conscience et l\'inconscient':
        "Insiste sur le Cogito de Descartes (la conscience comme certitude et grandeur) et oppose-le à l'hypothèse de l'inconscient de Freud (l'appareil psychique : le Ça, le Moi, le Surmoi). Parle des manifestations de l'inconscient (rêves, lapsus, actes manqués).",
    'Les passions':
        "Oppose la conception classique qui dévalorise la passion comme une 'maladie de l\'âme' (Kant, Descartes) à la conception positive (Hegel) qui fait de la passion le moteur des grandes actions humaines et de l'Histoire.",
    'Autrui':
        "Montre que l'existence d'autrui est indispensable à la conscience de soi (Sartre, Hegel avec la dialectique du maître et de l'esclave). Aborde les difficultés de la relation à l'autre (le conflit, l'enfer c'est les autres) et la possibilité de la sympathie.",
    'L\'ethnie et la nation':
        "Distingue l'ethnie (liens de sang, culture) de la nation (volonté de vivre ensemble, contrat social). Discute des dangers de l'ethnocentrisme et du tribalisme en Afrique, et de l'importance de l'unité nationale.",
    'Le langage':
        "Souligne la différence entre le langage humain (symbolique et articulé) et la communication animale (signal). Discute du rapport entre pensée et langage (sont-ils indissociables ? Bergson vs Hegel/Boileau).",
    'L\'État':
        "Aborde l'origine de l'État (le contrat social chez Hobbes, Locke, Rousseau) et son rôle (garantir la sécurité et la liberté). Mentionne le monopole de la violence légitime (Max Weber) et la critique marxiste de l'État comme outil d'oppression.",
    'La vérité':
        "Distingue la vérité formelle de la vérité matérielle. Aborde le problème de l'erreur, des illusions, et le scepticisme. Parle des critères de vérité (l'évidence cartésienne, la vérification expérimentale).",
    'La religion':
        "Définis la religion par le sacré et le profane (Mircea Eliade). Oppose l'approche théologique à l'approche critique (Marx, Freud) qui voit la religion comme l'opium du peuple ou une illusion.",
    'La liberté':
        "Distingue le libre arbitre (Descartes) du déterminisme (Spinoza). Montre que la liberté n'est pas faire ce qu'on veut, mais obéir à la loi qu'on s'est prescrite (Rousseau) ou agir par devoir (Kant).",
    'Le bonheur':
        "Oppose les conceptions épicuriennes (calcul des plaisirs) au stoïcisme (maîtrise des désirs). Aborde la difficulté d'atteindre le bonheur (idéal de l'imagination selon Kant) et le rapport entre bonheur et devoir moral.",
  };

  static String getPromptForNotion(String? notion) {
    if (notion == null || !prompts.containsKey(notion)) {
      return "Guide l'élève sur cette notion du programme de philosophie en l'aidant à problématiser et à structurer sa réflexion.";
    }
    return prompts[notion]!;
  }
}
