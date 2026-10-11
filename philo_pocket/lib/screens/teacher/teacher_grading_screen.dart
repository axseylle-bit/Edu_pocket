import 'package:flutter/material.dart';
import '../../core/services/ai_service.dart';
import '../../core/constants/app_colors.dart';

class TeacherGradingScreen extends StatefulWidget {
  const TeacherGradingScreen({Key? key}) : super(key: key);

  @override
  State<TeacherGradingScreen> createState() => _TeacherGradingScreenState();
}

class _TeacherGradingScreenState extends State<TeacherGradingScreen> {
  final TextEditingController _copyController = TextEditingController();
  final AiService _aiService = AiService();
  
  String _exerciseType = 'Dissertation'; // Valeur par défaut
  String _mode = 'correction'; // 'correction' ou 'preparation'
  bool _isGrading = false;
  String? _gradingResult;
  String? _errorMessage;

  Future<void> _startGrading() async {
    final copyText = _copyController.text.trim();
    if (copyText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_mode == 'correction' ? 'Veuillez coller la copie de l\'élève.' : 'Veuillez saisir le sujet de l\'épreuve.')),
      );
      return;
    }

    setState(() {
      _isGrading = true;
      _gradingResult = null;
      _errorMessage = null;
    });

    try {
      final result = _mode == 'correction' 
          ? await _aiService.gradeStudentCopy(copyText, _exerciseType)
          : await _aiService.prepareExam(copyText, _exerciseType);
      
      setState(() {
        _gradingResult = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isGrading = false;
      });
    }
  }

  @override
  void dispose() {
    _copyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correcteur PhiloPocket (IA)'),
        backgroundColor: AppColors.backgroundLight,
        elevation: 1,
      ),
      body: Row(
        children: [
          // Panneau de gauche : Saisie de la copie
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment<String>(
                        value: 'correction',
                        label: Text('Corriger une copie'),
                        icon: Icon(Icons.grading_rounded),
                      ),
                      ButtonSegment<String>(
                        value: 'preparation',
                        label: Text('Préparer une épreuve'),
                        icon: Icon(Icons.edit_document),
                      ),
                    ],
                    selected: {_mode},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _mode = newSelection.first;
                        _gradingResult = null;
                        _copyController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Type d\'exercice',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _exerciseType,
                        isExpanded: true,
                        items: ['Dissertation', 'Commentaire de texte']
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _exerciseType = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _mode == 'correction' ? 'Copie de l\'élève' : 'Sujet de l\'épreuve',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: _copyController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: _mode == 'correction' 
                            ? 'Collez le texte de la copie ici...' 
                            : 'Saisissez le sujet de l\'épreuve ici (ex: "La liberté est-elle une illusion ?")...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isGrading ? null : _startGrading,
                    icon: _isGrading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(_mode == 'correction' ? Icons.check_circle_outline : Icons.auto_awesome),
                    label: Text(_isGrading
                        ? 'Génération en cours...'
                        : (_mode == 'correction' ? 'Corriger avec l\'IA' : 'Préparer le corrigé (IA)')),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Ligne séparatrice
          Container(width: 1, color: Colors.grey.shade300),

          // Panneau de droite : Résultat de l'IA
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Évaluation et Feedback',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _buildResultContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultContent() {
    if (_isGrading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              _mode == 'correction' 
                  ? "Analyse de la copie selon la grille IPN...\nCela peut prendre quelques secondes."
                  : "Création du corrigé et analyse du sujet en cours...\nCela peut prendre quelques secondes.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          "Erreur :\n\n$_errorMessage",
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_gradingResult != null) {
      return SingleChildScrollView(
        child: SelectableText(
          _gradingResult!,
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
      );
    }

    return Center(
      child: Text(
        _mode == 'correction' 
            ? "L'évaluation apparaîtra ici après la correction."
            : "Le corrigé type et l'analyse apparaîtront ici.",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
