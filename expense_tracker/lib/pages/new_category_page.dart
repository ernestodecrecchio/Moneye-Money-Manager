import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
  Color selectedColor = Colors.amber;

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
            Row(
              children: [
                const Text('Colore'),
                Container(
                  height: 40,
                  width: 40,
                  color: selectedColor,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showColorPicker();
                  },
                  child: const Text('Seleziona colore'),
                )
              ],
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: _saveNewCategory, child: const Text('Salva'))
          ],
        ),
      ),
    );
  }

  _showColorPicker() {
    // create some values
    Color pickerColor = const Color(0xff443a49);

    // ValueChanged<Color> callback
    void changeColor(Color color) {
      setState(() => pickerColor = color);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => selectedColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _saveNewCategory() {
    if (title != null) {
      final newCategory =
          Category(name: title!, colorValue: selectedColor.value);
      Provider.of<CategoryProvider>(context, listen: false)
          .addNewCategory(newCategory)
          .then((value) => Navigator.of(context).pop());
    }
  }
}
