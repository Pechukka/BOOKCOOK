import 'package:flutter/material.dart';
import '../recipes/recipe_list_screen.dart';
import '../ingredients/ingredient_list_screen.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  
  int _currentIndex = 0;

  //LISTADO DE LAS PANTALLAS
  static const List<Widget> _screens = [
    RecipeListScreen(),
    IngredientListScreen(),
  ];

  // ── METODO PARA CAMBIAR DE VENTANA SEGUN INDEX ──
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}