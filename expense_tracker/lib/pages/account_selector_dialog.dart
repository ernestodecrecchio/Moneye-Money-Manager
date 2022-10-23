import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSelectorDialog extends StatefulWidget {
  final Account? currentSelection;

  const AccountSelectorDialog({
    Key? key,
    this.currentSelection,
  }) : super(key: key);

  @override
  State<AccountSelectorDialog> createState() => _AccountSelectorDialogState();
}

class _AccountSelectorDialogState extends State<AccountSelectorDialog> {
  Account? _selectedAccount;

  @override
  void initState() {
    super.initState();

    _selectedAccount = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    /*ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 350, minHeight: 200),
      child: Column(
        children: [
          Consumer<AccountProvider>(
            builder: (context, accountProvider, child) {
              final accountsList = accountProvider.accountList;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: accountsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CheckboxListTile(
                      value: _selectedAccount == accountsList[index],
                      onChanged: (bool? selected) {
                        setState(() {
                          if (selected == true) {
                            _selectedAccount = accountsList[index];
                          } else {
                            _selectedAccount = null;
                          }
                        });
                      },
                      title: Text(accountsList[index].name),
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
                  Navigator.pop(context, _selectedAccount);
                },
                child: const Text("Done"),
              )
            ],
          ),
        ],
      ),
    );*/
  }
}
