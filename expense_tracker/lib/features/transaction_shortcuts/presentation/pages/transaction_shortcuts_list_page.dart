import 'package:collection/collection.dart';
import 'package:expense_tracker/core/presentation/common/widgets/list_empty_state.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/features/transaction_shortcuts/domain/models/transaction_shortcut.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/providers/mutations/transaction_shortcuts_mutation_notifier.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/providers/queries/transaction_shortcuts_list_notifier.dart';
import 'package:expense_tracker/features/transaction_shortcuts/presentation/widgets/shortcut_list_cell.dart';
import 'package:expense_tracker/features/transactions/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionShortcutsListPage extends ConsumerWidget {
  static const routeName = '/transactionShortcutsListPage';

  const TransactionShortcutsListPage({super.key});

  void _openCreateShortcut(BuildContext context) {
    Navigator.of(context).pushNamed(
      NewEditTransactionPage.routeName,
      arguments: NewEditTransactionPageScreenArguments(
        isShortcutMode: true,
      ),
    );
  }

  void _openEditShortcut(BuildContext context, TransactionShortcut shortcut) {
    Navigator.of(context).pushNamed(
      NewEditTransactionPage.routeName,
      arguments: NewEditTransactionPageScreenArguments(
        isShortcutMode: true,
        transactionShortcut: shortcut,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final shortcutsAsync = ref.watch(transactionShortcutsListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.transactionShortcuts),
      ),
      body: SafeArea(
        child: shortcutsAsync.when(
          data: (shortcuts) {
            if (shortcuts.isEmpty) {
              return ListEmptyState(
                icon: Icons.bolt_rounded,
                message: appLocalizations.noTransactionShortcuts,
                actionLabel: appLocalizations.newTransactionShortcut,
                onAction: () => _openCreateShortcut(context),
              );
            }

            return ListView.separated(
              itemCount: shortcuts.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return _ShortcutListCell(
                  shortcut: shortcuts[index],
                  onEdit: () => _openEditShortcut(context, shortcuts[index]),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
        ),
      ),
      floatingActionButton: shortcutsAsync.asData?.value.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () => _openCreateShortcut(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _ShortcutListCell extends ConsumerWidget {
  final TransactionShortcut shortcut;
  final VoidCallback onEdit;

  const _ShortcutListCell({
    required this.shortcut,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    final categories = ref.watch(categoriesListProvider).asData?.value ?? [];
    final category = categories.firstWhereOrNull(
      (element) => element.id == shortcut.categoryId,
    );

    final accounts = ref.watch(accountsListProvider).asData?.value ?? [];
    final account = accounts.firstWhereOrNull(
      (element) => element.id == shortcut.accountId,
    );

    return Slidable(
      key: ValueKey(shortcut.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              ref
                  .read(transactionShortcutsMutationProvider.notifier)
                  .deleteTransactionShortcut(shortcut);
            },
            backgroundColor: CustomColors.swipeActionRed,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: appLocalizations.delete,
          ),
        ],
      ),
      child: ShortcutListCell(
        shortcut: shortcut,
        category: category,
        account: account,
        showChevron: true,
        onTap: onEdit,
      ),
    );
  }
}
