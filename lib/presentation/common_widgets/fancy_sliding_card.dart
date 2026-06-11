// ignore_for_file: unused_import, dead_null_aware_expression

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../core/extensions/platform_extension.dart';
import 'adaptive_refractive_container.dart';

class FancySlidingCard extends StatefulWidget {
  final Widget child;
  final Widget background;
  final VoidCallback onDelete;
  final double swipeThreshold;
  final bool isSwipeEnabled;

  const FancySlidingCard({
    super.key,
    required this.child,
    required this.background,
    required this.onDelete,
    this.swipeThreshold = 0.6,
    this.isSwipeEnabled = true,
  });

  @override
  State<FancySlidingCard> createState() => _FancySlidingCardState();
}

class _FancySlidingCardState extends State<FancySlidingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0.0;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _dragExtent = -(_controller.value * context.size!.width);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_dismissed || !widget.isSwipeEnabled) return;

    final double newExtent = _dragExtent + details.delta.dx;
    if (newExtent > 0) return;

    setState(() {
      _dragExtent = _clamp(newExtent, -context.size!.width, 0.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dismissed || !widget.isSwipeEnabled) return;

    final double screenWidth = context.size!.width;
    if (_dragExtent.abs() > screenWidth * widget.swipeThreshold) {
      _dismiss();
    } else {
      _controller.reverse(from: _dragExtent.abs() / screenWidth);
    }
  }

  void _dismiss() {
    _dismissed = true;
    _controller
        .forward(from: _dragExtent.abs() / context.size!.width)
        .then((_) {
      widget.onDelete();
    });
  }

  double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    // LÓGICA DE REFRACCIÓN CONDICIONAL
    final Widget backgroundLayer = context.isApple
        ? AdaptiveRefractiveContainer(
            refractionStrength:
                0.25,
            child: widget.background,
          )
        : widget.background;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned.fill(child: backgroundLayer),
            Transform.translate(
              offset: Offset(_dragExtent, 0.0),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteBackground extends StatelessWidget {
  final double currentSwipePercent;

  const DeleteBackground({super.key, required this.currentSwipePercent});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final iconSize = (size.width * 0.08).clamp(24.0, 36.0);

    // ARQUITECTURA DE CONTENIDO
    final Widget backgroundContent = Stack(
      children: [
        Positioned(
          right: (size.width * 0.05) +
              (1.0 - currentSwipePercent.clamp(0.0, 1.0)) * (size.width * 0.12),
          top: 0,
          bottom: 0,
          child: Center(
            child: Opacity(
              opacity: currentSwipePercent.clamp(0.0, 1.0),
              child: Transform.rotate(
                angle: (1.0 - currentSwipePercent.clamp(0.0, 1.0)) *
                    -1.2 *
                    (math.pi / 180),
                child: Icon(Icons.delete,
                    color: AppColors.cardLight, size: iconSize),
              ),
            ),
          ),
        ),
      ],
    );

    // INTERSECCIÓN DE DISEÑO ADAPTATIVO
    if (context.isApple) {
      return Container(
        color: AppColors.errorLight.withOpacity(isDark ? 0.35 : 0.5),
        child: backgroundContent,
      );
    } else {
      return Container(
        color: AppColors.errorLight,
        child: backgroundContent,
      );
    }
  }
}
