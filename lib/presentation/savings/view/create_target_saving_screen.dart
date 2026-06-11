// ignore_for_file: dead_code_catch_following_catch, dead_null_aware_expression

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/adaptive_background.dart';
import '../../dashboard/view/dashboard_screen.dart';

class CreateTargetSavingScreen extends ConsumerStatefulWidget {
  const CreateTargetSavingScreen({super.key});

  @override
  ConsumerState<CreateTargetSavingScreen> createState() =>
      _CreateTargetSavingScreenState();
}

class _CreateTargetSavingScreenState
    extends ConsumerState<CreateTargetSavingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _selectedFrequency = 'Diario';
  double _calculatedAmount = 0.0;
  bool _is_loading = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_calculateSavingAmount);
    _nameController.addListener(() {
      setState(() {});
    });
  }

  // VALIDADOR ORIGINAL DEL FORMULARIO
  bool _is_form_valid() {
    final nameIsEmpty = _nameController.text.trim().isEmpty;
    final rawAmount = _amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsedAmount = double.tryParse(rawAmount) ?? 0.0;

    return !nameIsEmpty && parsedAmount > 0.0 && !_is_loading;
  }

  // COMPROBACIÓN ORIGINAL DE FRECUENCIAS
  bool _is_frequency_available(String frequency) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final totalDays = _selectedDate.difference(today).inDays;

    if (frequency == 'Semanal' && totalDays < 7) return false;
    if (frequency == 'Quincenal' && totalDays < 15) return false;
    if (frequency == 'Mensual' && totalDays < 30) return false;
    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // LÓGICA DE CÁLCULO DE PERIODOS
  void _calculateSavingAmount() {
    final rawText = _amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final double targetAmount = double.tryParse(rawText) ?? 0.0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int days = _selectedDate.difference(today).inDays;
    if (days <= 0) days = 1;

    double periods = 1;

    if (_selectedFrequency == 'Diario') {
      periods = days / 1;
    } else if (_selectedFrequency == 'Semanal') {
      periods = days / 7;
    } else if (_selectedFrequency == 'Quincenal') {
      periods = days / 15;
    } else if (_selectedFrequency == 'Mensual') {
      periods = days / 30;
    }

    if (periods < 1) periods = 1;

    setState(() {
      _calculatedAmount = targetAmount / periods;
    });
  }

  // CONEXIÓN E INSERCIÓN EN SUPABASE
  Future<void> _submit_goal() async {
    final supabaseClient = Supabase.instance.client;
    final authenticatedUser = supabaseClient.auth.currentUser;
    final l10n = AppLocalizations.of(context)!;

    if (authenticatedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorNoSession ?? 'Error: No session')),
      );
      return;
    }

    setState(() {
      _is_loading = true;
    });

    try {
      final cleanAmount =
          _amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
      final targetAmount = double.tryParse(cleanAmount) ?? 0.0;

      int frequencyId = 1;
      if (_selectedFrequency == 'Semanal') {
        frequencyId = 2;
      } else if (_selectedFrequency == 'Quincenal') {
        frequencyId = 3;
      } else if (_selectedFrequency == 'Mensual') {
        frequencyId = 4;
      }

      final createdGoal = await supabaseClient
          .from('savings_goals')
          .insert({
            'user_id': authenticatedUser.id,
            'frequency_id': frequencyId,
            'goal_name': _nameController.text.trim(),
            'target_amount': targetAmount,
            'periodic_amount': _calculatedAmount,
            'start_date': DateTime.now().toIso8601String(),
            'end_date': _selectedDate.toIso8601String(),
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
          '/manage_target_saving',
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

  // SELECTOR DE FECHA
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(primary: AppColors.primaryDark)
                : const ColorScheme.light(primary: AppColors.primaryLight),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        if (!_is_frequency_available(_selectedFrequency)) {
          _selectedFrequency = 'Diario';
        }
      });
      _calculateSavingAmount();
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
          Text(
            l10n.targetTitle ?? '',
            style: GoogleFonts.poppins(
              fontSize: (size.width * 0.075).clamp(28.0, 36.0),
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Image.asset('assets/images/rich_piggy.png',
              height: (size.height * 0.13).clamp(100.0, 140.0)),
          SizedBox(height: size.height * 0.045),

          // Nombre
          _buildLabel(l10n.targetNameLabel ?? '', null, textColor, size),
          SizedBox(height: size.height * 0.01),
          _buildAdaptiveTextField(
            controller: _nameController,
            hint: l10n.targetNameHint ?? '',
            isDark: isDark,
            keyboardType: TextInputType.text,
            size: size,
          ),
          SizedBox(height: size.height * 0.03),

          // Cantidad Meta
          _buildLabel(l10n.targetAmountLabel ?? '', Icons.flag_rounded,
              textColor, size),
          SizedBox(height: size.height * 0.01),
          _buildAdaptiveTextField(
            controller: _amountController,
            hint: l10n.targetAmountHint ?? '',
            isDark: isDark,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [CurrencyInputFormatter()],
            size: size,
            onSubmitted: (value) {
              if (value == '\$0.00') {
                _amountController.clear();
                _calculateSavingAmount();
              }
            },
          ),
          SizedBox(height: size.height * 0.03),

          // Fecha Meta
          _buildLabel(l10n.targetDateLabel ?? '', Icons.calendar_month,
              textColor, size),
          SizedBox(height: size.height * 0.01),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05, vertical: size.height * 0.02),
              decoration: context.isApple
                  ? BoxDecoration(
                      color: isDark
                          ? AppColors.cardDark.withOpacity(0.2)
                          : AppColors.cardLight.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.cardLight.withOpacity(0.12)
                            : AppColors.cardLight.withOpacity(0.6),
                        width: 1.5,
                      ),
                    )
                  : BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: isDark
                              ? AppColors.cardLight.withOpacity(0.24)
                              : AppColors.textPrimaryLight.withOpacity(0.12)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimaryLight.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
              child: Text(
                DateFormat('yyyy/MM/dd').format(_selectedDate),
                style: GoogleFonts.poppins(
                  fontSize: (size.width * 0.04).clamp(14.0, 18.0),
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),

          // Frecuencia
          Text(
            l10n.targetFrequencyLabel ?? '',
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
          SizedBox(height: size.height * 0.045),

          // Resultado del cálculo
          _buildLabel(l10n.targetSaveAmountLabel ?? '',
              Icons.attach_money_rounded, textColor, size),
          SizedBox(height: size.height * 0.01),
          Text(
            '\$${_calculatedAmount.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: (size.width * 0.1).clamp(32.0, 48.0),
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.successDark : AppColors.successLight,
            ),
          ),
          SizedBox(height: size.height * 0.045),

          // Botón Guardar
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
    List<TextInputFormatter>? inputFormatters,
    Function(String)? onSubmitted,
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
          inputFormatters: inputFormatters,
          onSubmitted: onSubmitted,
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
        inputFormatters: inputFormatters,
        onSubmitted: onSubmitted,
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
    final isAvailable = _is_frequency_available(value);
    final isSelected = _selectedFrequency == value;
    final activeColor = isDark ? AppColors.primaryDark : AppColors.primaryLight;

    return InkWell(
      onTap: isAvailable
          ? () {
              setState(() {
                _selectedFrequency = value;
              });
              _calculateSavingAmount();
            }
          : null,
      borderRadius: BorderRadius.circular(20),
      child: Opacity(
        opacity: isAvailable ? 1.0 : 0.35,
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
      ),
    );
  }
}

