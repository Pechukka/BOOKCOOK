import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/credits_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/recipes/recipe_list_screen.dart';
import '../screens/recipes/recipe_add_screen.dart';
import '../screens/recipes/recipe_detail_screen.dart';
import '../screens/ingredients/ingredient_list_screen.dart';
import '../screens/ingredients/ingredient_scanner_screen.dart';
import '../screens/ingredients/ingredient_confirm_screen.dart';
import '../screens/ingredients/ingredient_detail_screen.dart';
import '../screens/ingredients/ingredient_edit_screen.dart';

class AppRoutes {

  static const String splash            = '/';
  static const String login             = '/login';
  static const String register          = '/register';
  static const String home              = '/home';
  static const String recipeList        = '/recipes';
  static const String recipeAdd         = '/recipes/add';
  static const String recipeDetail      = '/recipes/detail';
  static const String ingredientList    = '/ingredients';
  static const String ingredientScanner = '/ingredients/scanner';
  static const String ingredientConfirm = '/ingredients/confirm';
  static const String ingredientDetail  = '/ingredients/detail';
  static const String ingredientEdit    = '/ingredients/edit';
  static const String credits           = '/credits';

  static Map<String, WidgetBuilder> get routes => {
    splash:            (_) => const SplashScreen(),
    login:             (_) => const LoginScreen(),
    register:          (_) => const RegisterScreen(),
    home:              (_) => const HomeScreen(),
    recipeList:        (_) => const RecipeListScreen(),
    recipeAdd:         (_) => const RecipeAddScreen(),
    recipeDetail:      (_) => const RecipeDetailScreen(),
    ingredientList:    (_) => const IngredientListScreen(),
    ingredientScanner: (_) => const IngredientScannerScreen(),
    ingredientConfirm: (_) => const IngredientConfirmScreen(),
    ingredientDetail:  (_) => const IngredientDetailScreen(),
    ingredientEdit:    (_) => const IngredientEditScreen(),
    credits:           (_) => const CreditsScreen(),
  };
}