import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/utils/double_helper.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const double kShortcutHomeTileWidth = 152.0;
const double kShortcutHomeTileHeight = 130.0;

class ShortcutHomeTile extends ConsumerWidget {
  final TransactionShortcut shortcut;
  final Category? category;
  final Account? account;
  final VoidCallback? onTap;

  const ShortcutHomeTile({
    super.key,
    required this.shortcut,
    this.category,
    this.account,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    final categoryLabel = category?.name ?? appLocalizations.none;
    final accountLabel = account?.name ?? appLocalizations.none;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: kShortcutHomeTileWidth,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: context.appColors.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 8,
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
                  backgroundColor:
                      category?.color ?? context.appColors.textSecondary,
                  shape: BoxShape.circle,
                  iconPath: category?.iconPath,
                  size: 28,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    shortcut.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: context.appColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.add_circle_rounded,
                  size: 20,
                  color: context.appColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              categoryLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: context.appColors.textSecondary,
              ),
            ),
            Text(
              accountLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: context.appColors.textSecondary,
              ),
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                shortcut.amount.toStringAsFixedRoundedWithCurrency(
                  2,
                  currentCurrency,
                  currentCurrencyPosition,
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: shortcut.amount >= 0
                      ? context.appColors.income
                      : context.appColors.expense,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
