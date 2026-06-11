// ignore_for_file: dead_null_aware_expression

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/cosmic_celebration_stars.dart';
import 'manage_target_saving_view_model.dart';

// CLASE FORMATEADORA
class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String newRaw = newValue.text;
    bool deletedDot = oldValue.text.contains('.') &&
        !newValue.text.contains('.') &&
        oldValue.text.length > newValue.text.length;
    String cleanText;

    if (deletedDot) {
      int oldDotIndex = oldValue.text.indexOf('.');
      cleanText = oldValue.text
          .substring(0, oldDotIndex)
          .replaceAll(RegExp(r'[^0-9]'), '');
    } else {
      cleanText = newRaw.replaceAll(RegExp(r'[^0-9.]'), '');
    }

    if (cleanText.isEmpty) return const TextEditingValue(text: '');

    if (cleanText.startsWith('.')) cleanText = '0$cleanText';

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

    if (deletedDot) validCharsBeforeCursor = cleanText.length;

    int newCursorPos = 1;
    int charsCounted = 0;

    for (int i = 1; i < formattedText.length; i++) {
      if (charsCounted == validCharsBeforeCursor) {
        newCursorPos = i;
        break;
      }

      if (RegExp(r'[0-9.]').hasMatch(formattedText[i])) charsCounted++;

      newCursorPos = i + 1;
    }

    int maxValidCursor = cleanText.length + 1;

    if (newCursorPos > maxValidCursor) newCursorPos = maxValidCursor;

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
  }
}

class ManageTargetSavingScreen extends ConsumerStatefulWidget {
  final String goalId;
  const ManageTargetSavingScreen({super.key, required this.goalId});

  @override
  ConsumerState<ManageTargetSavingScreen> createState() =>
      _ManageTargetSavingScreenState();
}

