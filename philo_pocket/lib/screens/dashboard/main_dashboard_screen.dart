import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/student_provider.dart';

class MainDashboardScreen extends ConsumerWidget {
  const MainDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentState = ref.watch(studentProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(context, ref, studentState)
                  .animate()
                  .fade(duration: 600.ms)
                  .slideY(begin: -0.1, end: 0, curve: Curves.easeOutQuad),

              const SizedBox(height: 28),

              // Bannière VIP d'accès direct aux Progressions Officielles IPN 2026-2027
              _buildIpnProgressionsBanner(context)
                  .animate()
                  .fade(delay: 150.ms)
                  .slideY(begin: 0.08, end: 0),

              const SizedBox(height: 28),

              Text(
                'Matières',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fade(delay: 200.ms).slideX(begin: -0.1),

              const SizedBox(height: 20),

              // Subjects Grid
              _buildSubjectsGrid(context)
                  .animate()
                  .fade(delay: 300.ms)
                  .scale(begin: const Offset(0.95, 0.95)),

              const SizedBox(height: 32),
              
              Text(
                'Outils Transversaux',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ).animate().fade(delay: 400.ms).slideX(begin: -0.1),
              
              const SizedBox(height: 16),
              
              _buildToolsSection(context)
                  .animate()
                  .fade(delay: 500.ms)
                  .slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, WidgetRef ref, StudentState studentState) {
    final userName = studentState.userName;
    final globalProgress = studentState.globalProgress;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Dark slate premium feel
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour,',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    Text(
                      '$userName ðŸ‘‹',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('ðŸ”¥', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          '${studentState.streak}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ).animate().scale(delay: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/logo.jpg'), // Ou profile pic
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progression Globale',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
              ),
              Text(
                '${(globalProgress * 100).toInt()}%',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: globalProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Niveau ${studentState.niveau} ${studentState.serie}',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsGrid(BuildContext context) {
    return Column(
      children: [
        // Section Asymétrique : Philo Pocket (Grand Vaisseau Amiral) à gauche, Maths et Physique à droite
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Philo Pocket (Gauche) - Vaisseau Amiral
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Philo Pocket',
                subtitle: 'Vaisseau amiral · 15 Notions IPN',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.primary,
                gradient: AppColors.primaryGradient,
                isActive: true,
                isLarge: true,
                height: 376, // 180 + 16 + 180 = 376
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Philo Pocket',
                  subtitle: 'Philosophie · Programme officiel IPN Gabon',
                  icon: Icons.local_fire_department_rounded,
                  color: AppColors.primary,
                  description:
                      'Programme officiel complet du Gabon : 15 notions fondamentales, méthodologie de la dissertation, commentaire de texte et repères conceptuels.',
                  freePioneer: 'Socrate',
                  freePioneerDetails: 'Accès aux fiches de cours, méthodologie IPN de base, 1 quiz d\'évaluation par notion et ALECKSE basique en libre accès 100% gratuit.',
                  tier1Pioneer: 'Platon',
                  tier1Details: 'Tout le contenu Socrate, quiz illimités pour s\'entraîner, suivi détaillé de la progression et bulletin hebdomadaire pour les parents.',
                  tier2Pioneer: 'Aristote',
                  tier2Details: 'Tout le contenu Platon, mythes philosophiques en 3D, TP et ateliers pratiques, dialogue direct avec les grands philosophes, Bac blanc corrigé par ALECKSE avancé et mode hors ligne.',
                  targetRoute: '/philo-pocket',
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Colonne de droite (Maths et Physique)
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildSubjectCard(
                    context,
                    title: 'Mathématiques',
                    subtitle: 'Algèbre, Analyse, Géométrie',
                    icon: Icons.calculate_rounded,
                    color: const Color(0xFF1E88E5), // Bleu vibrant
                    isActive: true,
                    onTap: () => _showDisciplinePioneersModal(
                      context,
                      title: 'Mathématiques Générales',
                      subtitle: 'Séries C, D, B, A · Référentiel National IPN',
                      icon: Icons.calculate_rounded,
                      color: const Color(0xFF1E88E5),
                      description:
                          'Enseignement conforme aux programmes officiels gabonais : cours complets du collège au lycée, propriétés, théorèmes et résolutions guidées.',
                      freePioneer: 'Thalès & Pythagore',
                      freePioneerDetails: 'Cours complets, formules essentielles, résumés théoriques et fiches de révision en accès libre et 100% gratuit.',
                      tier1Pioneer: 'Archimède',
                      tier1Details: 'Travaux dirigés d\'approfondissement, méthodes de démonstration et résolutions pas-à-pas.',
                      tier2Pioneer: 'Isaac Newton',
                      tier2Details: 'Préparation intensive aux épreuves du Baccalauréat, annales résolues et simulations d\'examens.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSubjectCard(
                    context,
                    title: 'Physique-Chimie',
                    subtitle: 'Mécanique, Électricité, Chimie',
                    icon: Icons.science_rounded,
                    color: const Color(0xFF00897B), // Vert émeraude
                    isActive: true,
                    onTap: () => _showDisciplinePioneersModal(
                      context,
                      title: 'Physique - Chimie',
                      subtitle: 'Séries C, D, STI · Référentiel National IPN',
                      icon: Icons.science_rounded,
                      color: const Color(0xFF00897B),
                      description:
                          'Lois physiques, réactions chimiques, cinématique, électrostatique et applications pratiques préparant aux épreuves nationales.',
                      freePioneer: 'Galilée & Marie Curie',
                      freePioneerDetails: 'Fiches de cours intégrales, équations et formules fondamentales en libre accès gratuit pour tous les élèves.',
                      tier1Pioneer: 'Antoine Lavoisier',
                      tier1Details: 'TD d\'exercices résolus pas-à-pas, réactions chimiques expliquées et protocoles expérimentaux.',
                      tier2Pioneer: 'Albert Einstein',
                      tier2Details: 'Coaching d\'excellence, annales complètes du Bac gabonais et sujets types corrigés.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Grille des autres matières en bas (Toutes actives et colorées)
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Français & Lettres',
                subtitle: 'Méthodologie & Littérature',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFFE65100), // Orange ambré
                isActive: true,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Français & Littérature',
                  subtitle: 'Toutes Séries · Programme officiel IPN',
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFFE65100),
                  description:
                      'Maîtrise du commentaire composé, dissertation littéraire, contraction de texte et étude intégrale des œuvres au programme.',
                  freePioneer: 'Montesquieu & Aimé Césaire',
                  freePioneerDetails: 'Cours méthodologiques, synthèses d\'œuvres et fiches d\'auteurs accessibles librement et gratuitement.',
                  tier1Pioneer: 'Léopold Sédar Senghor',
                  tier1Details: 'Ateliers de rédaction, figures de style, perfectionnement grammatical et maîtrise de l\'expression.',
                  tier2Pioneer: 'Victor Hugo',
                  tier2Details: 'Simulations d\'épreuves du Bac, coaching d\'analyse littéraire et modèles rédigés d\'excellence.',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'S.V.T.',
                subtitle: 'Sciences de la Vie & Terre',
                icon: Icons.eco_rounded,
                color: const Color(0xFF2E7D32), // Vert nature
                isActive: true,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Sciences de la Vie et de la Terre',
                  subtitle: 'Séries D, C, Collège · Référentiel IPN',
                  icon: Icons.eco_rounded,
                  color: const Color(0xFF2E7D32),
                  description:
                      'Génétique, immunologie, reproduction, géologie gabonaise et tectonique des plaques conformes au programme officiel.',
                  freePioneer: 'Darwin & Cheikh Anta Diop',
                  freePioneerDetails: 'Cours complets, schémas de référence et fiches de synthèse gratuits pour chaque niveau scolaire.',
                  tier1Pioneer: 'Louis Pasteur',
                  tier1Details: 'Fiches bilans illustrées, TD d\'interprétation de graphes et protocoles biologiques.',
                  tier2Pioneer: 'Gregor Mendel',
                  tier2Details: 'Maîtrise complète des problèmes de génétique formelle, annales du Bac et entraînement ciblé.',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Histoire-Géo',
                subtitle: 'Histoire du Gabon & Monde',
                icon: Icons.public_rounded,
                color: const Color(0xFF6D4C41), // Marron terre
                isActive: true,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Histoire - Géographie',
                  subtitle: 'Toutes Séries · Programme Gabon IPN',
                  icon: Icons.public_rounded,
                  color: const Color(0xFF6D4C41),
                  description:
                      'Histoire contemporaine, traite et résistances au Gabon, mondialisation, géographie économique et spatiale du pays.',
                  freePioneer: 'Hérodote & Léon Mba',
                  freePioneerDetails: 'Chronologies historiques, fiches géographiques du Gabon et synthèses de cours libres et gratuites.',
                  tier1Pioneer: 'Cheikh Anta Diop',
                  tier1Details: 'Méthodologie de la dissertation historique, commentaire de documents et repères géopolitiques.',
                  tier2Pioneer: 'Fernand Braudel',
                  tier2Details: 'Dossiers complets, schémas cartographiques d\'examen et préparation intensive au grand oral/écrit.',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Anglais',
                subtitle: 'Langue Vivante 1',
                icon: Icons.language_rounded,
                color: const Color(0xFF5E35B1), // Violet royal
                isActive: true,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Anglais (LV1)',
                  subtitle: 'Toutes Séries & Cycles',
                  icon: Icons.language_rounded,
                  color: const Color(0xFF5E35B1),
                  description:
                      'Compréhension écrite, vocabulaire thématique, grammaire appliquée, traduction et expression personnelle.',
                  freePioneer: 'William Shakespeare',
                  freePioneerDetails: 'Guides grammaticaux, vocabulaire clé des épreuves et cours complets en accès 100% gratuit.',
                  tier1Pioneer: 'Chinua Achebe',
                  tier1Details: 'Ateliers de compréhension textuelle, connecteurs logiques et exercices d\'écriture guidés.',
                  tier2Pioneer: 'Nelson Mandela',
                  tier2Details: 'Coaching d\'expression avancée, sujets types corrigés du Baccalauréat et fluidité lexicale.',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Espagnol',
                subtitle: 'Langue Vivante 2',
                icon: Icons.translate_rounded,
                color: const Color(0xFFC2185B), // Framboise vive
                isActive: true,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Espagnol (LV2)',
                  subtitle: 'Séries A1, A2, B, Lycée & Collège',
                  icon: Icons.translate_rounded,
                  color: const Color(0xFFC2185B),
                  description:
                      'Grammaire hispanique, conjugaison, civilisation hispanophone, analyse de textes et expression écrite.',
                  freePioneer: 'Miguel de Cervantes',
                  freePioneerDetails: 'Tableaux de conjugaison, règles grammaticales et cours de base gratuits.',
                  tier1Pioneer: 'Gabriel García Márquez',
                  tier1Details: 'Analyses de textes hispaniques et renforcement lexical pour le secondaire.',
                  tier2Pioneer: 'Federico García Lorca',
                  tier2Details: 'Préparation complète aux épreuves écrites et orales du Baccalauréat.',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Économie (S.E.S)',
                subtitle: 'Série B (Éco-Gestion)',
                icon: Icons.trending_up_rounded,
                color: const Color(0xFF0288D1), // Bleu océan
                isActive: true,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Sciences Économiques & Sociales',
                  subtitle: 'Série B & Enseignement Tertiaire',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFF0288D1),
                  description:
                      'Mécanismes du marché, croissance économique, politique monétaire, sociologie et mutations sociales.',
                  freePioneer: 'Adam Smith',
                  freePioneerDetails: 'Définitions macroéconomiques, concepts clés et fiches de cours IPN gratuites.',
                  tier1Pioneer: 'John Maynard Keynes',
                  tier1Details: 'Méthodologie d\'argumentation économique et interprétation de tableaux statistiques.',
                  tier2Pioneer: 'Joseph Schumpeter',
                  tier2Details: 'Entraînement aux sujets d\'examen du Bac B et synthèses économiques complètes.',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Allemand',
                subtitle: 'Langue Vivante 2',
                icon: Icons.record_voice_over_rounded,
                color: const Color(0xFF455A64), // Ardoise noble
                isActive: true,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Allemand (LV2)',
                  subtitle: 'Séries Littéraires & Collège',
                  icon: Icons.record_voice_over_rounded,
                  color: const Color(0xFF455A64),
                  description:
                      'Grammaire allemande, déclinaisons, compréhension de documents et thèmes de civilisation.',
                  freePioneer: 'Johann Wolfgang von Goethe',
                  freePioneerDetails: 'Règles de déclinaison, vocabulaire essentiel et cours gratuits.',
                  tier1Pioneer: 'Friedrich Schiller',
                  tier1Details: 'Exercices d\'application, structures de phrases et compréhension guidée.',
                  tier2Pioneer: 'Alexander von Humboldt',
                  tier2Details: 'Préparation ciblée aux épreuves officielles du Baccalauréat.',
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Spacer(flex: 1), // Espace vide harmonieux
          ],
        ),
      ],
    );
  }

  void _showDisciplinePioneersModal(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String description,
    required String freePioneer,
    required String freePioneerDetails,
    required String tier1Pioneer,
    required String tier1Details,
    required String tier2Pioneer,
    required String tier2Details,
    String? targetRoute,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                description,
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 18),

              // 1. LE MODÈLE GRATUIT (Accès libre pour chaque enfant gabonais)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.socrateGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.socrateGreen.withValues(alpha: 0.4), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.socrateGreen,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '100% GRATUIT',
                            style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Socle Officiel IPN · $freePioneer',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.socrateGreen, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      freePioneerDetails,
                      style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.35),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          if (targetRoute != null) {
                            context.push(targetRoute);
                          } else {
                            context.push('/cours');
                          }
                        },
                        icon: const Icon(Icons.menu_book_rounded, size: 18),
                        label: const Text('Consulter les Cours & Fiches Gratuits'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.socrateGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.push('/ipn?category=${Uri.encodeComponent(title)}');
                        },
                        icon: const Icon(Icons.description_outlined, size: 18),
                        label: const Text('📋 Voir les Progressions Officielles IPN'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.socrateGreen,
                          side: const BorderSide(color: AppColors.socrateGreen),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 2. OFFRES DE FORMATION SUPPLÉMENTAIRE EN PALIERS PIONNIERS
              const Text(
                'Offres de formation supplémentaire (Optionnelles) :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              const Text(
                'EduPocket ne vend pas les cours. Seuls les ateliers de renforcement intensif et tutorat personnalisé font l\'objet de modules pionniers créés par les enseignants référents :',
                style: TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.3),
              ),
              const SizedBox(height: 10),

              // Palier 1 (Essentiel - 2 500 FCFA) - Orange un peu rose
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColors.platonCoral.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.platonCoral, width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.platonCoral.withValues(alpha: 0.15),
                      radius: 18,
                      child: const Icon(Icons.psychology_rounded, color: AppColors.platonCoral, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Palier $tier1Pioneer (Essentiel)',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.platonCoral),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.platonCoral,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  '2500 FCFA/mois',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Renforcement intensif & TD méthodologiques pas-à-pas',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 4),
                          Text(tier1Details, style: const TextStyle(fontSize: 11.5, color: Colors.black87, height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Palier 2 (Confort - 5 000 FCFA) - Violet
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.aristoteViolet.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.aristoteViolet.withValues(alpha: 0.45), width: 1.5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.aristoteViolet.withValues(alpha: 0.15),
                      radius: 18,
                      child: const Icon(Icons.military_tech_rounded, color: AppColors.aristoteViolet, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Palier $tier2Pioneer (Confort)',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.aristoteViolet),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.aristoteViolet,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  '5000 FCFA/mois',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Coaching d\'excellence, annales résolues & préparation examens',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 4),
                          Text(tier2Details, style: const TextStyle(fontSize: 11.5, color: Colors.black87, height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton vers la grille des abonnements
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/subscription');
                  },
                  icon: const Icon(Icons.workspace_premium_rounded, size: 16),
                  label: const Text('Découvrir toutes les formules de renforcement'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    Gradient? gradient,
    required bool isActive,
    bool isLarge = false,
    double? height,
    required VoidCallback onTap,
  }) {
    return Container(
      height: height ?? (isLarge ? 200 : 180),
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: (gradient != null ? AppColors.primary : color).withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, 
                        color: Colors.white, 
                        size: isLarge ? 40 : 32
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isLarge ? 24 : null,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.white, size: 11),
                      SizedBox(width: 4),
                      Text(
                        'Gratuit IPN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildToolButton(
            context,
            icon: Icons.smart_toy_rounded,
            label: 'ALECKSE (IA)',
            color: const Color(0xFF6366F1),
            onTap: () => context.push('/chat'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildToolButton(
            context,
            icon: Icons.picture_as_pdf_rounded,
            label: 'Progressions IPN',
            color: const Color(0xFF9C3B3B),
            onTap: () => context.push('/ipn'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildToolButton(
            context,
            icon: Icons.person_rounded,
            label: 'Profil',
            color: AppColors.textDark,
            onTap: () {
                // Future profile screen
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildToolButton(
            context,
            icon: Icons.grading_rounded,
            label: 'Correction (IA)',
            color: Colors.orange.shade700,
            onTap: () => context.push('/grading'),
          ),
        ),
      ],
    );
  }

  Widget _buildToolButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // BANNIÈRE OFFICIELLE : BIBLIOTHÈQUE DES PROGRESSIONS & RÉFÉRENTIELS IPN
  // =========================================================================
  Widget _buildIpnProgressionsBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)], // Bleu Nuit Impérial & Bleu Profond
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => context.push('/ipn'),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF38BDF8).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.4)),
                      ),
                      child: const Icon(
                        Icons.auto_stories_rounded,
                        color: Color(0xFF38BDF8),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '100% OFFICIEL IPN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  '28 DOCUMENTS TÉLÉCHARGÉS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bibliothèque des Progressions & Programmes Nationaux',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold,
                              height: 1.25,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Tous les documents de référence téléchargés et certifiés IPN pour l\'année scolaire 2026-2027.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Chips des matières disponibles
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildIpnTag('Maths (10 docs · 6e à Tle)', const Color(0xFF1E88E5)),
                    _buildIpnTag('Physique-Chimie (8 docs · 6e à Tle)', const Color(0xFF00897B)),
                    _buildIpnTag('Français (Collège complet)', const Color(0xFFE65100)),
                    _buildIpnTag('S.E.S (3 docs · 2de, 1ère, Tle)', const Color(0xFF0288D1)),
                    _buildIpnTag('Philosophie (6 docs & PDF)', AppColors.primary),
                  ],
                ),
                const SizedBox(height: 14),
                // Bouton d'accès direct
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/ipn'),
                    icon: const Icon(Icons.folder_shared_rounded, size: 18),
                    label: const Text(
                      'Consulter tous les documents officiels IPN',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIpnTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

