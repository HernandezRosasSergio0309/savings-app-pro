// ignore_for_file: dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../../l10n/app_localizations.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../common_widgets/adaptive_refractive_container.dart';
import '../../common_widgets/custom_auth_field.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  ConsumerState<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  final user_controller = TextEditingController();
  bool is_loading = false;
  bool _is_form_valid = false;

  @override
  void initState() {
    super.initState();
    user_controller.addListener(_validate_form);
  }

  @override
  void dispose() {
    user_controller.dispose();
    super.dispose();
  }

  void _validate_form() {
    setState(() => _is_form_valid = user_controller.text.trim().isNotEmpty);
  }

  void _show_snackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: GoogleFonts.poppins(color: AppColors.cardLight)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _save_profile() async {
    final l10n = AppLocalizations.of(context)!;
    final userText = user_controller.text.trim();

    if (userText.length < 4 || userText.length > 60) {
      return _show_snackbar(l10n.registerUserMinLength, AppColors.starYellow);
    }

    if (AppConstants.profanity_list
        .any((word) => userText.toLowerCase().contains(word))) {
      return _show_snackbar(l10n.registerUserProfanity, AppColors.starYellow);
    }

    setState(() => is_loading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null) {
        await Supabase.instance.client
            .from('profiles')
            .update({'username': userText}).eq('id', userId);
        ref.read(authProvider.notifier).updateUsernameInState(userText);
        if (mounted) context.go('/dashboard');
      }
    } catch (e) {
      if (mounted)
        _show_snackbar(
            l10n.errorUpdateProfile, Theme.of(context).colorScheme.error);
    } finally {
      if (mounted) setState(() => is_loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    // CONTENIDO DEL FORMULARIO
    final Widget formContent = Column(
      children: [
        Text(
          l10n.completeProfileTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: (size.width * 0.075).clamp(28.0, 36.0),
            fontWeight: FontWeight.bold,
            color:
                isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: size.height * 0.015),
        Text(
          l10n.completeProfileSubtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: (size.width * 0.04).clamp(14.0, 16.0),
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        SizedBox(height: size.height * 0.04),
        CustomAuthField(
          controller: user_controller,
          hint_text: l10n.loginUserPlaceholder,
        ),
        SizedBox(height: size.height * 0.04),
        SizedBox(
          width: double.infinity,
          height: (size.height * 0.06).clamp(48.0, 56.0),
          child: ElevatedButton(
            onPressed: (is_loading || !_is_form_valid) ? null : _save_profile,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? AppColors.primaryDark : AppColors.primaryLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: is_loading
                ? const CircularProgressIndicator(
                    color: AppColors.cardLight, strokeWidth: 2)
                : Text(l10n.btnSaveAndContinue,
                    style: GoogleFonts.poppins(
                        fontSize: (size.width * 0.04).clamp(14.0, 16.0),
                        fontWeight: FontWeight.w600,
                        color: AppColors.cardLight)),
          ),
        ),
      ],
    );

    // ESTRUCTURA ADAPTATIVA
    final Widget mainContainer = Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
      child: context.isApple
          ? AdaptiveRefractiveContainer(
              refractionStrength: 0.2,
              child: Container(
                padding: EdgeInsets.all(size.width * 0.05),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: formContent,
              ),
            )
          : formContent,
    );

    final Widget screenBody = Center(child: mainContainer);

    return context.isApple
        ? Scaffold(
            backgroundColor: Colors.transparent,
            body: AdaptiveBackground(child: screenBody),
          )
        : Scaffold(
            backgroundColor:
                AppColors.getBackgroundColor(Theme.of(context).brightness),
            body: screenBody,
          );
  }
}
