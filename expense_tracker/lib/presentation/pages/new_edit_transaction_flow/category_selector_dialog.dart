import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/configuration/constants.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/presentation/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/icon_item.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<Category?> showCategoryBottomSheet(
    BuildContext context, Category? initialSelection) async {
  return await showCustomModalBottomSheet(
    context: context,
    builder: ((context) {
      return CategorySelectorContent(currentSelection: initialSelection);
    }),
  );
}

class CategorySelectorContent extends ConsumerStatefulWidget {
  final Category? currentSelection;

  const CategorySelectorContent({
    super.key,
    this.currentSelection,
  });

  @override
  ConsumerState<CategorySelectorContent> createState() =>
      _CategorySelectorContentState();
}

class _CategorySelectorContentState
    extends ConsumerState<CategorySelectorContent> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.selectCategory,
                  style: textTheme.titleMedium?.copyWith(fontSize: 18),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          Expanded(
            child: ref.watch(categoriesListProvider).when(
                  data: (categoriesList) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: categoriesList.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == categoriesList.length) {
                            return _buildAddCategoryTile(appLocalizations);
                          }
                          return _buildCategoryTile(categoriesList[index]);
                        });
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

  ListTile _buildAddCategoryTile(AppLocalizations appLocalizations) {
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
      onTap: () {
        Navigator.of(context).pushNamed(NewEditCategoryPage.routeName);
      },
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
        _selectedCategory = category;

        Navigator.of(context).pop(_selectedCategory);
      },
    );
  }
}
