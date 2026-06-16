import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/widgets/shortcut_quick_add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double kShortcutHomeTileWidth = 108.0;
const double kShortcutHomeTileHeight = 84.0;

class ShortcutQuickAddParams {
  final double amount;
  final int? accountId;

  const ShortcutQuickAddParams({
    required this.amount,
    this.accountId,
  });
}

class ShortcutHomeTile extends ConsumerStatefulWidget {
  final TransactionShortcut shortcut;
  final Category? category;
  final Account? account;
  final bool enabled;
  final Future<void> Function(ShortcutQuickAddParams params) onAdd;

  const ShortcutHomeTile({
    super.key,
    required this.shortcut,
    this.category,
    this.account,
    this.enabled = true,
    required this.onAdd,
  });

  @override
  ConsumerState<ShortcutHomeTile> createState() => _ShortcutHomeTileState();
}

class _ShortcutHomeTileState extends ConsumerState<ShortcutHomeTile>
    with SingleTickerProviderStateMixin {
  static const _pressedScale = 0.92;

  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
      reverseDuration: const Duration(milliseconds: 160),
    );
    _scaleAnimation = Tween<double>(begin: 1, end: _pressedScale).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _quickAdd() async {
    if (!widget.enabled) return;
    await widget.onAdd(
      ShortcutQuickAddParams(
        amount: widget.shortcut.amount,
        accountId: widget.shortcut.accountId,
      ),
    );
  }

  Future<void> _openAdjustDialog() async {
    if (!widget.enabled) return;

    HapticFeedback.mediumImpact();
    await _scaleController.reverse();

    if (!mounted) return;

    final result = await showShortcutQuickAddDialog(
      context: context,
      shortcut: widget.shortcut,
      initialAccount: widget.account,
      category: widget.category,
    );

    if (result == null || !mounted) return;

    await widget.onAdd(
      ShortcutQuickAddParams(
        amount: result.amount,
        accountId: result.accountId,
      ),
    );
  }

  void _onLongPressDown() {
    if (!widget.enabled) return;
    _scaleController.forward();
  }

  void _onLongPressCancel() {
    if (_scaleController.status != AnimationStatus.dismissed) {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    return GestureDetector(
      onTap: _quickAdd,
      onLongPressDown: (_) => _onLongPressDown(),
      onLongPressCancel: _onLongPressCancel,
      onLongPress: _openAdjustDialog,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: kShortcutHomeTileWidth,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
          decoration: BoxDecoration(
            color: context.appColors.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 6,
                spreadRadius: 0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconItem(
                    backgroundColor: widget.category?.color ??
                        context.appColors.textSecondary,
                    shape: BoxShape.circle,
                    iconPath: widget.category?.iconPath,
                    size: 22,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      widget.shortcut.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.add_circle_rounded,
                    size: 16,
                    color: context.appColors.primary,
                  ),
                ],
              ),
              const Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.shortcut.amount.toStringAsFixedRoundedWithCurrency(
                    2,
                    currentCurrency,
                    currentCurrencyPosition,
                  ),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: widget.shortcut.amount >= 0
                        ? context.appColors.income
                        : context.appColors.expense,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
