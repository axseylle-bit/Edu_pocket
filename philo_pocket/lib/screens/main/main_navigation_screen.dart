import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../dashboard/student_dashboard_screen.dart';
import '../chat/aleckse_chat_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const StudentDashboardScreen(),
    const Center(child: Text('Cours & TP')),
    const AleckseChatScreen(),
    const Center(child: Text('Révisions & Quiz')),
    const Center(child: Text('Profil & Parents')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentIndex = 2; // Ouvre ALECKSE
          });
        },
        backgroundColor: AppColors.accent, // Bouton or chaud pour ALECKSE
        elevation: 4,
        child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Accueil', 0),
              _buildNavItem(Icons.menu_book_rounded, 'Cours', 1),
              const SizedBox(width: 48), // Espace pour le bouton central (Flamme)
              _buildNavItem(Icons.psychology_rounded, 'Révisions', 3),
              _buildNavItem(Icons.person_rounded, 'Profil', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
