// ignore_for_file: dead_null_aware_expression

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/platform_extension.dart';
import 'adaptive_refractive_container.dart';

class UniversalBackButton extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const UniversalBackButton({
    super.key,
    required this.isVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    // Obtenemos el tamaño exacto de la pantalla
    final size = MediaQuery.of(context).size;

    // Dimensiones proporcionales compartidas por ambas plataformas
    final double buttonWidth = (size.width * 0.13).clamp(45.0, 60.0);
    final double buttonHeight = (size.width * 0.13).clamp(45.0, 60.0);
    final double iconSize = (size.width * 0.07).clamp(24.0, 32.0);

    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: IgnorePointer(
        ignoring: !isVisible,
        child: context.isApple
            ? GestureDetector(
                onTap: onTap,
                child: AdaptiveRefractiveContainer(
                  refractionStrength: 0.3,
                  child: Container(
                    width: buttonWidth,
                    height: buttonHeight,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColors.cardDark.withOpacity(0.25)
                          : AppColors.cardLight.withOpacity(0.5),
                      border: Border.all(
                        color: isDark
                            ? AppColors.cardDark.withOpacity(0.3)
                            : AppColors.cardLight.withOpacity(0.7),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.15 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: textColor,
                      size: iconSize * 0.85,
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimaryLight.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Material(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  shape: const CircleBorder(),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: onTap,
                    child: SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: Icon(
                        Icons.arrow_back,
                        color: textColor,
                        size: iconSize,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
