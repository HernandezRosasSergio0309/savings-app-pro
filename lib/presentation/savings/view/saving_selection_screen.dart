// ignore_for_file: dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../common_widgets/adaptive_refractive_container.dart';

class SavingSelectionScreen extends StatelessWidget {
  const SavingSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final widgetColor = isDark ? AppColors.cardDark : AppColors.primaryLight;

    // CONTENIDO CENTRAL
    final Widget screenContent = SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              l10n.selectionTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: (size.width * 0.075).clamp(28.0, 36.0),
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            _SelectionCard(
              title: l10n.selectionGoalTitle,
              iconData: Icons.flag_rounded,
              color: widgetColor,
              onTap: () =>
                  context.push('/create_target_saving?from=/saving_selection'),
            ),
            SizedBox(height: size.height * 0.04),
            _SelectionCard(
              title: l10n.selectionFreeTitle,
              iconData: Icons.savings_rounded,
              color: widgetColor,
              onTap: () => context
                  .push('/create_freestyle_saving?from=/saving_selection'),
            ),
            SizedBox(height: size.height * 0.08),
          ],
        ),
      ),
    );

    // RENDERIZADO ADAPTATIVO
    return context.isApple
        ? Scaffold(
            backgroundColor: Colors.transparent,
            body: AdaptiveBackground(child: screenContent),
          )
        : Scaffold(
            backgroundColor: AppColors.getBackgroundColor(theme.brightness),
            body: screenContent,
          );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color color;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.title,
    required this.iconData,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final Widget cardContent = Row(
      children: [
        Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Container(
            width: (size.width * 0.15).clamp(60.0, 80.0),
            height: (size.width * 0.15).clamp(60.0, 80.0),
            decoration: BoxDecoration(
              color: AppColors.cardLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(iconData,
                size: (size.width * 0.08).clamp(30.0, 40.0),
                color: AppColors.cardLight),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(right: 16.0, top: 20.0, bottom: 20.0),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: (size.width * 0.045).clamp(16.0, 20.0),
                  fontWeight: FontWeight.w600,
                  color: AppColors.cardLight,
                  height: 1.3),
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: size.width * 0.06),
          child: Icon(Icons.arrow_forward_ios_rounded,
              color: AppColors.cardLight.withOpacity(0.54),
              size: (size.width * 0.045).clamp(18.0, 22.0)),
        ),
      ],
    );

    if (context.isApple) {
      return GestureDetector(
        onTap: onTap,
        child: AdaptiveRefractiveContainer(
          refractionStrength: 0.25,
          child: Container(
            width: double.infinity,
            height: (size.height * 0.15).clamp(120.0, 150.0),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.35 : 0.55),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withOpacity(isDark ? 0.25 : 0.65),
                width: 1.5,
              ),
            ),
            child: cardContent,
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: AppColors.textPrimaryLight.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8)),
          ],
        ),
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              width: double.infinity,
              height: (size.height * 0.15).clamp(120.0, 150.0),
              child: cardContent,
            ),
          ),
        ),
      );
    }
  }
}
