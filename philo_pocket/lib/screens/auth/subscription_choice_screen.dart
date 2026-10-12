import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/supabase_service.dart';
import 'mobile_money_payment_modal.dart';

class SubscriptionChoiceScreen extends StatefulWidget {
  final String targetDiscipline;
  
  const SubscriptionChoiceScreen({
    Key? key, 
    this.targetDiscipline = 'philo',
  }) : super(key: key);

  @override
  State<SubscriptionChoiceScreen> createState() => _SubscriptionChoiceScreenState();
}

class _SubscriptionChoiceScreenState extends State<SubscriptionChoiceScreen> {
  bool _isLoading = false;
  int _selectedTab = 0; // 0: Formules Mensuelles (Pionniers), 1: Packages & Bundles

  void _onSelectPlan({
    required String tierKey,
    required String tierTitle,
    required int amountFcfa,
  }) {
    if (amountFcfa == 0 ||
        tierKey == 'gratuit' ||
        tierKey == 'socrate' ||
        tierKey == 'archimede') {
      _activateFreeSubscription(tierKey);
    } else {
      MobileMoneyPaymentModal.show(
        context,
        tierTitle: tierTitle,
        tierKey: tierKey,
        amountFcfa: amountFcfa,
        onSuccess: () {
          if (mounted) {
            context.go('/hub');
          }
        },
      );
    }
  }

