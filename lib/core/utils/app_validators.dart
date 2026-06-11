import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// AppValidators contains reusable validation logic and regular expressions.
/// AppValidators contiene lógica de validación reutilizable y expresiones regulares.
class AppValidators {
  /// Valida que el correo tenga un formato estándar y seguro (ejemplo@dominio.com)
  static bool is_valid_email(String email) {
    // Esta RegEx estricta bloquea comillas, espacios y obliga a tener un formato de dominio real
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  // Checks / Validaciones individuales
  static bool has_min_length(String password) => password.length >= 8;
  static bool has_uppercase(String password) =>
      RegExp(r'[A-Z]').hasMatch(password);
  static bool has_lowercase(String password) =>
      RegExp(r'[a-z]').hasMatch(password);
  static bool has_number(String password) =>
      RegExp(r'[0-9]').hasMatch(password);
  static bool has_special_character(String password) =>
      RegExp(r'[!@#\$&*~_.,-]').hasMatch(password);

  /// Calculates password strength from 0.0 to 1.0
  /// Calcula la fuerza de la contraseña de 0.0 a 1.0
  static double calculate_password_strength(String password) {
    if (password.isEmpty) return 0.0;

    double strength = 0.0;
    if (has_min_length(password)) strength += 0.2;
    if (has_uppercase(password)) strength += 0.2;
    if (has_lowercase(password)) strength += 0.2;
    if (has_number(password)) strength += 0.2;
    if (has_special_character(password)) strength += 0.2;

    return strength;
  }

  /// Returns the color based on the current strength
  /// Retorna el color basado en la fuerza actual
  static Color get_strength_color(double strength) {
    // Adaptado para usar los colores de tu tema
    if (strength <= 0.2) {
      return AppColors
          .errorLight;
    }
    if (strength <= 0.6) {
      return AppColors
          .starYellow;
    }
    if (strength <= 0.8) {
      return AppColors.primaryLight;
    }
    return AppColors
        .successLight;
  }
}
