import 'package:flutter/material.dart';

class AppTheme {

  // ─────────────────────────────────────────────
  // 🎨 PALETA DE COLORES PRINCIPAL
  // ─────────────────────────────────────────────

  // Usado en botones principales, iconos activos y acentos.
  static const Color primary = Color(0xFF4F3F34);
  // Usado como fondo de pantallas.
  static const Color background = Color(0xFFF9F6F0);
  // Usado para acciones secundarias, badges y highlights.
  static const Color secondary = Color(0xFFCB8D72);
  // Usado para estados positivos, nutrición, detalles saludables.
  static const Color accent = Color(0xFFA2B59C);
  // Usado en tarjetas, inputs y separadores suaves.
  static const Color surface = Color(0xFFE8E0D5);

  // ─────────────────────────────────────────────
  // 🖋️ COLORES DE TEXTO
  // ─────────────────────────────────────────────

  // Para títulos y contenido importante.
  static const Color textPrimary = Color(0xFF3A2E25);
  // Para descripciones y textos menos relevantes.
  static const Color textSecondary = Color(0xFF6F5E53);
  // Para estados inactivos o informativos.
  static const Color textDisabled = Color(0xFF9E9188);

  // ─────────────────────────────────────────────
  // 🧱 COLORES DE ESTADO
  // ─────────────────────────────────────────────

  // Color de error
  static const Color error = Color(0xFFB85C5C);
  // Color de éxito
  static const Color success = Color(0xFF7FAE8F);

  //-----------------------------------------------------------------------------------------------------------------------

  // ─────────────────────────────────────────────
  // 🎯 TEMAS MATERIAL COMPLETO
  // ─────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,

      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        background: background,
        surface: surface,
        error: error,
      ),

      // ─────────────────────────────
      // AppBar
      // ─────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ─────────────────────────────
      // Text Theme
      // ─────────────────────────────
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 16,
        ),
        bodySmall: TextStyle(
          color: textDisabled,
          fontSize: 14,
        ),
      ),

      // ─────────────────────────────
      // Buttons
      // ─────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
        ),
      ),

      // ─────────────────────────────
      // Inputs
      // ─────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: textDisabled),
      ),

      // ─────────────────────────────
      // Cards
      // ─────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
