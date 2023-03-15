import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewAccountPage extends StatefulWidget {
  static const routeName = '/newAccountPage';

  const NewAccountPage({Key? key}) : super(key: key);

  @override
  State<NewAccountPage> createState() => _NewAccountPageState();
}

class _NewAccountPageState extends State<NewAccountPage> {
  TextEditingController titleInput = TextEditingController();
  TextEditingController descriptionInput = TextEditingController();

  String? title;
  String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuovo conto')),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextFormField(
              controller: titleInput,
              decoration: const InputDecoration(hintText: 'Nome'),
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
                onPressed: _saveNewAccount, child: const Text('Salva'))
          ],
        ),
      ),
    );
  }

  _saveNewAccount() {
    if (title != null) {
      final newAccount = Account(
        name: title!,
      );
      Provider.of<AccountProvider>(context, listen: false)
          .addNewAccount(newAccount: newAccount)
          .then((value) => Navigator.of(context).pop());
    }
  }
}
