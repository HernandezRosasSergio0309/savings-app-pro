// ignore_for_file: dead_null_aware_expression

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import 'manage_freestyle_saving_view_model.dart';
import 'manage_target_saving_screen.dart';

class ManageFreestyleSavingScreen extends ConsumerStatefulWidget {
  final String goalId;
  const ManageFreestyleSavingScreen({super.key, required this.goalId});

  @override
  ConsumerState<ManageFreestyleSavingScreen> createState() =>
      _ManageFreestyleSavingScreenState();
}

class _ManageFreestyleSavingScreenState
    extends ConsumerState<ManageFreestyleSavingScreen> {
  final TextEditingController _depositController = TextEditingController();

  @override
  void dispose() {
    _depositController.dispose();
    super.dispose();
  }

  String _getLocalizedFrequency(String dbFrequency, AppLocalizations l10n) {
    switch (dbFrequency.toLowerCase()) {
      case 'daily':
      case 'diario':
        return l10n.freqDaily ?? '';
      case 'weekly':
      case 'semanal':
        return l10n.freqWeekly ?? '';
      case 'biweekly':
      case 'quincenal':
        return l10n.freqBiweekly ?? '';
      case 'monthly':
      case 'mensual':
        return l10n.freqMonthly ?? '';
      default:
        return dbFrequency;
    }
  }

  // MODAL DE RETIRO
  void _showWithdrawDialog(BuildContext context,
      ManageFreestyleViewModel viewModel, AppLocalizations l10n, bool isDark) {
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
                inputFormatters: [
                  CurrencyInputFormatter()
                ],
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
                              l10n.errorInsufficientFunds ?? '',
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
    final stateAsync = ref.watch(manageFreestyleProvider(widget.goalId));
    final viewModel = ref.read(manageFreestyleProvider(widget.goalId).notifier);
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
              String piggy = data.totalSaved > 0
                  ? 'assets/images/rich_piggy.png'
                  : 'assets/images/normal_piggy.png';
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
                    SizedBox(height: size.height * 0.035),

                    // SECCIÓN CENTRAL-
                    Image.asset(piggy,
                        width: (size.width * 0.4).clamp(120.0, 160.0),
                        height: (size.width * 0.4).clamp(120.0, 160.0)),
                    SizedBox(height: size.height * 0.035),

                    // FILA DE ACCIONES
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _showWithdrawDialog(
                              context, viewModel, l10n, isDark),
                          icon: Icon(Icons.remove_circle_outline,
                              color: AppColors.errorLight,
                              size: (size.width * 0.08).clamp(28.0, 35.0)),
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
                              inputFormatters: [CurrencyInputFormatter()],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize:
                                      (size.width * 0.05).clamp(16.0, 20.0),
                                  fontWeight: FontWeight.bold,
                                  color: textColorInside),
                              decoration: InputDecoration(
                                  hintText: '\$0.00',
                                  hintStyle: TextStyle(
                                      color:
                                          subtextColorInside.withOpacity(0.5)),
                                  border: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10)),
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
                              _depositController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.successLight,
                            minimumSize: Size(
                                (size.width * 0.22).clamp(80.0, 100.0),
                                (size.height * 0.06).clamp(45.0, 50.0)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                          ),
                          child: Text(l10n.btnSave ?? '',
                              style: GoogleFonts.poppins(
                                  color: AppColors.cardLight,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.035),

                    // RACHAS
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

                    // DETALLES DE LA META
                    _buildAdaptiveContainer(
                      context: context,
                      isDark: isDark,
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: Row(children: [
                        Expanded(
                            child: _buildDetail(
                                l10n.freestyleModeLabel ?? '',
                                l10n.freestyleModeValue ?? '',
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
                                l10n.freestyleStartDateLabel ?? '',
                                DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(data.goal['start_date'])),
                                isDark,
                                textColorInside,
                                subtextColorInside,
                                size)),
                      ]),
                    ),
                    SizedBox(height: size.height * 0.025),

                    // GRÁFICA HISTÓRICA LINEAL
                    _buildAdaptiveContainer(
                      context: context,
                      isDark: isDark,
                      padding: EdgeInsets.all(size.width * 0.04),
                      child: FreestyleLineChart(
                        dailyBalances: data.dailyBalances,
                        isDark: isDark,
                        l10n: l10n,
                        startDateStr: DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(data.goal['start_date'])),
                        lastDepositStr: () {
                          final deposits = data.transactions.where(
                              (tx) => tx['transaction_type'] == 'deposito');
                          if (deposits.isNotEmpty) {
                            return DateFormat('yyyy/MM/dd').format(
                                DateTime.parse(
                                    deposits.first['transaction_date']));
                          }
                          return '-- / -- / --';
                        }(),
                      ),
                    ),
                    SizedBox(height: size.height * 0.035),

                    // TRANSACCIONES
                    Text(l10n.manageTransactionsTitle ?? '',
                        style: GoogleFonts.poppins(
                            fontSize: (size.width * 0.045).clamp(16.0, 18.0),
                            fontWeight: FontWeight.bold,
                            color: textColorInside)),
                    SizedBox(height: size.height * 0.015),
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
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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

