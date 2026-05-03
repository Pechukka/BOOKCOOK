import '../models/ingredient.dart';
import 'firestore_service.dart';

class IngredientService {

  static final IngredientService _instance = IngredientService._internal();
  IngredientService._internal();
  static IngredientService get instance => _instance;

  final _firestore = FirestoreService.instance;

  static const String _collection = 'ingredients';

  List<Ingredient> _ingredients = [];

  Future<void> init() async {
    final maps = await _firestore.getAll(_collection);
    _ingredients = maps.map((m) => Ingredient.fromMap(m)).toList();

    // MOCK INGREDIENTS PARA PRUEBAS
    if (!_ingredients.any((i) => i.id == 'mock_ing_1')) {
      final i1 = const Ingredient(
        id: 'mock_ing_1',
        name: 'Ingrediente 1 (Test)',
        brand: 'Mock Brand',
        calories: 120,
        protein: 5,
        carbs: 20,
        fats: 2,
      );
      _ingredients.add(i1);
      await _persist(i1);
    }

    if (!_ingredients.any((i) => i.id == 'mock_ing_2')) {
      final i2 = const Ingredient(
        id: 'mock_ing_2',
        name: 'Ingrediente 2 (Test)',
        brand: 'Mock Brand',
        calories: 250,
        protein: 15,
        carbs: 10,
        fats: 18,
      );
      _ingredients.add(i2);
      await _persist(i2);
    }

    if (!_ingredients.any((i) => i.id == 'mock_ing_3')) {
      final i3 = const Ingredient(
        id: 'mock_ing_3',
        name: 'Ingrediente 3 (Test)',
        brand: 'Mock Brand',
        calories: 80,
        protein: 2,
        carbs: 15,
        fats: 1,
      );
      _ingredients.add(i3);
      await _persist(i3);
    }
  }

  // ── PERSISTIR ──
  Future<void> _persist(Ingredient ingredient) async {
    await _firestore.save(_collection, ingredient.id, ingredient.toMap());
  }

  // ── LEER ──
  List<Ingredient> getAll() => List.from(_ingredients);

  Ingredient? getById(String id) {
    try {
      return _ingredients.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Ingredient> search(String query) {
    if (query.trim().isEmpty) return getAll();
    final q = query.toLowerCase();
    return _ingredients
        .where((i) =>
            i.name.toLowerCase().contains(q) ||
            (i.brand?.toLowerCase().contains(q) ?? false))
        .toList();
  }

  // ── CREAR ──
  Future<Ingredient> create({
    required String name,
    String? brand,
    String? imagePath,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    double? fiber,
    double? sugar,
    double? sodium,
  }) async {
    final ingredient = Ingredient(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      brand: brand,
      imagePath: imagePath,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
    );

    _ingredients.add(ingredient);
    await _persist(ingredient);
    return ingredient;
  }

  // ── ACTUALIZAR ──
  Future<bool> update({
    required String id,
    String? name,
    String? brand,
    String? imagePath,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? fiber,
    double? sugar,
    double? sodium,
  }) async {
    final index = _ingredients.indexWhere((i) => i.id == id);
    if (index == -1) return false;

    _ingredients[index] = _ingredients[index].copyWith(
      name: name,
      brand: brand,
      imagePath: imagePath,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      fiber: fiber,
      sugar: sugar,
      sodium: sodium,
    );

    await _persist(_ingredients[index]);
    return true;
  }

  // ── BORRAR ──
  Future<bool> delete(String id) async {
    final before = _ingredients.length;
    _ingredients.removeWhere((i) => i.id == id);
    if (_ingredients.length < before) {
      await _firestore.delete(_collection, id);
      return true;
    }
    return false;
  }
}