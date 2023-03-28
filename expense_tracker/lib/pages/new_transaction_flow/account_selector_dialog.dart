import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<Account?> showAccountBottomSheet(
    BuildContext context, Account? initialSelection) async {
  return await showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(34.0),
    ),
    context: context,
    builder: ((context) {
      return AccountSelectorContent(currentSelection: initialSelection);
    }),
  );
}

class AccountSelectorContent extends StatefulWidget {
  final Account? currentSelection;

  const AccountSelectorContent({
    Key? key,
    this.currentSelection,
  }) : super(key: key);

  @override
  State<AccountSelectorContent> createState() => _AccountSelectorContentState();
}

class _AccountSelectorContentState extends State<AccountSelectorContent> {
  Account? _selectedAccount;

  @override
  void initState() {
    super.initState();

    _selectedAccount = widget.currentSelection;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
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
                    return _buildAccountTile(accountsList[index]);
                  });
            },
          ),
        ],
      ),
    );
  }

  _buildAccountTile(Account account) {
    return ListTile(
      leading: Container(
        height: 32,
        width: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.red,
        ),
        child: Icon(
          account.iconData,
          color: Colors.white,
          size: 16,
        ),
      ),
      trailing: _selectedAccount == account ? const Icon(Icons.check) : null,
      title: Text(
        account.name,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: () {
        _selectedAccount = account;

        Navigator.of(context).pop(_selectedAccount);
      },
    );
  }
}
