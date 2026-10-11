import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_colors.dart';

class AdminLayout extends StatefulWidget {
  final Widget child;

  const AdminLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Tableau de Bord', 'route': '/dashboard'},
    {'icon': Icons.menu_book_rounded, 'label': 'Cours & Quiz', 'route': '/cours'},
    {'icon': Icons.people_alt_rounded, 'label': 'Élèves & Parents', 'route': '/users'},
    {'icon': Icons.category_rounded, 'label': 'Disciplines', 'route': '/disciplines'},
    {'icon': Icons.extension_rounded, 'label': 'Modules Futurs', 'route': '/modules'},
  ];

  @override
  Widget build(BuildContext context) {
    // Détecte si l'écran est petit (téléphone) ou grand (ordinateur)
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: isDesktop
          ? null // Pas d'appBar sur Desktop (la sidebar prend toute la hauteur)
          : AppBar(
              backgroundColor: AppColors.sidebar,
              foregroundColor: Colors.white,
              title: const Text('e-eduPocket Admin', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
      drawer: isDesktop ? null : _buildDrawer(),
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                if (isDesktop) _buildTopBar(),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.sidebar,
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 280,
      color: AppColors.sidebar,
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebarContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Logo / Header
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Icon(Icons.school_rounded, color: AppColors.accent, size: 48),
              const SizedBox(height: 16),
              const Text(
                'e-eduPocket',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                'Espace Administrateur',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white24, height: 1),
        const SizedBox(height: 16),
        
        // Menu Items
        Expanded(
          child: ListView.builder(
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              final isSelected = _selectedIndex == index;
              
              return ListTile(
                leading: Icon(
                  item['icon'],
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                ),
                title: Text(
                  item['label'],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade400,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: isSelected,
                selectedTileColor: AppColors.primary.withOpacity(0.15),
                contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  // Fermer le drawer si sur mobile
                  if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
                    Navigator.pop(context);
                  }
                  context.go(item['route']);
                },
              );
            },
          ),
        ),
        
        // Footer (Déconnexion)
        const Divider(color: Colors.white24, height: 1),
        ListTile(
          leading: const Icon(Icons.logout_rounded, color: AppColors.secondary),
          title: const Text('Déconnexion', style: TextStyle(color: AppColors.secondary)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          onTap: () async {
            await Supabase.instance.client.auth.signOut();
            if (context.mounted) {
              context.go('/login');
            }
          },
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titre de la page active
          Text(
            _menuItems[_selectedIndex]['label'],
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          
          // Profil administrateur
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textMuted),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                backgroundColor: AppColors.secondary,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Admin Principal', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  Text('Super Admin', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
