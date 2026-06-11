import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/providers/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  // Inicializamos SharedPreferences ANTES de correr la app
  final sharedPreferences = await SharedPreferences.getInstance();

  // Inicializamos Supabase
  await Supabase.initialize(
    url: 'https://ymjabaszosbrjwnghqry.supabase.co',
    anonKey: 'sb_publishable_GGMyGiX6xf8pq7mz4UhBiA_VVZ8nEbP',
  );

  runApp(
    // Envolvemos la app en el ProviderScope y SOBREESCRIBIMOS el provider
    ProviderScope(
      overrides: [
        // Aquí inyectamos la instancia real que acabamos de cargar
        shared_prefs_provider.overrideWithValue(sharedPreferences),
      ],
      child: const GalaxySavingsApp(),
    ),
  );
}

class GalaxySavingsApp extends ConsumerWidget {
  const GalaxySavingsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);
    final selectedLocale = ref.watch(locale_provider);

    // Escuchamos el estado del tema en tiempo real
    final currentThemeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Galaxy Savings',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,

      // i18n Configuration
      locale: selectedLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('pt'),
        Locale('it'),
        Locale('zh'),
        Locale('de'),
        Locale('ko'),
        Locale('ja'),
      ],

      // Router Configuration
      routerConfig: goRouter,

      // --- NUEVO: Escudo global contra el escalado de texto ---
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler:
                TextScaler.noScaling, // Fija la escala del texto al 100%
          ),
          child: child!,
        );
      },
    );
  }
}
