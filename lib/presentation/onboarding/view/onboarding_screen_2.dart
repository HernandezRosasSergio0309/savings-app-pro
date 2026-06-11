// ignore_for_file: dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../common_widgets/adaptive_refractive_container.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    // CONTENIDO ESTRUCTURAL
    final Widget mainContent = Column(
      children: [
        SizedBox(height: size.height * 0.1),
        // Imagen responsiva
        Expanded(
          flex: 4,
          child: Image.asset(
            'assets/images/goal_piggy.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        // Contenedor de Textos y Botón
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.onboardingTitle2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.068).clamp(22.0, 30.0),
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  l10n.onboardingSub2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.04).clamp(14.0, 18.0),
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                SizedBox(height: size.height * 0.045),
                SizedBox(
                  width: (size.width * 0.45).clamp(150.0, 200.0),
                  height: (size.height * 0.06).clamp(48.0, 60.0),
                  child: ElevatedButton(
                    onPressed: () =>
                        context.go('/onboarding_3?from=/onboarding_2'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.btnNext,
                      style: GoogleFonts.poppins(
                        fontSize: (size.width * 0.045).clamp(16.0, 20.0),
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.backgroundDark
                            : AppColors.cardLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // INTEGRACIÓN ADAPTATIVA
    if (context.isApple) {
      return Scaffold(
        body: AdaptiveBackground(
          child: AdaptiveRefractiveContainer(
            refractionStrength: 0.2,
            child: mainContent,
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: Stack(
          children: [
            Positioned.fill(child: mainContent),
          ],
        ),
      );
    }
  }
}
