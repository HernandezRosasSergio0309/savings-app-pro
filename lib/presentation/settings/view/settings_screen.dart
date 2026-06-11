// ignore_for_file: unused_local_variable, dead_null_aware_expression

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../dashboard/view/dashboard_screen.dart';

// Provider para consultar el perfil directo de la base de datos
final settingsProfileProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final supabase = Supabase.instance.client;
  final user = supabase.auth.currentUser;

  if (user == null) return null;
  return await supabase
      .from('profiles')
      .select('username, avatar_url')
      .eq('id', user.id)
      .single();
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme =
        Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final menuCardColor = theme.colorScheme.surface;

    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final widgetColor = isDark ? AppColors.cardDark : AppColors.primaryLight;
    final profileAsync = ref.watch(settingsProfileProvider);

    // CONTENIDO DEL MENÚ EN BLOQUE PARA REUTILIZACIÓN EN CAPAS
    final Widget menuListContent = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuRow(
          context: context,
          icon: Icons.language,
          title: l10n.settingsLanguage,
          textColor: textColor,
          size: size,
          onTap: () => context.go('/language?from=/settings'),
        ),
        Divider(
            height: 1,
            color: subtextColor.withOpacity(0.12),
            indent: size.width * 0.05,
            endIndent: size.width * 0.05),
        _buildThemeMenuRow(context, ref, l10n, textColor, size),
        Divider(
            height: 1,
            color: subtextColor.withOpacity(0.12),
            indent: size.width * 0.05,
            endIndent: size.width * 0.05),
        _buildMenuRow(
          context: context,
          icon: Icons.logout,
          title: l10n.settingsLogout,
          textColor: textColor,
          size: size,
          onTap: () => _showLogoutDialog(context, ref, l10n, size),
        ),
        Divider(
            height: 1,
            color: subtextColor.withOpacity(0.12),
            indent: size.width * 0.05,
            endIndent: size.width * 0.05),
        _buildMenuRow(
          context: context,
          icon: Icons.delete_outline,
          title: l10n.settingsDeleteAccount,
          textColor: Theme.of(context).colorScheme.error,
          iconColor: Theme.of(context).colorScheme.error,
          size: size,
          onTap: () => _showDeleteAccountDialog(context, ref, l10n, size),
        ),
      ],
    );

    // MAQUETACIÓN ESTRUCTURAL INTERNA CON TUS PROPORCIONES
    final Widget screenContent = SingleChildScrollView(
      padding: EdgeInsets.only(
          top: size.height * 0.10,
          left: size.width * 0.06,
          right: size.width * 0.06,
          bottom: size.height * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título general
          Text(
            l10n.settingsTitle,
            style: GoogleFonts.poppins(
              fontSize: (size.width * 0.075).clamp(26.0, 32.0),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: size.height * 0.025),

          // Sección de perfil dinámica
          profileAsync.when(
            data: (profileData) {
              final userName = profileData?['username']?.toString() ?? '';
              final userAvatar = profileData?['avatar_url']?.toString();
              return Column(
                children: [
                  Container(
                    width: (size.width * 0.26).clamp(85.0, 115.0),
                    height: (size.width * 0.26).clamp(85.0, 115.0),
                    decoration: BoxDecoration(
                      color: widgetColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!context.isApple)
                          BoxShadow(
                            color: textColor.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          )
                      ],
                      image: userAvatar != null
                          ? DecorationImage(
                              image: NetworkImage(userAvatar),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: userAvatar == null
                        ? Icon(Icons.person_outline,
                            size: (size.width * 0.13).clamp(45.0, 65.0),
                            color: AppColors.cardLight)
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(height: size.height * 0.015),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.04),
                    child: Text(
                      userName.trim().isEmpty ? 'Galaxy User' : userName,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: (size.width * 0.055).clamp(18.0, 24.0),
                          fontWeight: FontWeight.w600,
                          color: textColor),
                    ),
                  ),
                ],
              );
            },
            loading: () => Column(
              children: [
                Container(
                  width: (size.width * 0.26).clamp(85.0, 115.0),
                  height: (size.width * 0.26).clamp(85.0, 115.0),
                  decoration:
                      BoxDecoration(color: widgetColor, shape: BoxShape.circle),
                  child: const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.cardLight, strokeWidth: 2),
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                const SizedBox(height: 24),
              ],
            ),
            error: (e, __) => Column(
              children: [
                Icon(Icons.error_outline,
                    color: Theme.of(context).colorScheme.error, size: 40),
                SizedBox(height: size.height * 0.01),
                Text('Error al cargar perfil',
                    style: GoogleFonts.poppins(color: textColor)),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),

          // Link Editar Perfil
          GestureDetector(
            onTap: () => context.go('/edit_profile?from=/settings'),
            child: Text(
              l10n.btnEdit,
              style: GoogleFonts.poppins(
                fontSize: (size.width * 0.038).clamp(13.0, 16.0),
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),

          // Panel de menús adaptativo
          context.isApple
              ? Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardDark.withOpacity(0.15)
                        : AppColors.cardLight.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : AppColors.cardLight.withOpacity(0.6),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                      child: menuListContent,
                    ),
                  ),
                )
              : Card(
                  elevation: 4,
                  shadowColor: AppColors.textPrimaryLight.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  color: menuCardColor,
                  child: menuListContent,
                ),
          SizedBox(height: size.height * 0.035),

          // Versión y Créditos
          Text(
            '${l10n.settingsVersion} 0.1',
            style: GoogleFonts.poppins(
                fontSize: (size.width * 0.033).clamp(11.0, 14.0),
                fontWeight: FontWeight.w500,
                color: subtextColor),
          ),
          SizedBox(height: size.height * 0.008),
          Text(
            'Kocmocomm S.A\n${l10n.rightsReserved} 2026',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                fontSize: (size.width * 0.028).clamp(10.0, 12.0),
                color: subtextColor.withOpacity(0.7),
                height: 1.4),
          ),
        ],
      ),
    );

    // CAPA DE DISTRIBUCIÓN ADAPTATIVA DE INTERFAZ DE RAÍZ
    return context.isApple
        ? AdaptiveBackground(child: screenContent)
        : Scaffold(
            backgroundColor: AppColors.getBackgroundColor(theme.brightness),
            body: screenContent,
          );
  }

  // FILAS AUXILIARES ADAPTATIVAS
  Widget _buildMenuRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color textColor,
    Color? iconColor,
    required Size size,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      splashColor: context.isApple ? Colors.transparent : null,
      leading: Icon(icon,
          color: iconColor ?? textColor,
          size: (size.width * 0.06).clamp(22.0, 26.0)),
      title: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: (size.width * 0.038).clamp(13.0, 16.0),
            fontWeight: FontWeight.w500,
            color: textColor),
      ),
      trailing: Icon(Icons.chevron_right,
          color: textColor.withOpacity(0.4),
          size: (size.width * 0.055).clamp(18.0, 24.0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  Widget _buildThemeMenuRow(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, Color textColor, Size size) {
    final currentTheme = ref.watch(themeProvider);
    final effectiveTheme = currentTheme == ThemeMode.system
        ? (Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light)
        : currentTheme;

    return PopupMenuButton<ThemeMode>(
      offset: Offset(size.width * 0.4, size.height * 0.04),
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (ThemeMode selectedMode) =>
          ref.read(themeProvider.notifier).toggleTheme(selectedMode),
      itemBuilder: (context) => [
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.themeLight,
                  style: GoogleFonts.poppins(
                      fontSize: (size.width * 0.038).clamp(13.0, 15.0),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color)),
              Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: effectiveTheme,
                activeColor: AppColors.primaryLight,
                onChanged: (ThemeMode? value) => Navigator.pop(context, value),
              ),
            ],
          ),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.themeDark,
                  style: GoogleFonts.poppins(
                      fontSize: (size.width * 0.038).clamp(13.0, 15.0),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color)),
              Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: effectiveTheme,
                activeColor: AppColors.primaryLight,
                onChanged: (ThemeMode? value) => Navigator.pop(context, value),
              ),
            ],
          ),
        ),
      ],
      child: ListTile(
        splashColor: context.isApple ? Colors.transparent : null,
        leading: Icon(Icons.light_mode_outlined,
            color: textColor, size: (size.width * 0.06).clamp(22.0, 26.0)),
        title: Text(
          l10n.settingsTheme,
          style: GoogleFonts.poppins(
              fontSize: (size.width * 0.038).clamp(13.0, 16.0),
              fontWeight: FontWeight.w500,
              color: textColor),
        ),
        trailing: Icon(Icons.chevron_right,
            color: textColor.withOpacity(0.4),
            size: (size.width * 0.055).clamp(18.0, 24.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  // MODALES ADAPTATIVOS DE CONFIRMACIÓN
  void _showLogoutDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n, Size size) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.dialogLogoutTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: (size.width * 0.042).clamp(15.0, 18.0),
              fontWeight: FontWeight.bold),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.btnNo,
                style: GoogleFonts.poppins(
                    color: subtextColor,
                    fontSize: (size.width * 0.038).clamp(13.0, 15.0))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              ref.invalidate(savings_provider);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                elevation: context.isApple ? 0 : 2),
            child: Text(l10n.btnYes,
                style: GoogleFonts.poppins(
                    color: AppColors.cardLight,
                    fontWeight: FontWeight.bold,
                    fontSize: (size.width * 0.038).clamp(13.0, 15.0))),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, WidgetRef ref, AppLocalizations l10n, Size size) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.dialogDeleteTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: (size.width * 0.042).clamp(15.0, 18.0),
              fontWeight: FontWeight.bold),
        ),
        content: Text(
          l10n.dialogDeleteSub,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: (size.width * 0.035).clamp(12.0, 14.0)),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.btnNo,
                style: GoogleFonts.poppins(
                    color: subtextColor,
                    fontSize: (size.width * 0.038).clamp(13.0, 15.0))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              ref.invalidate(savings_provider);
              final success = await ref
                  .read(authProvider.notifier)
                  .deleteAccount(l10n.errorGeneric);

              if (success) {
                if (context.mounted) context.go('/login');
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(ref.read(authProvider).errorMessage ?? '')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                elevation: context.isApple ? 0 : 2),
            child: Text(l10n.btnYes,
                style: GoogleFonts.poppins(
                    color: AppColors.cardLight,
                    fontWeight: FontWeight.bold,
                    fontSize: (size.width * 0.038).clamp(13.0, 15.0))),
          ),
        ],
      ),
    );
  }
}
