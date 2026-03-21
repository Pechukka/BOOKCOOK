import 'ingredient.dart';

// RECIPE MODEL
class Recipe {
  final String id;
  final String name;
  final String? imagePath;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;

  const Recipe({
    required this.id,
    required this.name,
    this.imagePath,
    required this.ingredients,
    required this.steps,
  });

  // ── GETTERS NUTRICIONALES ──

  double get totalCalories => _sumNutrient((i) => i.calories);
  double get totalProtein  => _sumNutrient((i) => i.protein);
  double get totalCarbs    => _sumNutrient((i) => i.carbs);
  double get totalFats     => _sumNutrient((i) => i.fats);

  double _sumNutrient(double Function(Ingredient) getNutrient) {
    return ingredients.fold(0, (total, ri) {
      final qty = double.tryParse(ri.quantity) ?? 100;
      return total + (getNutrient(ri.ingredient) * qty / 100);
    });
  }

  // ── COPY WITH ──────
  Recipe copyWith({
    String? name,
    String? imagePath,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
  }) {
    return Recipe(
      id: id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

  // ── SERIALIZACIÓN 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'ingredients': ingredients.map((ri) => ri.toMap()).toList(),
      'steps': steps,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] as String,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String?,
      ingredients: (map['ingredients'] as List<dynamic>)
          .map((item) => RecipeIngredient.fromMap(item as Map<String, dynamic>))
          .toList(),
      steps: (map['steps'] as List<dynamic>)
          .map((s) => s as String)
          .toList(),
    );
  }
}

class RecipeIngredient {
  final Ingredient ingredient;
  final String quantity;

  const RecipeIngredient({
    required this.ingredient,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'ingredient': ingredient.toMap(),
      'quantity': quantity,
    };
  }

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      ingredient: Ingredient.fromMap(map['ingredient'] as Map<String, dynamic>),
      quantity: map['quantity'] as String? ?? '',
    );
  }
}