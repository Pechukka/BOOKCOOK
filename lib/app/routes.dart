import 'package:flutter/material.dart';

class AppRoutes {

  // ─────────────────────────────────────────────
  // Nombres de rutas
  // ─────────────────────────────────────────────
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static const String recipeList = '/recipes';
  static const String recipeAdd = '/recipes/add';
  static const String recipeDetail = '/recipes/detail';

  static const String ingredientList = '/ingredients';
  static const String ingredientScanner = '/ingredients/scanner';
  static const String ingredientDetail = '/ingredients/detail';
  static const String ingredientEdit = '/ingredients/edit';


  // ─────────────────────────────────────────────
  // Mapa de rutas
  // ─────────────────────────────────────────────
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (_) => const Placeholder(),
      register: (_) => const Placeholder(),
      home: (_) => const Placeholder(),

      recipeList: (_) => const Placeholder(),
      recipeAdd: (_) => const Placeholder(),
      recipeDetail: (_) => const Placeholder(),

      ingredientList: (_) => const Placeholder(),
      ingredientScanner: (_) => const Placeholder(),
      ingredientDetail: (_) => const Placeholder(),
      ingredientEdit: (_) => const Placeholder(),
    };
  }
}
