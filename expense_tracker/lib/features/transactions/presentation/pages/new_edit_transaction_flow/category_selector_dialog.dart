import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/core/presentation/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/common/widgets/safe_vector_graphic.dart';
import 'package:expense_tracker/features/categories/presentation/widgets/new_category_tile.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/core/presentation/common/extensions/category_extensions.dart';

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
                            return const NewCategoryTile();
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
