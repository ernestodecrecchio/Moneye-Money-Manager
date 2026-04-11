import 'package:equatable/equatable.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';

class AccountWithBalance extends Equatable {
  final Account account;
  final double balance;

  const AccountWithBalance({
    required this.account,
    required this.balance,
  });

  AccountWithBalance copyWith({
    Account? account,
    double? balance,
  }) {
    return AccountWithBalance(
      account: account ?? this.account,
      balance: balance ?? this.balance,
    );
  }

  @override
  List<Object?> get props => [account, balance];
}
