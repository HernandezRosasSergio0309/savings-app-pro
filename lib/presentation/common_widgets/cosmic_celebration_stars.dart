import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A lightweight cosmic particle system that shoots stars from the center.
/// Un sistema ligero de partículas cósmicas que dispara estrellas desde el centro.
class CosmicCelebrationStars extends StatefulWidget {
  final bool play;
  final Size size;

  const CosmicCelebrationStars({
    super.key,
    required this.play,
    required this.size,
  });

  @override
  State<CosmicCelebrationStars> createState() => _CosmicCelebrationStarsState();
}

class _CosmicCelebrationStarsState extends State<CosmicCelebrationStars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Generamos 14 partículas para un estallido óptimo sin saturar el procesador
  final List<_CosmicStarParticle> _particles =
      List.generate(14, (index) => _CosmicStarParticle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.play) _controller.repeat();
  }

  @override
  void didUpdateWidget(CosmicCelebrationStars oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: widget.size,
          painter: _CosmicStarPainter(_particles, _controller.value),
        );
      },
    );
  }
}

class _CosmicStarParticle {
  final double angle = math.Random().nextDouble() * 2 * math.pi;
  final double speed = math.Random().nextDouble() * 0.6 + 0.4;
  final double size = math.Random().nextDouble() * 5 + 3;
}

class _CosmicStarPainter extends CustomPainter {
  final List<_CosmicStarParticle> particles;
  final double progress;

  _CosmicStarPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      // Movimiento de expansión radial matemático
      final double distance = progress * (size.width * 0.55) * p.speed;
      final double opacity = (1.0 - progress).clamp(0.0, 1.0);

      // Sincronización cromática
      paint.color =
          (p.speed > 0.72 ? AppColors.successLight : AppColors.primaryLight)
              .withOpacity(opacity);

      final double x = center.dx + math.cos(p.angle) * distance;
      final double y = center.dy + math.sin(p.angle) * distance;

      // Renderizado matemático de estrellas de 4 puntas del espacio exterior
      final path = Path();
      path.moveTo(x, y - p.size);
      path.lineTo(x + p.size / 3, y - p.size / 3);
      path.lineTo(x + p.size, y);
      path.lineTo(x + p.size / 3, y + p.size / 3);
      path.lineTo(x, y + p.size);
      path.lineTo(x - p.size / 3, y + p.size / 3);
      path.lineTo(x - p.size, y);
      path.lineTo(x - p.size / 3, y - p.size / 3);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
