import 'package:expense_tracker/application/categories/notifiers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_graphics/vector_graphics.dart';

Future<Category?> showCategoryBottomSheet(
    BuildContext context, Category? initialSelection) async {
  return await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(34),
        topRight: Radius.circular(34),
      ),
    ),
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
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

    return Container(
      color: Colors.white,
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
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
    return ListTile(
      leading: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: CustomColors.darkBlue, width: 2),
        ),
        child: const Icon(
          Icons.add,
          color: CustomColors.darkBlue,
          size: 20,
        ),
      ),
      title: Text(
        appLocalizations.newCategory,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(NewEditCategoryPage.routeName);
      },
    );
  }

  ListTile _buildCategoryTile(Category category) {
    return ListTile(
      leading: Container(
        height: 32,
        width: 32,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category.color,
        ),
        child: category.iconPath != null
            ? VectorGraphic(
                loader: AssetBytesLoader(category.iconPath!),
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              )
            : null,
      ),
      trailing: _selectedCategory == category
          ? VectorGraphic(
              loader: AssetBytesLoader('assets/icons/checkmark.svg'))
          : null,
      title: Text(
        category.name,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: () {
        _selectedCategory = category;

        Navigator.of(context).pop(_selectedCategory);
      },
    );
  }
}
