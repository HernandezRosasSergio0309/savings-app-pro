import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageFreestyleState {
  final Map<String, dynamic> goal;
  final List<Map<String, dynamic>> transactions;
  final double totalSaved;
  final List<StreakDay> streaks;
  final List<double>
      dailyBalances;

  ManageFreestyleState({
    required this.goal,
    required this.transactions,
    required this.totalSaved,
    required this.streaks,
    required this.dailyBalances,
  });
}

class StreakDay {
  final DateTime date;
  final bool isSuccess;
  StreakDay({required this.date, required this.isSuccess});
}

final manageFreestyleProvider = StateNotifierProvider.family<
    ManageFreestyleViewModel, AsyncValue<ManageFreestyleState>, String>(
  (ref, goalId) => ManageFreestyleViewModel(goalId),
);

class ManageFreestyleViewModel
    extends StateNotifier<AsyncValue<ManageFreestyleState>> {
  final String goalId;
  final _supabase = Supabase.instance.client;

  ManageFreestyleViewModel(this.goalId) : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    try {
      final goalResponse = await _supabase
          .from('savings_goals')
          .select('*, frequencies(frequency_name)')
          .eq('goal_id', goalId)
          .single();

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

      processedTx = processedTx.reversed.toList();

      // LÓGICA DE RACHAS
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

      // CONSTRUCCIÓN DE CRONOLOGÍA PARA LA GRÁFICA
      List<double> dailyBalances = [];
      DateTime dayIterator =
          DateTime(startDate.year, startDate.month, startDate.day);
      DateTime todayMidnight = DateTime(now.year, now.month, now.day);

      double runningBalance = 0.0;

      // Añadimos el punto inicial
      dailyBalances.add(0.0);

      while (dayIterator.isBefore(todayMidnight) ||
          dayIterator.isAtSameMomentAs(todayMidnight)) {
        DateTime nextDay = dayIterator.add(const Duration(days: 1));

        // Filtramos las transacciones ocurridas estrictamente en este día iterable
        final daysTransactions = txResponse.where((tx) {
          final txDate = DateTime.parse(tx['transaction_date']).toLocal();
          return (txDate.isAfter(dayIterator) ||
                  txDate.isAtSameMomentAs(dayIterator)) &&
              txDate.isBefore(nextDay);
        });

        // Si hubo movimientos ese día, actualizamos el balance acumulado
        for (var tx in daysTransactions) {
          final amount = double.tryParse(tx['amount'].toString()) ?? 0.0;
          if (tx['transaction_type'] == 'deposito') {
            runningBalance += amount;
          } else {
            runningBalance -= amount;
          }
        }

        dailyBalances.add(runningBalance);
        dayIterator = nextDay;
      }

      state = AsyncValue.data(ManageFreestyleState(
        goal: goalResponse,
        transactions: processedTx,
        totalSaved: currentBalance,
        streaks: streaks.reversed.toList(),
        dailyBalances: dailyBalances, // Entregamos la cronología limpia a la UI
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addTransaction(double amount, String type) async {
    if (type == 'retiro' && state.hasValue) {
      final currentSaved = state.value!.totalSaved;
      if (amount > currentSaved) {
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
