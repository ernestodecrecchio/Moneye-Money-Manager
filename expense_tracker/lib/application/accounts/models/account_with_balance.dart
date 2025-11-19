import 'package:expense_tracker/domain/models/account.dart';

class AccountWithBalance {
  final Account account;
  final double balance;

  const AccountWithBalance({
    required this.account,
    required this.balance,
  });
}
