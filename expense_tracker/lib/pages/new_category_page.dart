import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCategoryPage extends StatefulWidget {
  const NewCategoryPage({Key? key}) : super(key: key);

  @override
  State<NewCategoryPage> createState() => _NewCategoryPageState();
}

class _NewCategoryPageState extends State<NewCategoryPage> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova categoria')),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextFormField(
              controller: titleInput,
              decoration: const InputDecoration(hintText: 'Titolo'),
              onChanged: (newValue) {
                title = newValue;
              },
            ),
            TextFormField(
              controller: descriptionInput,
              decoration: const InputDecoration(hintText: 'Descrizione'),
              onChanged: (newValue) {
                description = newValue;
              },
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: _saveNewCategory, child: const Text('Salva'))
          ],
        ),
      ),
    );
  }

  _saveNewCategory() {
    if (title != null) {
      final newCategory = Category(name: title!, colorValue: 1);
      Provider.of<CategoryProvider>(context, listen: false)
          .addNewCategory(newCategory)
          .then((value) => Navigator.of(context).pop());
    }
  }
}
