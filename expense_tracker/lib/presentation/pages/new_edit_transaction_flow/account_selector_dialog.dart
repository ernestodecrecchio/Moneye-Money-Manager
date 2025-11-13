import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/application/transactions/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_graphics/vector_graphics.dart';

Future<Account?> showAccountBottomSheet(
    BuildContext context, Account? initialSelection) async {
  return await showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(34),
        topRight: Radius.circular(34),
      ),
    ),
    backgroundColor: Colors.white,
    clipBehavior: Clip.antiAlias,
    context: context,
    builder: ((context) {
      return AccountSelectorContent(currentSelection: initialSelection);
    }),
  );
}

class AccountSelectorContent extends ConsumerStatefulWidget {
  final Account? currentSelection;

  const AccountSelectorContent({
    super.key,
    this.currentSelection,
  });

  @override
  ConsumerState<AccountSelectorContent> createState() =>
      _AccountSelectorContentState();
}

class _AccountSelectorContentState
    extends ConsumerState<AccountSelectorContent> {
  late final AppLocalizations appLocalizations;

  Account? _selectedAccount;

  @override
  void initState() {
    super.initState();

    _selectedAccount = widget.currentSelection;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appLocalizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.selectAccount,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final accountsList = ref.watch(accountProvider);
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
    );
  }

  ListTile _buildAddAccountTile() {
    return ListTile(
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
      title: Text(
        appLocalizations.newAccount,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(NewAccountPage.routeName);
      },
    );
  }

  ListTile _buildAccountTile(Account account) {
    return ListTile(
      leading: Container(
        height: 32,
        width: 32,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: account.color,
        ),
        child: account.iconPath != null
            ? VectorGraphic(
                loader: AssetBytesLoader(account.iconPath!),
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              )
            : null,
      ),
      trailing: _selectedAccount == account
          ? VectorGraphic(
              loader: AssetBytesLoader('assets/icons/checkmark.svg'))
          : null,
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
