// ignore_for_file: unused_local_variable, dead_null_aware_expression

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../common_widgets/custom_auth_field.dart';
import 'settings_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _usernameController;

  String? _usernameError;
  File? _pickedImage;
  String? _currentAvatarUrl;
  bool _isImagePending = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _usernameController.addListener(_validateUsername);
    _loadProfileData();
  }

  // FUNCIÓN ASÍNCRONA DE CARGA
  Future<void> _loadProfileData() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        final data = await supabase
            .from('profiles')
            .select('username, avatar_url')
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            _usernameController.text = data['username']?.toString() ?? '';
            _currentAvatarUrl = data['avatar_url']?.toString();
          });
        }
      }
    } catch (e) {
      debugPrint('Error cargando datos de perfil en edición: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.removeListener(_validateUsername);
    _usernameController.dispose();
    super.dispose();
  }

  // VALIDADOR DE USUARIO Y PALABRAS PROHIBIDAS
  void _validateUsername() {
    final text = _usernameController.text.trim();
    final l10n = AppLocalizations.of(context)!;

    if (text.isEmpty) {
      setState(() => _usernameError = null);
      return;
    }

    final hasProfanity = AppConstants.profanity_list.any(
      (word) => text.toLowerCase().contains(word.toLowerCase()),
    );

    setState(() {
      if (hasProfanity) {
        _usernameError = l10n.errorProfanity;
      } else {
        _usernameError = null;
      }
    });
  }

  // CAPTURA DE IMAGEN INTELIGENTE
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
        _isImagePending = true;
      });
    }
  }

  // HOJA DE ACCIONES
  void _showPhotoOptionsBottomSheet(
      BuildContext context, AppLocalizations l10n, bool isDark) {
    final menuColor = Theme.of(context).colorScheme.surface;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final size = MediaQuery.of(context).size;

    // Estructura interna de opciones compartida
    final Widget sheetRows = SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.photo_library_outlined, color: textColor),
            splashColor: context.isApple ? Colors.transparent : null,
            title: Text(
              l10n.btnChooseGallery,
              style: GoogleFonts.poppins(
                  fontSize: (size.width * 0.038).clamp(13.0, 16.0),
                  fontWeight: FontWeight.w500,
                  color: textColor),
            ),
            onTap: () {
              Navigator.pop(context);
              _pickImageFromGallery();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline,
                color: Theme.of(context).colorScheme.error),
            splashColor: context.isApple ? Colors.transparent : null,
            title: Text(
              l10n.btnRemoveCurrentPhoto,
              style: GoogleFonts.poppins(
                fontSize: (size.width * 0.038).clamp(13.0, 16.0),
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _showRemoveConfirmationDialog(context, l10n);
            },
          ),
        ],
      ),
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: context.isApple
          ? (isDark
              ? AppColors.cardDark.withOpacity(0.4)
              : AppColors.cardLight.withOpacity(0.6))
          : menuColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => context.isApple
          ? ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
                child: sheetRows,
              ),
            )
          : sheetRows,
    );
  }

  // CONEXIÓN ASÍNCRONA DE SUBIDA A STORAGEbucket
  Future<void> _uploadProfileImage() async {
    if (_pickedImage == null) return;

    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (currentUser == null) return;

    try {
      final userId = currentUser.id;
      final fileExtension = _pickedImage!.path.split('.').last;
      final fileName = '$userId/avatar.$fileExtension';

      await supabase.storage.from('avatars').upload(
            fileName,
            _pickedImage!,
            fileOptions: const FileOptions(upsert: true),
          );

      final avatarUrl = supabase.storage.from('avatars').getPublicUrl(fileName);

      await supabase
          .from('profiles')
          .update({'avatar_url': avatarUrl}).eq('id', userId);

      ref.read(authProvider.notifier).updateAvatarInState(avatarUrl);
      ref.invalidate(settingsProfileProvider);

      setState(() {
        _currentAvatarUrl = avatarUrl;
        _isImagePending = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.successAvatarUpdated,
              style: GoogleFonts.poppins(color: AppColors.cardLight),
            ),
            backgroundColor: AppColors.successLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.errorAvatarUpdate,
              style: GoogleFonts.poppins(color: AppColors.cardLight),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // ELIMINACIÓN ASÍNCRONA DE ARCHIVOS EN SUPABASE
  Future<void> _removeProfileImage() async {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (currentUser == null) return;

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    try {
      final userId = currentUser.id;

      if (_currentAvatarUrl != null &&
          _currentAvatarUrl!.contains('avatars/')) {
        final filePath = _currentAvatarUrl!.split('avatars/').last;
        await supabase.storage.from('avatars').remove([filePath]);
      }

      await supabase
          .from('profiles')
          .update({'avatar_url': null}).eq('id', userId);
      ref.read(authProvider.notifier).updateAvatarInState(null);
      ref.invalidate(settingsProfileProvider);
      setState(() {
        _pickedImage = null;
        _currentAvatarUrl = null;
        _isImagePending = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.successAvatarRemoved,
              style: GoogleFonts.poppins(color: AppColors.cardLight),
            ),
            backgroundColor: AppColors.successLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.errorAvatarRemove,
              style: GoogleFonts.poppins(color: AppColors.cardLight),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // DIÁLOGO DE REMOCIÓN
  void _showRemoveConfirmationDialog(
      BuildContext context, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          l10n.dialogRemovePhotoTitle,
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
            onPressed: () {
              Navigator.pop(dialogContext);
              _removeProfileImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              elevation: context.isApple ? 0 : 2,
            ),
            child: Text(
              l10n.btnYes,
              style: GoogleFonts.poppins(
                  color: AppColors.cardLight,
                  fontWeight: FontWeight.bold,
                  fontSize: (size.width * 0.038).clamp(13.0, 15.0)),
            ),
          ),
        ],
      ),
    );
  }

  // TU FUNCIÓN DE PERSISTENCIA PARA EL NOMBRE EN PERFILES
  Future<void> _updateUsernameInDatabase(String newUsername) async {
    if (newUsername.isEmpty || _usernameError != null) return;
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (currentUser == null) return;

    try {
      await supabase
          .from('profiles')
          .update({'username': newUsername}).eq('id', currentUser.id);
      ref.read(authProvider.notifier).updateUsernameInState(newUsername);
      ref.invalidate(settingsProfileProvider);

      if (mounted) {
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.successUsernameUpdated,
              style: GoogleFonts.poppins(color: AppColors.cardLight),
            ),
            backgroundColor: AppColors.successLight,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.errorUsernameUpdate,
              style: GoogleFonts.poppins(color: AppColors.cardLight),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final widgetColor = isDark ? AppColors.cardDark : AppColors.primaryLight;

    // CONTENIDO INTERNO DE EDICIÓN
    final Widget screenContent = SingleChildScrollView(
      padding: EdgeInsets.only(
          top: size.height * 0.11,
          left: size.width * 0.06,
          right: size.width * 0.06,
          bottom: size.height * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título Centralizado
          Text(
            l10n.editProfileTitle,
            style: GoogleFonts.poppins(
              fontSize: (size.width * 0.07).clamp(24.0, 30.0),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: size.height * 0.03),

          // Componente de Avatar Proporcional y Adaptativo
          Stack(
            children: [
              GestureDetector(
                onTap: () =>
                    _showPhotoOptionsBottomSheet(context, l10n, isDark),
                child: Container(
                  width: (size.width * 0.24).clamp(85.0, 110.0),
                  height: (size.width * 0.24).clamp(85.0, 110.0),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardDark
                        : AppColors.secondaryLight.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.isApple
                          ? Colors.white.withOpacity(0.2)
                          : widgetColor.withOpacity(0.4),
                      width: 2,
                    ),
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(_pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : (_currentAvatarUrl != null
                            ? DecorationImage(
                                image: NetworkImage(_currentAvatarUrl!),
                                fit: BoxFit.cover,
                              )
                            : null),
                  ),
                  child: (_pickedImage == null && _currentAvatarUrl == null)
                      ? Icon(
                          Icons.person_outline,
                          size: (size.width * 0.13).clamp(45.0, 65.0),
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              if (_isImagePending)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: (size.width * 0.08).clamp(32.0, 40.0),
                    height: (size.width * 0.08).clamp(32.0, 40.0),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      shape: BoxShape.circle,
                      boxShadow: context.isApple
                          ? []
                          : [
                              BoxShadow(
                                color: AppColors.successLight.withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.check,
                          color: AppColors.cardLight,
                          size: (size.width * 0.05).clamp(18.0, 24.0)),
                      onPressed: () {
                        setState(() {
                          _uploadProfileImage();
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: size.height * 0.015),

          // Link de Texto para Editar Foto
          GestureDetector(
            onTap: () => _showPhotoOptionsBottomSheet(context, l10n, isDark),
            child: Text(
              l10n.editProfilePhoto,
              style: GoogleFonts.poppins(
                fontSize: (size.width * 0.038).clamp(13.0, 15.0),
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.035),

          // Entrada de Texto
          CustomAuthField(
            controller: _usernameController,
            hint_text: l10n.usernameHint,
            is_password: false,
            keyboard_type: TextInputType.text,
            error_text: _usernameError,
            on_submitted: (value) {
              _updateUsernameInDatabase(value.trim());
            },
          ),
        ],
      ),
    );

    // CAPA DE DISTRIBUCIÓN ADAPTATIVA DE INTERFAZ DE RAÍZ
    return context.isApple
        ? AdaptiveBackground(
            child: screenContent)
        : Scaffold(
            backgroundColor:
                AppColors.getBackgroundColor(Theme.of(context).brightness),
            body: Stack(
                children: [screenContent]),
          );
  }
}
