import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../legal/legal_document_viewer_screen.dart';
import '../../core/services/supabase_service.dart';

class TeacherPartnerScreen extends StatefulWidget {
  const TeacherPartnerScreen({super.key});

  @override
  State<TeacherPartnerScreen> createState() => _TeacherPartnerScreenState();
}

class _TeacherPartnerScreenState extends State<TeacherPartnerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _degreeController = TextEditingController();
  final _subjectController = TextEditingController();
  final _schoolController = TextEditingController();
  final _chapterController = TextEditingController();

  String _educationOrder = 'Général';
  bool _isSubmitting = false;
  bool _isFormExpanded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _degreeController.dispose();
    _subjectController.dispose();
    _schoolController.dispose();
    _chapterController.dispose();
    super.dispose();
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('$label copié : $text'),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _openWhatsAppDirect(BuildContext context) {
    _copyToClipboard(context, '+24177141912', 'Numéro WhatsApp');
    final url = Uri.parse('https://wa.me/24177141912');
    launchUrl(url, mode: LaunchMode.externalNonBrowserApplication).catchError((_) {
      return launchUrl(url, mode: LaunchMode.platformDefault);
    });
  }

  void _openEmailDirect(BuildContext context) {
    _copyToClipboard(context, 'axseylle@gmail.com', 'Email');
    final url = Uri.parse('mailto:axseylle@gmail.com');
    launchUrl(url).catchError((_) => false);
  }

  Future<void> _submitApplication({required bool viaWhatsApp}) async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir les champs obligatoires du formulaire.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final degree = _degreeController.text.trim();
    final subject = _subjectController.text.trim();
    final school = _schoolController.text.trim();
    final chapter = _chapterController.text.trim();

    // 1. Sauvegarde en base de données Supabase (si connectivité active)
    try {
      await SupabaseService().client.from('teacher_applications').insert({
        'full_name': name,
        'phone_whatsapp': phone,
        'highest_degree': degree,
        'teaching_subject': subject,
        'education_order': _educationOrder,
        'school_name': school,
        'city': school,
        'preferred_chapters': chapter.isNotEmpty ? chapter : null,
      });
    } catch (e) {
      debugPrint('Tentative insertion Supabase candidature: $e');
      // On continue l'exécution : la transmission WhatsApp / Email assure la réception garantie
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    // 2. Structuration du message de candidature officiel
    final buffer = StringBuffer()
      ..writeln('📋 *CANDIDATURE ENSEIGNANT PIONNIER EDUPOCKET GABON*')
      ..writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
      ..writeln('👤 *Nom & Prénom(s)* : $name')
      ..writeln('📞 *Téléphone / WhatsApp* : $phone')
      ..writeln('🎓 *Diplôme / Certification* : $degree')
      ..writeln('📚 *Matière enseignée* : $subject')
      ..writeln('🎯 *Filière / Ordre* : $_educationOrder')
      ..writeln('🏫 *Établissement & Ville* : $school');
    if (chapter.isNotEmpty) {
      buffer.writeln('✍️ *Lot / Chapitre souhaité* : $chapter');
    }
    buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('Je souhaite rejoindre le collège des enseignants pionniers pour concevoir la progression nationale collectivement.');

    final applicationText = buffer.toString();

    // 3. Transmission via le canal choisi
    if (viaWhatsApp) {
      _copyToClipboard(context, applicationText, 'Dossier de candidature');
      final uri = Uri.parse('https://wa.me/24177141912?text=${Uri.encodeComponent(applicationText)}');
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication).catchError((_) {
        return launchUrl(uri, mode: LaunchMode.platformDefault);
      });
    } else {
      final uri = Uri.parse(
        'mailto:axseylle@gmail.com?subject=${Uri.encodeComponent('Candidature Enseignant Pionnier - $name')}&body=${Uri.encodeComponent(applicationText)}',
      );
      await launchUrl(uri).catchError((_) => false);
    }

    if (!mounted) return;

    // 4. Modale de confirmation
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Candidature Transmise !',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          'Merci cher collègue $name !\n\nVotre fiche officielle a été formulée et transmise à la coordination pédagogique (WhatsApp +241 77 14 19 12).\n\nNous reviendrons vers vous sous peu pour valider votre sélection et vous attribuer votre lot de chapitres de la progression officielle IPN.',
          style: const TextStyle(fontSize: 13.5, height: 1.45),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Parfait'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Espace Enseignant Pionnier'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Illustration & Entête
              const Center(
                child: Icon(
                  Icons.handshake_rounded,
                  size: 76,
                  color: AppColors.primary,
                ),
              ).animate().fade().scale(delay: 100.ms),
              const SizedBox(height: 18),
              
              Text(
                'Devenez Créateur Partenaire EduPocket',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                textAlign: TextAlign.center,
              ).animate().fade(delay: 200.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 8),
              const Text(
                'Bâtissons ensemble la progression annuelle officielle du Gabon : travail collaboratif à la chaîne, sans pression, cours signés protégés contre le vol et 50 % à 70 % de royalties d\'auteur.',
                style: TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.4),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 22),
              
              // =======================================================
              // LES 4 PILIERS DE L'ENGAGEMENT COLLÉGIAL
              // =======================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 1. PATRIMOINE & SIGNATURE NOMINATIVE (ANTI-VOL)
                    _buildFeatureRow(
                      context,
                      icon: Icons.verified_user_rounded,
                      title: 'Patrimoine & Cours Signés (Anti-Vol)',
                      description: 'Chaque cours est signé nominativement de votre nom, vous assurant une pleine reconnaissance d\'auteur et une protection absolue contre le vol intellectuel. En même temps, chaque collègue est libre d\'utiliser les cours des pairs en classe et réciproquement.',
                    ),
                    const Divider(height: 28),

                    // 2. TRAVAIL À LA CHAÎNE SANS SURCHARGE
                    _buildFeatureRow(
                      context,
                      icon: Icons.hub_rounded,
                      title: 'Travail Collaboratif à la Chaîne Sans Surcharge',
                      description: 'Aucun enseignant ne produit tout le programme seul. Après sélection, la progression annuelle officielle IPN est découpée en lots : vous rédigez un chapitre à votre rythme sans pression, selon une méthodologie nationale commune.',
                    ),
                    const Divider(height: 28),

                    // 3. 50 % À 70 % DE ROYALTIES
                    _buildFeatureRow(
                      context,
                      icon: Icons.monetization_on_rounded,
                      title: 'Rémunération Équitable (50 % à 70 % de Royalties)',
                      description: 'Percevez 50 % de royalties de base sur les abonnements mutualisés, et jusqu\'à 70 % au premier mois grâce à votre code parrain, reversés directement sur votre compte Airtel Money ou Moov Money.',
                    ),
                    const Divider(height: 28),

                    // 4. CODE PROMO ÉTHIQUE SANS PRESSION
                    _buildFeatureRow(
                      context,
                      icon: Icons.psychology_alt_rounded,
                      title: 'Code Promo Personnel & Charte Éthique',
                      description: 'Votre code parrain récompense légitimement le travail intellectuel abattu. Notre charte déontologique interdit tout démarchage ou pression sur les élèves en classe : leur adhésion reste entièrement libre et volontaire.',
                    ),
                  ],
                ),
              ).animate().fade(delay: 350.ms).slideY(begin: 0.1),
              
              const SizedBox(height: 16),
              
              // Liens vers les documents officiels
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => LegalDocumentViewerScreen.show(
                        context,
                        title: 'Manifeste & Vision Fondatrice',
                        assetPath: 'assets/legal/manifeste_vision.md',
                      ),
                      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                      label: const Text('Manifeste', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => LegalDocumentViewerScreen.show(
                        context,
                        title: 'Quotas Officiels par Province',
                        assetPath: 'assets/legal/quotas_provinciaux.md',
                      ),
                      icon: const Icon(Icons.table_chart_rounded, size: 16),
                      label: const Text('Quotas Provinciaux', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ).animate().fade(delay: 400.ms),

              const SizedBox(height: 24),

              // =======================================================
              // FORMULAIRE INTERACTIF DE CANDIDATURE ENSEIGNANT PIONNIER
              // =======================================================
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.app_registration_rounded, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Dépôt de Candidature Enseignant',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Transmettez vos informations officielles dès maintenant',
                                  style: TextStyle(color: Colors.white70, fontSize: 11.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Bouton d'ouverture du formulaire ou Formulaire déroulé
                      if (!_isFormExpanded)
                        ElevatedButton.icon(
                          onPressed: () => setState(() => _isFormExpanded = true),
                          icon: const Icon(Icons.edit_note_rounded, size: 20),
                          label: const Text(
                            '📝 Remplir ma Fiche de Candidature',
                            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1E3A8A),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        )
                      else
                        Form(
                          key: _formKey,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Fiche de Renseignements Officielle',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 14),

                                // 1. Nom & Prénom
                                TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Nom et Prénom(s) *',
                                    hintText: 'Ex: M. OBIANG Jean-Pierre',
                                    prefixIcon: const Icon(Icons.person_rounded, size: 20),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez saisir votre nom' : null,
                                ),
                                const SizedBox(height: 12),

                                // 2. Téléphone WhatsApp
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Téléphone / WhatsApp actif *',
                                    hintText: 'Ex: +241 77 XX XX XX',
                                    prefixIcon: const Icon(Icons.phone_rounded, size: 20),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez saisir votre téléphone' : null,
                                ),
                                const SizedBox(height: 12),

                                // 3. Diplôme ou Certification
                                TextFormField(
                                  controller: _degreeController,
                                  decoration: InputDecoration(
                                    labelText: 'Diplôme le plus élevé ou Certification *',
                                    hintText: 'Ex: CAPES, DIPES, Master Philosophie, Licence...',
                                    prefixIcon: const Icon(Icons.school_rounded, size: 20),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez préciser votre diplôme' : null,
                                ),
                                const SizedBox(height: 12),

                                // 4. Matière enseignée
                                TextFormField(
                                  controller: _subjectController,
                                  decoration: InputDecoration(
                                    labelText: 'Discipline / Matière enseignée *',
                                    hintText: 'Ex: Philosophie, Mathématiques, Génie Mécanique...',
                                    prefixIcon: const Icon(Icons.menu_book_rounded, size: 20),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez indiquer la matière' : null,
                                ),
                                const SizedBox(height: 12),

                                // 5. Choix de l'Ordre d'Enseignement
                                const Text(
                                  'Ordre d\'enseignement :',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textDark),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    ChoiceChip(
                                      label: const Text('Général'),
                                      selected: _educationOrder == 'Général',
                                      onSelected: (s) => setState(() => _educationOrder = 'Général'),
                                    ),
                                    ChoiceChip(
                                      label: const Text('Technique (STI/STMG)'),
                                      selected: _educationOrder == 'Technique (STI/STMG)',
                                      onSelected: (s) => setState(() => _educationOrder = 'Technique (STI/STMG)'),
                                    ),
                                    ChoiceChip(
                                      label: const Text('Professionnel (CET)'),
                                      selected: _educationOrder == 'Professionnel (CET)',
                                      onSelected: (s) => setState(() => _educationOrder = 'Professionnel (CET)'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // 6. Établissement et Ville
                                TextFormField(
                                  controller: _schoolController,
                                  decoration: InputDecoration(
                                    labelText: 'Établissement & Ville d\'affectation *',
                                    hintText: 'Ex: Lycée National Léon Mba, Libreville',
                                    prefixIcon: const Icon(Icons.location_city_rounded, size: 20),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Veuillez saisir votre établissement' : null,
                                ),
                                const SizedBox(height: 12),

                                // 7. Chapitre ou section souhaitée
                                TextFormField(
                                  controller: _chapterController,
                                  decoration: InputDecoration(
                                    labelText: 'Chapitre ou section souhaitée (facultatif)',
                                    hintText: 'Ex: La Conscience (Terminale A/B/C/D), Électronique F3...',
                                    prefixIcon: const Icon(Icons.bookmark_added_rounded, size: 20),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // Actions d'envoi
                                if (_isSubmitting)
                                  const Center(child: CircularProgressIndicator())
                                else ...[
                                  ElevatedButton.icon(
                                    onPressed: () => _submitApplication(viaWhatsApp: true),
                                    icon: const Icon(Icons.send_rounded, size: 18),
                                    label: const Text(
                                      'Transmettre ma Candidature (WhatsApp)',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF25D366),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 13),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    onPressed: () => _submitApplication(viaWhatsApp: false),
                                    icon: const Icon(Icons.email_outlined, size: 18),
                                    label: const Text('Transmettre par Email'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ).animate().fade(delay: 450.ms).scale(),

              const SizedBox(height: 24),
              
              // =======================================================
              // CONTACT DIRECT : NUMÉRO WHATSAPP & EMAIL EN CLAIR
              // =======================================================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade400, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.support_agent_rounded, color: Colors.green.shade800, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Coordination Pédagogique EduPocket',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.5,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'Joignable directement 7j/7 au Gabon :',
                                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 1. BLOC WHATSAPP DIRECT
                    InkWell(
                      onTap: () => _openWhatsAppDirect(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25D366).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFF25D366),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chat_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'WhatsApp Officiel Coordination',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E7E34),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  SelectableText(
                                    '+241 77 14 19 12',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0F5132),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copier le numéro WhatsApp',
                              icon: const Icon(Icons.copy_rounded, color: Color(0xFF1E7E34), size: 20),
                              onPressed: () => _copyToClipboard(context, '+24177141912', 'Numéro WhatsApp'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 2. BLOC EMAIL DIRECT
                    InkWell(
                      onTap: () => _openEmailDirect(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.email_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Courriel de la Coordination',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  SelectableText(
                                    'axseylle@gmail.com',
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Copier l\'adresse email',
                              icon: const Icon(Icons.copy_rounded, color: AppColors.primary, size: 20),
                              onPressed: () => _copyToClipboard(context, 'axseylle@gmail.com', 'Email'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Text(
                      'Touchez directement pour ouvrir ou cliquez sur l\'icône pour copier.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ).animate().fade(delay: 500.ms).scale(),
              
              const SizedBox(height: 16),
              
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/main');
                },
                icon: const Icon(Icons.phone_android_rounded),
                label: const Text(
                  'Tester l\'application (Mode Éditeur)',
                  style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ).animate().fade(delay: 550.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context, {required IconData icon, required String title, required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.35,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
