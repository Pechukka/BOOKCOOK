import '../models/ingredient.dart';
import '../models/recipe.dart';
import 'firestore_service.dart';

class RecipeService {

  static final RecipeService _instance = RecipeService._internal();
  RecipeService._internal();
  static RecipeService get instance => _instance;

  final _firestore = FirestoreService.instance;
  static const String _collection = 'recipes';

  List<Recipe> _recipes = [];

  Future<void> init() async {
    final maps = await _firestore.getAll(_collection);
    _recipes = maps.map((m) => Recipe.fromMap(m)).toList();

    // MOCK RECIPE PARA PRUEBAS
    if (!_recipes.any((r) => r.id == 'mock_recipe_1')) {
      final r1 = Recipe(
        id: 'mock_recipe_1',
        name: 'Receta de Prueba (Test)',
        ingredients: const [
          RecipeIngredient(
            ingredient: Ingredient(
              id: 'mock_ing_1',
              name: 'Ingrediente 1 (Test)',
              brand: 'Mock Brand',
              calories: 120,
              protein: 5,
              carbs: 20,
              fats: 2,
            ),
            quantity: '100',
          ),
          RecipeIngredient(
            ingredient: Ingredient(
              id: 'mock_ing_2',
              name: 'Ingrediente 2 (Test)',
              brand: 'Mock Brand',
              calories: 250,
              protein: 15,
              carbs: 10,
              fats: 18,
            ),
            quantity: '50',
          ),
          RecipeIngredient(
            ingredient: Ingredient(
              id: 'mock_ing_3',
              name: 'Ingrediente 3 (Test)',
              brand: 'Mock Brand',
              calories: 80,
              protein: 2,
              carbs: 15,
              fats: 1,
            ),
            quantity: '200',
          ),
        ],
        steps: const [
          'Paso 1: Mezclar el Ingrediente 1 y el Ingrediente 2 en un bol grande.',
          'Paso 2: Añadir poco a poco el Ingrediente 3 mientras se remueve constantemente.',
          'Paso 3: Servir frío. ¡A disfrutar!'
        ],
      );
      _recipes.add(r1);
      await _persist(r1);
    }
  }

  Future<void> _persist(Recipe recipe) async {
    await _firestore.save(_collection, recipe.id, recipe.toMap());
  }

  List<Recipe> getAll() => List.from(_recipes);

  Recipe? getById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Recipe> search(String query) {
    if (query.trim().isEmpty) return getAll();
    final q = query.toLowerCase();
    return _recipes
        .where((r) => r.name.toLowerCase().contains(q))
        .toList();
  }

  Future<Recipe> create({
    required String name,
    String? imagePath,
    required List<RecipeIngredient> ingredients,
    required List<String> steps,
  }) async {
    final recipe = Recipe(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      imagePath: imagePath,
      ingredients: ingredients,
      steps: steps,
    );
    _recipes.add(recipe);
    await _persist(recipe);
    return recipe;
  }

  Future<bool> update({
    required String id,
    String? name,
    String? imagePath,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
  }) async {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index == -1) return false;
    _recipes[index] = _recipes[index].copyWith(
      name: name,
      imagePath: imagePath,
      ingredients: ingredients,
      steps: steps,
    );
    await _persist(_recipes[index]);
    return true;
  }

  Future<bool> delete(String id) async {
    final before = _recipes.length;
    _recipes.removeWhere((r) => r.id == id);
    if (_recipes.length < before) {
      await _firestore.delete(_collection, id);
      return true;
    }
    return false;
  }
}