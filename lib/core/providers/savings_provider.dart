import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_provider.dart';

// 1. Añadimos .autoDispose para que la caché se limpie al salir de la pantalla
final savingsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  ref.watch(authProvider);

  final supabase = Supabase.instance.client;

  // Obtenemos el ID del usuario que está actualmente logueado
  final currentUser = supabase.auth.currentUser;

  // Si por alguna razón no hay usuario (sesión cerrada), devolvemos lista vacía
  if (currentUser == null) return [];

  // 2. Filtramos la consulta usando el ID del usuario actual
  final response = await supabase
      .from('savings_goals')
      .select('*, goal_transactions(amount, transaction_type)')
      .eq('user_id', currentUser.id) // <-- EL CANDADO DE SEGURIDAD
      .order('goal_id', ascending: true);

  final List<Map<String, dynamic>> formattedData = response.map((goal) {
    double totalSaved = 0.0;
    final transactions = goal['goal_transactions'] as List<dynamic>? ?? [];

    for (var tx in transactions) {
      final amount = double.parse(tx['amount'].toString());
      if (tx['transaction_type'] == 'deposito') {
        totalSaved += amount;
      } else if (tx['transaction_type'] == 'retiro') {
        totalSaved -= amount;
      }
    }

    final isFreestyle = goal['target_amount'] == null;

    return {
      'id': goal['goal_id'].toString(),
      'name': goal['goal_name'],
      'saved': totalSaved,
      'target':
          isFreestyle ? null : double.parse(goal['target_amount'].toString()),
      'type': isFreestyle ? 'freestyle' : 'target',
      'frequency_id': goal['frequency_id'],
      'raw_goal': goal,
    };
  }).toList();

  return formattedData;
});