  Future<void> _activateFreeSubscription(String tierKey) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await SupabaseService().updateSubscription(tierKey);
      if (mounted) {
        // Redirige vers le hub
        context.go('/hub');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSubscriptionCard(
    BuildContext context, {
    required String title,
    String? subtitle,
    required String price,
    String? billingPeriod,
    required List<String> features,
    required Color color,
    required IconData icon,
    required String tierKey,
    int amountFcfa = 0,
    bool isPopular = false,
    String? badgeText,
  }) {
    final effectiveBadge = badgeText ?? (isPopular ? 'LE PLUS CHOISI' : null);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isPopular || badgeText != null)
              ? color
              : AppColors.border.withValues(alpha: 0.5),
          width: (isPopular || badgeText != null) ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _isLoading
              ? null
              : () => _onSelectPlan(
                    tierKey: tierKey,
                    tierTitle: title,
                    amountFcfa: amountFcfa,
                  ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (effectiveBadge != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      effectiveBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textDark,
                                  fontSize: 18,
                                ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            price,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (billingPeriod != null)
                            Text(
                              billingPeriod,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                    _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.arrow_forward_ios_rounded,
                            color: AppColors.border),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                ...features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: color, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                color: AppColors.textDark,
                                fontSize: 13.5,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 14, bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Détection si la demande concerne l'enseignement technique & professionnel
    final isTechnique = widget.targetDiscipline == 'technique' ||
        widget.targetDiscipline == 'technique_pro' ||
        widget.targetDiscipline.startsWith('f') ||
        widget.targetDiscipline.startsWith('sti') ||
        widget.targetDiscipline.startsWith('stmg') ||
        widget.targetDiscipline.startsWith('stl') ||
        widget.targetDiscipline.startsWith('cet') ||
        widget.targetDiscipline == 'pro';

    // Noms, sous-noms et prix des paliers historiques (Philo Pocket & Enseignement Général)
    String tier1Name = 'Socrate';
    String? tier1Subtitle;
    String tier2Name = 'Platon';
    String? tier2Subtitle;
    String tier3Name = 'Aristote';
    String? tier3Subtitle;
    bool showTier3 = true;
    String subjectName = "la philosophie";

    int tier2Amount = 2500;
    int tier3Amount = 5000;
    String tier1Price = 'Gratuit';
    String tier2Price = '2500 FCFA/mois (Essentiel)';
    String tier3Price = '5000 FCFA/mois (Confort)';
    String tier1Key = 'socrate';
    String tier2Key = 'platon';
    String tier3Key = 'aristote';

    Color tier1Color = AppColors.socrateGreen;   // Vert foncé (0xFF1B5E20)
    Color tier2Color = AppColors.platonCoral;    // Orange un peu rose / Corail (0xFFE06D53)
    Color tier3Color = AppColors.aristoteViolet; // Violet (0xFF6A4C93)

    IconData tier1Icon = Icons.menu_book_rounded;
    IconData tier2Icon = Icons.psychology_rounded;
    IconData tier3Icon = Icons.military_tech_rounded;

    String? tier2Badge = 'LE PLUS CHOISI';
    String? tier3Badge;

    List<String> tier1Features = [
      'Accès aux fiches de cours',
      'Méthodologie IPN de base',
      '1 quiz d\'évaluation par notion',
      'ALECKSE basique',
    ];

    List<String> tier2Features = [
      'Tout le contenu Socrate',
      'Quiz illimités pour s\'entraîner',
      'Suivi détaillé de la progression',
      'Bulletin hebdomadaire pour les parents',
    ];

    List<String> tier3Features = [
      'Tout le contenu Platon',
      'Mythes philosophiques en 3D',
      'TP et Ateliers pratiques',
      'Dialogue direct avec les grands philosophes',
      'Bac blanc corrigé par ALECKSE avancé',
      'Mode hors ligne',
    ];

    // MODÈLE ÉCONOMIQUE TECHNIQUE : PIONNIERS DE L'INGÉNIERIE & MINIMUM 3000 FCFA
    if (isTechnique) {
      tier1Name = 'Archimède';
      tier1Subtitle = null;
      tier2Name = 'Léonard de Vinci';
      tier2Subtitle = null;
      tier3Name = 'Gustave Eiffel';
      tier3Subtitle = null;
      showTier3 = true;
      subjectName = "l'enseignement technique & professionnel";

      tier2Amount = 3000; // Minimum strict de 3 000 FCFA
      tier3Amount = 6000; // Palier supérieur atelier
      tier1Price = 'Gratuit';
      tier2Price = '3000 FCFA/mois (Essentiel Pro)';
      tier3Price = '6000 FCFA/mois (Confort & Ateliers)';
      tier1Key = 'archimede';
      tier2Key = 'leonard_de_vinci';
      tier3Key = 'gustave_eiffel';

      tier1Color = AppColors.socrateGreen;
      tier2Color = AppColors.platonCoral;
      tier3Color = AppColors.aristoteViolet;

      tier1Icon = Icons.handyman_rounded;
      tier2Icon = Icons.precision_manufacturing_rounded;
      tier3Icon = Icons.engineering_rounded;
      tier2Badge = 'LE PLUS CHOISI (PRO)';

      tier1Features = [
        'Syllabus officiel & fiches d\'initiation aux ateliers',
        'Panorama complet des filières industrielles & débouchés au Gabon',
        '1 fiche méthodologique par module technologique',
        'Accès à la communauté technique PhiloPocket',
      ];

      tier2Features = [
        'Tout le contenu Archimède',
        'Cours théoriques & technologiques complets (STI, STL, STMG, CET dès la 4e)',
        'Schémas techniques industriels & dessins cotés aux normes',
        'ALECKSE IA Assistant Technique spécialisé d\'atelier',
        'QCM industriels & situations-problèmes d\'atelier illimités',
        'Rapport de compétences pour les parents',
      ];

      tier3Features = [
        'Tout le contenu Léonard de Vinci',
        'Guides complets de Travaux Pratiques (TP) & protocoles d\'atelier',
        'Annales officielles corrigées du Baccalauréat Technologique (CGBT) & CAP',
        'Préparation aux épreuves pratiques (LTNOB, Léconi, Bikélé, Nkok)',
        'Correction IA pas-à-pas des calculs appliqués, RDM et schémas',
        'Mode hors-ligne pour réviser à l\'atelier sans connexion Internet',
      ];
    } else if (widget.targetDiscipline == 'science') {
      tier1Name = 'Thalès & Pythagore';
      tier2Name = 'Archimède';
      tier3Name = 'Isaac Newton';
      tier1Price = 'Gratuit';
      tier2Price = '2500 FCFA/mois (Essentiel)';
      tier3Price = '5000 FCFA/mois (Confort)';
      tier1Color = AppColors.socrateGreen;
      tier2Color = AppColors.platonCoral;
      tier3Color = AppColors.aristoteViolet;
      tier1Icon = Icons.calculate_rounded;
      tier2Icon = Icons.science_rounded;
      tier3Icon = Icons.military_tech_rounded;
      tier2Badge = 'LE PLUS CHOISI';
      subjectName = "les sciences & mathématiques";
      tier1Features = [
        'Accès aux fiches de cours & formules fondamentales',
        'Méthodologie IPN de base',
        '1 quiz d\'évaluation par notion',
        'ALECKSE basique',
      ];
      tier2Features = [
        'Tout le contenu gratuit',
        'TD dirigés & résolutions pas-à-pas',
        'Quiz illimités pour s\'entraîner',
        'Bulletin hebdomadaire pour les parents',
      ];
      tier3Features = [
        'Tout le contenu Essentiel',
        'Annales officielles résolues du Baccalauréat',
        'Simulations d\'épreuves complexes',
        'ALECKSE résolveur d\'exercices avancé',
        'Mode hors ligne',
      ];
    } else if (widget.targetDiscipline == 'litterature' || widget.targetDiscipline == 'francais') {
      tier1Name = 'Montesquieu';
      tier2Name = 'Victor Hugo & Senghor';
      showTier3 = false; // Un seul palier payant pour la Littérature et Langues (2 500 FCFA)
      tier1Price = 'Gratuit';
      tier2Price = '2500 FCFA/mois (Palier Unique)';
      tier2Amount = 2500;
      tier2Key = 'pack_pole_litteraire';
      tier1Color = AppColors.socrateGreen;
      tier2Color = AppColors.platonCoral;
      tier1Icon = Icons.menu_book_rounded;
      tier2Icon = Icons.edit_note_rounded;
      tier2Badge = 'PALIER UNIQUE 2 500 F';
      subjectName = "le français & la littérature";
      tier1Features = [
        'Accès aux synthèses d\'œuvres & fiches d\'auteurs',
        'Méthodologie IPN de base (Commentaire & Dissertation)',
        '1 quiz d\'évaluation par œuvre',
        'ALECKSE basique',
      ];
      tier2Features = [
        'Tout le contenu gratuit Montesquieu',
        'Synthèses intégrales des œuvres littéraires au programme IPN',
        'Méthodologie guidée du commentaire composé & dissertation',
        'Modèles rédigés de dissertations d\'excellence avec citations clés',
        'Règles de grammaire, vocabulaire & compréhension pour les langues',
        'Annales officielles corrigées du Baccalauréat Série A gabonais',
        'ALECKSE IA correcteur de style et d\'argumentation',
        'Mode hors-ligne complet',
      ];
    } else if (widget.targetDiscipline == 'economie') {
      tier1Name = 'Hérodote & Adam Smith';
      tier2Name = 'Keynes & Cheikh Anta Diop';
      showTier3 = false; // Un seul palier payant pour le Pôle Économie & SHS (2 500 FCFA)
      tier1Price = 'Gratuit';
      tier2Price = '2500 FCFA/mois (Palier Unique)';
      tier2Amount = 2500;
      tier2Key = 'pack_pole_eco';
      tier1Color = AppColors.socrateGreen;
      tier2Color = AppColors.platonCoral;
      tier1Icon = Icons.trending_up_rounded;
      tier2Icon = Icons.analytics_rounded;
      tier2Badge = 'PALIER UNIQUE 2 500 F';
      subjectName = "l'économie (S.E.S) & Histoire-Géo";
      tier1Features = [
        'Définitions macroéconomiques & fiches IPN',
        'Repères historiques essentiels du Gabon et du monde',
        'Méthodologie de base du raisonnement économique',
        '1 quiz d\'évaluation par chapitre',
        'ALECKSE basique',
      ];
      tier2Features = [
        'Tout le contenu gratuit',
        'Méthodologie du raisonnement économique et commentaire de documents',
        'Annales officielles résolues du Bac B gabonais (Éco & Histoire-Géo)',
        'Cartographie, schémas géographiques & études de cas contemporaines',
        'Analyses approfondies des mutations socio-économiques',
        'ALECKSE IA pour structurer vos argumentaires économiques',
        'Mode hors-ligne complet',
      ];
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Choisissez votre formule'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            Text(
              'Débloquez tout le potentiel pour $subjectName avec la formule qui vous correspond.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Information Tarification Technique & Règle des 3 000 FCFA
            if (isTechnique)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_rounded,
                        color: Color(0xFF1E3A8A), size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Paliers Pionniers & Packages Techniques : Minimum strict de 3 000 FCFA par formule payante.',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // =================================================================
            // SÉLECTEUR D'ONGLETS : PALIERS PIONNIERS VS PACKAGES & BUNDLES
            // =================================================================
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _selectedTab == 0
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.psychology_rounded,
                              size: 18,
                              color: _selectedTab == 0
                                  ? (isTechnique
                                      ? const Color(0xFF1E3A8A)
                                      : AppColors.primary)
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isTechnique
                                  ? '🎯 Filières Techniques & Pro'
                                  : '🎯 Philo Pocket (Solo Vaisseau Amiral)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 0
                                    ? AppColors.textDark
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _selectedTab == 1
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.all_inclusive_rounded,
                              size: 18,
                              color: _selectedTab == 1
                                  ? const Color(0xFFD97706)
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '📦 Packages de Pôle & Filières',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 1
                                    ? AppColors.textDark
                                    : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =================================================================
            // CONTENU ONGLET 0 : FORMULES SOLO (À LA CARTE)
            // =================================================================
            if (_selectedTab == 0) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 20, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isTechnique
                            ? 'Filières Techniques & Professionnelles (LTNOB, Léconi, Bikélé, CET dès la 4e) : Paliers Archimède (Gratuit), Léonard de Vinci (3 000 F/mois) et Gustave Eiffel (6 000 F/mois). Minimum légal de 3 000 F respecté pour les paliers payants.'
                            : 'Philo Pocket est le vaisseau amiral 100% indépendant : la Philosophie ne se mélange à aucune autre matière et fonctionne en solo avec ses 3 paliers d\'excellence (Socrate gratuit, Platon 2 500 F, Aristote 5 000 F). Retrouvez les autres matières réunies par pôles dans l\'onglet Packages ci-contre.',
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textDark, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              _buildSubscriptionCard(
                context,
                title: tier1Name,
                subtitle: tier1Subtitle,
                price: tier1Price,
                billingPeriod: null,
                color: tier1Color,
                icon: tier1Icon,
                tierKey: tier1Key,
                amountFcfa: 0,
                features: tier1Features,
              ),
              _buildSubscriptionCard(
                context,
                title: tier2Name,
                subtitle: tier2Subtitle,
                price: tier2Price,
                billingPeriod: null,
                color: tier2Color,
                icon: tier2Icon,
                isPopular: true,
                badgeText: tier2Badge,
                tierKey: tier2Key,
                amountFcfa: tier2Amount,
                features: tier2Features,
              ),
              if (showTier3)
                _buildSubscriptionCard(
                  context,
                  title: tier3Name,
                  subtitle: tier3Subtitle,
                  price: tier3Price,
                  billingPeriod: null,
                  color: tier3Color,
                  icon: tier3Icon,
                  badgeText: tier3Badge,
                  tierKey: tier3Key,
                  amountFcfa: tier3Amount,
                  features: tier3Features,
                ),
            ],

            // =================================================================
            // CONTENU ONGLET 1 : PACKAGES & BUNDLES (OFFRES GROUPÉES)
            // =================================================================
            if (_selectedTab == 1) ...[
              // Information pedagogique sur les Poles
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFD97706).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD97706).withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Color(0xFFD97706), size: 22),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Pôles d\'Excellence & Filières : Choisissez votre pack mutualisé (Sciences, Littérature & Langues, Économie, ou Technique & Pro). En enseignement général, il n\'y a que deux tarifs pour deux paliers : 2 500 F et 5 000 F (seuls la Philo et les Sciences ont 2 paliers en raison des niveaux de difficulté ; la Littérature et l\'Éco ont un palier unique à 2 500 F). Seules les matières du Technique sont à 3 000 F et 6 000 F. Philo Pocket reste 100% solo et indépendant dans le 1er onglet.',
                        style: TextStyle(fontSize: 11.5, color: AppColors.textDark, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),

              // ===============================================================
              // 1. PÔLE SCIENCES (SÉRIES C & D) : 2 PALIERS PAYANTS (2 500 & 5 000 F)
              // ===============================================================
              _buildSectionHeader(
                title: '🔬 PÔLE SCIENCES (SÉRIES C & D)',
                subtitle: 'Mathématiques + Physique-Chimie + S.V.T. mutualisées (2 Paliers)',
                icon: Icons.science_rounded,
                color: const Color(0xFF00897B),
              ),

              // Palier Essentiel Sciences (2 500 FCFA / mois)
              _buildSubscriptionCard(
                context,
                title: 'Pôle Sciences · Palier Essentiel (Galilée & Newton)',
                subtitle: 'Socle scientifique renforcé sur les 3 matières du pôle',
                price: '2 500 FCFA / mois',
                billingPeriod: 'Maths + Physique-Chimie + SVT réunies (2 500 FCFA / mois)',
                badgeText: 'PÔLE SCIENCES · ESSENTIEL',
                color: const Color(0xFF00897B),
                icon: Icons.science_rounded,
                tierKey: 'pack_pole_sciences_essentiel',
                amountFcfa: 2500,
                features: [
                  'Débloque les 3 matières phares du Bac scientifique (Maths, Physique-Chimie, SVT)',
                  'Formulaires complets & synthèses de cours conformes IPN',
                  'TD d\'exercices résolus et méthodes de raisonnement scientifique',
                  'ALECKSE IA tuteur scientifique polyvalent sur les 3 disciplines',
                  'Quiz d\'auto-évaluation réguliers par chapitre',
                ],
              ),

              // Palier Confort Sciences (5 000 FCFA / mois)
              _buildSubscriptionCard(
                context,
                title: 'Pôle Sciences · Palier Confort (Albert Einstein)',
                subtitle: 'Préparation d\'excellence intégrale au Baccalauréat C & D',
                price: '5 000 FCFA / mois',
                billingPeriod: 'Toutes les matières scientifiques en formule d\'excellence',
                badgeText: 'PÔLE SCIENCES · CONFORT (EXCELLENCE)',
                isPopular: true,
                color: AppColors.aristoteViolet,
                icon: Icons.military_tech_rounded,
                tierKey: 'pack_pole_sciences_confort',
                amountFcfa: 5000,
                features: [
                  'Tout le contenu Essentiel Sciences',
                  'Annales officielles résolues du Baccalauréat C & D gabonais',
                  'Problèmes de synthèse avancés & simulations d\'épreuves types',
                  'ALECKSE IA résolveur d\'exercices complexes pas-à-pas',
                  'Protocoles d\'expérimentation & fiches d\'analyses de graphiques',
                  'Mode hors-ligne complet pour réviser sans connexion Internet',
                ],
              ),

              // ===============================================================
              // 2. PÔLE LITTÉRATURE & LANGUES (SÉRIES A & COLLÈGE) : PALIER UNIQUE 2 500 F
              // ===============================================================
              _buildSectionHeader(
                title: '📚 PÔLE LITTÉRATURE & LANGUES (SÉRIES A & COLLÈGE)',
                subtitle: 'Français + Anglais + Espagnol + Allemand (Palier Unique : 2 500 FCFA/mois)',
                icon: Icons.menu_book_rounded,
                color: const Color(0xFFE65100),
              ),

              // Palier Unique Littéraire & Langues (2 500 FCFA / mois)
              _buildSubscriptionCard(
                context,
                title: 'Pôle Littéraire & Langues · Palier Unique (Victor Hugo & Senghor)',
                subtitle: 'Méthodes littéraires & maîtrise complète des langues vivantes',
                price: '2 500 FCFA / mois',
                billingPeriod: 'Français + Anglais + Espagnol + Allemand réunis',
                badgeText: 'PÔLE LITTÉRAIRE · PALIER UNIQUE 2 500 F',
                color: const Color(0xFFE65100),
                icon: Icons.menu_book_rounded,
                tierKey: 'pack_pole_litteraire',
                amountFcfa: 2500,
                features: [
                  'Synthèses intégrales des œuvres littéraires au programme IPN',
                  'Méthodologie guidée du commentaire composé & de la dissertation',
                  'Modèles rédigés de dissertations d\'excellence avec citations clés',
                  'Règles de grammaire, vocabulaire et compréhension pour les langues',
                  'Annales officielles corrigées du Baccalauréat Série A gabonais',
                  'Simulations d\'épreuves écrites et orales de langues vivantes',
                  'ALECKSE IA spécialiste en expression écrite et argumentation',
                  'Mode hors-ligne complet pour réviser sans connexion Internet',
                ],
              ),

              // ===============================================================
              // 3. PÔLE ÉCONOMIQUE & SCIENCES HUMAINES (SÉRIE B) : PALIER UNIQUE 2 500 F
              // ===============================================================
              _buildSectionHeader(
                title: '📈 PÔLE ÉCONOMIQUE & SCIENCES HUMAINES (SÉRIE B)',
                subtitle: 'Histoire-Géographie + Économie (S.E.S) (Palier Unique : 2 500 FCFA/mois)',
                icon: Icons.trending_up_rounded,
                color: const Color(0xFF2E7D32),
              ),

              // Palier Unique Éco & Humain (2 500 FCFA / mois)
              _buildSubscriptionCard(
                context,
                title: 'Pôle Éco & Humain · Palier Unique (Adam Smith & Keynes)',
                subtitle: 'Analyse économique approfondie & maîtrise du Baccalauréat Série B',
                price: '2 500 FCFA / mois',
                billingPeriod: 'Histoire-Géographie + S.E.S incluses',
                badgeText: 'PÔLE ÉCO & HUMAIN · PALIER UNIQUE 2 500 F',
                color: const Color(0xFF2E7D32),
                icon: Icons.trending_up_rounded,
                tierKey: 'pack_pole_eco',
                amountFcfa: 2500,
                features: [
                  'Définitions macroéconomiques & fiches IPN en sciences économiques',
                  'Repères historiques essentiels, frises chronologiques & cartes du Gabon',
                  'Méthodologie du raisonnement économique et du commentaire de documents',
                  'Annales officielles résolues du Bac B gabonais (Économie & Histoire-Géo)',
                  'Études de cas économiques contemporaines et dissertations modèles',
                  'Analyses approfondies des mutations socio-économiques internationales',
                  'ALECKSE IA pour structurer vos plans et argumentaires économiques',
                  'Mode hors-ligne complet',
                ],
              ),

              // ===============================================================
              // 4. FILIÈRES TECHNIQUES & PROFESSIONNELLES (LYCÉES TECH & CET)
              // ===============================================================
              _buildSectionHeader(
                title: '⚙️ FILIÈRES TECHNIQUES & PROFESSIONNELLES',
                subtitle: 'Lycées Techniques (LTNOB, Léconi, Bikélé, Nkok...) & CET (Dès la 4e de métier)',
                icon: Icons.precision_manufacturing_rounded,
                color: const Color(0xFF1E3A8A),
              ),

              // Palier Léonard de Vinci (3 000 FCFA / mois - min strict)
              _buildSubscriptionCard(
                context,
                title: 'Filières Tech · Palier Léonard de Vinci (Essentiel Pro)',
                subtitle: 'Cours théoriques & technologiques de filière (Minimum strict 3 000 F)',
                price: '3 000 FCFA / mois',
                billingPeriod: 'Mensuel · Minimum strict de 3 000 FCFA respecté',
                badgeText: 'MIN. STRICT 3 000 FCFA (PRO)',
                color: const Color(0xFF0284C7),
                icon: Icons.precision_manufacturing_rounded,
                tierKey: 'leonard_de_vinci',
                amountFcfa: 3000,
                features: [
                  'Cours technologiques complets (STI, STL, STMG, CET dès la 4e de métier)',
                  'Schémas techniques industriels, cotations & plans normalisés',
                  'ALECKSE IA Assistant Technique spécialisé d\'atelier',
                  'QCM industriels & situations-problèmes d\'atelier',
                  'Renouvellement mensuel sans engagement',
                ],
              ),

              // Palier Gustave Eiffel (6 000 FCFA / mois)
              _buildSubscriptionCard(
                context,
                title: 'Filières Tech · Palier Gustave Eiffel (Confort & Ateliers TP)',
                subtitle: 'Pratique intensive en atelier & protocoles de travaux pratiques',
                price: '6 000 FCFA / mois',
                billingPeriod: 'Mensuel · Formule atelier d\'excellence',
                badgeText: 'ATELIERS & TRAVAUX PRATIQUES',
                color: const Color(0xFF1E3A8A),
                icon: Icons.engineering_rounded,
                tierKey: 'gustave_eiffel',
                amountFcfa: 6000,
                features: [
                  'Tout le contenu Léonard de Vinci',
                  'Guides complets de Travaux Pratiques (TP) & protocoles d\'atelier',
                  'Annales officielles corrigées du Baccalauréat Technologique (CGBT) & CAP',
                  'Préparation aux épreuves pratiques (LTNOB, Léconi, Bikélé, Nkok)',
                  'Correction IA pas-à-pas des calculs appliqués, RDM et schémas',
                  'Mode hors-ligne pour réviser à l\'atelier sans connexion Internet',
                ],
              ),

              // Pack Filière Complète All-in-One (6 000 FCFA / mois)
              _buildSubscriptionCard(
                context,
                title: 'Pack Filière Intégrale (All-in-One Technique)',
                subtitle: 'Toutes les matières techniques + enseignement général de la série',
                price: '6 000 FCFA / mois',
                billingPeriod: 'Toutes les matières de la filière incluses',
                badgeText: 'FORMULE TOUT-EN-UN COMPLÈTE',
                color: const Color(0xFFD97706),
                icon: Icons.account_tree_rounded,
                tierKey: 'pack_technique_filiere',
                amountFcfa: 6000,
                features: [
                  'Débloque 100% des matières de votre filière (STI, STL, STMG ou CET)',
                  'Matières technologiques ET matières générales (Maths appliquées, etc.)',
                  'Tuteur IA ALECKSE polyvalent sur l\'ensemble du cursus technique',
                  'Guides de Travaux Pratiques (TP) d\'atelier et protocoles',
                  'Rapports de compétences pour la famille',
                ],
              ),

              // Pack Trimestre Réussite Tech (8 000 FCFA / 3 mois)
              _buildSubscriptionCard(
                context,
                title: 'Pack Trimestre Réussite Tech (3 Mois)',
                subtitle: 'Forfait 90 jours pour sécuriser tout le trimestre en lycée technique',
                price: '8 000 FCFA / trimestre',
                billingPeriod: 'Paiement unique pour 3 mois (Soit 2 667 F/mois)',
                badgeText: 'ÉCONOMISEZ 1 000 FCFA · 90 JOURS',
                color: const Color(0xFF059669),
                icon: Icons.date_range_rounded,
                tierKey: 'pack_technique_trimestre',
                amountFcfa: 8000,
                features: [
                  'Accès ininterrompu pendant 3 mois consécutifs (90 jours)',
                  'Toutes les matières de la filière incluses sans restriction',
                  'Préparation ciblée aux devoirs surveillés & compositions trimestrielles',
                  'Sujets types et protocoles de validation des compétences d\'atelier',
                  'Mode hors-ligne pour réviser à l\'atelier sans data',
                ],
              ),

              // Pack Annuel Examen d'État Tech (24 000 FCFA / 9 mois)
              _buildSubscriptionCard(
                context,
                title: 'Pack Annuel Examen d\'État Tech (Bac Tech / CAP)',
                subtitle: 'Abonnement annuel intégral jusqu\'aux épreuves pratiques et écrites du Bac ou CAP',
                price: '24 000 FCFA / an',
                billingPeriod: 'Paiement unique pour 9 mois d\'année scolaire',
                badgeText: 'PACK ANNUEL TECH · ÉCONOMIE 3 000 F+',
                color: const Color(0xFF1E3A8A),
                icon: Icons.workspace_premium_rounded,
                tierKey: 'pack_technique_annuel',
                amountFcfa: 24000,
                features: [
                  'Accès garanti 9 mois (octobre à juillet, jusqu\'aux délibérations)',
                  'Toutes les annales officielles du CGBT & CAP avec corrigés ministériels',
                  'Coaching intensif aux épreuves pratiques (LTNOB, Léconi, Bikélé, Nkok)',
                  'Mode hors-ligne illimité et téléchargement de tous les cours',
                  'Assistance prioritaire ALECKSE IA 24h/24 jusqu\'au jour J',
                ],
              ),

              // ===============================================================
              // 5. PACKS ANNUELS & MULTI-TRIMESTRES (ENSEIGNEMENT GÉNÉRAL)
              // ===============================================================
              _buildSectionHeader(
                title: '🎓 PACKS ANNUELS & TRIMESTRES (ENSEIGNEMENT GÉNÉRAL)',
                subtitle: 'Forfaits longue durée couvrant tous les pôles généraux',
                icon: Icons.school_rounded,
                color: AppColors.primary,
              ),

              // Pack Trimestre Réussite Général (6 500 FCFA / 3 mois)
              _buildSubscriptionCard(
                context,
                title: 'Pack Trimestre Réussite Général (3 Mois)',
                subtitle: 'Couvre l\'intégralité d\'un trimestre scolaire pour tous les pôles',
                price: '6 500 FCFA / trimestre',
                billingPeriod: 'Paiement unique pour 3 mois (90 jours)',
                badgeText: 'ÉCONOMISEZ 1 000 FCFA',
                color: AppColors.socrateGreen,
                icon: Icons.date_range_rounded,
                tierKey: 'pack_general_trimestre',
                amountFcfa: 6500,
                features: [
                  'Accès ininterrompu pendant 90 jours consécutifs',
                  'Devoirs surveillés types & compositions trimestrielles corrigées',
                  'ALECKSE IA Correcteur de copies et coaching méthodique',
                  'Relevé de notes et synthèse des compétences pour la famille',
                ],
              ),

              // Pack Annuel Examen d'État Bac Général (19 000 FCFA / 9 mois)
              _buildSubscriptionCard(
                context,
                title: 'Pack Annuel Examen d\'État (Bac Général - 9 Mois)',
                subtitle: 'Abonnement annuel complet pour toute l\'année scolaire (9 mois)',
                price: '19 000 FCFA / an',
                billingPeriod: 'Paiement unique pour 9 mois d\'année scolaire',
                badgeText: 'PACK ANNUEL · ÉCONOMIE 3 500 F',
                color: AppColors.aristoteViolet,
                icon: Icons.military_tech_rounded,
                tierKey: 'pack_general_annuel',
                amountFcfa: 19000,
                features: [
                  'Accès garanti pendant 9 mois jusqu\'aux délibérations du Bac',
                  'Toutes les annales officielles du Bac gabonais corrigées pas-à-pas',
                  'Mode hors-ligne complet et fiches imprimables',
                  'ALECKSE IA illimité 24h/24 pour réviser sans stress',
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

