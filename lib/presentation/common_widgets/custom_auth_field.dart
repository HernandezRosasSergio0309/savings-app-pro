import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/platform_extension.dart';
import 'adaptive_refractive_container.dart'; // Tu nuevo motor de refracción

/// Reusable text field with cross-platform design and error shaking animation.
/// Campo de texto reutilizable con diseño adaptativo, efecto glassmorphism refractivo en iOS y animación de vibración.
class CustomAuthField extends StatefulWidget {
  final TextEditingController controller;
  final String hint_text;
  final bool is_password;
  final TextInputType keyboard_type;
  final String? error_text;
  final FocusNode? focus_node;
  final Function(String)? on_submitted;

  const CustomAuthField({
    super.key,
    required this.controller,
    required this.hint_text,
    this.is_password = false,
    this.keyboard_type = TextInputType.text,
    this.error_text,
    this.focus_node,
    this.on_submitted,
  });

  @override
  State<CustomAuthField> createState() => _CustomAuthFieldState();
}

class _CustomAuthFieldState extends State<CustomAuthField>
    with SingleTickerProviderStateMixin {
  bool _obscure_text = true;
  bool _has_text = false;

  late AnimationController _shake_controller;
  late Animation<double> _shake_animation;

  @override
  void initState() {
    super.initState();
    _obscure_text = widget.is_password;
    _has_text = widget.controller.text.isNotEmpty;

    widget.controller.addListener(_on_text_changed);

    _shake_controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shake_animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shake_controller, curve: Curves.easeInOut),
    );
  }

  void _on_text_changed() {
    if (widget.is_password) {
      final currentlyHasText = widget.controller.text.isNotEmpty;
      if (_has_text != currentlyHasText) {
        setState(() {
          _has_text = currentlyHasText;
        });
      }
    }
  }

  @override
  void didUpdateWidget(CustomAuthField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.error_text != null &&
        widget.error_text != oldWidget.error_text) {
      _shake_controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_on_text_changed);
    _shake_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.error_text != null && widget.error_text!.isNotEmpty;
    final showErrorText = hasError && widget.error_text != " ";
    final size = MediaQuery.of(context).size;

    // DECORACIÓN
    final BoxDecoration fieldDecoration = BoxDecoration(
      color:
          isDark ? Theme.of(context).colorScheme.surface : AppColors.cardLight,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: hasError
            ? Theme.of(context).colorScheme.error
            : (isDark
                ? AppColors.cardLight.withOpacity(0.24)
                : AppColors.secondaryLight.withOpacity(0.3)),
        width: 1.5,
      ),
      boxShadow: [
        if (!isDark && !hasError)
          BoxShadow(
            color: AppColors.textPrimaryLight.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
      ],
    );

    // TEXTFIELD BASE
    final Widget textField = TextField(
      controller: widget.controller,
      onSubmitted: widget.on_submitted,
      focusNode: widget.focus_node,
      obscureText: widget.is_password ? _obscure_text : false,
      keyboardType: widget.keyboard_type,
      style: GoogleFonts.poppins(
        fontSize: (size.width * 0.035).clamp(13.0, 16.0),
        color: isDark
            ? AppColors.textPrimaryDark
            : Theme.of(context).textTheme.bodyLarge?.color ??
                AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        hintText: widget.hint_text,
        hintStyle: GoogleFonts.poppins(
          color: isDark
              ? AppColors.textSecondaryDark
              : Theme.of(context).hintColor,
        ),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        suffixIcon: widget.is_password && _has_text
            ? IconButton(
                icon: Icon(
                  _obscure_text ? Icons.visibility_off : Icons.visibility,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  size: (size.width * 0.05).clamp(20.0, 24.0),
                ),
                onPressed: () {
                  setState(() => _obscure_text = !_obscure_text);
                },
              )
            : null,
      ),
    );

    return AnimatedBuilder(
      animation: _shake_animation,
      builder: (context, child) {
        final sineValue = sin(4 * pi * _shake_animation.value);
        return Transform.translate(
          offset: Offset(sineValue * 6, 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: (size.height * 0.06).clamp(48.0, 56.0),
            child: context.isApple
                ? AdaptiveRefractiveContainer(
                    refractionStrength: 0.15,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardDark.withOpacity(0.2)
                            : AppColors.cardLight.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hasError
                              ? Theme.of(context).colorScheme.error
                              : (isDark
                                  ? AppColors.cardLight.withOpacity(0.12)
                                  : AppColors.cardLight.withOpacity(0.6)),
                          width: 1.5,
                        ),
                      ),
                      child: textField,
                    ),
                  )
                : Container(
                    decoration: fieldDecoration,
                    alignment: Alignment.center,
                    child: textField,
                  ),
          ),

          // GESTIÓN DE ERRORES
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: showErrorText
                ? Padding(
                    padding: const EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      widget.error_text!,
                      style: GoogleFonts.poppins(
                        fontSize: (size.width * 0.025).clamp(10.0, 12.0),
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
