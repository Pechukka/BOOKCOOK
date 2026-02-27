import 'package:flutter/material.dart';

class AppTheme {
  // ─────────────────────────────────────────────────────────
  // COLORES BASE
  // ─────────────────────────────────────────────────────────
  static const Color _primaryColor    = Color(0xFF8B6914); // café dorado
  static const Color _backgroundColor = Color(0xFFF5F0E8); // crema papel
  static const Color _surfaceColor    = Color(0xFFEDE8DB); // tarjetas
  static const Color _textPrimary     = Color(0xFF3D2B0A); // texto oscuro
  static const Color _textSecondary   = Color(0xFF8C7B5E); // texto suave
  static const Color _borderColor     = Color(0xFFD9D0BF); // bordes

  // ─────────────────────────────────────────────────────────
  // TEMA PRINCIPAL
  // ─────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      
      // ── ColorScheme ──
      colorScheme: ColorScheme.light(
        primary:   _primaryColor,
        surface:   _surfaceColor,
        onPrimary: Colors.white,
        onSurface: _textPrimary,
      ),

      // El fondo de cada pantalla
      scaffoldBackgroundColor: _backgroundColor,

      // ── TextTheme ──
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: _primaryColor,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: _textSecondary,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
        ),
      ),

      // ── InputDecorationTheme ──
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        // border normal (sin foco y sin error)
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderColor),
        ),

        // border cuando el campo está inactivo
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderColor),
        ),

        // border cuando el usuario está escribiendo en el campo
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 1.5),
        ),
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 14),
        iconColor: _textSecondary,
      ),

      // ── ElevatedButtonTheme ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}