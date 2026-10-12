import 'package:flutter/services.dart' show rootBundle;
import 'package:supabase_flutter/supabase_flutter.dart';

class AiService {
  String _systemInstruction = "";
  List<Map<String, dynamic>> _chatHistory = [];
  bool _isInitialized = false;

  // Initialisation du modèle (on prépare juste les instructions)
  Future<void> init(String? methodologyId, String? contextText,
      {String? initialModelMessage}) async {
    
    // Chargement de la méthodologie (le system prompt)
    String systemInstruction =
        "Tu es ALECKSE, une professeure virtuelle de philosophie gabonaise, stricte sur le fond et bienveillante sur la forme. "
        "RÈGLE ABSOLUE ET INVIOLABLE : Tu dois STRICTEMENT te limiter au programme de philosophie du Gabon (classes de Première et Terminale). "
        "Si l'utilisateur te pose une question hors sujet (mathématiques, blagues, code, culture générale non philosophique, etc.), "
        "tu DOIS REFUSER poliment mais fermement de répondre, en lui rappelant avec fermeté que tu es une professeure de philosophie et que ton seul but est de préparer son baccalauréat. "
        "Tu tutoyeras l'élève et l'encourageras à réfléchir par lui-même. Ne lui donne jamais les réponses toutes faites, mais guide-le pas à pas. "
        "Pour les exercices (TD), tu dois STRICTEMENT suivre les étapes de la méthodologie une par une sans donner la correction complète d'un coup.";

    if (methodologyId != null && methodologyId.isNotEmpty) {
      try {
        final methodologyText =
            await rootBundle.loadString('assets/methodologie/$methodologyId');
        systemInstruction +=
            "\n\nVoici la méthodologie officielle (IPN) que tu dois utiliser pour corriger et guider l'élève :\n\n$methodologyText";
      } catch (e) {
        print("Erreur de chargement de la méthodologie: $e");
      }
    }

    if (contextText != null && contextText.isNotEmpty) {
      systemInstruction +=
          "\n\nContexte supplémentaire de l'exercice : $contextText";
    }

    _systemInstruction = systemInstruction;
    _chatHistory = [];

    if (initialModelMessage != null && initialModelMessage.isNotEmpty) {
      _chatHistory.add({
        "role": "model",
        "parts": [{"text": initialModelMessage}]
      });
    }

    _isInitialized = true;
  }

  DateTime? _lastMessageTime;

  // Envoi d'un message à l'IA via la Supabase Edge Function
  Future<String?> sendMessage(String message) async {
    if (!_isInitialized) {
      throw Exception("L'IA n'est pas initialisée.");
    }

    // Protection anti-flood / rate-limiting (au moins 1.5s entre chaque question)
    if (_lastMessageTime != null) {
      final diff = DateTime.now().difference(_lastMessageTime!);
      if (diff.inMilliseconds < 1500) {
        return "Un instant, je termine d'analyser ta réflexion précédente avant de te répondre ! Prends le temps de bien relire tes arguments.";
      }
    }
    _lastMessageTime = DateTime.now();

    _chatHistory.add({
      "role": "user",
      "parts": [{"text": message}]
    });

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'chat-gemini',
        body: {
          "contents": _chatHistory,
          "systemInstruction": _systemInstruction,
          "model": "gemini-1.5-flash-latest"
        },
      );

