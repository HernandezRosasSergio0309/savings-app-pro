// ignore_for_file: dead_null_aware_expression

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../core/extensions/platform_extension.dart';
import 'adaptive_refractive_container.dart';

class DraggableGlassToolbar extends StatefulWidget {
  final int initialIndex;
  final Function(int) onTabDropped;

  const DraggableGlassToolbar({
    super.key,
    required this.initialIndex,
    required this.onTabDropped,
  });

  @override
  State<DraggableGlassToolbar> createState() => _DraggableGlassToolbarState();
}

class _DraggableGlassToolbarState extends State<DraggableGlassToolbar> {
  late int currentIndex;
  double? dragX;
  bool isDragging = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(DraggableGlassToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        currentIndex = widget.initialIndex;
      });
    }
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size.width;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    final baseColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final ovalColor = isDark
        ? AppColors.cardLight.withOpacity(0.15)
        : AppColors.primaryLight.withOpacity(0.1);

    final List<String> tabLabels = [
      l10n.toolbarMenu ?? '',
      l10n.toolbarCreate ?? '',
      l10n.toolbarSettings ?? '',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double itemWidth = constraints.maxWidth / 3;
        final double baseHeight = (size.height * 0.08).clamp(65.0, 85.0);
        final double toolbarHeight = isDragging ? baseHeight + 3.0 : baseHeight;
        final double ovalHeight =
            isDragging ? baseHeight - 10.0 : baseHeight - 14.0;
        final double centerOfTab = (currentIndex * itemWidth) + (itemWidth / 2);
        final double deltaX =
            (isDragging && dragX != null) ? (dragX! - centerOfTab) : 0.0;
        final double shiftX = (deltaX * 0.03).clamp(-5.0, 5.0);

        int activeHighlightIndex;
        if (isDragging && dragX != null) {
          activeHighlightIndex = (dragX! / itemWidth).floor().clamp(0, 2);
        } else {
          activeHighlightIndex = currentIndex;
        }

        final TextStyle activeTextStyle = GoogleFonts.poppins(
          fontSize: (size.width * 0.03).clamp(11.0, 14.0),
          fontWeight: FontWeight.w600,
        );
        final double textWidth =
            _getTextWidth(tabLabels[activeHighlightIndex], activeTextStyle);
        final double iconWidth = (size.width * 0.06).clamp(24.0, 30.0);
        final double contentWidth = math.max(textWidth, iconWidth);
        double targetOvalWidth = contentWidth + 40.0;
        final double ovalWidth = math.min(targetOvalWidth, itemWidth - 16.0);
        const double edgePadding = 12.0;

        double currentLeft;
        if (isDragging && dragX != null) {
          currentLeft = dragX! - (ovalWidth / 2);
        } else {
          final double exactCenterOfCurrentTab =
              (currentIndex * itemWidth) + (itemWidth / 2);
          currentLeft = exactCenterOfCurrentTab - (ovalWidth / 2);
        }

        currentLeft = currentLeft.clamp(
            edgePadding, constraints.maxWidth - ovalWidth - edgePadding);

        // CONTENIDO DE LA BARRA
        final Widget toolbarContent = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragStart: (details) {
            setState(() {
              isDragging = true;
              dragX = details.localPosition.dx;
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              dragX = details.localPosition.dx;
            });
          },
          onHorizontalDragEnd: (details) {
            if (dragX != null) {
              int nearestIndex = (dragX! / itemWidth).floor().clamp(0, 2);
              setState(() {
                isDragging = false;
                currentIndex = nearestIndex;
              });
              widget.onTabDropped(nearestIndex);
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedPositioned(
                duration: isDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: currentLeft,
                top: (toolbarHeight - ovalHeight) / 2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  width: ovalWidth,
                  height: ovalHeight,
                  decoration: BoxDecoration(
                    color: context.isApple
                        ? (isDark
                            ? Colors.white.withOpacity(0.08)
                            : AppColors.primaryLight.withOpacity(0.15))
                        : ovalColor,
                    borderRadius: BorderRadius.circular(27),
                  ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildNavItem(Icons.grid_view_rounded, tabLabels[0], 0,
                        activeHighlightIndex, isDark, size, itemWidth),
                    _buildNavItem(Icons.add_circle_outline, tabLabels[1], 1,
                        activeHighlightIndex, isDark, size, itemWidth),
                    _buildNavItem(Icons.settings, tabLabels[2], 2,
                        activeHighlightIndex, isDark, size, itemWidth),
                  ],
                ),
              ),
            ],
          ),
        );

        // BIFURCACIÓN DE DISEÑO ADAPTATIVO
        if (context.isApple) {
          return AnimatedContainer(
            duration:
                isDragging ? Duration.zero : const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: toolbarHeight,
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()..translate(shiftX, 0.0),
            child: AdaptiveRefractiveContainer(
              refractionStrength: isDragging ? 0.35 : 0.15,
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.cardDark.withOpacity(0.3)
                      : AppColors.cardLight.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: isDark
                        ? AppColors.cardDark.withOpacity(0.25)
                        : AppColors.cardLight.withOpacity(0.65),
                    width: 1.5,
                  ),
                ),
                child: toolbarContent,
              ),
            ),
          );
        } else {
          return AnimatedContainer(
            duration:
                isDragging ? Duration.zero : const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: toolbarHeight,
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()..translate(shiftX, 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimaryLight.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: toolbarContent,
            ),
          );
        }
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      int activeHighlightIndex, bool isDark, Size size, double itemWidth) {
    final isHighlighted = activeHighlightIndex == index;
    final iconColor = isDark ? AppColors.cardLight : AppColors.primaryLight;
    final color = isHighlighted ? iconColor : iconColor.withOpacity(0.45);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() => currentIndex = index);
          widget.onTabDropped(index);
        },
        child: Container(
          color: Colors.transparent,
          child: AnimatedScale(
            scale: isHighlighted ? (context.isApple ? 1.15 : 1.05) : 1.0,
            duration: const Duration(milliseconds: 300),
            curve: context.isApple ? Curves.easeOutBack : Curves.easeOutCubic,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: color, size: (size.width * 0.06).clamp(24.0, 30.0)),
                const SizedBox(height: 5),
                SizedBox(
                  width: itemWidth - 28.0,
                  height: 20.0,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(
                        label,
                        maxLines: 1,
                        strutStyle: const StrutStyle(
                            forceStrutHeight: true, height: 1.2),
                        style: GoogleFonts.poppins(
                          fontSize: (size.width * 0.03).clamp(11.0, 14.0),
                          fontWeight:
                              isHighlighted ? FontWeight.w600 : FontWeight.w400,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
