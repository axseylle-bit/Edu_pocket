import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/student_provider.dart';
import '../auth/mobile_money_payment_modal.dart';

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
          const SizedBox(height: 14),
          // Capsule Académie EVA (Excelle Virtual Academy)
          InkWell(
            onTap: () => _showEvaAcademyInfoModal(context, studentState),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded,
                        color: Colors.amber, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Académie EVA · Excelle Virtual Academy',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'Grade ${studentState.statutEva}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${studentState.creditsEva} Crédits EVA',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white60, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsGrid(BuildContext context) {
    return Column(
      children: [
        // 1. SECTION SUPÉRIEURE : Philo Pocket (Vaisseau Amiral Solo) & Pôle Sciences (Séries C & D)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Philo Pocket (Gauche) - Vaisseau Amiral Indépendant
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Philo Pocket',
                subtitle: 'Vaisseau amiral · Philosophie IPN (15 Notions)',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.primary,
                gradient: AppColors.primaryGradient,
                isActive: true,
                isLarge: true,
                badgeText: 'VAISSEAU AMIRAL (SOLO)',
                height: 380,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Philo Pocket',
                  subtitle: 'Philosophie · Vaisseau Amiral IPN Gabon',
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
                  tier1Price: '2500 FCFA/mois',
                  tier2Price: '5000 FCFA/mois',
                  tier1Amount: 2500,
                  tier2Amount: 5000,
                  tier1Key: 'platon',
                  tier2Key: 'aristote',
                  targetRoute: '/philo-pocket',
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Pôle Sciences (Droite) - Séries C & D (Maths + Physique + SVT)
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Pôle Sciences',
                subtitle: 'Maths · Physique-Chimie · S.V.T.',
                icon: Icons.science_rounded,
                color: const Color(0xFF00897B), // Vert émeraude vibrant
                isActive: true,
                isLarge: true,
                badgeText: 'SÉRIES C & D',
                height: 380,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Pôle Sciences (Séries C & D)',
                  subtitle: 'Mathématiques · Physique-Chimie · S.V.T.',
                  icon: Icons.science_rounded,
                  color: const Color(0xFF00897B),
                  description:
                      'Mutualisation complète des 3 matières scientifiques fondamentales du Bac gabonais : algèbre, géométrie, cinématique, réactions chimiques, immunologie et génétique.',
                  freePioneer: 'Thalès, Marie Curie & Darwin',
                  freePioneerDetails: 'Fiches de cours intégrales, formules clés, protocoles et quiz de base 100% gratuits pour toutes les matières scientifiques.',
                  tier1Pioneer: 'Galilée & Newton',
                  tier1Details: 'TD d\'approfondissement pas-à-pas, réactions chimiques expliquées, résolutions guidées et quiz illimités pour tout le pôle.',
                  tier2Pioneer: 'Albert Einstein',
                  tier2Details: 'Annales officielles corrigées des Séries C et D, coaching d\'excellence, simulations d\'examen, IA ALECKSE avancée et mode hors ligne.',
                  isPole: true,
                  hasTwoPaidTiers: true,
                  poleBadge: 'PÔLE SCIENCES C & D',
                  poleIncludedSubjects: 'Maths + Physique + SVT',
                  tier1Price: '2500 FCFA/mois',
                  tier2Price: '5000 FCFA/mois',
                  tier1Amount: 2500,
                  tier2Amount: 5000,
                  tier1Key: 'pack_pole_sciences_essentiel',
                  tier2Key: 'pack_pole_sciences_confort',
                  tier1Subtitle: 'Pack Essentiel Pôle Sciences (Maths + Physique + SVT)',
                  tier2Subtitle: 'Pack Confort Pôle Sciences (Examen & Annales C/D)',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 2. SECTION INTERMÉDIAIRE : Pôle Littérature & Langues & Pôle Économique
        Row(
          children: [
            // Pôle Littérature & Langues (Séries A & Collège) - Palier Unique 2 500 F
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Pôle Littérature & Langues',
                subtitle: 'Français · Anglais · Espagnol · Allemand',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFFE65100), // Orange ambré
                isActive: true,
                badgeText: 'SÉRIES A · 2 500 F',
                height: 200,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Pôle Littérature & Langues',
                  subtitle: 'Français · Anglais (LV1) · Espagnol (LV2) · Allemand (LV2)',
                  icon: Icons.menu_book_rounded,
                  color: const Color(0xFFE65100),
                  description:
                      'Excellence littéraire et linguistique : méthodologie du commentaire composé, dissertation, contraction de texte, grammaire et expression en langues vivantes.',
                  freePioneer: 'Montesquieu & Césaire',
                  freePioneerDetails: 'Synthèses d\'œuvres au programme IPN, méthodologies de base et fiches grammaticales libres et 100% gratuites.',
                  tier1Pioneer: 'Victor Hugo & Senghor',
                  tier1Details: 'Ateliers d\'écriture guidés, modèles rédigés de dissertations d\'excellence, annales corrigées du Baccalauréat Série A et renforcement en langues vivantes.',
                  isPole: true,
                  hasTwoPaidTiers: false,
                  poleBadge: 'PÔLE LITTÉRAIRE & LANGUES',
                  poleIncludedSubjects: 'Français + Anglais + Espagnol + Allemand',
                  tier1Price: '2500 FCFA/mois',
                  tier1Amount: 2500,
                  tier1Key: 'pack_pole_litteraire',
                  tier1Subtitle: 'Pack Unique Littéraire & Langues (Français + LV1 + LV2)',
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Pôle Économique & Sciences Humaines (Série B) - Palier Unique 2 500 F
            Expanded(
              flex: 1,
              child: _buildSubjectCard(
                context,
                title: 'Pôle Économique & Humain',
                subtitle: 'Histoire-Géo · Économie (S.E.S)',
                icon: Icons.trending_up_rounded,
                color: const Color(0xFF0288D1), // Bleu océan
                isActive: true,
                badgeText: 'SÉRIE B · 2 500 F',
                height: 200,
                onTap: () => _showDisciplinePioneersModal(
                  context,
                  title: 'Pôle Économique & Sciences Humaines',
                  subtitle: 'Histoire-Géographie & Économie (S.E.S)',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFF0288D1),
                  description:
                      'Histoire contemporaine du Gabon, mondialisation, géographie spatiale et mécanismes macroéconomiques au programme de la Série B.',
                  freePioneer: 'Hérodote & Adam Smith',
                  freePioneerDetails: 'Repères historiques essentiels, fiches géographiques du Gabon et définitions macroéconomiques gratuites.',
                  tier1Pioneer: 'Keynes & Cheikh Anta Diop',
                  tier1Details: 'Méthodologie de dissertation historique, analyse de documents statistiques, cartes géopolitiques et dossiers complets du Bac B.',
                  isPole: true,
                  hasTwoPaidTiers: false,
                  poleBadge: 'PÔLE ÉCONOMIQUE & HIST-GÉO',
                  poleIncludedSubjects: 'Histoire-Géo + S.E.S',
                  tier1Price: '2500 FCFA/mois',
                  tier1Amount: 2500,
                  tier1Key: 'pack_pole_eco',
                  tier1Subtitle: 'Pack Unique Économique & Hist-Géo (Série B)',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 3. GRANDE CARTE : FILIÈRES TECHNIQUES & PROFESSIONNELLES (Lycées Techniques & CET)
        _buildTechnicalStreamBanner(context),
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
    String tier2Pioneer = 'Aristote',
    String tier2Details = '',
    bool hasTwoPaidTiers = true,
    String? targetRoute,
    bool isPole = false,
    bool isTechnique = false,
    String tier1Price = '2500 FCFA/mois',
    String tier2Price = '5000 FCFA/mois',
    int tier1Amount = 2500,
    int tier2Amount = 5000,
    String? tier1Subtitle,
    String? tier2Subtitle,
    String? poleBadge,
    String? poleIncludedSubjects,
    String tier1Key = 'platon',
    String tier2Key = 'aristote',
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
              if (isTechnique)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFF1E3A8A).withValues(alpha: 0.25)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.school_rounded, color: Color(0xFF1E3A8A), size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🎯 Enseignement Supérieur Sans Ambages & Emploi',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'En découvrant tôt l\'ensemble des offres de formation, l\'élève choisit le technique à temps. Les disciplines d\'ingénierie et d\'atelier acquises au secondaire lui permettent d\'aborder le supérieur avec fluidité, là où les étudiants issus du général les découvrent tardivement avec difficulté.',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textDark,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                    if (isTechnique) ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                context.push('/ipn?category=STMG');
                              },
                              icon: const Icon(Icons.business_center_rounded, size: 16),
                              label: const Text('📋 STMG Tronc & Projet'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.socrateGreen,
                                side: const BorderSide(color: AppColors.socrateGreen),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(ctx);
                                context.push('/ipn?category=Bac Pro');
                              },
                              icon: const Icon(Icons.work_outline_rounded, size: 16),
                              label: const Text('📋 Bac Pro TGA'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.socrateGreen,
                                side: const BorderSide(color: AppColors.socrateGreen),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ] else
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

              // 2. OFFRES DE FORMATION SUPPLÉMENTAIRES (PALIERS PIONNIERS AVEC LEURS PRIX)
              Text(
                isPole
                    ? (hasTwoPaidTiers
                        ? 'Offres de formation mutualisées (Pôle $title) : 2 Paliers (2 500 F & 5 000 F)'
                        : 'Offre de formation mutualisée (Pôle $title) : Palier Unique (2 500 FCFA/mois)')
                    : (isTechnique
                        ? 'Offres de formation Lycées Techniques & CET :'
                        : 'Offres de formation Philo Pocket (Vaisseau Amiral Solo) :'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                isPole
                    ? (hasTwoPaidTiers
                        ? 'Toutes les matières du pôle ($poleIncludedSubjects) sont regroupées dans ces formules : pas de surcoût par matière !'
                        : 'Toutes les matières du pôle ($poleIncludedSubjects) sont réunies dans ce palier unique à 2 500 FCFA/mois.')
                    : (isTechnique
                        ? 'Modules de renforcement d\'atelier et technologiques (Minimum strict de 3 000 FCFA respecté).'
                        : 'Accompagnement philosophique d\'excellence pour toutes les séries de Terminale.'),
                style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.3),
              ),
              const SizedBox(height: 12),

              // Palier 1 (Essentiel ou Palier Unique) - Orange un peu rose
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.platonCoral.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.platonCoral, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                                      hasTwoPaidTiers
                                          ? 'Palier $tier1Pioneer (Essentiel)'
                                          : 'Palier $tier1Pioneer (Palier Unique)',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.platonCoral),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.platonCoral,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      tier1Price,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                tier1Subtitle ?? (hasTwoPaidTiers ? 'Pack Essentiel · Renforcement méthodologique & suivi parents' : 'Pack Unique · Formation complète mutualisée'),
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                              ),
                              const SizedBox(height: 4),
                              Text(tier1Details, style: const TextStyle(fontSize: 11.5, color: Colors.black87, height: 1.3)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          MobileMoneyPaymentModal.show(
                            context,
                            tierTitle: hasTwoPaidTiers
                                ? 'Palier $tier1Pioneer (Essentiel - $title)'
                                : 'Palier $tier1Pioneer (Palier Unique - $title)',
                            tierKey: tier1Key,
                            amountFcfa: tier1Amount,
                            onSuccess: () => context.go('/hub'),
                          );
                        },
                        icon: const Icon(Icons.bolt_rounded, size: 16),
                        label: Text(hasTwoPaidTiers
                            ? 'Choisir le Palier Essentiel ($tier1Price)'
                            : 'Choisir le Palier Unique ($tier1Price)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.platonCoral,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Palier 2 (Confort) - Violet (affiché uniquement si hasTwoPaidTiers est vrai)
              if (hasTwoPaidTiers)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.aristoteViolet.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.aristoteViolet.withValues(alpha: 0.45), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                      child: Text(
                                        tier2Price,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  tier2Subtitle ?? 'Pack Confort · Coaching d\'excellence, Bac blanc ALECKSE & Mode hors-ligne',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                                ),
                                const SizedBox(height: 4),
                                Text(tier2Details, style: const TextStyle(fontSize: 11.5, color: Colors.black87, height: 1.3)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            MobileMoneyPaymentModal.show(
                              context,
                              tierTitle: 'Palier $tier2Pioneer (Confort - $title)',
                              tierKey: tier2Key,
                              amountFcfa: tier2Amount,
                              onSuccess: () => context.go('/hub'),
                            );
                          },
                          icon: const Icon(Icons.star_rounded, size: 16),
                          label: Text('Choisir le Palier Confort ($tier2Price)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.aristoteViolet,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
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
                  icon: const Icon(Icons.all_inclusive_rounded, size: 16),
                  label: const Text('📦 Découvrir tous les Packages, Trimestres & Packs Annuels'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 11),
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
    String? badgeText,
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
                                fontSize: isLarge ? 22 : null,
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
                    color: Colors.black.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, color: Colors.white, size: 11),
                      const SizedBox(width: 4),
                      Text(
                        badgeText ?? 'Gratuit IPN',
                        style: const TextStyle(
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

  static Widget _buildTechChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildTechnicalStreamBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.5),
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
          onTap: () => _showDisciplinePioneersModal(
            context,
            title: 'Enseignement Technique & Professionnel',
            subtitle: '7 Filières, 43 Séries de Bac & 5 Examens Pros (CAP, BEP, BT...)',
            icon: Icons.engineering_rounded,
            color: const Color(0xFF1E3A8A),
            description:
                'Panorama officiel DGEC 2026 : Baccalauréat des Sciences de l\'Ingénieur (SI), STI (Génie Mécanique F1/F1C/F1D, Électronique F2, Électrotechnique F3, Génie Civil F4, AEC, ERE), STT (ACA, CG, ACC / ex-G1, G2, G3), STMG (CFE, RHC, GSI, Mercatique), STL (Biotech, SPCL, BGB, CLPI), 15 Bac Pro, STA Agricole, et cycle moyen CAP, BEP, BT (Froid, Diesel), DENC.',
            freePioneer: 'Archimède (Syllabus & Ateliers)',
            freePioneerDetails: 'Fiches d\'initiation aux ateliers, panorama des filières et fiches méthodologiques 100% gratuites.',
            tier1Pioneer: 'Léonard de Vinci (Essentiel Pro)',
            tier1Details: 'Cours technologiques complets, schémas techniques industriels cotés, QCM d\'atelier et tuteur IA ALECKSE Pro.',
            tier2Pioneer: 'Gustave Eiffel (Confort & TP Ateliers)',
            tier2Details: 'Guides complets de TP d\'atelier, annales corrigées du Baccalauréat Technologique (CGBT) & CAP, préparation pratique aux lycées techniques.',
            isTechnique: true,
            tier1Price: '3000 FCFA/mois',
            tier2Price: '6000 FCFA/mois',
            tier1Amount: 3000,
            tier2Amount: 6000,
            tier1Key: 'leonard_de_vinci',
            tier2Key: 'gustave_eiffel',
            tier1Subtitle: 'Pack Essentiel Pro (Min. strict 3 000 FCFA respecté)',
            tier2Subtitle: 'Pack Confort Ateliers & Annales CGBT/CAP',
          ),
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.engineering_rounded, color: Colors.white, size: 30),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD97706),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.precision_manufacturing_rounded, color: Colors.white, size: 13),
                          SizedBox(width: 4),
                          Text(
                            'LYCÉES TECHNIQUES & CET GABON',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Filières Techniques & Professionnelles',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lycée Technique Omar Bongo (LTNOB), Léconi, Bikélé, Nkok & CET (Dès la 4e)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_rounded, color: Colors.amberAccent, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Vulgarisation précoce : Choisir le technique à temps permet de maîtriser l\'ingénierie dès l\'adolescence pour aborder le supérieur sans ambages et garantir l\'adéquation formation-emploi.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildTechChip('7 Filières & 43 Séries de Bac'),
                    _buildTechChip('SI & STI (F1 à F4, AEC, ERE)'),
                    _buildTechChip('STT & STMG (Tertiaire)'),
                    _buildTechChip('STL (Léconi) & 15 Bac Pro'),
                    _buildTechChip('1er Cycle : CAP, BEP, BT, DENC'),
                    _buildTechChip('Dès 3 000 F/mois'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showDisciplinePioneersModal(
                          context,
                          title: 'Enseignement Technique & Professionnel',
                          subtitle: '7 Filières, 43 Séries de Bac & 5 Examens Pros (CAP, BEP, BT...)',
                          icon: Icons.engineering_rounded,
                          color: const Color(0xFF1E3A8A),
                          description:
                              'Panorama officiel DGEC 2026 : Baccalauréat des Sciences de l\'Ingénieur (SI), STI (Génie Mécanique F1/F1C/F1D, Électronique F2, Électrotechnique F3, Génie Civil F4, AEC, ERE), STT (ACA, CG, ACC / ex-G1, G2, G3), STMG (CFE, RHC, GSI, Mercatique), STL (Biotech, SPCL, BGB, CLPI), 15 Bac Pro, STA Agricole, et cycle moyen CAP, BEP, BT (Froid, Diesel), DENC.',
                          freePioneer: 'Archimède (Syllabus & Ateliers)',
                          freePioneerDetails: 'Fiches d\'initiation aux ateliers, panorama des filières et fiches méthodologiques 100% gratuites.',
                          tier1Pioneer: 'Léonard de Vinci (Essentiel Pro)',
                          tier1Details: 'Cours technologiques complets, schémas techniques industriels cotés, QCM d\'atelier et tuteur IA ALECKSE Pro.',
                          tier2Pioneer: 'Gustave Eiffel (Confort & TP Ateliers)',
                          tier2Details: 'Guides complets de TP d\'atelier, annales corrigées du Baccalauréat Technologique (CGBT) & CAP, préparation pratique aux lycées techniques.',
                          isTechnique: true,
                          tier1Price: '3000 FCFA/mois',
                          tier2Price: '6000 FCFA/mois',
                          tier1Amount: 3000,
                          tier2Amount: 6000,
                          tier1Key: 'leonard_de_vinci',
                          tier2Key: 'gustave_eiffel',
                          tier1Subtitle: 'Pack Essentiel Pro (Min. strict 3 000 FCFA respecté)',
                          tier2Subtitle: 'Pack Confort Ateliers & Annales CGBT/CAP',
                        ),
                        icon: const Icon(Icons.card_membership_rounded, size: 16),
                        label: const Text('Offres de Formation Technique'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF1E3A8A),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () => context.push('/hub?tab=1'),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('Explorer les Ateliers'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white70),
                        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  void _showEvaAcademyInfoModal(BuildContext context, StudentState studentState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: ListView(
            controller: scrollController,
            children: [
              // Poignée de glissement
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header Académie EVA
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A4C93), Color(0xFF1E3A8A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.workspace_premium_rounded,
                        color: Colors.amber, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Académie EVA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        Text(
                          'Excelle Virtual Academy · Gamification du Savoir',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Carte Statut Actuel de l'Élève
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'VOTRE GRADE ACADÉMIQUE',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              studentState.statutEva,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.stars_rounded, color: Colors.black, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                '${studentState.creditsEva} Crédits',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 8),
                    const Text(
                      'L\'Académie EVA récompense votre assiduité réelle et la rigueur de vos révisions. Les points s\'obtiennent par l\'effort scolaire continu.',
                      style: TextStyle(color: Colors.white70, fontSize: 11.5, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Comment progresser dans l\'Académie EVA ?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),

              _buildEvaPerkTile(
                icon: Icons.menu_book_rounded,
                color: const Color(0xFF00897B),
                title: 'Lire une fiche de synthèse officielle',
                points: '+25 Crédits EVA',
                description: 'Maîtrisez les notions fondamentales du programme gabonais.',
              ),
              _buildEvaPerkTile(
                icon: Icons.quiz_rounded,
                color: const Color(0xFFE65100),
                title: 'Réussir un Quiz d\'évaluation IPN',
                points: '+30 Crédits EVA',
                description: 'Testez votre compréhension immédiate après chaque chapitre.',
              ),
              _buildEvaPerkTile(
                icon: Icons.assignment_turned_in_rounded,
                color: const Color(0xFF6A4C93),
                title: 'Résoudre un sujet d\'examen blanc',
                points: '+50 Crédits EVA',
                description: 'Entraînez-vous sur les annales officielles avec correction pas-à-pas.',
              ),
              _buildEvaPerkTile(
                icon: Icons.local_fire_department_rounded,
                color: Colors.orange,
                title: 'Assiduité quotidienne continue',
                points: 'Bonus Série Flamme 🔥',
                description: 'Revenez réviser chaque jour pour maximiser vos multiplicateurs.',
              ),

              const SizedBox(height: 16),
              const Text(
                'Échelons de l\'Académie EVA',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),

              _buildGradeStep(title: 'Initié 🌱', points: '0 à 99 Crédits', desc: 'Découverte des programmes et fiches libres.'),
              _buildGradeStep(title: 'Apprenti ⭐', points: '100 à 199 Crédits', desc: 'Régularité confirmée et premiers quiz réussis.'),
              _buildGradeStep(title: 'Disciple ⭐⭐', points: '200 à 349 Crédits', desc: 'Méthodologie solide et devoirs surveillés réguliers.'),
              _buildGradeStep(title: 'Maître ⭐⭐⭐', points: '350+ Crédits', desc: 'Excellence méthodologique et maîtrise des annales d\'examen.'),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/subscription-choice');
                  },
                  icon: const Icon(Icons.workspace_premium_rounded),
                  label: const Text('Découvrir les formules & bonus EVA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvaPerkTile({
    required IconData icon,
    required Color color,
    required String title,
    required String points,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                    ),
                    Text(
                      points,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: color,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeStep({required String title, required String points, required String desc}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline_rounded, color: Color(0xFF1E3A8A), size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
          ),
          const SizedBox(width: 6),
          Text(
            '($points) :',
            style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              desc,
              style: const TextStyle(fontSize: 11.5, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}

