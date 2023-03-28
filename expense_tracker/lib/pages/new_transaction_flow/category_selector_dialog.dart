import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<Category?> showCategoryBottomSheet(
    BuildContext context, Category? initialSelection) async {
  return await showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(34.0),
    ),
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 17, right: 17),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Seleziona la categoria',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Icon(Icons.close)
                ],
              ),
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  final categoriesList = categoryProvider.categoryList;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoriesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildCategoryTile(categoriesList[index]);
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCategoryTile(Category category) {
    return ListTile(
      leading: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category.color,
        ),
        child: Icon(
          category.iconData,
          color: Colors.white,
          size: 16,
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
