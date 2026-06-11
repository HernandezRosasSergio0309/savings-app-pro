// ignore_for_file: unused_local_variable, dead_null_aware_expression

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/platform_extension.dart';

class AdaptiveBackground extends StatelessWidget {
  final Widget child;

  const AdaptiveBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // COMPORTAMIENTO NATIVO EN ANDROID
    if (!context.isApple) {
      return Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: child,
      );
    }

    // COMPORTAMIENTO NATIVO EN IOS
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                        .withOpacity(0.35),
                    (isDark ? AppColors.primaryDark : AppColors.primaryLight)
                        .withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (isDark
                            ? AppColors.secondaryDark
                            : AppColors.secondaryLight)
                        .withOpacity(0.3),
                    (isDark
                            ? AppColors.secondaryDark
                            : AppColors.secondaryLight)
                        .withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}
