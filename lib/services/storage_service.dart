import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  static final StorageService _instance = StorageService._internal();
  StorageService._internal();
  static StorageService get instance => _instance;

  // ── GUARDAR LISTA ──
  Future<void> saveList(String key, List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }


  // ── LEER LISTA ──
  Future<List<Map<String, dynamic>>> loadList(String key) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(key);

    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((item) => item as Map<String, dynamic>).toList();
  }


  // ── BORRAR ──
  Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}