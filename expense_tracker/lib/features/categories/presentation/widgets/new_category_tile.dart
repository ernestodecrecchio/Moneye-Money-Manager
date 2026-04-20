import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/new_edit_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewCategoryTile extends ConsumerWidget {
  final Function(Category)? onCategoryCreated;

  const NewCategoryTile({
    super.key,
    this.onCategoryCreated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Container(
        height: Constants.defaultIconItemHeight,
        width: Constants.defaultIconItemWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: colors.secondary, width: 2),
        ),
        child: Icon(
          Icons.add,
          color: colors.secondary,
          size: 20,
        ),
      ),
      title: Text(
        appLocalizations.newCategory,
        style: textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
      onTap: () async {
        final result = await Navigator.of(context).pushNamed(
          NewEditCategoryPage.routeName,
        );

        if (result is Category && onCategoryCreated != null) {
          onCategoryCreated!(result);
        }
      },
    );
  }
}
