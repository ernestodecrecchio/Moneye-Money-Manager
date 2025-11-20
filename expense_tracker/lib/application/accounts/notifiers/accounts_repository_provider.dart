import 'package:expense_tracker/data/repositories/accounts_repository_impl.dart';
import 'package:expense_tracker/domain/repositories/accounts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountsRepositoryProvider = Provider<AccountsRepository>((ref) {
  return AccountsRepositoryImpl();
});
