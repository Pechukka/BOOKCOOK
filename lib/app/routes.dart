import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/recipes/recipe_add_screen.dart';
import '../screens/recipes/recipe_detail_screen.dart';
import '../screens/ingredients/ingredient_scanner_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String addRecipe = '/addRecipe';
  static const String recipeDetail = '/recipeDetail';
  static const String scanner = '/scanner';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      home: (context) => const HomeScreen(),
      addRecipe: (context) => const RecipeAddScreen(),
      recipeDetail: (context) => const RecipeDetailScreen(),
      scanner: (context) => const IngredientScannerScreen(),
    };
  }
}