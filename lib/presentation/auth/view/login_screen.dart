// lib/presentation/screens/auth/login_screen.dart
// ignore_for_file: dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../common_widgets/custom_auth_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final email_focus = FocusNode();
  final password_focus = FocusNode();

  bool is_loading = false;
  String? _email_error;
  String? _password_error;

  @override
  void initState() {
    super.initState();
    email_controller.addListener(() {
      if (_email_error != null) setState(() => _email_error = null);
    });
    password_controller.addListener(() {
      if (_password_error != null) setState(() => _password_error = null);
    });
  }

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    email_focus.dispose();
    password_focus.dispose();
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

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    final emailText = email_controller.text.trim();
    final passText = password_controller.text;
    bool hasValidationError = false;

    if (emailText.isEmpty) {
      _email_error = l10n.errorEmptyEmail;
      hasValidationError = true;
    }

    if (passText.isEmpty) {
      _password_error = l10n.errorEmptyPassword;
      hasValidationError = true;
    }

    if (hasValidationError) {
      setState(() {});
      return;
    }
    setState(() => is_loading = true);

    final success = await ref.read(authProvider.notifier).login(
          emailText,
          passText,
          l10n.loginError ?? '',
        );

    if (mounted) setState(() => is_loading = false);

    if (success) {
      if (mounted) context.go('/dashboard');
    } else {
      if (mounted) {
        final rawError = ref.read(authProvider).errorMessage ?? '';
        setState(() {
          _email_error = " ";
          _password_error =
              rawError.isNotEmpty ? rawError : l10n.loginError ?? '';
        });
      }
    }
  }

  Future<void> _login_with_google() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => is_loading = true);
    final success = await ref.read(authProvider.notifier).login_with_google(
          l10n.loginGoogleError ?? '',
        );

    if (mounted) setState(() => is_loading = false);

    if (!success && mounted) {
      final rawError =
          ref.read(authProvider).errorMessage ?? l10n.loginGoogleError ?? '';
      _show_snackbar(rawError, Theme.of(context).colorScheme.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    // --- CONTENIDO ESTRUCTURAL ---
    final Widget screenContent = SingleChildScrollView(
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            // 1. BOTÓN DE IDIOMA
            Positioned(
              top: size.height * 0.09,
              right: size.width * 0.06,
              child: _buildLanguageButton(context, isDark, size),
            ),
            // 2. TÍTULO
            Positioned(
              top: size.height * 0.26,
              left: 0,
              right: 0,
              child: Text(
                l10n.loginTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: (size.width * 0.075).clamp(28.0, 36.0),
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
            ),
            // 3. CAMPO EMAIL
            Positioned(
              top: size.height * 0.49,
              left: size.width * 0.06,
              right: size.width * 0.06,
              child: CustomAuthField(
                controller: email_controller,
                hint_text: l10n.registerEmailPlaceholder,
                focus_node: email_focus,
                keyboard_type: TextInputType.emailAddress,
                error_text: _email_error,
              ),
            ),
            // 4. CAMPO CONTRASEÑA
            Positioned(
              top: size.height * 0.59,
              left: size.width * 0.06,
              right: size.width * 0.06,
              child: CustomAuthField(
                controller: password_controller,
                hint_text: l10n.loginPassPlaceholder,
                focus_node: password_focus,
                is_password: true,
                error_text: _password_error,
              ),
            ),
            // 5. LINK REGISTRO
            Positioned(
              top: size.height * 0.68,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => context.go('/register?from=/login'),
                child: Text(
                  l10n.loginNoAccount,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.035).clamp(13.0, 16.0),
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ),
            // 6. BOTÓN GOOGLE
            Positioned(
              top: size.height * 0.73,
              left: size.width * 0.06,
              right: size.width * 0.06,
              child: Center(
                  child: _buildGoogleButton(context, isDark, size, l10n)),
            ),
            // 7. BOTÓN LOGIN
            Positioned(
              top: size.height * 0.82,
              left: size.width * 0.25,
              right: size.width * 0.25,
              child: _buildLoginButton(context, isDark, size, l10n),
            ),
          ],
        ),
      ),
    );

    // --- INTEGRACIÓN ADAPTATIVA ---
    return PopScope(
      canPop: false,
      child: context.isApple
          ? Scaffold(
              backgroundColor: Colors.transparent,
              body: AdaptiveBackground(child: screenContent),
            )
          : Scaffold(
              backgroundColor:
                  AppColors.getBackgroundColor(Theme.of(context).brightness),
              body: screenContent,
            ),
    );
  }

  // --- HELPER BUTTONS ---
  Widget _buildLanguageButton(BuildContext context, bool isDark, Size size) {
    return SizedBox(
      width: (size.width * 0.13).clamp(45.0, 60.0),
      height: (size.width * 0.13).clamp(45.0, 60.0),
      child: InkWell(
        onTap: () => context.go('/language?from=/login'),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: context.isApple
              ? BoxDecoration(
                  color: isDark
                      ? AppColors.cardDark.withOpacity(0.3)
                      : AppColors.cardLight.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isDark
                          ? AppColors.cardDark.withOpacity(0.2)
                          : AppColors.cardLight.withOpacity(0.7),
                      width: 1.5),
                )
              : BoxDecoration(
                  color: isDark
                      ? AppColors.cardDark
                      : Theme.of(context).primaryColor,
                  shape: BoxShape.circle),
          child: Icon(Icons.language,
              color: isDark ? AppColors.textPrimaryDark : AppColors.cardLight,
              size: (size.width * 0.07).clamp(24.0, 32.0)),
        ),
      ),
    );
  }

  Widget _buildGoogleButton(
      BuildContext context, bool isDark, Size size, AppLocalizations l10n) {
    return SizedBox(
      height: (size.height * 0.06).clamp(48.0, 56.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: size.width * 0.50, maxWidth: size.width * 0.88),
        child: OutlinedButton(
          onPressed: is_loading ? null : _login_with_google,
          style: OutlinedButton.styleFrom(
            backgroundColor: context.isApple
                ? (isDark
                    ? AppColors.cardDark.withOpacity(0.2)
                    : AppColors.cardLight.withOpacity(0.45))
                : (isDark ? AppColors.cardDark : AppColors.cardLight),
            side: BorderSide(
                color: context.isApple
                    ? (isDark
                        ? AppColors.cardDark.withOpacity(0.15)
                        : AppColors.cardLight.withOpacity(0.6))
                    : (isDark
                        ? AppColors.secondaryDark.withOpacity(0.3)
                        : AppColors.secondaryLight.withOpacity(0.2))),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/google_logo.png',
                  width: 24, height: 24),
              const SizedBox(width: 12),
              Flexible(
                  child: Text(l10n.loginWithGoogle,
                      style: GoogleFonts.poppins(
                          fontSize: (size.width * 0.035).clamp(13.0, 15.0),
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
      BuildContext context, bool isDark, Size size, AppLocalizations l10n) {
    return SizedBox(
      height: (size.height * 0.06).clamp(48.0, 56.0),
      child: ElevatedButton(
        onPressed: is_loading ? null : _login,
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
                    strokeWidth: 2, color: AppColors.cardLight))
            : Text(l10n.btnLogin,
                style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.04).clamp(14.0, 16.0),
                    fontWeight: FontWeight.w600,
                    color: AppColors.cardLight)),
      ),
    );
  }
}
