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

    // Noms et prix des paliers par défaut (Enseignement Général / Philo)
    String tier1Name = 'Socrate';
    String? tier1Subtitle = 'Père de la maïeutique et du questionnement';
    String tier2Name = 'Platon';
    String? tier2Subtitle = 'Théorie des Idées et dialectique';
    String tier3Name = 'Aristote';
    String? tier3Subtitle = 'Logique, éthique et sciences premières';
    bool showTier3 = true;
    String subjectName = "la philosophie";

    int tier2Amount = 2500;
    int tier3Amount = 5000;
    String tier2Price = '2 500 FCFA/mois';
    String tier3Price = '5 000 FCFA/mois';
    String tier1Key = 'socrate';
    String tier2Key = 'platon';
    String tier3Key = 'aristote';

    List<String> tier1Features = [
      'Accès à tous les cours fondamentaux (Chapitres complets)',
      'Méthodologie IPN de base',
    ];

    List<String> tier2Features = [
      'Tout le contenu gratuit',
      'ALECKSE IA (Explications et TD guidés)',
      'Quiz illimités pour s\'entraîner',
      'Bulletin pour les parents',
    ];

    List<String> tier3Features = [
      'Tout le contenu Essentiel',
      'ALECKSE Correcteur (Bac & Copies)',
      'Situations-Problèmes complexes',
      'Travaux Pratiques (TP) intensifs',
      'Mode hors ligne',
    ];

    // MODÈLE ÉCONOMIQUE TECHNIQUE : PIONNIERS DE L'INGÉNIERIE & MINIMUM 3000 FCFA
    if (isTechnique) {
      tier1Name = 'Archimède';
      tier1Subtitle = 'Père de la mécanique & de l\'ingénierie fondamentale';
      tier2Name = 'Léonard de Vinci';
      tier2Subtitle = 'Maître du dessin technique coté & des machines';
      tier3Name = 'Gustave Eiffel';
      tier3Subtitle = 'Pionnier du génie civil & des grands ouvrages métalliques';
      showTier3 = true;
      subjectName = "l'enseignement technique & professionnel";

      tier2Amount = 3000; // Minimum strict de 3 000 FCFA
      tier3Amount = 6000; // Palier supérieur atelier
      tier2Price = '3 000 FCFA/mois (Essentiel Pro)';
      tier3Price = '6 000 FCFA/mois (Expert & Ateliers)';
      tier1Key = 'archimede';
      tier2Key = 'leonard_de_vinci';
      tier3Key = 'gustave_eiffel';

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
      tier1Name = 'Newton';
      tier1Subtitle = 'Fondements de la physique classique & gravitation';
      tier2Name = 'Tesla';
      tier2Subtitle = 'Électromagnétisme & innovations appliquées';
      tier3Name = 'Einstein';
      tier3Subtitle = 'Relativité & physique moderne d\'excellence';
      subjectName = "les sciences";
    } else if (widget.targetDiscipline == 'litterature') {
      tier1Name = 'Découverte';
      tier1Subtitle = 'Initiation aux genres littéraires';
      tier2Name = 'Molière';
      tier2Subtitle = 'Analyse de texte, théâtre & dissertation littéraire';
      showTier3 = false;
      subjectName = "la littérature";
    } else if (widget.targetDiscipline == 'economie') {
      tier1Name = 'Adam Smith';
      tier1Subtitle = 'Notions de base de marché & société';
      tier2Name = 'Keynes';
      tier2Subtitle = 'Macroéconomie, politiques publiques & dissertations';
      showTier3 = false;
      subjectName = "l'économie";
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
                              'Paliers Pionniers',
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
                              '📦 Packages & Bundles',
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
            // CONTENU ONGLET 0 : PALIERS PIONNIERS (MENSUEL)
            // =================================================================
            if (_selectedTab == 0) ...[
              _buildSubscriptionCard(
                context,
                title: tier1Name,
                subtitle: tier1Subtitle,
                price: 'Gratuit',
                billingPeriod: 'Accès libre illimité',
                color: isTechnique
                    ? const Color(0xFF0284C7)
                    : AppColors.primary,
                icon: isTechnique
                    ? Icons.handyman_rounded
                    : Icons.menu_book_rounded,
                tierKey: tier1Key,
                amountFcfa: 0,
                features: tier1Features,
              ),
              _buildSubscriptionCard(
                context,
                title: tier2Name,
                subtitle: tier2Subtitle,
                price: tier2Price,
                billingPeriod: 'Facturation mensuelle sans engagement',
                color: isTechnique
                    ? const Color(0xFFD97706)
                    : AppColors.accent,
                icon: isTechnique
                    ? Icons.precision_manufacturing_rounded
                    : Icons.psychology_rounded,
                isPopular: true,
                badgeText: 'PIONNIER DU DESSIN & ATELIER',
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
                  billingPeriod: 'Facturation mensuelle · Ateliers & TP complets',
                  color: isTechnique
                      ? const Color(0xFF1E3A8A)
                      : const Color(0xFF6A4C93),
                  icon: isTechnique
                      ? Icons.engineering_rounded
                      : Icons.workspace_premium_rounded,
                  badgeText: 'EXCELLENCE & HORS-LIGNE',
                  tierKey: tier3Key,
                  amountFcfa: tier3Amount,
                  features: tier3Features,
                ),
            ],

            // =================================================================
            // CONTENU ONGLET 1 : PACKAGES & BUNDLES (OFFRES GROUPÉES)
            // =================================================================
            if (_selectedTab == 1) ...[
              if (isTechnique) ...[
                // 1. Pack Solo (3 000 FCFA / mois)
                _buildSubscriptionCard(
                  context,
                  title: 'Pack Matière Solo (Spécialité Unique)',
                  subtitle: 'Renforcement ciblé sur 1 seule matière d\'atelier ou technologique',
                  price: '3 000 FCFA / mois',
                  billingPeriod: 'Mensuel · Min. 3 000 FCFA respecté',
                  badgeText: 'À LA CARTE (MIN. 3 000 F)',
                  color: const Color(0xFF0284C7),
                  icon: Icons.category_rounded,
                  tierKey: 'pack_technique_solo',
                  amountFcfa: 3000,
                  features: [
                    'Choix d\'une matière spécifique (Électricité CET, F1 Mécanique, F2 Électrotech, Mercatique STMG, etc.)',
                    'Cours complets, schémas cotés et exercices appliqués de la matière',
                    'Tuteur ALECKSE IA configuré pour la matière choisie',
                    'QCM d\'entraînement d\'atelier et synthèse des cours',
                    'Renouvellement mensuel libre',
                  ],
                ),

                // 2. Pack Filière Complète (6 000 FCFA / mois)
                _buildSubscriptionCard(
                  context,
                  title: 'Pack Filière Intégrale (All-in-One)',
                  subtitle: 'Toutes les matières techniques + enseignement général de la série',
                  price: '6 000 FCFA / mois',
                  billingPeriod: 'Toutes les matières de la filière incluses',
                  badgeText: 'FORMULE TOUT-EN-UN COMPLÈTE',
                  isPopular: true,
                  color: const Color(0xFFD97706),
                  icon: Icons.account_tree_rounded,
                  tierKey: 'pack_technique_filiere',
                  amountFcfa: 6000,
                  features: [
                    'Débloque 100% des matières de votre filière (STI, STL, STMG ou CET)',
                    'Toutes les matières technologiques ET générales (Maths appliquées, etc.)',
                    'Tuteur IA ALECKSE polyvalent sur l\'ensemble du cursus',
                    'Guides de Travaux Pratiques (TP) d\'atelier et protocoles',
                    'Rapports hebdomadaires de progression pour la famille',
                  ],
                ),

                // 3. Pack Trimestre Réussite (8 000 FCFA / 3 mois)
                _buildSubscriptionCard(
                  context,
                  title: 'Pack Trimestre Réussite (3 Mois)',
                  subtitle: 'Forfait 90 jours pour sécuriser tout le trimestre scolaire',
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
                    'Sujets types et protocoles de validation des compétences',
                    'Mode hors-ligne pour réviser à l\'atelier sans data',
                  ],
                ),

                // 4. Pack Annuel Examen d'État (24 000 FCFA / 9 mois)
                _buildSubscriptionCard(
                  context,
                  title: 'Pack Annuel Examen d\'État (Bac Tech / CAP)',
                  subtitle: 'Le Pass intégral jusqu\'aux épreuves pratiques et écrites du Bac ou CAP',
                  price: '24 000 FCFA / an',
                  billingPeriod: 'Paiement unique pour 9 mois d\'année scolaire',
                  badgeText: 'PASS EXAMEN · ÉCONOMIE 3 000 F+',
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
              ] else ...[
                // PACKAGES ENSEIGNEMENT GÉNÉRAL
                _buildSubscriptionCard(
                  context,
                  title: 'Pack Matière Solo Mensuel',
                  subtitle: 'Accès illimité à une discipline spécifique',
                  price: '2 500 FCFA / mois',
                  billingPeriod: 'Facturation mensuelle',
                  badgeText: 'À LA CARTE',
                  color: AppColors.primary,
                  icon: Icons.book_rounded,
                  tierKey: 'pack_general_solo',
                  amountFcfa: 2500,
                  features: [
                    'Tous les cours et chapitres de la matière',
                    'ALECKSE IA tuteur dédié',
                    'Quiz illimités et fiches de révision',
                  ],
                ),
                _buildSubscriptionCard(
                  context,
                  title: 'Pack Trimestre Réussite (3 Mois)',
                  subtitle: 'Couvre l\'intégralité d\'un trimestre scolaire',
                  price: '6 500 FCFA / trimestre',
                  billingPeriod: 'Paiement unique pour 3 mois (90 jours)',
                  badgeText: 'ÉCONOMISEZ 1 000 FCFA',
                  isPopular: true,
                  color: const Color(0xFF059669),
                  icon: Icons.date_range_rounded,
                  tierKey: 'pack_general_trimestre',
                  amountFcfa: 6500,
                  features: [
                    'Accès ininterrompu pendant 90 jours',
                    'Devoirs surveillés types & compositions corrigées',
                    'ALECKSE IA Correcteur de copies',
                    'Relevé de notes périodique',
                  ],
                ),
                _buildSubscriptionCard(
                  context,
                  title: 'Pack Annuel Examen d\'État (Bac Général)',
                  subtitle: 'Pass complet pour toute l\'année scolaire (9 mois)',
                  price: '19 000 FCFA / an',
                  billingPeriod: 'Paiement unique pour 9 mois',
                  badgeText: 'PASS EXAMEN · ÉCONOMIE 3 500 F',
                  color: const Color(0xFF6A4C93),
                  icon: Icons.workspace_premium_rounded,
                  tierKey: 'pack_general_annuel',
                  amountFcfa: 19000,
                  features: [
                    'Accès garanti pendant 9 mois jusqu\'au Bac',
                    'Toutes les annales officielles du Bac corrigées',
                    'Mode hors-ligne complet',
                    'ALECKSE IA illimité 24h/24',
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