      if (response.status == 200) {
        final reply = response.data['reply'] as String;
        _chatHistory.add({
          "role": "model",
          "parts": [{"text": reply}]
        });
        return reply;
      } else {
        throw Exception("Erreur Edge Function: ${response.status}");
      }
    } catch (e) {
      print("Erreur lors de l'appel à la fonction Supabase Edge : $e");
      // Retirer le message utilisateur de l'historique en cas d'échec
      if (_chatHistory.isNotEmpty) {
        _chatHistory.removeLast();
      }
      final errStr = e.toString().toLowerCase();
      if (errStr.contains('socket') || errStr.contains('connection') || errStr.contains('network') || errStr.contains('host')) {
        return "Connexion temporairement instable. Vérifie tes données mobiles (Airtel ou Moov) ou ton Wi-Fi et réessaie dans un instant.";
      }
      return "ALECKSE est momentanément indisponible pour des raisons de maintenance. Réessaie dans quelques instants.";
    }
  }

  // Fonction spécifique pour corriger les copies avec la méthode IPN via Edge Function
  Future<String?> gradeStudentCopy(String studentCopy, String exerciseType) async {
    
    // 1. On charge la grille d'évaluation IPN
    String grilleText = "";
    try {
      grilleText = await rootBundle
          .loadString('assets/ipn/grille_evaluation_placeholder.md');
    } catch (e) {
      print("Erreur chargement grille: $e");
      grilleText = "Grille de notation standard (sur 20)...";
    }

    // 2. On charge la méthodologie IPN en fonction du type d'exercice
    String methodeText = "";
    String methodePath = exerciseType == 'Dissertation' 
        ? 'assets/methodologie/methodologie_dissertation.md' 
        : 'assets/methodologie/sujet_texte.md';
    try {
      methodeText = await rootBundle.loadString(methodePath);
    } catch (e) {
      print("Erreur chargement methodologie: $e");
    }

    String promptCorrecteur = """
Tu es un enseignant de philosophie expérimenté. Pour corriger et évaluer les copies de tes élèves, tu t'appuies rigoureusement sur les documents officiels de l'Inspection Pédagogique Nationale (IPN).

Voici la copie d'un élève. Le type d'exercice est : $exerciseType. 
Ton rôle est de l'évaluer de manière juste, pédagogique et constructive, en t'appuyant EXCLUSIVEMENT sur la méthodologie officielle et la grille fournies ci-dessous.

ATTENTION MÉTHODOLOGIQUE MAJEURE : Vérifie systématiquement que l'élève a bien respecté les étapes décrites dans le document [MÉTHODOLOGIE OFFICIELLE IPN]. 
Rappel important pour la dissertation : En philosophie (selon l'IPN), on n'annonce JAMAIS explicitement le plan dans l'introduction. Si l'élève le fait, sanctionne-le comme erreur méthodologique.

Pour structurer ton retour, fournis ta réponse sous le format suivant :

1. "Analyse par partie" : 
   - Introduction : Évalue le respect des étapes méthodologiques de l'introduction (amorce, problème, problématique).
   - Développement : Évalue la pertinence des arguments, l'utilisation des concepts, les références et la fluidité des transitions.
   - Conclusion : Évalue le bilan de la réflexion.

2. "Détail de l'évaluation (Points)" : Une ventilation des points attribués pour chaque grand critère de la grille IPN, en justifiant brièvement.

3. "Note globale et Appréciation générale" : La note sur 20 accompagnée d'un commentaire pédagogique global.

4. "Axes d'amélioration" : 2 ou 3 conseils pratiques et très précis.

---
[MÉTHODOLOGIE OFFICIELLE IPN ($exerciseType)]
$methodeText
---
[GRILLE DE NOTATION IPN]
$grilleText
""";

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'chat-gemini',
        body: {
          "contents": [
            {
              "role": "user",
              "parts": [{"text": "Voici la copie de l'élève à corriger :\n\n$studentCopy"}]
            }
          ],
          "systemInstruction": promptCorrecteur,
          "model": "gemini-1.5-pro-latest"
        },
      );

      if (response.status == 200) {
        return response.data['reply'] as String;
      } else {
        throw Exception("Erreur Edge Function: ${response.status}");
      }
    } catch (e) {
      print("Erreur lors de la correction (Edge Function) : $e");
      throw Exception("Impossible de corriger la copie via le serveur sécurisé : $e");
    }
  }

  // Fonction pour générer un corrigé type ou analyser un sujet via Edge Function
  Future<String?> prepareExam(String subject, String exerciseType) async {
    
    String methodeText = "";
    String methodePath = exerciseType == 'Dissertation' 
        ? 'assets/methodologie/methodologie_dissertation.md' 
        : 'assets/methodologie/sujet_texte.md';
    try {
      methodeText = await rootBundle.loadString(methodePath);
    } catch (e) {
      print("Erreur chargement methodologie: $e");
    }

    String promptPreparation = """
Tu es un enseignant de philosophie expérimenté au Gabon. Ton rôle est de préparer le corrigé-type et l'analyse d'un sujet d'examen pour tes élèves, en te basant sur la méthodologie officielle de l'IPN.

Le type d'exercice est : $exerciseType.

Veuillez structurer l'analyse du sujet de la façon suivante :
1. "Analyse du sujet et Problématisation" : Définition des termes clés, paradoxe ou tension soulevée par le sujet, et formulation d'une problématique claire.
2. "Plan détaillé (Proposition de corrigé)" : Les grands axes de réflexion (Parties et sous-parties) avec les arguments principaux et les concepts philosophiques à mobiliser.
3. "Pièges à éviter" : Ce que les élèves risquent de faire comme hors-sujet ou erreur méthodologique.

Rappel méthodologique : respecte la démarche imposée par le document ci-dessous.
---
[MÉTHODOLOGIE OFFICIELLE IPN ($exerciseType)]
$methodeText
""";

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'chat-gemini',
        body: {
          "contents": [
            {
              "role": "user",
              "parts": [{"text": "Voici le sujet de l'épreuve à préparer :\n\n$subject"}]
            }
          ],
          "systemInstruction": promptPreparation,
          "model": "gemini-1.5-pro-latest"
        },
      );

      if (response.status == 200) {
        return response.data['reply'] as String;
      } else {
        throw Exception("Erreur Edge Function: ${response.status}");
      }
    } catch (e) {
      print("Erreur lors de la préparation (Edge Function) : $e");
      throw Exception("Impossible de préparer le corrigé via le serveur sécurisé : $e");
    }
  }
}
