import 'package:expense_tracker/features/categories/presentation/providers/mutations/category_mutation_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/core/presentation/common/dialogs.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/new_edit_category_page.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/transfer_transactions_bottom_sheet.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';

class CategoryListCell extends ConsumerWidget {
  final Category category;

  const CategoryListCell({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Slidable(
      key: Key(category.id.toString()),
      startActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      endActionPane: _buildDeleteActionPane(context, ref, appLocalizations),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(NewEditCategoryPage.routeName, arguments: category),
        title: Text(
          category.name,
          style: const TextStyle(fontSize: 16),
        ),
        leading: _buildCategoryIcon(context, category),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  ActionPane _buildDeleteActionPane(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return ActionPane(
      motion: const ScrollMotion(),
      dismissible: DismissiblePane(
        confirmDismiss: () async {
          return await _handleDeleteCategory(context, ref, appLocalizations);
        },
        onDismissed: () {
          // Handled in _handleDeleteCategory
        },
      ),
      children: [
        SlidableAction(
          backgroundColor: CustomColors.swipeActionRed,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: appLocalizations.delete,
          autoClose: false,
          onPressed: (_) async {
            await _handleDeleteCategory(context, ref, appLocalizations);
          },
        ),
      ],
    );
  }

  Future<bool> _handleDeleteCategory(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations appLocalizations,
  ) async {
    final transactionsRepo = ref.read(transactionsRepositoryProvider);
    final count = await transactionsRepo.getTransactionsCount(
      forCategory: category,
    );

    if (!context.mounted) return false;

    final result = await showDeleteCategoryAlert(
      context: context,
      appLocalizations: appLocalizations,
      transactionCount: count,
    );

    if (!context.mounted) return false;

    switch (result) {
      case CategoryDeletionResult.cancel:
        return false;
      case CategoryDeletionResult.deleteCategoryAndTransactions:
        await ref
            .read(categoryMutationProvider.notifier)
            .deleteCategoryAndTransactions(category);
        return true;
      case CategoryDeletionResult.transferTransactions:
        final targetCategory = await showTransferTransactionsBottomSheet(
          context: context,
          categoryToDelete: category,
          transactionCount: count,
        );

        if (targetCategory != null && context.mounted) {
          final isConfirmed = await showConfirmTransferTransactionsAlert(
            context: context,
            appLocalizations: appLocalizations,
            count: count,
            sourceCategoryName: category.name,
            targetCategoryName: targetCategory.name,
          );

          if (isConfirmed && context.mounted) {
            await ref
                .read(categoryMutationProvider.notifier)
                .reassignTransactionsAndDelete(
                  source: category,
                  target: targetCategory,
                );
            return true;
          }
        }
        return false;
    }
  }

  Widget _buildCategoryIcon(BuildContext context, Category category) {
    return IconItem(
      backgroundColor: category.color,
      shape: BoxShape.circle,
      iconPath: category.iconPath,
    );
  }
}
