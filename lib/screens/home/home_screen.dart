// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/routes.dart';
import '../../services/auth_service.dart';
import '../../services/ingredient_service.dart';
import '../../services/recipe_service.dart';
import '../../widgets/navigation/bottom_nav_bar.dart';
import '../ingredients/ingredient_list_screen.dart';
import '../recipes/recipe_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentIndex = 0;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    await IngredientService.instance.init();
    await RecipeService.instance.init();
    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  Future<void> _onLogout() async {
    Navigator.pop(context);

    await AuthService.instance.logout();

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(

      // ── DRAWER ──
      drawer: _buildDrawer(context),

      body: IndexedStack(
        index: _currentIndex,
        children: const [
          RecipeListScreen(),
          IngredientListScreen(),
        ],
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [

          // ── CABECERA DEL DRAWER ──
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/logo_white.png',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 10),
                Text(
                  'BookCook',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 4),
                // Email del usuario logueado
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // ── OPCIONES DEL DRAWER ──

          // CREDITS
          ListTile(
            leading: Icon(
              Icons.info_outline_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Credits'),
            onTap: () {
              Navigator.pop(context); 
              Navigator.pushNamed(context, AppRoutes.credits);
            },
          ),

          const Divider(),

          // LOGOUT
          ListTile(
            leading: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
            title: const Text(
              'Log out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: _onLogout,
          ),
        ],
      ),
    );
  }
}