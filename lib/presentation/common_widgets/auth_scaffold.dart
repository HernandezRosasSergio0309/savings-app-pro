// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/platform_extension.dart';
import 'adaptive_background.dart';
import 'adaptive_refractive_container.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;

  const AuthScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // CONTENIDO BASE
    final Widget coreContent = SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            child,
          ],
        ),
      ),
    );

    // INTERSECCIÓN DE DISEÑO ADAPTATIVO
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: context.isApple
          ? AdaptiveRefractiveContainer(
              refractionStrength:
                  0.2,
              child: coreContent,
            )
          : Scaffold(
              backgroundColor:
                  isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              body:
                  coreContent,
            ),
    );
  }
}
