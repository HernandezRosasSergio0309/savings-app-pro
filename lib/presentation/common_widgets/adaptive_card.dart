import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/platform_extension.dart';
import 'adaptive_refractive_container.dart';

class AdaptiveCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;

  const AdaptiveCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ANDROID
    if (!context.isApple) {
      return Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight)
                  .withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );
    }

    // IOS
    return SizedBox(
      width: width,
      height: height,
      child: AdaptiveRefractiveContainer(
        refractionStrength: 0.25,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.cardDark.withOpacity(0.15)
                : AppColors.cardLight.withOpacity(0.4),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark
                  ? AppColors.cardDark.withOpacity(0.3)
                  : AppColors.cardLight.withOpacity(0.6),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
