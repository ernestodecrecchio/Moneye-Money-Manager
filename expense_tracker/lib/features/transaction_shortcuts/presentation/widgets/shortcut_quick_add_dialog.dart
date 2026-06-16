import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/account_ui_extension.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_chrome.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_host.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_keyboard_scope.dart';
import 'package:expense_tracker/core/presentation/common/amount_keyboard/amount_text_field.dart';
import 'package:expense_tracker/core/presentation/common/custom_elevated_button.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/utils/shortcut_amount_utils.dart';
import 'package:expense_tracker/features/transactions/presentation/pages/new_edit_transaction_flow/account_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShortcutQuickAddResult {
  final double amount;
  final int? accountId;

  const ShortcutQuickAddResult({
    required this.amount,
    this.accountId,
  });
}

Future<ShortcutQuickAddResult?> showShortcutQuickAddDialog({
  required BuildContext context,
  required TransactionShortcut shortcut,
  Account? initialAccount,
  Category? category,
}) {
  return showAmountKeyboardOverlayDialog<ShortcutQuickAddResult>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (dialogContext) => ShortcutQuickAddDialog(
      shortcut: shortcut,
      initialAccount: initialAccount,
      category: category,
    ),
  );
}

class ShortcutQuickAddDialog extends ConsumerStatefulWidget {
  final TransactionShortcut shortcut;
  final Account? initialAccount;
  final Category? category;

  const ShortcutQuickAddDialog({
    super.key,
    required this.shortcut,
    this.initialAccount,
    this.category,
  });

  @override
  ConsumerState<ShortcutQuickAddDialog> createState() =>
      _ShortcutQuickAddDialogState();
}

class _ShortcutQuickAddDialogState extends ConsumerState<ShortcutQuickAddDialog> {
  late final TextEditingController _amountController;
  late double _amount;
  late final bool _prefersIncome;
  Account? _selectedAccount;

  @override
  void initState() {
    super.initState();
    _prefersIncome = widget.shortcut.amount >= 0;
    _amount = widget.shortcut.amount;
    _selectedAccount = widget.initialAccount;
    _amountController = TextEditingController(
      text: _controllerTextForAmount(_amount),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  String _controllerTextForAmount(double amount) {
    final fractionDigits =
        shortcutFractionDigitsForStep(shortcutStepForMagnitude(amount.abs()));
    return amount.abs().toStringAsFixedRounded(fractionDigits);
  }

  double _signedMagnitude(double magnitude) {
    final absolute = magnitude.abs();
    if (absolute == 0) return 0;

    if (_amount == 0) {
      return _prefersIncome ? absolute : -absolute;
    }
    return _amount < 0 ? -absolute : absolute;
  }

  void _setAmount(double amount) {
    setState(() {
      _amount = amount;
      _amountController.text = _controllerTextForAmount(_amount);
    });
  }

  void _syncAmountFromController() {
    final raw = _amountController.text.trim();
    if (raw.isEmpty) return;

    final parsed = double.tryParse(raw);
    if (parsed == null) return;

    final signed = _signedMagnitude(parsed);
    if (signed == _amount) return;

    setState(() {
      _amount = signed;
      final text = _controllerTextForAmount(_amount);
      if (_amountController.text != text) {
        _amountController.text = text;
        _amountController.selection = TextSelection.collapsed(
          offset: text.length,
        );
      }
    });
  }

  void _adjustAmount(int direction) {
    HapticFeedback.selectionClick();
    _syncAmountFromController();

    final step = shortcutStepForMagnitude(_amount.abs());

    if (_amount == 0) {
      _setAmount(direction * step);
      return;
    }

    _setAmount(snapShortcutAmount(_amount + direction * step, step));
  }

  Future<void> _pickAccount() async {
    final picked = await showAccountBottomSheet(context, _selectedAccount);
    if (picked == null || !mounted) return;

    HapticFeedback.selectionClick();
    setState(() => _selectedAccount = picked);
  }

  void _confirm() {
    _syncAmountFromController();
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(
      ShortcutQuickAddResult(
        amount: _amount,
        accountId: _selectedAccount?.id ?? widget.shortcut.accountId,
      ),
    );
  }

  Color _amountFieldFillColor(AppColors colors) {
    if (colors.fieldBackground == colors.surface) {
      return colors.scaffoldBackground;
    }
    return colors.fieldBackground;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final category = widget.category;

    return AmountKeyboardScope(
      doneLabel: appLocalizations.done,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        backgroundColor: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
            color: colors.divider.withValues(alpha: 0.35),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: colors.divider.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconItem(
                      backgroundColor:
                          category?.color ?? colors.textSecondary,
                      shape: BoxShape.circle,
                      iconPath: category?.iconPath,
                      size: 40,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          widget.shortcut.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            height: 1.2,
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AmountTextField(
                  controller: _amountController,
                  fillColor: _amountFieldFillColor(colors),
                  textAlign: TextAlign.center,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  textStyle: textTheme.headlineMedium?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.1,
                    color: _amount >= 0 ? colors.income : colors.expense,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  prefix: _amount < 0
                      ? Text('-', style: textTheme.bodyLarge)
                      : null,
                  onDone: () {
                    _syncAmountFromController();
                    FocusScope.of(context).unfocus();
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AmountStepButton(
                      icon: Icons.remove_rounded,
                      enabled: true,
                      onPressed: () => _adjustAmount(-1),
                    ),
                    const SizedBox(width: 28),
                    _AmountStepButton(
                      icon: Icons.add_rounded,
                      enabled: true,
                      onPressed: () => _adjustAmount(1),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _pickAccount,
                    borderRadius: BorderRadius.circular(16),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colors.divider.withValues(alpha: 0.45),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            IconItem(
                              backgroundColor: _selectedAccount?.color ??
                                  colors.textSecondary,
                              shape: BoxShape.rectangle,
                              iconPath: _selectedAccount?.iconPath,
                              size: Constants.defaultIconItemHeight,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appLocalizations.account,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _selectedAccount?.name ??
                                        appLocalizations.none,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: _amountFieldFillColor(colors),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                size: 20,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                AmountKeyboardChrome(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomElevatedButton(
                        text: appLocalizations.confirm,
                        onPressed: () async => _confirm(),
                        isLoading: false,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.textSecondary,
                          minimumSize: const Size.fromHeight(44),
                        ),
                        child: Text(
                          appLocalizations.cancel,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountStepButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  const _AmountStepButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: enabled ? 1 : 0.35,
      child: Material(
        color: colors.surface,
        elevation: enabled ? 1 : 0,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onPressed : null,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              size: 22,
              color: enabled ? colors.textPrimary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
