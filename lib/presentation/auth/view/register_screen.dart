// ignore_for_file: dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../common_widgets/custom_auth_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final user_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final confirm_password_controller = TextEditingController();

  bool is_loading = false;
  double _password_strength = 0.0;
  String? _user_error;
  String? _email_error;
  String? _password_error;
  String? _confirm_error;

  @override
  void initState() {
    super.initState();
    user_controller.addListener(() => _clearError(() => _user_error = null));
    email_controller.addListener(() => _clearError(() => _email_error = null));
    password_controller.addListener(() {
      _clearError(() => _password_error = null);
      setState(() => _password_strength =
          AppValidators.calculate_password_strength(password_controller.text));
    });
    confirm_password_controller
        .addListener(() => _clearError(() => _confirm_error = null));
  }

  void _clearError(VoidCallback clearAction) {
    if (mounted) setState(clearAction);
  }

  @override
  void dispose() {
    user_controller.dispose();
    email_controller.dispose();
    password_controller.dispose();
    confirm_password_controller.dispose();
    super.dispose();
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

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    final userText = user_controller.text.trim();
    final emailText = email_controller.text.trim();
    final passText = password_controller.text;
    final confirmText = confirm_password_controller.text;

    bool hasValidationError = false;

    // Validaciones
    if (userText.isEmpty) {
      _user_error = l10n.errorEmptyUser;
      hasValidationError = true;
    } else if (userText.length < 4) {
      _user_error = l10n.registerUserMinLength;
      hasValidationError = true;
    } else if (AppConstants.profanity_list
        .any((word) => userText.toLowerCase().contains(word))) {
      _user_error = l10n.registerUserProfanity;
      hasValidationError = true;
    }

    if (emailText.isEmpty) {
      _email_error = l10n.errorEmptyEmail;
      hasValidationError = true;
    } else if (!AppValidators.is_valid_email(emailText)) {
      _email_error = l10n.errorInvalidEmail;
      hasValidationError = true;
    }

    if (passText.isEmpty) {
      _password_error = l10n.errorEmptyPassword;
      hasValidationError = true;
    } else if (_password_strength < 1.0) {
      _password_error = " ";
      hasValidationError = true;
    }

    if (confirmText.isEmpty) {
      _confirm_error = l10n.errorEmptyPassword;
      hasValidationError = true;
    } else if (passText != confirmText) {
      _confirm_error = l10n.registerPassMismatch;
      hasValidationError = true;
    }

    if (hasValidationError) {
      setState(() {});
      return;
    }

    setState(() => is_loading = true);

    final success = await ref
        .read(authProvider.notifier)
        .register(userText, emailText, passText, l10n.registerError ?? '');

    if (mounted) setState(() => is_loading = false);

    if (success) {
      if (mounted) context.go('/dashboard');
    } else {
      if (mounted) {
        final rawError = ref.read(authProvider).errorMessage ?? '';
        if (rawError.toLowerCase().contains('email'))
          setState(() => _email_error = l10n.registerEmailInUse);
        else if (rawError.contains('Username'))
          setState(() => _user_error = l10n.registerUsernameInUse ?? '');
        else
          _show_snackbar(rawError.isNotEmpty ? rawError : 'Error',
              Theme.of(context).colorScheme.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    final Widget screenContent = SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            // TÍTULO
            Positioned(
              top: size.height * 0.26,
              left: 0,
              right: 0,
              child: Text(l10n.registerTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: (size.width * 0.075).clamp(28.0, 36.0),
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight)),
            ),
            // USER
            Positioned(
              top: size.height * 0.39,
              left: size.width * 0.06,
              right: size.width * 0.06,
              child: CustomAuthField(
                  controller: user_controller,
                  hint_text: l10n.loginUserPlaceholder,
                  error_text: _user_error),
            ),
            // EMAIL
            Positioned(
              top: size.height * 0.49,
              left: size.width * 0.06,
              right: size.width * 0.06,
              child: CustomAuthField(
                  controller: email_controller,
                  hint_text: l10n.registerEmailPlaceholder,
                  keyboard_type: TextInputType.emailAddress,
                  error_text: _email_error),
            ),
            // PASSWORD
            Positioned(
              top: size.height * 0.59,
              left: size.width * 0.06,
              right: size.width * 0.06,
              child: CustomAuthField(
                  controller: password_controller,
                  hint_text: l10n.loginPassPlaceholder,
                  is_password: true,
                  error_text: _password_error),
            ),
            // MEDIDOR
            Positioned(
              top: size.height * 0.655,
              left: size.width * 0.07,
              right: size.width * 0.07,
              child: _buildPasswordStrengthIndicator(isDark, size, l10n),
            ),
            // CONFIRM
            Positioned(
              top: size.height * 0.69,
              left: size.width * 0.06,
              right: size.width * 0.06,
              child: CustomAuthField(
                  controller: confirm_password_controller,
                  hint_text: l10n.registerConfirmPassPlaceholder,
                  is_password: true,
                  error_text: _confirm_error),
            ),
            // BOTÓN
            Positioned(
              top: size.height * 0.79,
              left: size.width * 0.25,
              right: size.width * 0.25,
              child: _buildRegisterButton(isDark, size, l10n),
            ),
          ],
        ),
      ),
    );

    return PopScope(
      canPop: false,
      child: context.isApple
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: AdaptiveBackground(child: screenContent))
          : Scaffold(
              backgroundColor:
                  AppColors.getBackgroundColor(Theme.of(context).brightness),
              body: screenContent),
    );
  }

  Widget _buildPasswordStrengthIndicator(
      bool isDark, Size size, AppLocalizations l10n) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: password_controller.text.isNotEmpty ? 1.0 : 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _password_strength,
              backgroundColor: context.isApple
                  ? (isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.05))
                  : (isDark
                      ? AppColors.secondaryDark.withOpacity(0.3)
                      : AppColors.secondaryLight.withOpacity(0.2)),
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppValidators.get_strength_color(_password_strength)),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _password_strength < 1.0
                ? l10n.passwordStrengthWeak
                : l10n.passwordStrengthStrong,
            style: GoogleFonts.poppins(
              fontSize: (size.width * 0.025).clamp(10.0, 12.0),
              color: _password_strength < 1.0
                  ? (isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight)
                  : AppValidators.get_strength_color(_password_strength),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton(bool isDark, Size size, AppLocalizations l10n) {
    return SizedBox(
      height: (size.height * 0.06).clamp(48.0, 56.0),
      child: ElevatedButton(
        onPressed: is_loading ? null : _register,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.isApple
              ? (isDark
                  ? AppColors.primaryDark.withOpacity(0.5)
                  : AppColors.primaryLight.withOpacity(0.8))
              : (isDark ? AppColors.cardDark : Theme.of(context).primaryColor),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: isDark || context.isApple ? 0 : 2,
        ),
        child: is_loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: AppColors.cardLight, strokeWidth: 2))
            : Text(l10n.btnRegister,
                style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.04).clamp(14.0, 16.0),
                    fontWeight: FontWeight.w600,
                    color: AppColors.cardLight)),
      ),
    );
  }
}
