import 'package:expense_tracker/data/repositories/transactions_repository.dart';
import 'package:expense_tracker/domain/repositories/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepositoryImpl();
});
