import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_scope.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_text_field.dart';
import 'package:expense_tracker/core/presentation/common/custom_elevated_button.dart';
import 'package:expense_tracker/core/presentation/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/mutations/account_mutation_notifier.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/total_balance_notifier.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<bool?> showAccountRebalanceSheet(
  BuildContext context,
  Account account,
) {
  return showCustomModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => AccountRebalanceSheet(account: account),
  );
}

class AccountRebalanceSheet extends ConsumerStatefulWidget {
  final Account account;

  const AccountRebalanceSheet({super.key, required this.account});

  @override
  ConsumerState<AccountRebalanceSheet> createState() =>
      _AccountRebalanceSheetState();
}

class _AccountRebalanceSheetState extends ConsumerState<AccountRebalanceSheet> {
  final _realBalanceController = TextEditingController();
  final _realBalanceFieldKey = const ValueKey('account_rebalance_real_balance');
  double? _previewDifference;
  double? _cachedCurrentBalance;

  TotalBalanceParams get _balanceParams =>
      TotalBalanceParams(account: widget.account);

  @override
  void dispose() {
    _realBalanceController.dispose();
    super.dispose();
  }

  void _updatePreviewDifference(double? currentBalance) {
    final realBalance = double.tryParse(_realBalanceController.text);
    setState(() {
      if (currentBalance == null || realBalance == null) {
        _previewDifference = null;
      } else {
        _previewDifference = realBalance - currentBalance;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);
    final isLoading = ref.watch(accountMutationProvider).isLoading;
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final referenceAccount = ref.watch(accountsListProvider).maybeWhen(
          data: (accounts) =>
              accounts.firstWhereOrNull((a) => a.id == widget.account.id),
          orElse: () => widget.account,
        );

    final balanceAsync = ref.watch(totalBalanceProvider(_balanceParams));
    ref.listen(totalBalanceProvider(_balanceParams), (_, next) {
      next.whenData((balance) {
        if (_cachedCurrentBalance != balance) {
          setState(() => _cachedCurrentBalance = balance);
        }
      });
    });
    final currentBalance = balanceAsync.maybeWhen(
      data: (balance) => balance,
      orElse: () => _cachedCurrentBalance,
    );
    final effectiveBalance = currentBalance ?? _cachedCurrentBalance;

    return AmountKeyboardScope(
      doneLabel: appLocalizations.done,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              Constants.horizontalPadding,
              0,
              Constants.horizontalPadding,
              modalSheetBottomSpacing(context),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        appLocalizations.correctBalance,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (effectiveBalance != null)
                  _buildBalanceRow(
                    label: appLocalizations.currentCalculatedBalance,
                    value: effectiveBalance.toStringAsFixedRoundedWithCurrency(
                      2,
                      currentCurrency,
                      currentCurrencyPosition,
                    ),
                    textTheme: textTheme,
                    colors: colors,
                  )
                else
                  balanceAsync.when(
                    data: (balance) => _buildBalanceRow(
                      label: appLocalizations.currentCalculatedBalance,
                      value: balance.toStringAsFixedRoundedWithCurrency(
                        2,
                        currentCurrency,
                        currentCurrencyPosition,
                      ),
                      textTheme: textTheme,
                      colors: colors,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                const SizedBox(height: 14),
                AmountTextField(
                  key: _realBalanceFieldKey,
                  controller: _realBalanceController,
                  label: appLocalizations.realBalance,
                  hintText: appLocalizations.realBalancePlaceholder,
                  onTextChanged: (_) =>
                      _updatePreviewDifference(effectiveBalance),
                ),
                if (effectiveBalance != null) ...[
                  const SizedBox(height: 14),
                  _buildBalanceRow(
                    label: appLocalizations.rebalanceAdjustment,
                    value: _formatDifference(
                      _previewDifference,
                      currentCurrency,
                      currentCurrencyPosition,
                    ),
                    textTheme: textTheme,
                    colors: colors,
                    valueColor: _differenceColor(colors, _previewDifference),
                  ),
                  const SizedBox(height: 24),
                  CustomElevatedButton(
                    text: appLocalizations.save,
                    isLoading: isLoading,
                    onPressed: () => _save(
                      context,
                      referenceAccount ?? widget.account,
                      effectiveBalance,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceRow({
    required String label,
    required String value,
    required TextTheme textTheme,
    required dynamic colors,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  String _formatDifference(
    double? difference,
    dynamic currency,
    dynamic currencyPosition,
  ) {
    if (difference == null) return '—';

    final prefix = difference > 0
        ? '+'
        : difference < 0
            ? ''
            : '';
    return '$prefix${difference.toStringAsFixedRoundedWithCurrency(2, currency, currencyPosition)}';
  }

  Color? _differenceColor(dynamic colors, double? difference) {
    if (difference == null || difference == 0) return null;
    return difference > 0 ? colors.income : colors.expense;
  }

  Future<void> _save(
    BuildContext context,
    Account account,
    double currentBalance,
  ) async {
    final realBalance = double.tryParse(_realBalanceController.text);
    if (realBalance == null) return;

    if (realBalance == currentBalance) {
      if (context.mounted) Navigator.of(context).pop();
      return;
    }

    final success = await ref
        .read(accountMutationProvider.notifier)
        .rebalanceAccount(account, realBalance);

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(ref.read(appLocalizationsProvider).rebalanceSuccess)),
      );
      Navigator.of(context).pop(true);
    }
  }
}
