import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySelectorDialog extends StatefulWidget {
  final Category? currentSelection;

  const CategorySelectorDialog({
    Key? key,
    this.currentSelection,
  }) : super(key: key);

  @override
  State<CategorySelectorDialog> createState() => _CategorySelectorDialogState();
}

class _CategorySelectorDialogState extends State<CategorySelectorDialog> {
  Category? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _selectedCategory = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 350, minHeight: 200),
      child: Column(
        children: [
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              final categoriesList = categoryProvider.categoryList;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoriesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      value: _selectedCategory == categoriesList[index],
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedCategory = categoriesList[index];
                          } else {
                            _selectedCategory = null;
                          }
                        });
                      },
                      title: Text(categoriesList[index].name),
                    );
                  });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, widget.currentSelection);
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _selectedCategory);
                },
                child: const Text("Done"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
