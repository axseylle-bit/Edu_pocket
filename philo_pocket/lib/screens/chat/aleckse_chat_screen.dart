import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/ai_service.dart';
import '../../core/constants/notion_prompts.dart';

class AleckseChatScreen extends StatefulWidget {
  final String? mode;
  final String? notion;
  final String? subject;
  final String? type;
  final String? methodologyId;

  const AleckseChatScreen({
    Key? key,
    this.mode,
    this.notion,
    this.subject,
    this.type,
    this.methodologyId,
  }) : super(key: key);

  @override
  State<AleckseChatScreen> createState() => _AleckseChatScreenState();
}

class _AleckseChatScreenState extends State<AleckseChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final AiService _aiService = AiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final initialMsg = _initChat();
    _initAi(initialMsg);
  }

  Future<void> _initAi(String initialMessage) async {
    String? extraContext = widget.subject;
    
    if (widget.notion != null) {
      final notionContext = NotionPrompts.getPromptForNotion(widget.notion);
      extraContext = (extraContext == null) 
          ? "NOTION ABORDÉE : ${widget.notion}\nCONSIGNES SPÉCIFIQUES : $notionContext"
          : "$extraContext\n\nNOTION ABORDÉE : ${widget.notion}\nCONSIGNES SPÉCIFIQUES : $notionContext";
    }

    if (widget.mode == 'td') {
      extraContext =
          "Exercice de type ${widget.type}. Le sujet est : ${widget.subject}\n\n$extraContext";
    }

    try {
      await _aiService.init(
        widget.methodologyId,
        extraContext,
        initialModelMessage: initialMessage,
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            'isMe': false,
            'text': "Erreur lors de l'initialisation de mon cerveau: $e",
          });
        });
      }
    }
  }

  String _initChat() {
    String firstMessage;
    if (widget.mode == 'td' && widget.subject != null) {
      firstMessage =
          'Excellent choix ! Nous allons traiter ce ${widget.type ?? 'sujet'} :\n\n"${widget.subject}"\n\nJe vais t\'aider pas à pas. Pour commencer, propose-moi une idée d\'amorce pour l\'introduction.';
    } else {
      firstMessage =
          'Bonjour ! Je suis Aleckse, ta professeure virtuelle. Pose-moi une question sur ton cours de philosophie !';
    }

    _messages.add({
      'isMe': false,
      'text': firstMessage,
    });

    return firstMessage;
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final question = _messageController.text;

    setState(() {
      _messages.add({
        'isMe': true,
        'text': question,
      });
      _isLoading = true;
    });

    _messageController.clear();

    final response = await _aiService.sendMessage(question);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (response != null) {
        _messages.add({
          'isMe': false,
          'text': response,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/aleckse.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Aleckse', style: TextStyle(fontSize: 16)),
                  if (widget.mode == 'td')
                    const Text('Entraînement TD',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 1,
        actions: [
          if (widget.mode == 'td' && widget.methodologyId != null)
            IconButton(
              icon: const Icon(Icons.menu_book_rounded),
              tooltip: 'Voir la méthodologie',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Méthodologie Officielle'),
                    content: Text(
                        'Le document "${widget.methodologyId}" sera chargé ici pour t\'aider à rédiger selon les critères de l\'IPN.\n\nALECKSE utilisera également ce document pour évaluer et corriger tes réponses de manière stricte et bienveillante.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Compris'),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 16),
                        Text("Aleckse réfléchit...",
                            style: TextStyle(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  );
                }

                final message = _messages[index];
                final isMe = message['isMe'] as bool;
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isMe ? AppColors.primary : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: isMe ? const Radius.circular(0) : null,
                        bottomLeft: !isMe ? const Radius.circular(0) : null,
                      ),
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Text(
                      message['text'] as String,
                      style: TextStyle(
                        color: isMe ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écris ton message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
