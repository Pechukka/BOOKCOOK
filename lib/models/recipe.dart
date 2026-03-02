import 'ingredient.dart';

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
      quantity: map['quantity'] as String,
    );
  }
}


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

  double get totalCalories {
    return ingredients.fold(
      0,
      (total, recipeIngredient) =>
          total + recipeIngredient.ingredient.calories,
    );
  }

  double get totalProtein {
    return ingredients.fold(
      0,
      (total, recipeIngredient) =>
          total + recipeIngredient.ingredient.protein,
    );
  }

  double get totalCarbs {
    return ingredients.fold(
      0,
      (total, recipeIngredient) =>
          total + recipeIngredient.ingredient.carbs,
    );
  }

  double get totalFats {
    return ingredients.fold(
      0,
      (total, recipeIngredient) =>
          total + recipeIngredient.ingredient.fats,
    );
  }

  Recipe copyWith({
    String? id,
    String? name,
    String? imagePath,
    List<RecipeIngredient>? ingredients,
    List<String>? steps,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }

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
      ingredients: (map['ingredients'] as List)
          .map((item) => RecipeIngredient.fromMap(item as Map<String, dynamic>))
          .toList(),
      steps: List<String>.from(map['steps'] as List),
    );
  }
}