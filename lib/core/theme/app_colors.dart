import 'package:flutter/material.dart';

/// AppColors defines the exact color palette from Figma.
/// Define la paleta de colores exacta desde Figma.
class AppColors {
  // Light Mode Colors
  static const Color primaryLight = Color(0xFF1A365D); // Deep Navy
  static const Color secondaryLight = Color(0xFF475569); // Slate Gray
  static const Color successLight = Color(0xFF10B981); // Emerald
  static const Color errorLight = Color(0xFFEF4444); // Coral Red
  static const Color backgroundLight = Color(0xFFF8FAFC); // Off-White
  static const Color cardLight = Color(0xFFFFFFFF); // Pure White
  static const Color textPrimaryLight = Color(0xFF0F172A); // Navy Black
  static const Color textSecondaryLight = Color(0xFF64748B); // Cool Gray

  // Dark Mode Colors
  static const Color primaryDark = Color(0xFF82A9DF); // Soft Blue
  static const Color secondaryDark = Color(0xFF94A3B8); // Light Slate
  static const Color successDark = Color(0xFF34D399); // Soft Emerald
  static const Color errorDark = Color(0xFFF87171); // Soft Red
  static const Color backgroundDark = Color(0xFF0B1120); // Deepest Navy
  static const Color cardDark = Color(0xFF1E293B); // Dark Slate
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Off-White
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Light Slate

  // Universal Colors
  static const Color starYellow = Color(0xFFFFCC00); // Star Yellow

  /// Returns the background color based on brightness.
  /// Retorna el color de fondo basado en el brillo (tema oscuro/claro).
  static Color getBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? backgroundDark : backgroundLight;
  }
}
