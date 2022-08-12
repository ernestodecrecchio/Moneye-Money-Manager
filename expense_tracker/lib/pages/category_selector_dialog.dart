import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySelectorDialog extends StatefulWidget {
  final List<Category> currentSelection;

  const CategorySelectorDialog({
    Key? key,
    required this.currentSelection,
  }) : super(key: key);

  @override
  State<CategorySelectorDialog> createState() => _CategorySelectorDialogState();
}

class _CategorySelectorDialogState extends State<CategorySelectorDialog> {
  final List<Category> _selectedCategories = [];

  @override
  void initState() {
    _selectedCategories.addAll(widget.currentSelection);
    super.initState();
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
                      value:
                          _selectedCategories.contains(categoriesList[index]),
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedCategories.add(categoriesList[index]);
                          } else {
                            _selectedCategories.remove(categoriesList[index]);
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
                  Navigator.pop(context, _selectedCategories);
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
