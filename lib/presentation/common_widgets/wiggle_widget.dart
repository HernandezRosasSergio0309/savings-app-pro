// ignore_for_file: unused_import, dead_null_aware_expression

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/platform_extension.dart';

/// Reusable widget for "Jiggle Mode" effect used in edit modes.
/// Widget reutilizable para el modo "Jiggle" (edición) de elementos.
class WiggleWidget extends StatefulWidget {
  final Widget child;
  final bool isWiggling;

  const WiggleWidget({
    super.key,
    required this.child,
    required this.isWiggling,
  });

  @override
  State<WiggleWidget> createState() => _WiggleWidgetState();
}

class _WiggleWidgetState extends State<WiggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Controlador rápido para una vibración creíble
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // Si empieza en modo edición, arrancamos la vibración de una vez
    if (widget.isWiggling) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(WiggleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Escuchamos los cambios en el parámetro 'isWiggling'
    if (widget.isWiggling && !oldWidget.isWiggling) {
      // Activar vibración continua
      _controller.repeat(reverse: true);
    } else if (!widget.isWiggling && oldWidget.isWiggling) {
      // Detener vibración y resetear al centro
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenemos el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    // Usamos AnimatedBuilder para animar eficientemente sin redibujar todo
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double sineWave = math.sin(_controller.value * 2 * math.pi);

        // Hacemos que la amplitud sea proporcional a la pantalla
        final double amplitude = (size.width * 0.003).clamp(1.0, 2.5);
        final double offset = sineWave * amplitude;

        // INTERSECCIÓN DE MOVIMIENTO ADAPTATIVO POR PLATAFORMA
        if (context.isApple) {
          const double rotationAmplitude = 0.012;
          final double rotationAngle = sineWave * rotationAmplitude;

          return Transform.translate(
            offset: Offset(offset, 0),
            child: Transform.rotate(
              angle: rotationAngle,
              child: child,
            ),
          );
        } else {
          return Transform.translate(
            offset: Offset(offset, 0),
            child: child,
          );
        }
      },
      child:
          widget.child,
    );
  }
}
