import 'package:flutter/services.dart' show rootBundle;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  late GenerativeModel _model;
  late ChatSession _chatSession;
  bool _isInitialized = false;

  // Initialisation du modèle avec la clé API
  Future<void> init(String? methodologyId, String? contextText) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || apiKey == 'votre_cle_api_ici') {
      throw Exception('Clé API Gemini introuvable. Veuillez configurer le fichier .env.');
    }

    // Chargement de la méthodologie (le system prompt)
    String systemInstruction = "Tu es ALECKSE, une professeure virtuelle de philosophie gabonaise, stricte sur le fond et bienveillante sur la forme. Tu tutoyeras l'élève et l'encourageras à réfléchir par lui-même. Ne lui donne jamais les réponses toutes faites, mais guide-le étape par étape.";
    
    if (methodologyId != null && methodologyId.isNotEmpty) {
      try {
        final methodologyText = await rootBundle.loadString('assets/methodologie/$methodologyId');
        systemInstruction += "\n\nVoici la méthodologie officielle (IPN) que tu dois utiliser pour corriger et guider l'élève :\n\n$methodologyText";
      } catch (e) {
        print("Erreur de chargement de la méthodologie: $e");
      }
    }

    if (contextText != null && contextText.isNotEmpty) {
      systemInstruction += "\n\nContexte supplémentaire de l'exercice : $contextText";
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        temperature: 0.7,
      ),
    );

    _chatSession = _model.startChat();
    _isInitialized = true;
  }

  // Envoi d'un message à l'IA
  Future<String?> sendMessage(String message) async {
    if (!_isInitialized) {
      throw Exception("L'IA n'est pas initialisée.");
    }
    
    try {
      final response = await _chatSession.sendMessage(Content.text(message));
      return response.text;
    } catch (e) {
      print("Erreur lors de l'appel à Gemini : $e");
      return "Désolé, je rencontre un problème de connexion avec mon cerveau artificiel.\n\nErreur technique détaillée pour qu'on puisse corriger : $e";
    }
  }
}
