import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/student_provider.dart';

class DisciplineSelectionScreen extends ConsumerStatefulWidget {
  final int initialTab;
  const DisciplineSelectionScreen({super.key, this.initialTab = 0});

  @override
  ConsumerState<DisciplineSelectionScreen> createState() =>
      _DisciplineSelectionScreenState();
}

class _DisciplineSelectionScreenState
    extends ConsumerState<DisciplineSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTechSector = 'all'; // 'all', 'industriel', 'tertiaire', 'leconi'

  @override
  void initState() {
    super.initState();
    final safeIndex = (widget.initialTab >= 0 && widget.initialTab <= 1) ? widget.initialTab : 0;
    _tabController = TabController(length: 2, vsync: this, initialIndex: safeIndex);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentState = ref.watch(studentProvider);
    final isTerminal = studentState.niveau == 'Terminale';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'eduPocket',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.primary,
                                        ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'Gabon IPN',
                                      style: TextStyle(
                                        color: AppColors.accent,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Portail officiel des cours & filières',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => context.push('/profile-setup'),
                            borderRadius: BorderRadius.circular(30),
                            child: const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person_outline,
                                  color: AppColors.primary),
                            ),
                          ),
                        ],
                      ).animate().fade().slideY(begin: -0.2),

                      const SizedBox(height: 20),

                      // Onglets d'orientation : Enseignement Général vs Technique & Pro
                      Container(
                        height: 52,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: AppColors.textDark,
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          unselectedLabelStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          tabs: const [
                            Tab(
                              iconMargin: EdgeInsets.zero,
                              text: '🎓 Enseignement Général',
                            ),
                            Tab(
                              iconMargin: EdgeInsets.zero,
                              text: '⚙️ Technique & Pro',
                            ),
                          ],
                        ),
                      ).animate().fade(delay: 100.ms),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // 1. VUE ENSEIGNEMENT GÉNÉRAL
              _buildGeneralStreamView(context, isTerminal, studentState),

              // 2. VUE ENSEIGNEMENT TECHNIQUE & PROFESSIONNEL
              _buildTechnicalStreamView(context),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // SECTION 1 : ENSEIGNEMENT GÉNÉRAL
  // ===========================================================================
  Widget _buildGeneralStreamView(
      BuildContext context, bool isTerminal, dynamic studentState) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      children: [
        // Badge descriptif
        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.school_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Séries A1, A2 (Littéraires), B (Économique), C & D (Scientifiques)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Titre Vaisseau Amiral Solo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Vaisseau Amiral (100% Indépendant)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Solo · Socrate / Platon / Aristote',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Matière Phare : Philosophie (Philo Pocket)
        _buildDisciplineCard(
          context,
          title: 'Philo Pocket',
          subtitle: 'Philosophie Solo · 15 Notions IPN · 3 Paliers d\'Excellence',
          icon: Icons.local_fire_department_rounded,
          gradient: AppColors.premiumGradient,
          isPrimary: true,
          badgeText: 'Vaisseau Amiral Solo',
          isObligatoire: isTerminal,
          onTap: () => context.push('/main'),
        ).animate().fade(delay: 150.ms).scale(begin: const Offset(0.95, 0.95)),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pôles d\'Enseignement Général',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            const Text(
              '2 Paliers par Pôle',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ).animate().fade(delay: 200.ms),
        const SizedBox(height: 12),

        // Grille des Pôles généraux
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.88,
          children: [
            // 1. Pôle Sciences
            _buildDisciplineCard(
              context,
              title: 'Pôle Sciences',
              subtitle: 'Maths + Physique-Chimie + SVT',
              icon: Icons.science_rounded,
              color: const Color(0xFF00897B),
              badgeText: 'Séries C & D · 2 Paliers (2 500 & 5 000 F)',
              isObligatoire: isTerminal && (studentState.serie == 'C' || studentState.serie == 'D'),
              onTap: () => _showDisciplineDetailsModal(
                context,
                title: 'Pôle Sciences (Séries C & D)',
                filiere: 'Mathématiques + Physique-Chimie + S.V.T.',
                description:
                    'Les 3 matières scientifiques indispensables réunies dans un package mutualisé : cours conformes IPN, TD dirigés, formules et annales officielles du Bac C & D.',
                etablissements: 'Lycées d\'État de Libreville, Port-Gentil, Franceville, Oyem',
                targetDiscipline: 'science',
                isPole: true,
              ),
            ).animate().fade(delay: 250.ms).slideY(begin: 0.1),

            // 2. Pôle Littérature & Langues
            _buildDisciplineCard(
              context,
              title: 'Pôle Littérature',
              subtitle: 'Français + Anglais + Espagnol/All.',
              icon: Icons.menu_book_rounded,
              color: const Color(0xFFE65100),
              badgeText: 'Séries A · Palier Unique 2 500 F',
              isObligatoire: isTerminal && (studentState.serie == 'A1' || studentState.serie == 'A2'),
              onTap: () => _showDisciplineDetailsModal(
                context,
                title: 'Pôle Littérature & Langues (Séries A)',
                filiere: 'Français + Anglais + Espagnol + Allemand',
                description:
                    'Maîtrise de la langue française, commentaire composé, dissertation littéraire et cours complets de langues vivantes pour réussir les épreuves des séries A.',
                etablissements: 'Lycée Léon Mba, Lycée Paul Indjendjet Gondjout, tous lycées du Gabon',
                targetDiscipline: 'litterature',
                isPole: true,
              ),
            ).animate().fade(delay: 300.ms).slideY(begin: 0.1),

            // 3. Pôle Économique & Sciences Humaines
            _buildDisciplineCard(
              context,
              title: 'Pôle Économique',
              subtitle: 'Histoire-Géo + Économie (SES)',
              icon: Icons.trending_up_rounded,
              color: const Color(0xFF2E7D32),
              badgeText: 'Série B · Palier Unique 2 500 F',
              isObligatoire: isTerminal && studentState.serie == 'B',
              onTap: () => _showDisciplineDetailsModal(
                context,
                title: 'Pôle Économique & Sciences Humaines',
                filiere: 'Histoire-Géographie + Économie (S.E.S)',
                description:
                    'Analyse macroéconomique, sociologie, mutations contemporaines, cartographie et repères historiques indispensables pour le grand écrit du Bac B.',
                etablissements: 'Lycée Léon Mba, Lycée d\'État de l\'Estuaire, lycées du Gabon',
                targetDiscipline: 'economie',
                isPole: true,
              ),
            ).animate().fade(delay: 350.ms).slideY(begin: 0.1),

            // 4. Hub Filières Techniques
            _buildDisciplineCard(
              context,
              title: 'Filières Tech & Pro',
              subtitle: 'STI, STMG, CET (Dès la 4e)',
              icon: Icons.precision_manufacturing_rounded,
              color: const Color(0xFF1E3A8A),
              badgeText: 'LTNOB, Léconi... · Dès 3 000 F',
              onTap: () {
                _tabController.animateTo(1);
              },
            ).animate().fade(delay: 400.ms).slideY(begin: 0.1),
          ],
        ),

        const SizedBox(height: 20),

        // Bannière d'accès direct aux Filières Techniques & Professionnelles
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.handyman_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filières Techniques & Professionnelles',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Lycées Techniques (LTNOB, Léconi, Bikélé, Nkok...) & CET (Dès la 4e)',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Formules de formation dédiées : Archimède (100% Gratuit), Léonard de Vinci (3 000 F/mois), Gustave Eiffel (6 000 F/mois). Séries STI, STMG, CET dès la 4e de métier.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _tabController.animateTo(1);
                      },
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text(
                        'Consulter les Ateliers & Filières',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E3A8A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.push('/subscription?discipline=technique');
                    },
                    icon: const Icon(Icons.stars_rounded, size: 18),
                    label: const Text(
                      'Paliers Pro',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fade(delay: 450.ms).slideY(begin: 0.1),
        const SizedBox(height: 32),
      ],
    );
  }

  // ===========================================================================
  // SECTION 2 : ENSEIGNEMENT TECHNIQUE ET PROFESSIONNEL
  // ===========================================================================
  Widget _buildTechnicalStreamView(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      children: [
        // Bandeau d'information Lycées Techniques du Gabon
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E3A8A).withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.precision_manufacturing_rounded,
                        color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Lycées Techniques & Professionnels',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Lycée Technique National Omar Bongo (LTNOB), Lycée Technologique de Léconi, Nyonda Makita, LTAO, LTK, Lycée Technique de Ntoum, Agathe Obendze, Paul Kouya.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ).animate().fade().slideY(begin: 0.1),

        // Filtre de secteur
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip('Toutes les filières', 'all'),
              _buildFilterChip('1er Cycle : CET & CAP (Dès la 4e)', 'cet'),
              _buildFilterChip('Industriel & STI (LTNOB)', 'industriel'),
              _buildFilterChip('Tertiaire & Management (STMG)', 'tertiaire'),
              _buildFilterChip('Laboratoire (STL & Léconi)', 'labo'),
              _buildFilterChip('Métiers d\'Avenir & NTIC (Nkok)', 'metiers'),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 0. SOUS-SECTION : 1ER CYCLE TECHNIQUE – COLLÈGES D'ENSEIGNEMENT TECHNIQUE (CET) & CAP
        if (_selectedTechSector == 'all' || _selectedTechSector == 'cet') ...[
          _buildSectorHeader(
            context,
            title: '1er Cycle Technique : CET & CAP (Dès la 4e)',
            subtitle: 'CET de Libreville, CET de Mouila, Fougamou, Port-Gentil, Centres CAP',
            icon: Icons.handyman_rounded,
            color: const Color(0xFFD97706),
          ),
          const SizedBox(height: 12),
          _buildTechCard(
            context,
            code: 'CET Elec',
            title: 'Électricité du Bâtiment & Installations',
            lycees: 'CET Libreville, CET Mouila (CAP Électricité)',
            icon: Icons.electrical_services_rounded,
            color: const Color(0xFFD97706),
          ),
          _buildTechCard(
            context,
            code: 'CET Meca',
            title: 'Mécanique Automobile & Moteurs',
            lycees: 'CET Libreville, Port-Gentil (CAP Mécanique Auto)',
            icon: Icons.car_repair_rounded,
            color: const Color(0xFFEA580C),
          ),
          _buildTechCard(
            context,
            code: 'CET Bois',
            title: 'Menuiserie, Ébénisterie & Travail du Bois',
            lycees: 'CET et Centres de formation professionnelle',
            icon: Icons.carpenter_rounded,
            color: const Color(0xFFB45309),
          ),
          _buildTechCard(
            context,
            code: 'CET BTP',
            title: 'Maçonnerie & Gros Œuvre BTP',
            lycees: 'CET Libreville, Oyem, Mouila (CAP Maçonnerie)',
            icon: Icons.foundation_rounded,
            color: const Color(0xFF475569),
          ),
          _buildTechCard(
            context,
            code: 'CET Métal',
            title: 'Chaudronnerie, Soudure & Serrurerie Métallique',
            lycees: 'CET et Pôles industriels',
            icon: Icons.construction_rounded,
            color: const Color(0xFF0369A1),
          ),
          _buildTechCard(
            context,
            code: 'CET Tertiaire',
            title: 'Employé de Bureau, Secrétariat & Saisie',
            lycees: 'CET Tertiaire, Écoles professionnelles (CAP)',
            icon: Icons.desk_rounded,
            color: const Color(0xFF7C3AED),
          ),
          _buildTechCard(
            context,
            code: 'CET Mode',
            title: 'Coupe, Couture & Métiers de la Mode',
            lycees: 'Centres de Formation Professionnelle Féminine & CET',
            icon: Icons.checkroom_rounded,
            color: const Color(0xFFDB2777),
          ),
          const SizedBox(height: 24),
        ],

        // 1. SOUS-SECTION : SECTEUR INDUSTRIEL – BAC TECHNOLOGIQUE (STI)
        if (_selectedTechSector == 'all' || _selectedTechSector == 'industriel') ...[
          _buildSectorHeader(
            context,
            title: 'Secteur Industriel – Bac STI (Sciences & Technologies Industrielles)',
            subtitle: 'LTNOB, Nyonda Makita, LTK, Fougamou, Fulbert Bongotha (Moanda)',
            icon: Icons.engineering_rounded,
            color: const Color(0xFF0284C7),
          ),
          const SizedBox(height: 12),
          _buildTechCard(
            context,
            code: 'F1',
            title: 'Génie Mécanique (Option Productique)',
            lycees: 'LTNOB, Nyonda Makita',
            icon: Icons.settings_suggest_rounded,
            color: const Color(0xFF0284C7),
          ),
          _buildTechCard(
            context,
            code: 'F1C',
            title: 'Génie Mécanique (Structures Métalliques & Chaudronnerie)',
            lycees: 'LTNOB, CIMFEP Nkok',
            icon: Icons.construction_rounded,
            color: const Color(0xFF0369A1),
          ),
          _buildTechCard(
            context,
            code: 'F2',
            title: 'Génie Électronique',
            lycees: 'LTNOB, Nyonda Makita',
            icon: Icons.memory_rounded,
            color: const Color(0xFF0369A1),
          ),
          _buildTechCard(
            context,
            code: 'F3',
            title: 'Génie Électrotechnique',
            lycees: 'LTNOB, Nyonda Makita',
            icon: Icons.bolt_rounded,
            color: const Color(0xFFD97706),
          ),
          _buildTechCard(
            context,
            code: 'F4',
            title: 'Génie Civil & Bâtiment',
            lycees: 'LTNOB, Nyonda Makita, CFEP Bois-BTP',
            icon: Icons.apartment_rounded,
            color: const Color(0xFF475569),
          ),
          _buildTechCard(
            context,
            code: 'AC',
            title: 'Architecture & Construction',
            lycees: 'LTNOB, Écoles Spécialisées',
            icon: Icons.home_work_rounded,
            color: const Color(0xFF334155),
          ),
          _buildTechCard(
            context,
            code: 'MVA',
            title: 'Maintenance des Véhicules Automobiles',
            lycees: 'LTNOB, CIMFEP Nkok, Port-Gentil',
            icon: Icons.directions_car_rounded,
            color: const Color(0xFFEA580C),
            isHighlight: true,
          ),
          _buildTechCard(
            context,
            code: 'ISEC',
            title: 'Systèmes Énergétiques & Climatiques (Froid)',
            lycees: 'LTNOB, CIMFEP Nkok',
            icon: Icons.ac_unit_rounded,
            color: const Color(0xFF0284C7),
          ),
          _buildTechCard(
            context,
            code: 'ER',
            title: 'Génie Mécanique (Option Énergies Renouvelables)',
            lycees: 'LTNOB, Nkok (Transition Énergétique Gabon)',
            icon: Icons.solar_power_rounded,
            color: const Color(0xFF16A34A),
            isHighlight: true,
          ),
          _buildTechCard(
            context,
            code: 'SI',
            title: 'Sciences de l\'Ingénierie (STI)',
            lycees: 'LTNOB, Lycée Technologique de Léconi',
            icon: Icons.architecture_rounded,
            color: const Color(0xFF7C3AED),
          ),
          _buildTechCard(
            context,
            code: 'MI',
            title: 'Maintenance Industrielle',
            lycees: 'LTNOB, Nyonda Makita, Secteur Pétrolier & Minier',
            icon: Icons.build_circle_rounded,
            color: const Color(0xFF0D9488),
          ),
          _buildTechCard(
            context,
            code: 'Biomédical',
            title: 'Maintenance des Équipements Biomédicaux',
            lycees: 'LTNOB (Filière d\'excellence hospitalière)',
            icon: Icons.health_and_safety_rounded,
            color: const Color(0xFFE11D48),
            isHighlight: true,
          ),
          _buildTechCard(
            context,
            code: 'Info-Indus',
            title: 'Informatique Industrielle & Systèmes Embarqués',
            lycees: 'LTNOB',
            icon: Icons.computer_rounded,
            color: const Color(0xFF4338CA),
          ),
          _buildTechCard(
            context,
            code: 'F1D / Bois',
            title: 'Génie Industriel Bois & Matériaux Associés',
            lycees: 'LTNOB, ZIS Nkok (Filière Forêt-Bois)',
            icon: Icons.carpenter_rounded,
            color: const Color(0xFFB45309),
          ),
          const SizedBox(height: 24),
        ],

        // 2. SOUS-SECTION : SCIENCES DE LABORATOIRE (STL) & PÔLE LÉCONI
        if (_selectedTechSector == 'all' || _selectedTechSector == 'labo') ...[
          _buildSectorHeader(
            context,
            title: 'Sciences & Technologies de Laboratoire (STL) & Léconi',
            subtitle: 'Léconi, Laboratoires Médicaux, Agroalimentaires, Pétrole & Mines',
            icon: Icons.biotech_rounded,
            color: const Color(0xFF059669),
          ),
          const SizedBox(height: 12),
          _buildTechCard(
            context,
            code: 'STL BGB',
            title: 'Biochimie - Génie Biologique',
            lycees: 'Examens CGBT - Laboratoires d\'Analyses Médicales & Agro',
            icon: Icons.biotech_rounded,
            color: const Color(0xFF059669),
            isHighlight: true,
          ),
          _buildTechCard(
            context,
            code: 'STL CLPI',
            title: 'Chimie de Laboratoires et Procédés Industriels',
            lycees: 'Mines de Moanda, Raffinerie SOGARA, Pétrole Port-Gentil',
            icon: Icons.science_rounded,
            color: const Color(0xFF047857),
          ),
          _buildTechCard(
            context,
            code: 'SI',
            title: 'Sciences de l\'Ingénierie',
            lycees: 'Lycée Technologique de Léconi',
            icon: Icons.precision_manufacturing_rounded,
            color: const Color(0xFF0D9488),
          ),
          _buildTechCard(
            context,
            code: 'Bio Thec',
            title: 'Bio Technologies & Agro-ressources',
            lycees: 'Lycée Technologique de Léconi',
            icon: Icons.eco_rounded,
            color: const Color(0xFF10B981),
          ),
          _buildTechCard(
            context,
            code: 'SPCL',
            title: 'Sciences Physiques et Chimie de Laboratoire',
            lycees: 'Lycée Technologique de Léconi',
            icon: Icons.opacity_rounded,
            color: const Color(0xFF14B8A6),
          ),
          _buildTechCard(
            context,
            code: 'MEH',
            title: 'Maintenance des Équipements Hospitaliers',
            lycees: 'Lycée Technologique de Léconi',
            icon: Icons.medical_services_rounded,
            color: const Color(0xFFBE185D),
          ),
          _buildTechCard(
            context,
            code: 'CQA',
            title: 'Contrôle Qualité Agroalimentaire',
            lycees: 'Lycée Technologique de Léconi',
            icon: Icons.fact_check_rounded,
            color: const Color(0xFF65A30D),
          ),
          const SizedBox(height: 24),
        ],

        // 3. SOUS-SECTION : CYCLE TECHNOLOGIQUE TERTIAIRE (STMG) & CYCLE PRO
        if (_selectedTechSector == 'all' || _selectedTechSector == 'tertiaire') ...[
          _buildSectorHeader(
            context,
            title: 'Cycle Technologique & Tertiaire : STMG',
            subtitle: 'LTNOB, Nyonda Makita, LTAO, LTK, Ntoum, Agathe Obendze, Paul Kouya',
            icon: Icons.storefront_rounded,
            color: const Color(0xFF9333EA),
          ),
          const SizedBox(height: 12),
          _buildTechCard(
            context,
            code: 'STMG Merca',
            title: 'Mercatique (Marketing & Négociation Commerciale)',
            lycees: '2nde STMG, 1ère STMG, Tle Mercatique',
            icon: Icons.campaign_rounded,
            color: const Color(0xFF9333EA),
          ),
          _buildTechCard(
            context,
            code: 'STMG RHC',
            title: 'Ressources Humaines & Communication',
            lycees: '2nde STMG, 1ère STMG, Tle RHC',
            icon: Icons.people_alt_rounded,
            color: const Color(0xFF7E22CE),
          ),
          _buildTechCard(
            context,
            code: 'STMG GSI',
            title: 'Gestion & Systèmes d\'Information',
            lycees: '2nde STMG, 1ère STMG, Tle GSI',
            icon: Icons.lan_rounded,
            color: const Color(0xFF6B21A8),
          ),
          _buildTechCard(
            context,
            code: 'STMG CFE',
            title: 'Comptabilité & Finance d\'Entreprise',
            lycees: '2nde STMG, 1ère STMG, Tle CFE',
            icon: Icons.account_balance_rounded,
            color: const Color(0xFF4C1D95),
          ),
          _buildTechCard(
            context,
            code: 'CMFE',
            title: 'Comptabilité, Marketing & Finances d\'Entreprises',
            lycees: 'Lycée Scientifique & Technologique Paul Kouya (Koula-Moutou)',
            icon: Icons.analytics_rounded,
            color: const Color(0xFF581C87),
            isHighlight: true,
          ),
          _buildTechCard(
            context,
            code: 'Cycle Modulaire',
            title: 'Secrétariat Bureautique (SB) & Comptabilité Gestion (CG)',
            lycees: 'Nyonda Makita, LTAO, LTK',
            icon: Icons.assignment_rounded,
            color: const Color(0xFF1E40AF),
          ),
          _buildTechCard(
            context,
            code: 'Cycle Pro',
            title: 'TCG (Commerce) & TGA (Gestion Administrative)',
            lycees: '2nde, 1ère, Tle TCG / TGA - Nyonda Makita, LTAO, LTK',
            icon: Icons.business_center_rounded,
            color: const Color(0xFF172554),
          ),
          const SizedBox(height: 24),
        ],

        // 4. SOUS-SECTION : PÔLE MÉTIERS D'AVENIR & FORMATION PROFESSIONNELLE (NKOK & BIKÉLÉ)
        if (_selectedTechSector == 'all' || _selectedTechSector == 'metiers') ...[
          _buildSectorHeader(
            context,
            title: 'Métiers d\'Avenir, Industrie & NTIC (Nkok / Bikélé)',
            subtitle: 'CIMFEP Nkok, CFEP NTIC, CFEP Bois-BTP, CFPP Bikélé',
            icon: Icons.hub_rounded,
            color: const Color(0xFFEA580C),
          ),
          const SizedBox(height: 12),
          _buildTechCard(
            context,
            code: 'Froid',
            title: 'Ingénierie du Froid & Climatisation Industrielle',
            lycees: 'CIMFEP Nkok (Métier sous très forte demande)',
            icon: Icons.ac_unit_rounded,
            color: const Color(0xFF0284C7),
            isHighlight: true,
          ),
          _buildTechCard(
            context,
            code: 'Réseaux & Fibre',
            title: 'Réseaux Télécoms & Déploiement Fibre Optique',
            lycees: 'CFEP NTIC Nkok',
            icon: Icons.settings_ethernet_rounded,
            color: const Color(0xFFEA580C),
          ),
          _buildTechCard(
            context,
            code: 'Dév & Cyber',
            title: 'Développement Web, Mobile & Cybersécurité',
            lycees: 'CFEP NTIC Nkok',
            icon: Icons.security_rounded,
            color: const Color(0xFFC2410C),
          ),
          _buildTechCard(
            context,
            code: 'Agri-Machinisme',
            title: 'Maintenance des Machines Agricoles & Engins',
            lycees: 'CIMFEP Nkok (Agro-industrie gabonaise)',
            icon: Icons.agriculture_rounded,
            color: const Color(0xFF15803D),
          ),
          _buildTechCard(
            context,
            code: 'Soudage Indus',
            title: 'Ingénierie et Technologie du Soudage Industriel',
            lycees: 'CIMFEP Nkok (Chantiers maritimes & pétroliers)',
            icon: Icons.flash_on_rounded,
            color: const Color(0xFFB45309),
          ),
          const SizedBox(height: 32),
        ],
      ],
    );
  }

  // ===========================================================================
  // COMPOSANTS UI RÉUTILISABLES
  // ===========================================================================

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedTechSector == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedTechSector = value);
          }
        },
        selectedColor: AppColors.primary,
        backgroundColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : AppColors.border.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildSectorHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechCard(
    BuildContext context, {
    required String code,
    required String title,
    required String lycees,
    required IconData icon,
    required Color color,
    bool isHighlight = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlight
              ? color
              : AppColors.border.withValues(alpha: 0.5),
          width: isHighlight ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDisciplineDetailsModal(
            context,
            title: title,
            filiere: 'Filière $code',
            description:
                'Programme de formation technique et professionnelle conforme aux programmes des lycées techniques gabonais.',
            etablissements: lycees,
            isTechnique: true,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 22),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              code,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w900,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isHighlight)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.amber.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Très demandée',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lycees,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.border,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDisciplineDetailsModal(
    BuildContext context, {
    required String title,
    required String filiere,
    required String description,
    required String etablissements,
    bool isTechnique = false,
    String targetDiscipline = 'general',
    bool isPole = false,
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
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school_rounded,
                      color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        filiere,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Établissements de référence au Gabon :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              etablissements,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Programme & Contenus :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            // Encadré Modèle Économique & Tarification
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isTechnique
                    ? const Color(0xFF1E3A8A).withValues(alpha: 0.08)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isTechnique
                      ? const Color(0xFF1E3A8A).withValues(alpha: 0.25)
                      : AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isTechnique
                          ? const Color(0xFF1E3A8A).withValues(alpha: 0.15)
                          : AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isTechnique
                          ? Icons.precision_manufacturing_rounded
                          : Icons.school_rounded,
                      color: isTechnique
                          ? const Color(0xFF1E3A8A)
                          : AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isTechnique
                              ? 'Formule Technique & Professionnelle'
                              : 'Formule Enseignement Général',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: isTechnique
                                ? const Color(0xFF1E3A8A)
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          isTechnique
                              ? 'Cours officiels 100% gratuits · Modules pionniers optionnels : Archimède (Gratuit), Léonard de Vinci (3 000 FCFA/mois), Gustave Eiffel (6 000 FCFA/mois)'
                              : isPole
                                  ? 'Cours officiels IPN 100% gratuits · Offres de formation du Pôle : Palier Unique (2 500 FCFA/mois) ou Formule Sciences (2 500 & 5 000 FCFA/mois)'
                                  : 'Cours officiels IPN 100% gratuits · Modules pionniers Philo Pocket : Socrate (Gratuit), Platon (2 500 FCFA/mois), Aristote (5 000 FCFA/mois)',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isTechnique
                                ? const Color(0xFF1E3A8A)
                                : AppColors.primary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Bouton vers les cours gratuits
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/cours');
                },
                icon: const Icon(Icons.menu_book_rounded, size: 20),
                label: const Text(
                  'Consulter les cours & fiches gratuits',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Bouton vers les progressions officielles IPN
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/ipn');
                },
                icon: const Icon(Icons.description_outlined, size: 18),
                label: const Text(
                  '📋 Consulter les Progressions Officielles IPN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isTechnique ? const Color(0xFF1E3A8A) : AppColors.primary,
                  side: BorderSide(
                    color: isTechnique ? const Color(0xFF1E3A8A) : AppColors.primary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Bouton secondaire pour découvrir les modules de perfectionnement
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push(
                    Uri(
                      path: '/subscription',
                      queryParameters: {'discipline': isTechnique ? 'technique' : targetDiscipline},
                    ).toString(),
                  );
                },
                icon: const Icon(Icons.workspace_premium_rounded, size: 18),
                label: Text(
                  isTechnique
                      ? 'Découvrir les modules pionniers de perfectionnement (dès 3 000 FCFA)'
                      : isPole
                          ? 'Découvrir les offres de formation du Pôle (dès 3 000 FCFA)'
                          : 'Découvrir les modules pionniers de perfectionnement (dès 2 500 FCFA)',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification activée ! Vous serez alerté dès la sortie des prochains modules.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_active_outlined, size: 16),
                label: const Text('Être notifié des nouveaux cours'),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDisciplineCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Color? color,
    Gradient? gradient,
    bool isPrimary = false,
    bool isObligatoire = false,
    String? badgeText,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: (color ?? AppColors.primary).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(isPrimary ? 20.0 : 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isPrimary ? 14 : 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: isPrimary ? 28 : 22,
                      ),
                    ),
                    if (badgeText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else if (isObligatoire)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Obligatoire',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: isPrimary ? 16 : 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isPrimary ? 22 : 16,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: isPrimary ? 13 : 11,
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
}
