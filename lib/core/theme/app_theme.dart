import 'package:flutter/material.dart';
import 'app_colors.dart';

/// AppTheme defines the global themes for Android (Material) and baseline for iOS.
/// AppTheme define los temas globales para Android (Material) y la base para iOS.
class AppTheme {
  /// Light Theme Configuration
  /// Configuración del Tema Claro
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        error: AppColors.errorLight,
        surface: AppColors.cardLight,
      ), // <-- Coma añadida aquí
      // Android Material Design Cards (Elevation: 4, Radius: 12)
      // Tarjetas Material Design Android (Elevación: 4, Radio: 12)
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 4,
        shadowColor: const Color(0x1A000000), // Black at 10% opacity
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Dark Theme Configuration
  /// Configuración del Tema Oscuro
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        error: AppColors.errorDark,
        surface: AppColors.cardDark,
      ), // <-- Coma añadida aquí
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 4,
        shadowColor: const Color(0x1A000000), // Black at 10% opacity
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
