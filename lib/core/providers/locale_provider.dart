import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Este es el Provider global que inyectaste en tu main.dart
final shared_prefs_provider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Se debe inicializar en el main.dart');
});

// 2. Notifier para manejar el idioma
class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences prefs;

  // Al iniciar, cargamos el idioma de la memoria
  LocaleNotifier(this.prefs) : super(_loadLocale(prefs));

  static Locale _loadLocale(SharedPreferences prefs) {
    final savedLocale = prefs.getString('language_code');

    if (savedLocale != null) {
      return Locale(savedLocale);
    }

    // Si es la primera vez, puedes dejar 'es' por defecto,
    // o usar PlatformDispatcher.instance.locale para leer el idioma del celular.
    return const Locale('es');
  }

  // Guardamos el nuevo idioma en la memoria al seleccionarlo
  void setLocale(Locale locale) {
    state = locale;
    prefs.setString('language_code', locale.languageCode);
  }
}

// 3. El Provider que usarás en tu MaterialApp y Settings
final locale_provider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(shared_prefs_provider);
  return LocaleNotifier(prefs);
});