// FORMATEADOR DE MONEDA
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newRaw = newValue.text;
    bool deletedDot = oldValue.text.contains('.') &&
        !newValue.text.contains('.') &&
        oldValue.text.length > newValue.text.length;
    String cleanText;

    if (deletedDot) {
      int oldDotIndex = oldValue.text.indexOf('.');
      String preDot = oldValue.text.substring(0, oldDotIndex);
      cleanText = preDot.replaceAll(RegExp(r'[^0-9]'), '');
    } else {
      cleanText = newRaw.replaceAll(RegExp(r'[^0-9.]'), '');
    }

    if (cleanText.isEmpty) {
      return const TextEditingValue(text: '');
    }

    if (cleanText.startsWith('.')) {
      cleanText = '0$cleanText';
    }

    int firstDot = cleanText.indexOf('.');
    if (firstDot != -1) {
      cleanText = cleanText.substring(0, firstDot + 1) +
          cleanText.substring(firstDot + 1).replaceAll('.', '');

      if (cleanText.length > firstDot + 3) {
        cleanText = cleanText.substring(0, firstDot + 3);
      }
    }

    String formattedText = '\$$cleanText';

    if (!cleanText.contains('.')) {
      formattedText += '.00';
    } else {
      int decimals = cleanText.length - 1 - firstDot;
      if (decimals == 0) {
        formattedText += '00';
      } else if (decimals == 1) formattedText += '0';
    }

    int validCharsBeforeCursor = 0;
    for (int i = 0;
        i < newValue.selection.baseOffset && i < newValue.text.length;
        i++) {
      if (RegExp(r'[0-9.]').hasMatch(newValue.text[i])) {
        validCharsBeforeCursor++;
      }
    }

    if (deletedDot) {
      validCharsBeforeCursor = cleanText.length;
    }

    int newCursorPos = 1;
    int charsCounted = 0;

    for (int i = 1; i < formattedText.length; i++) {
      if (charsCounted == validCharsBeforeCursor) {
        newCursorPos = i;
        break;
      }

      if (RegExp(r'[0-9.]').hasMatch(formattedText[i])) {
        charsCounted++;
      }
      newCursorPos = i + 1;
    }

    int maxValidCursor = cleanText.length + 1;
    if (newCursorPos > maxValidCursor) {
      newCursorPos = maxValidCursor;
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }
}
