import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'locale_provider.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences prefs;

  // Al iniciar, cargamos el tema guardado
  ThemeNotifier(this.prefs) : super(_loadTheme(prefs));

  // --- LÓGICA DE CARGA ---
  static ThemeMode _loadTheme(SharedPreferences prefs) {
    final savedTheme = prefs.getString('theme_mode');

    if (savedTheme == 'light') return ThemeMode.light;
    if (savedTheme == 'dark') return ThemeMode.dark;

    // MAGIA: Si no hay nada guardado (primera vez), usa el modo del celular
    return ThemeMode.system;
  }

  // --- LÓGICA DE GUARDADO ---
  void toggleTheme(ThemeMode mode) {
    state = mode; // Actualizamos la pantalla

    // Guardamos en la memoria interna del celular
    if (mode == ThemeMode.light) {
      prefs.setString('theme_mode', 'light');
    } else if (mode == ThemeMode.dark) {
      prefs.setString('theme_mode', 'dark');
    } else {
      prefs.setString('theme_mode', 'system');
    }
  }
}

// Actualizamos el provider para que inyecte SharedPreferences
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(shared_prefs_provider);
  return ThemeNotifier(prefs);
});
