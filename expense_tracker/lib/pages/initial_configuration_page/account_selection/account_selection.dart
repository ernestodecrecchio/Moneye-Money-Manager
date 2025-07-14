import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/pages/initial_configuration_page/account_selection/account_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSelectionPage extends ConsumerStatefulWidget {
  final Function(List<Account>) onSelectedAccountListChanged;

  const AccountSelectionPage({
    super.key,
    required this.onSelectedAccountListChanged,
  });

  @override
  ConsumerState<AccountSelectionPage> createState() => _AccountSelectionState();
}

class _AccountSelectionState extends ConsumerState<AccountSelectionPage> {
  List<Account> accountList = [];
  List<Account> selectedAccountList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    accountList = [
      Account(
        name: AppLocalizations.of(context)!.cash,
        colorValue: 4278214515,
        iconPath: 'assets/icons/cash.svg',
      ),
      Account(
        name: AppLocalizations.of(context)!.creditCard,
        colorValue: 4291454722,
        iconPath: 'assets/icons/credit_card.svg',
      ),
      Account(
        name: AppLocalizations.of(context)!.debitCard,
        colorValue: 4289472825,
        iconPath: 'assets/icons/credit_card.svg',
      ),
      Account(
        name: AppLocalizations.of(context)!.savings,
        colorValue: 4283990359,
        iconPath: 'assets/icons/savings.svg',
      ),
    ];

    selectedAccountList = List.from(accountList);

    widget.onSelectedAccountListChanged(selectedAccountList);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Text(
            AppLocalizations.of(context)!.selectAccountMsg1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            AppLocalizations.of(context)!.selectAccountMsg2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10),
              shrinkWrap: true,
              children: accountList
                  .map(
                    (account) => AccountListTile(
                      account: account,
                      selected: selectedAccountList.contains(account),
                      onTap: (selected) {
                        if (selected) {
                          selectedAccountList.add(account);
                        } else {
                          selectedAccountList.remove(account);
                        }

                        widget
                            .onSelectedAccountListChanged(selectedAccountList);

                        setState(() {});
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
