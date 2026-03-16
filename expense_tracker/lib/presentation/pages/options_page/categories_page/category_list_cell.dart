import 'package:expense_tracker/application/categories/notifiers/mutations/category_mutation_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/presentation/pages/common/dialogs.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/icon_item.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:expense_tracker/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
        confirmDismiss: () =>
            showDeleteCategoryAlert(context, appLocalizations),
        closeOnCancel: true,
        onDismissed: () async => await ref
            .read(categoryMutationProvider.notifier)
            .deleteCategory(category),
      ),
      children: [
        _buildDeleteSlidableAction(context, ref, appLocalizations),
      ],
    );
  }

  SlidableAction _buildDeleteSlidableAction(
      BuildContext context, WidgetRef ref, AppLocalizations appLocalizations) {
    return SlidableAction(
      backgroundColor: CustomColors.swipeActionRed,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: appLocalizations.delete,
      onPressed: (_) async {
        final isDeleteConfirmed =
            await showDeleteCategoryAlert(context, appLocalizations);

        if (context.mounted && isDeleteConfirmed) {
          await ref
              .read(categoryMutationProvider.notifier)
              .deleteCategory(category);
        }
      },
    );
  }

  Widget _buildCategoryIcon(BuildContext context, Category category) {
    return IconItem(
      backgroundColor: category.color,
      shape: BoxShape.circle,
      iconPath: category.iconPath,
    );
  }
}
