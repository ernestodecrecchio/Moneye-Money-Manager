import 'package:collection/collection.dart';
import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/pages/transaction_shortcuts_list_page.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/providers/queries/transaction_shortcuts_list_notifier.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/widgets/shortcut_home_tile.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/mutations/transaction_mutation_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeShortcutsSection extends ConsumerWidget {
  const HomeShortcutsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final shortcutsAsync = ref.watch(transactionShortcutsListProvider);

    return shortcutsAsync.when(
      data: (shortcuts) {
        if (shortcuts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Constants.horizontalPadding,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Text(
                    appLocalizations.shortcuts,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      TransactionShortcutsListPage.routeName,
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: [
                        Text(
                          appLocalizations.viewAll,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: kShortcutHomeTileHeight,
              child: ListView.separated(
                clipBehavior: Clip.none,
                padding: EdgeInsets.symmetric(
                  horizontal: Constants.horizontalPadding,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: shortcuts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  return _HomeShortcutTileWrapper(shortcut: shortcuts[index]);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }
}

class _HomeShortcutTileWrapper extends ConsumerWidget {
  final TransactionShortcut shortcut;

  const _HomeShortcutTileWrapper({required this.shortcut});

  Future<void> _addTransaction(BuildContext context, WidgetRef ref) async {
    final appLocalizations = ref.read(appLocalizationsProvider);
    final isLoading = ref.read(transactionMutationProvider).isLoading;

    if (isLoading) return;

    await ref
        .read(transactionMutationProvider.notifier)
        .addTransaction(shortcut.toTransaction());

    if (context.mounted) {
      CustomSnackBar.show(
        context,
        message: appLocalizations.shortcutTransactionAdded,
        type: SnackBarType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(transactionMutationProvider).isLoading;

    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];
    final category = categories.firstWhereOrNull(
      (element) => element.id == shortcut.categoryId,
    );

    final accounts = ref.watch(accountsListProvider).asData?.value ?? [];
    final account = accounts.firstWhereOrNull(
      (element) => element.id == shortcut.accountId,
    );

    return ShortcutHomeTile(
      shortcut: shortcut,
      category: category,
      account: account,
      onTap: isLoading ? null : () => _addTransaction(context, ref),
    );
  }
}
