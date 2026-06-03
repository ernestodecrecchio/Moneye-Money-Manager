import 'package:expense_tracker/core/presentation/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';
import 'package:expense_tracker/features/categories/presentation/widgets/new_category_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<Category?> showTransferTransactionsBottomSheet({
  required BuildContext context,
  required Category categoryToDelete,
  required int transactionCount,
}) async {
  return await showCustomModalBottomSheet<Category>(
    context: context,
    builder: (context) {
      return TransferTransactionsBottomSheet(
        categoryToDelete: categoryToDelete,
        transactionCount: transactionCount,
      );
    },
  );
}

class TransferTransactionsBottomSheet extends ConsumerStatefulWidget {
  final Category categoryToDelete;
  final int transactionCount;

  const TransferTransactionsBottomSheet({
    super.key,
    required this.categoryToDelete,
    required this.transactionCount,
  });

  @override
  ConsumerState<TransferTransactionsBottomSheet> createState() =>
      _TransferTransactionsBottomSheetState();
}

class _TransferTransactionsBottomSheetState
    extends ConsumerState<TransferTransactionsBottomSheet> {
  Category? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        spacing: 6,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLocalizations.selectTargetCategory,
                      style: textTheme.titleMedium?.copyWith(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),
                Text(
                  appLocalizations
                      .transferTransactionsMessage(widget.transactionCount),
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          // Category list
          Expanded(
            child: ref.watch(categoriesListProvider).when(
                  data: (categoriesList) {
                    final filteredList = categoriesList
                        .where((c) => c.id != widget.categoryToDelete.id)
                        .toList();

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Text(appLocalizations.noCategories),
                      );
                    }

                    return ListView.builder(
                      padding: modalSheetScrollPadding(context),
                      shrinkWrap: true,
                      itemCount: filteredList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == filteredList.length) {
                          return const NewCategoryTile();
                        }
                        return _buildCategoryTile(filteredList[index]);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      const Center(child: Text('Error loading categories')),
                ),
          ),
        ],
      ),
    );
  }

  ListTile _buildCategoryTile(Category category) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return ListTile(
      leading: IconItem(
        backgroundColor: category.color,
        shape: BoxShape.circle,
        iconPath: category.iconPath,
      ),
      trailing: _selectedCategory == category
          ? SafeVectorGraphic(
              iconPath: 'assets/icons/checkmark.svg',
              color: colors.primary,
            )
          : null,
      title: Text(
        category.name,
        style: textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
        Navigator.of(context).pop(category);
      },
    );
  }
}