class _ManageTargetSavingScreenState
    extends ConsumerState<ManageTargetSavingScreen>
    with TickerProviderStateMixin {
  final TextEditingController _depositController = TextEditingController();

  bool _isInit = false;

  late AnimationController _victoryController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _haloAnimation;

  @override
  void initState() {
    super.initState();

    _victoryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.1)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1.1, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50),
    ]).animate(_victoryController);

    _haloAnimation = Tween<double>(begin: 0.8, end: 1.4).animate(
      CurvedAnimation(parent: _victoryController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _depositController.dispose();
    _victoryController.dispose();
    super.dispose();
  }

  String _getLocalizedFrequency(String dbFrequency, AppLocalizations l10n) {
    switch (dbFrequency.toLowerCase()) {
      case 'daily':
      case 'diario':
        return l10n.freqDaily ?? 'Diario';
      case 'weekly':
      case 'semanal':
        return l10n.freqWeekly ?? 'Semanal';
      case 'biweekly':
      case 'quincenal':
        return l10n.freqBiweekly ?? 'Quincenal';
      case 'monthly':
      case 'mensual':
        return l10n.freqMonthly ?? 'Mensual';
      default:
        return dbFrequency;
    }
  }

  // MODAL DE RETIRO
  void _showWithdrawDialog(BuildContext context,
      ManageTargetViewModel viewModel, AppLocalizations l10n, bool isDark) {
    final TextEditingController withdrawController = TextEditingController();
    final size = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/poor_piggy.png',
                width: (size.width * 0.25).clamp(80.0, 120.0),
                height: (size.width * 0.25).clamp(80.0, 120.0)),
            SizedBox(height: size.height * 0.02),
            Text(l10n.withdrawTitle ?? '',
                style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.045).clamp(16.0, 18.0),
                    fontWeight: FontWeight.bold)),
            SizedBox(height: size.height * 0.02),
            Container(
              decoration: context.isApple
                  ? BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : AppColors.backgroundLight.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : AppColors.cardLight.withOpacity(0.6),
                        width: 1.5,
                      ),
                    )
                  : null,
              child: TextField(
                controller: withdrawController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [CurrencyInputFormatter()],
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.06).clamp(20.0, 24.0),
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  filled: !context.isApple,
                  fillColor: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                  border: context.isApple
                      ? InputBorder.none
                      : OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.025),
            SizedBox(
              width: double.infinity,
              height: (size.height * 0.06).clamp(45.0, 50.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorLight,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: context.isApple ? 0 : 2),
                onPressed: () async {
                  final raw = withdrawController.text
                      .replaceAll(RegExp(r'[^0-9.]'), '');
                  final amount = double.tryParse(raw) ?? 0.0;

                  if (amount > 0) {
                    try {
                      await viewModel.addTransaction(amount, 'retiro');
                      if (ctx.mounted) Navigator.pop(ctx);
                    } catch (e) {
                      if (e.toString().contains('insufficient_funds')) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.errorInsufficientFunds,
                              style: GoogleFonts.poppins(
                                  color: AppColors.cardLight),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  }
                },
                child: Text(l10n.btnWithdraw ?? '',
                    style: GoogleFonts.poppins(
                        color: AppColors.cardLight,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final stateAsync = ref.watch(manageTargetProvider(widget.goalId));
    final viewModel = ref.read(manageTargetProvider(widget.goalId).notifier);
    final textColorInside =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColorInside =
        isDark ? AppColors.textSecondaryDark : AppColors.secondaryLight;

    return Scaffold(
      backgroundColor:
          AppColors.getBackgroundColor(Theme.of(context).brightness),
      body: Stack(
        children: [
          stateAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (data) {
              final double periodicAmount =
                  double.tryParse(data.goal['periodic_amount'].toString()) ??
                      0.0;

              if (!_isInit) {
                _depositController.text =
                    '\$${periodicAmount.toStringAsFixed(2)}';
                _isInit = true;
              }

              String piggy = 'assets/images/poor_piggy.png';
              final bool isGoalAchieved = data.percentage >= 100;

              if (data.percentage >= 100) {
                piggy = 'assets/images/rich_piggy.png';
                _victoryController.repeat();
              } else {
                _victoryController.stop();
                _victoryController.reset();

                if (data.percentage >= 85) {
                  piggy = 'assets/images/rich_piggy.png';
                } else if (data.percentage >= 40) {
                  piggy = 'assets/images/normal_piggy.png';
                }
              }

              return SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(size.width * 0.06,
                    size.height * 0.16, size.width * 0.06, size.height * 0.05),
                child: Column(
                  children: [
                    Text(data.goal['goal_name'],
                        style: GoogleFonts.poppins(
                            fontSize: (size.width * 0.065).clamp(24.0, 28.0),
                            fontWeight: FontWeight.bold,
                            color: textColorInside)),
                    SizedBox(height: size.height * 0.01),
                    Text(l10n.manageSavedAmount ?? '',
                        style: GoogleFonts.poppins(
                            fontSize: (size.width * 0.035).clamp(12.0, 14.0),
                            color: subtextColorInside)),
                    Text('\$${data.totalSaved.toStringAsFixed(2)}',
                        style: GoogleFonts.poppins(
                            fontSize: (size.width * 0.09).clamp(28.0, 38.0),
                            fontWeight: FontWeight.bold,
                            color: AppColors.successLight)),

                    if (isGoalAchieved) ...[
                      SizedBox(height: size.height * 0.008),
                      Text(
                        l10n.manageTargetAchieved,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: (size.width * 0.038).clamp(13.0, 16.0),
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.successDark
                              : AppColors.successLight,
                        ),
                      ),
                    ],
                    SizedBox(height: size.height * 0.035),

                    // SECCIÓN CENTRAL ANIMADA
                    AnimatedBuilder(
                        animation: _victoryController,
                        builder: (context, child) {
                          final double piggyWidth =
                              (size.width * 0.3).clamp(100.0, 140.0);
                          final double piggyHeight =
                              (size.width * 0.3).clamp(100.0, 140.0);
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              if (isGoalAchieved)
                                CosmicCelebrationStars(
                                  play: true,
                                  size:
                                      Size(piggyWidth * 2.2, piggyHeight * 2.2),
                                ),
                              if (isGoalAchieved)
                                Transform.scale(
                                  scale: _haloAnimation.value,
                                  child: Opacity(
                                    opacity: (1.4 - _haloAnimation.value)
                                        .clamp(0.0, 0.4),
                                    child: Container(
                                      width: piggyWidth * 1.1,
                                      height: piggyHeight * 1.1,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primaryLight
                                            .withOpacity(0.6),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primaryLight
                                                .withOpacity(0.4),
                                            blurRadius: 20,
                                            spreadRadius: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              Transform.scale(
                                scale: isGoalAchieved
                                    ? _scaleAnimation.value
                                    : 1.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(piggy,
                                        width: piggyWidth, height: piggyHeight),
                                    SizedBox(width: size.width * 0.05),
                                    SizedBox(
                                      width:
                                          (size.width * 0.2).clamp(65.0, 85.0),
                                      height:
                                          (size.width * 0.2).clamp(65.0, 85.0),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          CircularProgressIndicator(
                                              value: (data.percentage / 100)
                                                  .clamp(0.0, 1.0),
                                              strokeWidth: (size.width * 0.025)
                                                  .clamp(6.0, 10.0),
                                              backgroundColor: AppColors
                                                  .cardLight
                                                  .withOpacity(0.1),
                                              color: isGoalAchieved
                                                  ? AppColors.successLight
                                                  : (isDark
                                                      ? AppColors.primaryDark
                                                      : AppColors
                                                          .primaryLight)),
                                          Center(
                                              child: Text(
                                                  '${data.percentage.toStringAsFixed(0)}%',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: (size.width *
                                                              0.045)
                                                          .clamp(14.0, 18.0),
                                                      color: textColorInside))),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                    SizedBox(height: size.height * 0.035),

                    // FILA DE ACCIONES
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(
                            opacity: animation,
                            child: SizeTransition(
                                sizeFactor: animation, child: child));
                      },
                      child: !isGoalAchieved
                          ? Row(
                              key: const ValueKey('action_row'),
                              children: [
                                IconButton(
                                  onPressed: () => _showWithdrawDialog(
                                      context, viewModel, l10n, isDark),
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: AppColors.errorLight,
                                      size: (size.width * 0.08)
                                          .clamp(28.0, 35.0)),
                                ),
                                Expanded(
                                  child: _buildAdaptiveContainer(
                                    context: context,
                                    isDark: isDark,
                                    child: TextField(
                                      controller: _depositController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        CurrencyInputFormatter()
                                      ],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: (size.width * 0.05)
                                              .clamp(16.0, 20.0),
                                          fontWeight: FontWeight.bold,
                                          color: textColorInside),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: size.width * 0.025),
                                ElevatedButton(
                                  onPressed: () async {
                                    final raw = _depositController.text
                                        .replaceAll(RegExp(r'[^0-9.]'), '');
                                    final amount = double.tryParse(raw) ?? 0.0;

                                    if (amount > 0) {
                                      await viewModel.addTransaction(
                                          amount, 'deposito');
                                      _depositController.text =
                                          '\$${periodicAmount.toStringAsFixed(2)}';
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.successLight,
                                    minimumSize: Size(
                                        (size.width * 0.22).clamp(80.0, 100.0),
                                        (size.height * 0.06).clamp(45.0, 50.0)),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 0,
                                  ),
                                  child: Text(l10n.btnSave ?? '',
                                      style: GoogleFonts.poppins(
                                          color: AppColors.cardLight,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(key: ValueKey('empty_space')),
                    ),
                    SizedBox(
                        height: isGoalAchieved
                            ? size.height * 0.01
                            : size.height * 0.035),

                    // RECUADRO DE RACHAS
                    _buildAdaptiveContainer(
                      context: context,
                      isDark: isDark,
                      height: (size.height * 0.1).clamp(80.0, 90.0),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        itemCount: data.streaks.length,
                        itemBuilder: (ctx, i) {
                          final s = data.streaks[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    s.isSuccess
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    color: s.isSuccess
                                        ? AppColors.successLight
                                        : AppColors.errorLight,
                                    size:
                                        (size.width * 0.065).clamp(22.0, 28.0)),
                                const SizedBox(height: 6),
                                Text(DateFormat('yyyy/MM/dd').format(s.date),
                                    style: GoogleFonts.poppins(
                                        fontSize: (size.width * 0.025)
                                            .clamp(9.0, 10.0),
                                        fontWeight: isDark
                                            ? FontWeight.normal
                                            : FontWeight.w600,
                                        color: subtextColorInside)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: size.height * 0.025),

                    // DETALLES METRICOS DE LA META
                    _buildAdaptiveContainer(
                      context: context,
                      isDark: isDark,
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Row(children: [
                        Expanded(
                            child: _buildDetail(
                                l10n.manageTargetLabel ?? '',
                                '\$${data.goal['target_amount']}',
                                isDark,
                                textColorInside,
                                subtextColorInside,
                                size)),
                        Expanded(
                            child: _buildDetail(
                                l10n.manageFrequencyLabel ?? '',
                                _getLocalizedFrequency(
                                    data.goal['frequencies'] != null
                                        ? data.goal['frequencies']
                                            ['frequency_name']
                                        : '',
                                    l10n),
                                isDark,
                                textColorInside,
                                subtextColorInside,
                                size)),
                        Expanded(
                            child: _buildDetail(
                                l10n.manageEndDateLabel ?? '',
                                DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(data.goal['end_date'])),
                                isDark,
                                textColorInside,
                                subtextColorInside,
                                size)),
                      ]),
                    ),
                    SizedBox(height: size.height * 0.035),
                    Text(l10n.manageTransactionsTitle ?? '',
                        style: GoogleFonts.poppins(
                            fontSize: (size.width * 0.045).clamp(16.0, 18.0),
                            fontWeight: FontWeight.bold,
                            color: textColorInside)),
                    SizedBox(height: size.height * 0.015),

                    // HISTORIAL DE TRANSACCIONES
                    _buildAdaptiveContainer(
                      context: context,
                      isDark: isDark,
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: data.transactions.length,
                        itemBuilder: (ctx, i) {
                          final tx = data.transactions[i];
                          final isDep = tx['transaction_type'] == 'deposito';
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: context.isApple
                                ? BoxDecoration(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.04)
                                        : AppColors.cardLight.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark
                                          ? Colors.white.withOpacity(0.05)
                                          : AppColors.cardLight
                                              .withOpacity(0.6),
                                      width: 1,
                                    ),
                                  )
                                : null,
                            child: context.isApple
                                ? ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 4),
                                    leading: _buildLeadingTx(isDep, tx, size,
                                        subtextColorInside, isDark),
                                    title: _buildTitleTx(tx, textColorInside,
                                        size, l10n, subtextColorInside, isDark),
                                    trailing: _buildTrailingTx(isDep, size),
                                  )
                                : Card(
                                    elevation: 1,
                                    color: isDark
                                        ? AppColors.cardDark
                                        : AppColors.cardLight,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                      leading: _buildLeadingTx(isDep, tx, size,
                                          subtextColorInside, isDark),
                                      title: _buildTitleTx(
                                          tx,
                                          textColorInside,
                                          size,
                                          l10n,
                                          subtextColorInside,
                                          isDark),
                                      trailing: _buildTrailingTx(isDep, size),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // COMPONENTES INTERNOS EXTRACURRICULARES
  Widget _buildAdaptiveContainer({
    required BuildContext context,
    required bool isDark,
    required Widget child,
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    if (context.isApple) {
      return Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.cardDark.withOpacity(0.15)
              : AppColors.cardLight.withOpacity(0.45),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.cardLight.withOpacity(0.1)
                : AppColors.cardLight.withOpacity(0.55),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: child,
          ),
        ),
      );
    } else {
      return Card(
        elevation: 2,
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          height: height,
          padding: padding,
          child: child,
        ),
      );
    }
  }

  Widget _buildLeadingTx(
      bool isDep, dynamic tx, Size size, Color subtextColor, bool isDark) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${isDep ? '+' : '-'}\$${tx['amount']}',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: (size.width * 0.035).clamp(12.0, 14.0),
                  color:
                      isDep ? AppColors.successLight : AppColors.errorLight)),
          Text(
              DateFormat('yyyy/MM/dd')
                  .format(DateTime.parse(tx['transaction_date'])),
              style: TextStyle(
                  fontSize: (size.width * 0.025).clamp(9.0, 10.0),
                  fontWeight: isDark ? FontWeight.normal : FontWeight.w600,
                  color: subtextColor)),
        ]);
  }

  Widget _buildTitleTx(dynamic tx, Color textColor, Size size,
      AppLocalizations l10n, Color subtextColor, bool isDark) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text('\$${tx['historical_balance'].toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: (size.width * 0.035).clamp(12.0, 14.0),
              color: textColor)),
      Text(l10n.manageBalanceLabel ?? '',
          style: TextStyle(
              fontSize: (size.width * 0.025).clamp(9.0, 10.0),
              fontWeight: isDark ? FontWeight.normal : FontWeight.w600,
              color: subtextColor)),
    ]);
  }

  Widget _buildTrailingTx(bool isDep, Size size) {
    return Icon(isDep ? Icons.arrow_upward : Icons.arrow_downward,
        size: (size.width * 0.05).clamp(20.0, 24.0),
        color: isDep ? AppColors.successLight : AppColors.errorLight);
  }

  Widget _buildDetail(String label, String value, bool isDark, Color textColor,
      Color subtextColor, Size size) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(label,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: (size.width * 0.028).clamp(9.0, 11.0),
              fontWeight: isDark ? FontWeight.normal : FontWeight.w600,
              color: subtextColor)),
      const SizedBox(height: 4),
      Text(value,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: (size.width * 0.033).clamp(11.0, 13.0),
              color: textColor)),
    ]);
  }
}
