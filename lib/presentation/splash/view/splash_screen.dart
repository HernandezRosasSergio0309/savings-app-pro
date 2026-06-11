import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    // Pausa estética para mostrar el logo y dar tiempo a que Supabase intercepte el Deep Link si venimos de Google.
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Revisamos el estado de la sesión actual
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // SÍ hay sesión
      try {
        final userId = session.user.id;
        // Consultamos el perfil
        final profile = await Supabase.instance.client
            .from('profiles')
            .select('username')
            .eq('id', userId)
            .single();

        if (mounted) {
          // Verificamos si el username es nulo o está vacío
          if (profile['username'] == null ||
              profile['username'].toString().trim().isEmpty) {
            context.go('/complete-profile');
          } else {
            context.go('/dashboard');
          }
        }
      } catch (e) {
        // Error de red o perfil no encontrado
        if (mounted) context.go('/complete-profile');
      }
    } else {
      // No hay sesión. Es un usuario nuevo, procedemos al flujo normal.
      if (mounted) context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Obtenemos las dimensiones exactas de la pantalla actual
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // IMAGEN RESPONSIVA
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: size.height * 0.78, //
              child: Image.asset(
                'assets/images/logo_splash_screen.png',
                fit: BoxFit.cover,
              ),
            ),
            // TEXTO RESPONSIVO
            Positioned(
              left: size.width * 0.05,
              top: size.height * 0.36,
              child: Text(
                'Galaxy\nSavings',
                style: GoogleFonts.poppins(
                  fontSize: (size.width * 0.115).clamp(32.0, 48.0),
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  letterSpacing: -1.0,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
