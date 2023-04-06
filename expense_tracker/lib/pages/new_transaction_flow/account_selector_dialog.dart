import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/pages/accounts_page/new_account_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

Future<Account?> showAccountBottomSheet(
    BuildContext context, Account? initialSelection) async {
  return await showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(34.0),
    ),
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Seleziona il conto',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
            ),
            Expanded(
              child: Consumer<AccountProvider>(
                builder: (context, accountProvider, child) {
                  final accountsList = accountProvider.accountList;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: accountsList.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == accountsList.length) {
                          return _buildAddAccountTile();
                        }
                        return _buildAccountTile(accountsList[index]);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAddAccountTile() {
    return ListTile(
      tileColor: Colors.white,
      leading: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: CustomColors.darkBlue, width: 2),
        ),
        child: const Icon(
          Icons.add,
          color: CustomColors.darkBlue,
          size: 20,
        ),
      ),
      title: const Text(
        'Nuovo conto',
        style: TextStyle(fontSize: 18),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(NewAccountPage.routeName);
      },
    );
  }

  _buildAccountTile(Account account) {
    return ListTile(
      tileColor:
          _selectedAccount == account ? CustomColors.lightBlue : Colors.white,
      leading: Container(
        height: 32,
        width: 32,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: account.color,
        ),
        child: SvgPicture.asset(
          account.iconPath!,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
      trailing: _selectedAccount == account ? const Icon(Icons.check) : null,
      title: Text(
        account.name,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: () {
        if (account == widget.currentSelection) {
          _selectedAccount = null;
        } else {
          _selectedAccount = account;
        }

        Navigator.of(context).pop(_selectedAccount);
      },
    );
  }
}
