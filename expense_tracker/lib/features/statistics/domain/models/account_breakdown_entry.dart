import 'package:expense_tracker/features/accounts/domain/models/account.dart';

class AccountBreakdownEntry {
  const AccountBreakdownEntry({
    required this.account,
    required this.amount,
    required this.percentage,
  });

  final Account account;
  final double amount;
  final double percentage;
}
