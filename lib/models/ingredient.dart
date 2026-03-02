class Ingredient {

  final String id;     
  final String name;  
  final String? brand;
  final String? imagePath;

  final double calories; 
  final double protein;
  final double carbs; 
  final double fats; 

  final double? fiber; 
  final double? sugar; 
  final double? sodium; 

  const Ingredient({
    required this.id,
    required this.name,
    this.brand,
    this.imagePath,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.fiber,
    this.sugar,
    this.sodium,
  });

  Ingredient copyWith({
    String? id,
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
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imagePath: imagePath ?? this.imagePath,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'imagePath': imagePath,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'] as String,
      name: map['name'] as String,
      brand: map['brand'] as String?,
      imagePath: map['imagePath'] as String?,
      // (map['calories'] as num) porque puede venir como int o double
      // .toDouble() lo convierte siempre a double
      calories: (map['calories'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fats: (map['fats'] as num).toDouble(),
      fiber: map['fiber'] != null ? (map['fiber'] as num).toDouble() : null,
      sugar: map['sugar'] != null ? (map['sugar'] as num).toDouble() : null,
      sodium: map['sodium'] != null ? (map['sodium'] as num).toDouble() : null,
    );
  }
}