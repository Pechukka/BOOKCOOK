import 'package:flutter/material.dart';
import 'app/app.dart';
import 'services/ingredient_service.dart';
import 'services/recipe_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await IngredientService.instance.init();
  await RecipeService.instance.init();

  // Solo cuando todo está cargado, arrancamos la app.
  runApp(const BookCookApp());
}