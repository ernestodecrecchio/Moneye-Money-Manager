import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/category_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewTransactionPage extends StatefulWidget {
  const NewTransactionPage({Key? key}) : super(key: key);

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController valueInput = TextEditingController();

  String? title;
  double? value;
  List<Category> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova spesa')),
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
              controller: valueInput,
              decoration: const InputDecoration(hintText: 'Valore'),
              onChanged: (newValue) {
                value = double.parse(newValue);
              },
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: ((context) {
                    return Dialog(
                      child: CategorySelectorDialog(
                          currentSelection: selectedCategories),
                    );
                  }),
                );
              },
              child: const Text('ciao'),
            ),
            Wrap(
              children: [
                ...selectedCategories.map((e) => Text(e.name)).toList()
              ],
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: _saveNewTransaction, child: const Text('Salva'))
          ],
        ),
      ),
    );
  }

  _saveNewTransaction() {
    if (title != null && value != null) {
      final newTransaction =
          Transaction(title: title!, value: value!, date: DateTime.now());
      Provider.of<TransactionProvider>(context, listen: false)
          .addNewTransaction(newTransaction)
          .then((value) => Navigator.of(context).pop());
    }
  }
}