// COMPONENTE VISUAL
class FreestyleLineChart extends StatelessWidget {
  final List<double> dailyBalances;
  final String startDateStr;
  final String lastDepositStr;
  final bool isDark;
  final AppLocalizations l10n;
  const FreestyleLineChart({
    super.key,
    required this.dailyBalances,
    required this.startDateStr,
    required this.lastDepositStr,
    required this.isDark,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.secondaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                size: (size.width * 0.05).clamp(18.0, 22.0),
                color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.freestyleChartTitle ?? '',
                style: GoogleFonts.poppins(
                  fontSize: (size.width * 0.038).clamp(13.0, 15.0),
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: (size.height * 0.16).clamp(120.0, 160.0),
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: CustomPaint(
              painter: _LineChartPainter(
                dailyBalances: dailyBalances,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.freestyleStartDateLabel ?? 'Inicio',
                    style: GoogleFonts.poppins(
                      fontSize: (size.width * 0.025).clamp(9.0, 11.0),
                      color: subtextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    startDateStr,
                    style: GoogleFonts.poppins(
                      fontSize: (size.width * 0.028).clamp(11.0, 13.0),
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.freestyleLastDepositLabel ?? 'Último depósito',
                    style: GoogleFonts.poppins(
                      fontSize: (size.width * 0.025).clamp(9.0, 11.0),
                      color: subtextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastDepositStr,
                    style: GoogleFonts.poppins(
                      fontSize: (size.width * 0.028).clamp(11.0, 13.0),
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> dailyBalances;
  final bool isDark;
  _LineChartPainter({required this.dailyBalances, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = (isDark ? AppColors.cardLight : AppColors.textPrimaryLight)
          .withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double segmentHeight = size.height / 3;
    for (int i = 0; i < 3; i++) {
      double yPos = i * segmentHeight;
      canvas.drawLine(Offset(0, yPos), Offset(size.width, yPos), gridPaint);
    }

    final baseLinePaint = Paint()
      ..color = (isDark ? AppColors.cardLight : AppColors.textPrimaryLight)
          .withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), baseLinePaint);

    if (dailyBalances.isEmpty) return;

    double maxBalance = dailyBalances.reduce((a, b) => a > b ? a : b);
    if (maxBalance == 0) maxBalance = 1.0;

    final int totalPoints = dailyBalances.length;
    final double stepX = size.width / (totalPoints > 1 ? totalPoints - 1 : 1);

    List<Offset> points = [];
    for (int i = 0; i < totalPoints; i++) {
      double x = i * stepX;
      double y =
          size.height - (dailyBalances[i] / maxBalance * (size.height - 4.0));
      points.add(Offset(x, y));
    }

    Path fillPath = Path()..moveTo(0, size.height);
    for (var point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.successLight.withOpacity(isDark ? 0.16 : 0.1),
          AppColors.successLight.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    Path linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = isDark ? AppColors.successDark : AppColors.successLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(linePath, linePaint);

    if (points.isNotEmpty) {
      final lastPoint = points.last;
      final nodeOuterPaint = Paint()
        ..color = isDark ? AppColors.cardDark : AppColors.cardLight
        ..style = PaintingStyle.fill;
      final nodeInnerPaint = Paint()
        ..color = isDark ? AppColors.successDark : AppColors.successLight
        ..style = PaintingStyle.fill;
      canvas.drawCircle(lastPoint, 5.5, nodeInnerPaint);
      canvas.drawCircle(lastPoint, 3.0, nodeOuterPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.dailyBalances != dailyBalances ||
        oldDelegate.isDark != isDark;
  }
}
