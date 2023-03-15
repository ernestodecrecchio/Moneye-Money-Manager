import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_selector_dialog.dart';
import 'package:expense_tracker/pages/new_transaction_flow/category_selector_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NewTransactionPage extends StatefulWidget {
  static const routeName = '/newTransactionPage';

  const NewTransactionPage({Key? key}) : super(key: key);

  @override
  State<NewTransactionPage> createState() => _NewTransactionPageState();
}

class _NewTransactionPageState extends State<NewTransactionPage> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController valueInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  String? title;
  double? value;
  Category? selectedCategory;
  Account? selectedAccount;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    dateInput.text = selectedDate.toString();
  }

  @override
  void dispose() {
    titleInput.dispose();
    valueInput.dispose();
    dateInput.dispose();

    super.dispose();
  }

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
            ),
            TextFormField(
              controller: dateInput,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              decoration: const InputDecoration(hintText: 'Data'),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'(^[-,+]?\d*\.?\d*)'))
              ],
              onTap: () => _selectDate(context),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        dateInput.text = picked.toString();
        selectedDate = picked;
      });
    }
  }

  _saveNewTransaction() {
    value = double.parse(valueInput.text);

    if (title != null && value != null) {
      Provider.of<TransactionProvider>(context, listen: false)
          .addNewTransaction(
              title: title!,
              value: value!,
              date: DateTime.now(),
              category: selectedCategory,
              account: selectedAccount)
          .then((value) => Navigator.of(context).pop());
    }
  }
}
