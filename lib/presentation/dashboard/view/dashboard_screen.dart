// ignore_for_file: unused_local_variable, dead_null_aware_expression

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/extensions/platform_extension.dart';
import '../../common_widgets/fancy_sliding_card.dart';
import '../../common_widgets/wiggle_widget.dart';
import '../../common_widgets/cosmic_celebration_stars.dart';
import '../../common_widgets/adaptive_refractive_container.dart'; // Tu motor de refracción

// Provider global para controlar el modo edición
final dashboard_edit_mode_provider = StateProvider<bool>((ref) => false);

// Provider para obtener los datos de Supabase
final savings_provider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final supabase = Supabase.instance.client;
  final currentUser = supabase.auth.currentUser;

  if (currentUser == null) return [];

  final response = await supabase
      .from('savings_goals')
      .select('*, goal_transactions(amount, transaction_type)')
      .eq('user_id', currentUser.id)
      .order('goal_id', ascending: true);

  return (response as List<dynamic>).map((goal) {
    double totalSaved = 0.0;
    final transactions = goal['goal_transactions'] as List<dynamic>? ?? [];

    for (var tx in transactions) {
      final amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
      tx['transaction_type'] == 'deposito'
          ? totalSaved += amount
          : totalSaved -= amount;
    }

    final isFreestyle = goal['target_amount'] == null;
    return {
      'id': goal['goal_id'].toString(),
      'name': goal['goal_name'],
      'saved': totalSaved,
      'target': isFreestyle
          ? null
          : double.tryParse(goal['target_amount'].toString()),
      'type': isFreestyle ? 'freestyle' : 'target',
      'frequency_id': goal['frequency_id'],
      'raw_goal': goal,
    };
  }).toList();
});

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _get_piggy_image(double percentage, String type) {
    if (type == 'freestyle') return 'assets/images/relax_piggy.png';
    if (percentage >= 85) return 'assets/images/rich_piggy.png';
    if (percentage >= 40) return 'assets/images/normal_piggy.png';
    return 'assets/images/poor_piggy.png';
  }

  Future<void> _delete_saving_goal(
      Map<String, dynamic> savingData, AppLocalizations l10n) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    final supabase = Supabase.instance.client;
    final String goalId = savingData['id'].toString();
    final String goalName = savingData['name'];

    try {
      await supabase.from('savings_goals').delete().eq('goal_id', goalId);
      ref.invalidate(savings_provider);

      final currentData = ref.read(savings_provider).value ?? [];
      final remainingCount =
          currentData.where((g) => g['id'].toString() != goalId).length;

      if (remainingCount == 0) {
        ref.read(dashboard_edit_mode_provider.notifier).state = false;
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(l10n.deleteSnackbarMessage(goalName)),
        ),
      );
    } catch (error) {
      debugPrint('Error al eliminar meta de ahorro: $error');
    }
  }

  Future<bool?> _show_delete_confirmation(
      BuildContext context, AppLocalizations l10n) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.deleteConfirmTitle ?? '',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content:
            Text(l10n.deleteConfirmContent ?? '', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.deleteConfirmNo ?? '',
                style:
                    GoogleFonts.poppins(color: AppColors.textSecondaryLight)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(l10n.deleteConfirmYes ?? '',
                style: GoogleFonts.poppins(color: AppColors.cardLight)),
          ),
        ],
      ),
    );
  }

  Widget _build_empty_state(
      AppLocalizations l10n, Color textColor, Color subtextColor, Size size) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.savings_outlined,
            size: (size.width * 0.25).clamp(80.0, 120.0),
            color: textColor.withOpacity(0.2),
          ),
          SizedBox(height: size.height * 0.025),
          Text(
            l10n.dashboardEmptyTitle ?? "",
            style: GoogleFonts.poppins(
              fontSize: (size.width * 0.055).clamp(18.0, 24.0),
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Text(
              l10n.dashboardEmptySubtitle ?? "",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: (size.width * 0.035).clamp(12.0, 16.0),
                color: subtextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build_saving_card(
      Map<String, dynamic> saving,
      ThemeData theme,
      AppLocalizations l10n,
      bool isDark,
      Color textColor,
      Color subtextColor,
      bool isEditing,
      Size size) {
    final String goalId = saving['id'].toString();
    final isTarget = saving['type'] == 'target';
    final double currentSaved = saving['saved'];
    final double? targetAmount = saving['target'];
    final double percentage =
        (isTarget && targetAmount != null && targetAmount > 0)
            ? (currentSaved / targetAmount * 100)
            : 0;

    final bool isCompleted = isTarget && percentage >= 100;
    final surfaceColor = theme.colorScheme.surface;
    final innerCardColor = isDark
        ? AppColors.cardLight.withOpacity(0.08)
        : AppColors.textPrimaryLight.withOpacity(0.04);

    void handleNavigation() {
      if (isEditing) return;
      if (isTarget) {
        context.push('/manage_target_saving?from=/dashboard', extra: goalId);
      } else {
        context.push('/manage_freestyle_saving?from=/dashboard', extra: goalId);
      }
    }

    final Widget cardInnerContent = Container(
      padding: EdgeInsets.all(size.width * 0.03),
      decoration: BoxDecoration(
        color: context.isApple
            ? (isDark
                ? Colors.white.withOpacity(0.04)
                : AppColors.cardLight.withOpacity(0.4))
            : (isDark
                ? innerCardColor
                : AppColors.backgroundLight.withOpacity(0.7)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? (context.isApple
                  ? Colors.white.withOpacity(0.05)
                  : Colors.transparent)
              : AppColors.textPrimaryLight.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (isCompleted)
                Positioned(
                  width: (size.width * 0.18).clamp(60.0, 90.0) * 1.6,
                  height: (size.width * 0.18).clamp(60.0, 90.0) * 1.6,
                  child: CosmicCelebrationStars(
                    play: true,
                    size: Size(
                      (size.width * 0.18).clamp(60.0, 90.0) * 1.6,
                      (size.width * 0.18).clamp(60.0, 90.0) * 1.6,
                    ),
                  ),
                ),
              Image.asset(
                _get_piggy_image(percentage, saving['type']),
                width: (size.width * 0.18).clamp(60.0, 90.0),
                height: (size.width * 0.18).clamp(60.0, 90.0),
              ),
            ],
          ),
          SizedBox(width: size.width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  saving['name'],
                  style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.045).clamp(16.0, 20.0),
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '\$${currentSaved.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.035).clamp(12.0, 16.0),
                    color: subtextColor,
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isEditing
                ? size.width * 0.15
                : (isCompleted ? size.width * 0.24 : size.width * 0.15),
            alignment: Alignment.centerRight,
            child: isEditing
                ? IconButton(
                    onPressed: () async {
                      final confirm =
                          await _show_delete_confirmation(context, l10n);
                      if (confirm == true) {
                        _delete_saving_goal(saving, l10n);
                      }
                    },
                    icon: Icon(
                      Icons.remove_circle,
                      color: theme.colorScheme.error,
                      size: (size.width * 0.07).clamp(24.0, 32.0),
                    ),
                  )
                : (isTarget
                    ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                            scale: CurvedAnimation(
                                parent: animation, curve: Curves.elasticOut),
                            child: FadeTransition(
                                opacity: animation, child: child),
                          );
                        },
                        child: isCompleted
                            ? Container(
                                key: const ValueKey('badge_completed'),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.successDark.withOpacity(0.15)
                                      : AppColors.successLight
                                          .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.successDark
                                        : AppColors.successLight,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  l10n.dashboardGoalCompleted,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        (size.width * 0.028).clamp(10.0, 12.0),
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.successDark
                                        : AppColors.successLight,
                                  ),
                                ),
                              )
                            : Text(
                                '${percentage.toStringAsFixed(0)}%',
                                key: const ValueKey('txt_percentage'),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      (size.width * 0.055).clamp(20.0, 26.0),
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ))
                    : const SizedBox.shrink()),
          ),
        ],
      ),
    );

    return WiggleWidget(
      isWiggling: isEditing,
      child: FancySlidingCard(
        key: ValueKey(goalId),
        isSwipeEnabled: isEditing,
        onDelete: () => _delete_saving_goal(saving, l10n),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: theme.colorScheme.error,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.delete_forever,
              color: AppColors.cardLight,
              size: (size.width * 0.07).clamp(24.0, 32.0)),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: context.isApple
                ? (isDark
                    ? AppColors.cardDark.withOpacity(0.15)
                    : AppColors.cardLight.withOpacity(0.35))
                : (isDark ? surfaceColor : AppColors.cardLight),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (!isDark && !context.isApple)
                BoxShadow(
                  color: AppColors.textPrimaryLight.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: context.isApple
              ? GestureDetector(
                  onTap: handleNavigation, child: cardInnerContent)
              : InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: handleNavigation,
                  child: cardInnerContent,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final surfaceColor = theme.colorScheme.surface;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final widgetColor = isDark ? AppColors.cardDark : AppColors.primaryLight;

    final savingsAsync = ref.watch(savings_provider);
    final isEditing = ref.watch(dashboard_edit_mode_provider);

    bool hasSavings = savingsAsync.maybeWhen(
      data: (data) => data.isNotEmpty,
      orElse: () => false,
    );

    final Widget mainListContainer = savingsAsync.when(
      data: (visibleData) {
        if (visibleData.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(savings_provider),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child:
                        _build_empty_state(l10n, textColor, subtextColor, size),
                  ),
                );
              },
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(savings_provider),
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: size.height * 0.02),
            itemCount: visibleData.length,
            separatorBuilder: (_, __) => SizedBox(height: size.height * 0.015),
            itemBuilder: (_, i) => _build_saving_card(visibleData[i], theme,
                l10n, isDark, textColor, subtextColor, isEditing, size),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, __) => Center(child: Text('Error: $e')),
    );

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(theme.brightness),
      body: Stack(
        children: [
          Positioned(
            left: size.width * 0.06,
            top: size.height * 0.098,
            child: Text(l10n.dashboardTitle ?? '',
                style: GoogleFonts.poppins(
                    fontSize: (size.width * 0.075).clamp(28.0, 36.0),
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          ),
          if (hasSavings || isEditing)
            Positioned(
              right: size.width * 0.06,
              top: size.height * 0.09,
              child: SizedBox(
                width: (size.width * 0.13).clamp(45.0, 60.0),
                height: (size.width * 0.13).clamp(45.0, 60.0),
                child: IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ref.read(dashboard_edit_mode_provider.notifier).state =
                        !isEditing;
                  },
                  icon: Icon(isEditing ? Icons.check : Icons.edit,
                      size: (size.width * 0.07).clamp(24.0, 32.0)),
                  style: IconButton.styleFrom(
                    backgroundColor: isEditing
                        ? (isDark
                            ? AppColors.successDark
                            : AppColors.successLight)
                        : (context.isApple
                            ? (isDark
                                ? AppColors.cardDark.withOpacity(0.3)
                                : AppColors.cardLight.withOpacity(0.6))
                            : widgetColor),
                    foregroundColor: context.isApple && !isEditing
                        ? (isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight)
                        : AppColors.cardLight,
                    shape: const CircleBorder(),
                    side: context.isApple && !isEditing
                        ? BorderSide(
                            color: isDark
                                ? AppColors.cardDark.withOpacity(0.2)
                                : AppColors.cardLight.withOpacity(0.7),
                            width: 1.5)
                        : BorderSide.none,
                    elevation: isEditing ? 4 : 0,
                  ),
                ),
              ),
            ),

          // PANEL CENTRAL
          Positioned(
            left: size.width * 0.03,
            right: size.width * 0.03,
            top: size.height * 0.17,
            child: SizedBox(
              height: size.height * 0.71,
              child: context.isApple
                  ? AdaptiveRefractiveContainer(
                      refractionStrength: 0.15,
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.04),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardDark.withOpacity(0.2)
                              : AppColors.cardLight.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: isDark
                                ? AppColors.cardDark.withOpacity(0.12)
                                : AppColors.cardLight.withOpacity(0.6),
                            width: 1.5,
                          ),
                        ),
                        child: mainListContainer,
                      ),
                    )
                  : Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28)),
                      color: surfaceColor,
                      child: Padding(
                        padding: EdgeInsets.all(size.width * 0.04),
                        child: mainListContainer,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
