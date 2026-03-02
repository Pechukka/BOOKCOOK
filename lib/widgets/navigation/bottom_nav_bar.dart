import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {

  // 0 → Recetas, 1 → Ingredientes
  final int currentIndex;

  final ValueChanged<int> onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,

      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: primary.withOpacity(0.4),
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      elevation: 8,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_outlined),
          activeIcon: Icon(Icons.menu_book_rounded),
          label: 'Recipes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.egg_outlined),
          activeIcon: Icon(Icons.egg_rounded),
          label: 'Ingredients',
        ),
      ],
    );
  }
}