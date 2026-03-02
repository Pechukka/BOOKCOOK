import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenFoodService {

  static final OpenFoodService _instance = OpenFoodService._internal();
  OpenFoodService._internal();
  static OpenFoodService get instance => _instance;

  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v0/product';

  // ── BUSCAR POR CÓDIGO DE BARRAS ──
  Future<OpenFoodResult?> getByBarcode(String barcode) async {
    try {
      final url = Uri.parse('$_baseUrl/$barcode.json');
      final response = await http.get(url);

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['status'] != 1) return null;

      final product = data['product'] as Map<String, dynamic>;
      final nutrients = product['nutriments'] as Map<String, dynamic>? ?? {};

      return OpenFoodResult(
        name: product['product_name'] as String? ?? '',
        brand: product['brands'] as String? ?? '',
        imageUrl: product['image_url'] as String? ?? '',
        calories: _toDouble(nutrients['energy-kcal_100g']),
        protein: _toDouble(nutrients['proteins_100g']),
        carbs: _toDouble(nutrients['carbohydrates_100g']),
        fats: _toDouble(nutrients['fat_100g']),
        fiber: _toDouble(nutrients['fiber_100g']),
        sugar: _toDouble(nutrients['sugars_100g']),
        sodium: _toDouble(nutrients['sodium_100g']),
      );

    } catch (_) {
      return null;
    }
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}


// ── RESULTADO DEL ESCANEO ──
class OpenFoodResult {
  final String name;
  final String brand;
  final String imageUrl;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fats;
  final double? fiber;
  final double? sugar;
  final double? sodium;

  const OpenFoodResult({
    required this.name,
    required this.brand,
    required this.imageUrl,
    this.calories,
    this.protein,
    this.carbs,
    this.fats,
    this.fiber,
    this.sugar,
    this.sodium,
  });
}