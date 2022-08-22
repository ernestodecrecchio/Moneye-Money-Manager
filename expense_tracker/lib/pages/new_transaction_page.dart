import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_selector_dialog.dart';
import 'package:expense_tracker/pages/category_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewTransactionPage extends StatefulWidget {
  static const routeName = '/newTransactionPage';

  final DateTime date;
  const NewTransactionPage({Key? key, required this.date}) : super(key: key);

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController valueInput = TextEditingController();

  String? title;
  double? value;
  Category? selectedCategory;
  Account? selectedAccount;

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
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              decoration: const InputDecoration(hintText: 'Valore'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'(^[-,+]?\d*\.?\d*)'))
              ],
              onChanged: (newValue) {
                value = double.parse(newValue);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final Category? newSelectedCategory = await showDialog(
                  context: context,
                  builder: ((context) {
                    return Dialog(
                      child: CategorySelectorDialog(
                          currentSelection: selectedCategory),
                    );
                  }),
                );
                setState(() => selectedCategory = newSelectedCategory);
              },
              child: const Text('Seleziona categoria'),
            ),
            if (selectedCategory != null) Text(selectedCategory!.name),
            ElevatedButton(
              onPressed: () async {
                final Account? newSelectedAccount = await showDialog(
                  context: context,
                  builder: ((context) {
                    return Dialog(
                      child: AccountSelectorDialog(
                          currentSelection: selectedAccount),
                    );
                  }),
                );
                setState(() => selectedAccount = newSelectedAccount);
              },
              child: const Text('Seleziona conto'),
            ),
            if (selectedAccount != null) Text(selectedAccount!.name),
            const Spacer(),
            ElevatedButton(
                onPressed: _saveNewTransaction, child: const Text('Salva')),
          ],
        ),
      ),
    );
  }

  _saveNewTransaction() {
    if (title != null && value != null) {
      Provider.of<TransactionProvider>(context, listen: false)
          .addNewTransaction(
              title: title!,
              value: value!,
              date: widget.date,
              category: selectedCategory,
              account: selectedAccount)
          .then((value) => Navigator.of(context).pop());
    }
  }
}
