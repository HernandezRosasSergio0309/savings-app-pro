// ignore_for_file: dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../dashboard/view/dashboard_screen.dart';

class CreateFreestyleSavingScreen extends ConsumerStatefulWidget {
  const CreateFreestyleSavingScreen({super.key});

  @override
  ConsumerState<CreateFreestyleSavingScreen> createState() =>
      _CreateFreestyleSavingScreenState();
}

class _CreateFreestyleSavingScreenState
    extends ConsumerState<CreateFreestyleSavingScreen> {
  final TextEditingController _nameController = TextEditingController();

  String _selectedFrequency = 'Diario';
  bool _is_loading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // VALIDADOR ORIGINAL DEL FORMULARIO
  bool _is_form_valid() {
    final nameIsEmpty = _nameController.text.trim().isEmpty;
    return !nameIsEmpty && !_is_loading;
  }

  // CONEXIÓN E INSERCIÓN EN SUPABASE
  Future<void> _submit_goal() async {
    final supabaseClient = Supabase.instance.client;
    final authenticatedUser = supabaseClient.auth.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (authenticatedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorNoSession ?? '')),
      );
      return;
    }

    setState(() {
      _is_loading = true;
    });

    try {
      int frequencyId = 1;
      if (_selectedFrequency == 'Semanal') {
        frequencyId = 2;
      } else if (_selectedFrequency == 'Quincenal') {
        frequencyId = 3;
      } else if (_selectedFrequency == 'Mensual') {
        frequencyId = 4;
      }

      // Insertar con target_amount y end_date en NULL para definirlo como Freestyle de forma nativa
      final createdGoal = await supabaseClient
          .from('savings_goals')
          .insert({
            'user_id': authenticatedUser.id,
            'frequency_id': frequencyId,
            'goal_name': _nameController.text.trim(),
            'target_amount': null,
            'periodic_amount': null,
            'start_date': DateTime.now().toIso8601String(),
            'end_date': null,
            'is_system_goal': false,
          })
          .select()
          .single();

      final newGoalId = createdGoal['goal_id'].toString();
      ref.invalidate(savings_provider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.successGoalCreated ?? ''),
            backgroundColor: AppColors.successLight,
          ),
        );
        context.pushReplacement(
          '/manage_freestyle_saving',
          extra: newGoalId,
        );
      }
    } catch (database_error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${l10n.errorSavingGoal}${database_error.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _is_loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    // CONTENIDO DEL FORMULARIO
    final Widget formContent = SingleChildScrollView(
      padding: EdgeInsets.only(
          top: size.height * 0.17,
          left: size.width * 0.06,
          right: size.width * 0.06,
          bottom: size.height * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Título de la pantalla
          Text(
            l10n.freestyleTitle ?? '',
            style: GoogleFonts.poppins(
              fontSize: (size.width * 0.075).clamp(28.0, 36.0),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Image.asset('assets/images/normal_piggy.png',
              height: (size.height * 0.13).clamp(100.0, 140.0)),
          SizedBox(height: size.height * 0.045),

          // Nombre del objetivo
          _buildLabel(l10n.freestyleNameLabel ?? '', null, textColor, size),
          SizedBox(height: size.height * 0.01),
          _buildAdaptiveTextField(
            controller: _nameController,
            hint: l10n.freestyleNameHint ?? '',
            isDark: isDark,
            keyboardType: TextInputType.text,
            size: size,
          ),
          SizedBox(height: size.height * 0.04),

          // Sección de Frecuencia de Ahorro
          Text(
            l10n.freestyleFrequencyLabel ?? '',
            style: GoogleFonts.poppins(
                fontSize: (size.width * 0.04).clamp(14.0, 18.0),
                fontWeight: FontWeight.w600,
                color: textColor),
          ),
          SizedBox(height: size.height * 0.015),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: _buildFreqRadio('Diario', l10n.freqDaily ?? '',
                          isDark, textColor, size)),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                      child: _buildFreqRadio('Semanal', l10n.freqWeekly ?? '',
                          isDark, textColor, size)),
                ],
              ),
              SizedBox(height: size.height * 0.015),
              Row(
                children: [
                  Expanded(
                      child: _buildFreqRadio('Quincenal',
                          l10n.freqBiweekly ?? '', isDark, textColor, size)),
                  SizedBox(width: size.width * 0.03),
                  Expanded(
                      child: _buildFreqRadio('Mensual', l10n.freqMonthly ?? '',
                          isDark, textColor, size)),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.06),

          // Botón Iniciar Ahorro
          Builder(builder: (context) {
            final formIsValid = _is_form_valid();
            return SizedBox(
              width: double.infinity,
              height: (size.height * 0.06).clamp(48.0, 60.0),
              child: ElevatedButton(
                onPressed: formIsValid ? _submit_goal : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: formIsValid
                      ? (context.isApple
                          ? (isDark
                              ? AppColors.primaryDark.withOpacity(0.5)
                              : AppColors.primaryLight.withOpacity(0.8))
                          : (isDark
                              ? AppColors.primaryDark
                              : AppColors.primaryLight))
                      : (isDark
                          ? AppColors.cardDark.withOpacity(0.4)
                          : AppColors.textPrimaryLight.withOpacity(0.12)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _is_loading
                    ? SizedBox(
                        width: (size.width * 0.06).clamp(20.0, 24.0),
                        height: (size.width * 0.06).clamp(20.0, 24.0),
                        child: CircularProgressIndicator(
                          color: isDark
                              ? AppColors.backgroundDark
                              : AppColors.cardLight,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        l10n.btnStartSaving ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: (size.width * 0.045).clamp(16.0, 20.0),
                          fontWeight: FontWeight.w600,
                          color: formIsValid
                              ? (isDark
                                  ? AppColors.backgroundDark
                                  : AppColors.cardLight)
                              : (isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight),
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );

    // CAPA DE DISTRIBUCIÓN ADAPTATIVA DE RAÍZ POR ENTORNO
    return context.isApple
        ? AdaptiveBackground(
            child: formContent)
        : Scaffold(
            backgroundColor: AppColors.getBackgroundColor(theme.brightness),
            body: Stack(children: [
              formContent
            ]),
          );
  }

  // WIDGETS AUXILIARES DE UI
  Widget _buildLabel(String text, IconData? icon, Color color, Size size) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: color, size: (size.width * 0.05).clamp(18.0, 24.0)),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: GoogleFonts.poppins(
              fontSize: (size.width * 0.04).clamp(14.0, 18.0),
              fontWeight: FontWeight.w600,
              color: color),
        ),
      ],
    );
  }

  Widget _buildAdaptiveTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    required TextInputType keyboardType,
    required Size size,
  }) {
    final style = GoogleFonts.poppins(
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      fontSize: (size.width * 0.04).clamp(14.0, 18.0),
    );

    if (context.isApple) {
      return Container(
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.cardDark.withOpacity(0.15)
              : AppColors.cardLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.cardLight.withOpacity(0.1)
                : AppColors.cardLight.withOpacity(0.55),
            width: 1.5,
          ),
        ),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: style,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      );
    } else {
      return TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: style,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight),
          filled: true,
          fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: isDark
                    ? AppColors.cardLight.withOpacity(0.24)
                    : AppColors.textPrimaryLight.withOpacity(0.12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: isDark
                    ? AppColors.cardLight.withOpacity(0.24)
                    : AppColors.textPrimaryLight.withOpacity(0.12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                width: 2),
          ),
        ),
      );
    }
  }

  Widget _buildFreqRadio(
      String value, String label, bool isDark, Color textColor, Size size) {
    final isSelected = _selectedFrequency == value;
    final activeColor = isDark ? AppColors.primaryDark : AppColors.primaryLight;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFrequency = value;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
        decoration: context.isApple
            ? BoxDecoration(
                color: isSelected
                    ? activeColor.withOpacity(0.25)
                    : (isDark
                        ? AppColors.cardDark.withOpacity(0.1)
                        : AppColors.cardLight.withOpacity(0.35)),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? activeColor
                      : (isDark
                          ? AppColors.cardLight.withOpacity(0.1)
                          : AppColors.cardLight.withOpacity(0.5)),
                  width: 1.5,
                ),
              )
            : BoxDecoration(
                color: isSelected
                    ? activeColor.withOpacity(0.1)
                    : (isDark ? AppColors.cardDark : AppColors.cardLight),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? activeColor
                      : (isDark
                          ? AppColors.cardLight.withOpacity(0.24)
                          : AppColors.textPrimaryLight.withOpacity(0.12)),
                ),
                boxShadow: isSelected
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.textPrimaryLight.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
              ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: (size.width * 0.035).clamp(12.0, 16.0),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? activeColor : textColor,
          ),
        ),
      ),
    );
  }
}
