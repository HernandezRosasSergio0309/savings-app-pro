import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart'; // Tu lienzo de esferas fluidas
import '../../common_widgets/adaptive_refractive_container.dart'; // Tu motor de refracción

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    // EL CONTENIDO PRINCIPAL
    final Widget mainContent = Column(
      children: [
        SizedBox(height: size.height * 0.1),
        Expanded(
          flex: 4,
          child: Image.asset(
            'assets/images/coin_piggy.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.onboardingTitle1,
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
                  l10n.onboardingSub1,
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
                        context.go('/onboarding_2?from=/onboarding'),
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
            child: Stack(
              children: [
                mainContent,
                // Botón de Lenguaje
                Positioned(
                  right: size.width * 0.06,
                  top: size.height * 0.08,
                  child: _buildLanguageButton(context, isDark, size),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: Stack(
          children: [
            mainContent,
            Positioned(
              right: size.width * 0.06,
              top: size.height * 0.08,
              child: _buildLanguageButton(context, isDark, size),
            ),
          ],
        ),
      );
    }
  }

  // BOTÓN LENGUAJE
  Widget _buildLanguageButton(BuildContext context, bool isDark, Size size) {
    return SizedBox(
      width: (size.width * 0.13).clamp(45.0, 60.0),
      height: (size.width * 0.13).clamp(45.0, 60.0),
      child: InkWell(
        onTap: () => context.go('/language?from=/onboarding'),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.language,
            color: isDark ? AppColors.textPrimaryDark : AppColors.cardLight,
            size: (size.width * 0.07).clamp(24.0, 32.0),
          ),
        ),
      ),
    );
  }
}
