import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/pages/categories_page/new_category_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Future<Category?> showCategoryBottomSheet(
    BuildContext context, Category? initialSelection) async {
  return await showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(34.0),
    ),
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
    context: context,
    builder: ((context) {
      return CategorySelectorContent(currentSelection: initialSelection);
    }),
  );
}

class CategorySelectorContent extends StatefulWidget {
  final Category? currentSelection;

  const CategorySelectorContent({
    Key? key,
    this.currentSelection,
  }) : super(key: key);

  @override
  State<CategorySelectorContent> createState() =>
      _CategorySelectorContentState();
}

class _CategorySelectorContentState extends State<CategorySelectorContent> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Seleziona la categoria',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, categoryProvider, child) {
                final categoriesList = categoryProvider.categoryList;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoriesList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == categoriesList.length) {
                        return _buildAddCategoryTile();
                      }
                      return _buildCategoryTile(categoriesList[index]);
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildAddCategoryTile() {
    return ListTile(
      tileColor: Colors.white,
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
      title: const Text(
        'Nuova categoria',
        style: TextStyle(fontSize: 18),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(NewCategoryPage.routeName);
      },
    );
  }

  _buildCategoryTile(Category category) {
    return ListTile(
      tileColor:
          _selectedCategory == category ? CustomColors.lightBlue : Colors.white,
      leading: Container(
        height: 32,
        width: 32,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category.color,
        ),
        child: SvgPicture.asset(
          category.iconPath!,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      trailing: _selectedCategory == category ? const Icon(Icons.check) : null,
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
