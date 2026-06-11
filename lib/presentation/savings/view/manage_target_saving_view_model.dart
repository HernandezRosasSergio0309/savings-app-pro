import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Modelo de estado para la pantalla
class ManageTargetState {
  final Map<String, dynamic> goal;
  final List<Map<String, dynamic>> transactions;
  final double totalSaved;
  final double percentage;
  final List<StreakDay> streaks;

  ManageTargetState({
    required this.goal,
    required this.transactions,
    required this.totalSaved,
    required this.percentage,
    required this.streaks,
  });
}

class StreakDay {
  final DateTime date;
  final bool isSuccess;
  StreakDay({required this.date, required this.isSuccess});
}

// Provider que recibe el ID de la meta
final manageTargetProvider = StateNotifierProvider.family<ManageTargetViewModel,
    AsyncValue<ManageTargetState>, String>(
  (ref, goalId) => ManageTargetViewModel(goalId),
);

class ManageTargetViewModel
    extends StateNotifier<AsyncValue<ManageTargetState>> {
  final String goalId;
  final _supabase = Supabase.instance.client;

  ManageTargetViewModel(this.goalId) : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Obtener la meta con su frecuencia
      final goalResponse = await _supabase
          .from('savings_goals')
          .select('*, frequencies(frequency_name)')
          .eq('goal_id', goalId)
          .single();

      // Obtener transacciones
      final txResponse = await _supabase
          .from('goal_transactions')
          .select()
          .eq('goal_id', goalId)
          .order('transaction_date', ascending: true);

      double currentBalance = 0.0;
      List<Map<String, dynamic>> processedTx = [];

      for (var tx in txResponse) {
        final amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
        final isDeposit = tx['transaction_type'] == 'deposito';

        isDeposit ? currentBalance += amount : currentBalance -= amount;

        processedTx.add({
          ...tx,
          'historical_balance': currentBalance,
        });
      }

      // Invertir transacciones para que la más nueva esté arriba
      processedTx = processedTx.reversed.toList();

      // Calcular Porcentaje
      final targetAmount =
          double.tryParse(goalResponse['target_amount'].toString()) ?? 1.0;
      double percentage = (currentBalance / targetAmount) * 100;
      percentage = percentage.clamp(0, 100);

      // Lógica de Rachas
      final startDate = DateTime.parse(goalResponse['start_date']).toLocal();
      final now = DateTime.now();
      List<StreakDay> streaks = [];

      DateTime periodStart = startDate;
      while (periodStart.isBefore(now)) {
        DateTime periodEnd = periodStart.add(const Duration(hours: 24));

        bool hasDeposit = txResponse.any((tx) {
          final txDate = DateTime.parse(tx['transaction_date']).toLocal();
          return tx['transaction_type'] == 'deposito' &&
              txDate.isAfter(periodStart) &&
              txDate.isBefore(periodEnd);
        });

        streaks.add(StreakDay(date: periodStart, isSuccess: hasDeposit));
        periodStart = periodEnd;
      }

      state = AsyncValue.data(ManageTargetState(
        goal: goalResponse,
        transactions: processedTx,
        totalSaved: currentBalance,
        percentage: percentage,
        streaks: streaks.reversed.toList(),
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTransaction(double amount, String type) async {
    // VALIDACIÓN DE NEGOCIO DESDE EL VIEWMODEL
    if (type == 'retiro' && state.hasValue) {
      final currentSaved = state.value!.totalSaved;
      if (amount > currentSaved) {
        // Lanzamos un error de formato específico que la vista sabrá interpretar
        throw const FormatException('insufficient_funds');
      }
    }

    try {
      await _supabase.from('goal_transactions').insert({
        'goal_id': goalId,
        'amount': amount,
        'transaction_type': type,
        'transaction_date': DateTime.now().toIso8601String(),
      });
      await loadData();
    } catch (e) {
      rethrow;
    }
  }
}
