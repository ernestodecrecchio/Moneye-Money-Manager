import 'package:expense_tracker/core/configuration/constants.dart';
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

class ShortcutListCell extends ConsumerWidget {
  final TransactionShortcut shortcut;
  final Category? category;
  final Account? account;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool showAddAction;

  const ShortcutListCell({
    super.key,
    required this.shortcut,
    this.category,
    this.account,
    this.onTap,
    this.showChevron = false,
    this.showAddAction = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    final categoryLabel = category?.name ?? appLocalizations.none;
    final accountLabel = account?.name ?? appLocalizations.none;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: Constants.horizontalPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconItem(
              backgroundColor:
                  category?.color ?? context.appColors.textSecondary,
              shape: BoxShape.circle,
              iconPath: category?.iconPath,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 2,
                children: [
                  Text(
                    shortcut.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  shortcut.amount.toStringAsFixedRoundedWithCurrency(
                    2,
                    currentCurrency,
                    currentCurrencyPosition,
                  ),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: shortcut.amount >= 0
                        ? context.appColors.income
                        : context.appColors.expense,
                  ),
                ),
                if (showAddAction)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.add_circle_rounded,
                      size: 20,
                      color: context.appColors.primary,
                    ),
                  ),
              ],
            ),
            if (showChevron) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: context.appColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
