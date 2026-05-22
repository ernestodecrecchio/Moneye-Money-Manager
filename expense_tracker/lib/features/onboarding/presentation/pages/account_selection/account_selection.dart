import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/onboarding/presentation/pages/account_selection/account_list_tile.dart';
import 'package:expense_tracker/core/style/style.dart';
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

    final appLocalizations = ref.read(appLocalizationsProvider);

    accountList = [
      Account(
        name: appLocalizations.cash,
        colorValue: CustomColors.green300.toARGB32(),
        iconPath: 'assets/icons/cash.svg',
      ),
      Account(
        name: appLocalizations.creditCard,
        colorValue: CustomColors.teal500.toARGB32(),
        iconPath: 'assets/icons/credit-card.svg',
      ),
      Account(
        name: appLocalizations.debitCard,
        colorValue: CustomColors.orange300.toARGB32(),
        iconPath: 'assets/icons/credit-card.svg',
      ),
      Account(
        name: appLocalizations.savings,
        colorValue: CustomColors.red300.toARGB32(),
        iconPath: 'assets/icons/savings.svg',
      ),
    ];

    selectedAccountList = List.from(accountList);

    widget.onSelectedAccountListChanged(selectedAccountList);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Text(
            appLocalizations.selectAccountMsg1,
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
            appLocalizations.selectAccountMsg2,
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
