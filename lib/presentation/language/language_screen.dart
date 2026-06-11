// ignore_for_file: unused_local_variable, dead_null_aware_expression

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final menuCardColor = theme.colorScheme.surface;
    final l10n = AppLocalizations.of(context)!;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    // Escuchamos el estado actual del idioma
    final currentLocale = ref.watch(locale_provider);
    final size = MediaQuery.of(context).size;

    final languages = [
      {'name': 'English', 'code': 'en', 'flag': 'assets/images/usa_uk.png'},
      {'name': 'Español', 'code': 'es', 'flag': 'assets/images/mex_spain.png'},
      {'name': 'Français', 'code': 'fr', 'flag': 'assets/images/france.png'},
      {'name': 'Português', 'code': 'pt', 'flag': 'assets/images/bra_por.png'},
      {'name': 'Italiano', 'code': 'it', 'flag': 'assets/images/italy.png'},
      {'name': '中文', 'code': 'zh', 'flag': 'assets/images/china.png'},
      {'name': 'Deutsch', 'code': 'de', 'flag': 'assets/images/germany.png'},
      {'name': '한국어', 'code': 'ko', 'flag': 'assets/images/korea.png'},
      {'name': '日本語', 'code': 'ja', 'flag': 'assets/images/japan.png'},
    ];

    // CONTENIDO CENTRAL DE LA INTERFAZ CON COEFICIENTES ORIGINALES
    final Widget screenContent = Stack(
      children: [
        // Título central unificado con posición relativa
        Positioned(
          top: size.height * 0.11,
          left: size.width * 0.06,
          right: size.width * 0.06,
          child: Text(
            l10n.languageTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: (size.width * 0.075).clamp(24.0, 32.0),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),

        // Lista de idiomas
        Positioned.fill(
          top: size.height * 0.17,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06, vertical: size.height * 0.02),
            itemCount: languages.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: size.height * 0.015),
            itemBuilder: (context, index) {
              final lang = languages[index];
              final isSelected = currentLocale.languageCode == lang['code'];

              // Cuerpo interno del tile reutilizado de forma responsiva
              final Widget tileContent = ListTile(
                onTap: () {
                  ref
                      .read(locale_provider.notifier)
                      .setLocale(Locale(lang['code']!));
                },
                splashColor: context.isApple ? Colors.transparent : null,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.04,
                    vertical: size.height * 0.01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tileColor: context.isApple
                    ? Colors.transparent
                    : (isSelected
                        ? (isDark
                            ? AppColors.primaryDark.withOpacity(0.25)
                            : AppColors.primaryLight.withOpacity(0.15))
                        : Colors.transparent),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    lang['flag']!,
                    width: (size.width * 0.1).clamp(35.0, 45.0),
                    height: (size.height * 0.035).clamp(25.0, 35.0),
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  lang['name']!,
                  style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.045).clamp(16.0, 20.0),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: textColor,
                  ),
                ),
                trailing: Radio<String>(
                  value: lang['code']!,
                  groupValue: currentLocale.languageCode,
                  activeColor:
                      isDark ? AppColors.primaryDark : AppColors.primaryLight,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(locale_provider.notifier)
                          .setLocale(Locale(value));
                    }
                  },
                ),
              );

              // COMPORTAMIENTO ADAPTATIVO DEL CONTENEDOR CELDA
              if (context.isApple) {
                return Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? AppColors.primaryDark.withOpacity(0.2)
                            : AppColors.primaryLight.withOpacity(0.15))
                        : (isDark
                            ? AppColors.cardDark.withOpacity(0.15)
                            : AppColors.cardLight.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? (isDark
                              ? AppColors.primaryDark.withOpacity(0.4)
                              : AppColors.primaryLight.withOpacity(0.5))
                          : (isDark
                              ? Colors.white.withOpacity(0.08)
                              : AppColors.cardLight.withOpacity(0.6)),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                      child: tileContent,
                    ),
                  ),
                );
              } else {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: menuCardColor,
                  child: tileContent,
                );
              }
            },
          ),
        ),
      ],
    );

    // CAPA DE DISTRIBUCIÓN ADAPTATIVA DE INTERFAZ DE RAÍZ
    return context.isApple
        ? AdaptiveBackground(
            child:
                screenContent)
        : Scaffold(
            backgroundColor: AppColors.getBackgroundColor(theme.brightness),
            body:
                screenContent,
          );
  }
}
