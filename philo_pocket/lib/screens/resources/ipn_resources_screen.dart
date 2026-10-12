import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../legal/legal_document_viewer_screen.dart';
import '../../core/constants/app_colors.dart';

class IpnResourcesScreen extends StatefulWidget {
  final String? initialCategory;

  const IpnResourcesScreen({super.key, this.initialCategory});

  @override
  State<IpnResourcesScreen> createState() => _IpnResourcesScreenState();
}

class _IpnResourcesScreenState extends State<IpnResourcesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = const [
    {
      'name': 'Mathématiques',
      'icon': Icons.calculate_rounded,
      'color': Color(0xFF1E88E5),
      'docs': [
        {
          'title': 'Terminale A1 & B — Progression Nationale 2026-2027',
          'path': 'assets/ipn/maths/progression_tle_a1_b.md',
          'type': 'md',
          'desc': 'Séries littéraires et économiques',
        },
        {
          'title': '1ère S & SI — Progression Nationale 2026-2027',
          'path': 'assets/ipn/maths/progression_1ere_s_si.md',
          'type': 'md',
          'desc': 'Séries scientifiques et industrielles',
        },
        {
          'title': '2nde S & STI — Progression Nationale 2026-2027',
          'path': 'assets/ipn/maths/progression_2de_s_sti.md',
          'type': 'md',
          'desc': 'Tronc commun scientifique',
        },
        {
          'title': '2nde LE & STMG — Progression Nationale 2026-2027',
          'path': 'assets/ipn/maths/progression_2de_le_stmg.md',
          'type': 'md',
          'desc': 'Séries tertiaires et littéraires',
        },
        {
          'title': '3ème — Progression Nationale & Référentiel BEPC',
          'path': 'assets/ipn/maths/progression_3eme.md',
          'type': 'md',
          'desc': 'Classe d\'examen BEPC Gabon',
        },
        {
          'title': '4ème — Progression Nationale 2026-2027',
          'path': 'assets/ipn/maths/progression_4eme.md',
          'type': 'md',
          'desc': 'Cycle secondaire 1',
        },
        {
          'title': '5ème — Progression Nationale 2026-2027',
          'path': 'assets/ipn/maths/progression_5eme.md',
          'type': 'md',
          'desc': 'Cycle d\'observation',
        },
        {
          'title': '6ème — Progression Nationale 2026-2027',
          'path': 'assets/ipn/maths/progression_6eme.md',
          'type': 'md',
          'desc': 'Entrée au collège',
        },
        {
          'title': 'Référentiel d\'Évaluation & Typologie BEPC',
          'path': 'assets/ipn/maths/referentiel_evaluation_bepc.md',
          'type': 'md',
          'desc': 'Cadre officiel de certification IPN',
        },
        {
          'title': 'Banque d\'Épreuves de Mathématiques',
          'path': 'assets/ipn/maths/epreuves_mathematiques.md',
          'type': 'md',
          'desc': 'Sujets officiels et exercices d\'application',
        },
      ],
    },
    {
      'name': 'Physique-Chimie',
      'icon': Icons.science_rounded,
      'color': Color(0xFF00897B),
      'docs': [
        {
          'title': 'Terminale D — Progression Nationale 2026-2027',
          'path': 'assets/ipn/physique_chimie/progression_tle_d.md',
          'type': 'md',
          'desc': 'Baccalauréat Scientifique D',
        },
        {
          'title': 'Terminale C & SI — Progression Nationale 2026-2027',
          'path': 'assets/ipn/physique_chimie/progression_tle_c_si.md',
          'type': 'md',
          'desc': 'Baccalauréat Mathématiques & Technique',
        },
        {
          'title': '1ère S & SI — Progression Nationale 2026-2027',
          'path': 'assets/ipn/physique_chimie/progression_1ere_s_si.md',
          'type': 'md',
          'desc': 'Lycée Général & Technologique',
        },
        {
          'title': '2nde S & STI — Progression Nationale 2026-2027',
          'path': 'assets/ipn/physique_chimie/progression_2nde_s_sti.md',
          'type': 'md',
          'desc': 'Sciences Physiques 2nde',
        },
        {
          'title': '3ème — Progression Annuelle BEPC',
          'path': 'assets/ipn/physique_chimie/progression_3eme.md',
          'type': 'md',
          'desc': 'Préparation au BEPC',
        },
        {
          'title': '4ème — Progression Annuelle 2026-2027',
          'path': 'assets/ipn/physique_chimie/progression_4eme.md',
          'type': 'md',
          'desc': 'Physique-Chimie Collège',
        },
        {
          'title': '5ème — Progression Annuelle 2026-2027',
          'path': 'assets/ipn/physique_chimie/progression_5eme.md',
          'type': 'md',
          'desc': 'Physique-Chimie Collège',
        },
        {
          'title': '6ème — Progression Annuelle 2026-2027',
          'path': 'assets/ipn/physique_chimie/progression_6eme.md',
          'type': 'md',
          'desc': 'Initiation aux sciences physiques',
        },
      ],
    },
    {
      'name': 'Français & Lettres',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFFE65100),
      'docs': [
        {
          'title': 'Progressions Collège (6e, 5e, 4e, 3e) — Français',
          'path': 'assets/ipn/francais/progression_college.md',
          'type': 'md',
          'desc': 'Programme intégral IPN des 4 niveaux du collège (94 Ko)',
        },
      ],
    },
    {
      'name': 'S.E.S (Économie)',
      'icon': Icons.trending_up_rounded,
      'color': Color(0xFF0288D1),
      'docs': [
        {
          'title': 'Terminale B — Progression Indicative 2026-2027',
          'path': 'assets/ipn/ses/progression_terminale_b.md',
          'type': 'md',
          'desc': 'Sciences Éco & Sociales · Bac Série B',
        },
        {
          'title': '1ère B — Progression Indicative 2026-2027',
          'path': 'assets/ipn/ses/progression_1ere_b.md',
          'type': 'md',
          'desc': 'Sciences Économiques et Sociales 1ère B',
        },
        {
          'title': '2de LE & S — Progression Indicative 2026-2027',
          'path': 'assets/ipn/ses/progression_2de.md',
          'type': 'md',
          'desc': 'Initiation à l\'économie et la société',
        },
      ],
    },
    {
      'name': 'Philosophie & IPN',
      'icon': Icons.local_fire_department_rounded,
      'color': AppColors.primary,
      'docs': [
        {
          'title': 'Progressions Nationales 2025-2026 (PDF)',
          'path': 'assets/ipn/progressions_nationales.pdf',
          'type': 'pdf',
          'desc': 'Document cadre officiel IPN Gabon',
        },
        {
          'title': 'Méthodologies Nationales de Philosophie v2 (PDF)',
          'path': 'assets/ipn/methodologies_nationales_philosophie_v2.pdf',
          'type': 'pdf',
          'desc': 'Dissertation, commentaire de texte et démarches',
        },
        {
          'title': 'L\'Épreuve Orale de Philosophie (PDF)',
          'path': 'assets/ipn/epreuve_orale_philosophie.pdf',
          'type': 'pdf',
          'desc': 'Modalités et critères d\'évaluation de l\'oral',
        },
        {
          'title': 'Grilles d\'Évaluation Officielles (PDF)',
          'path': 'assets/ipn/grilles_evaluation_philosophie.pdf',
          'type': 'pdf',
          'desc': 'Barèmes et grilles harmonisées des jurys',
        },
        {
          'title': 'Critères d\'Élaboration des Épreuves (PDF)',
          'path': 'assets/ipn/criteres_elaboration_epreuves.pdf',
          'type': 'pdf',
          'desc': 'Conception des sujets d\'examen officiel',
        },
        {
          'title': 'Étude d\'une Œuvre Philosophique (PDF)',
          'path': 'assets/ipn/etude_oeuvre_philosophique.pdf',
          'type': 'pdf',
          'desc': 'Guide méthodologique d\'étude intégrale',
        },
      ],
    },
    {
      'name': 'Série STMG (Gestion)',
      'icon': Icons.business_center_rounded,
      'color': Color(0xFF6A1B9A),
      'docs': [
        {
          'title': '1ère STMG — Programme Intégral Tronc Commun (2024-2026)',
          'path': 'assets/ipn/stmg/programme_1ere_stmg.md',
          'type': 'md',
          'desc': 'SGDN (8h), Économie, Droit, Management, Maths, CMC, Philo, Langues, Arts',
        },
        {
          'title': 'Terminale STMG — Épreuve Orale & Projet de Gestion Officiel',
          'path': 'assets/ipn/stmg/epreuve_projet_gestion_stmg.md',
          'type': 'md',
          'desc': 'Guide officiel IPN, plan 15-20 pages, fiche de suivi et grille de notation /20',
        },
      ],
    },
    {
      'name': 'Bac Pro TGA',
      'icon': Icons.work_outline_rounded,
      'color': Color(0xFFC2185B),
      'docs': [
        {
          'title': 'Bac Pro TGA — Référentiels & Progression (2nde, 1ère, Tle)',
          'path': 'assets/ipn/bac_pro/progression_bac_pro_tga.md',
          'type': 'md',
          'desc': 'Les 4 pôles, grille horaire, 16 semaines de stages, épreuves et philo adaptée',
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    int initialIdx = 0;
    if (widget.initialCategory != null) {
      final found = _categories.indexWhere(
        (c) => (c['name'] as String).toLowerCase().contains(widget.initialCategory!.toLowerCase()),
      );
      if (found != -1) initialIdx = found;
    }
    _tabController = TabController(length: _categories.length, vsync: this, initialIndex: initialIdx);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _openDocument(BuildContext context, Map<String, dynamic> doc) {
    final title = doc['title'] as String;
    final path = doc['path'] as String;
    final type = doc['type'] as String;

    if (type == 'pdf') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(title: title, pdfPath: path),
        ),
      );
    } else {
      LegalDocumentViewerScreen.show(context, title: title, assetPath: path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque des Progressions & IPN'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.black54,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: _categories.map((cat) {
            return Tab(
              icon: Icon(cat['icon'] as IconData, size: 20),
              text: cat['name'] as String,
            );
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          // Barre de recherche instantanée
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rechercher un programme, épreuve, chapitre...',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.black45),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.trim().toLowerCase()),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((cat) {
                final List<Map<String, dynamic>> allDocs = cat['docs'] as List<Map<String, dynamic>>;
                final Color catColor = cat['color'] as Color;

                final docs = allDocs.where((doc) {
                  if (_searchQuery.isEmpty) return true;
                  final title = (doc['title'] as String).toLowerCase();
                  final desc = (doc['desc'] as String).toLowerCase();
                  return title.contains(_searchQuery) || desc.contains(_searchQuery);
                }).toList();

                if (docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 56, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'Aucun document trouvé pour "$_searchQuery"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textDark),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Vérifiez l\'orthographe ou consultez un autre onglet.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Réinitialiser la recherche'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: catColor.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(cat['icon'] as IconData, color: catColor, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Progressions Officielles IPN · ${cat['name']}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: catColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _searchQuery.isNotEmpty
                                      ? '${docs.length} document(s) correspondant(s)'
                                      : 'Référentiels pédagogiques nationaux conformes à l\'année 2026-2027.',
                                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ...docs.map((doc) {
                      final isPdf = doc['type'] == 'pdf';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12.0),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isPdf ? Colors.red.shade50 : catColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPdf ? Icons.picture_as_pdf_rounded : Icons.description_rounded,
                              color: isPdf ? Colors.redAccent : catColor,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            doc['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                          ),
                          subtitle: Text(
                            doc['desc']!,
                            style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black45),
                          onTap: () => _openDocument(context, doc),
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String pdfPath;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.pdfPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.asset(
        pdfPath,
        canShowScrollHead: true,
        canShowScrollStatus: true,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Impossible d\'ouvrir ce document : ${details.error}')),
          );
        },
      ),
    );
  }
}
