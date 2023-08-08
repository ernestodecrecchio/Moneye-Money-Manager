import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/pages/initial_configuration_page/account_selection/account_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSelectionPage extends ConsumerStatefulWidget {
  const AccountSelectionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AccountSelectionPage> createState() => _AccountSelectionState();
}

class _AccountSelectionState extends ConsumerState<AccountSelectionPage> {
  List<Account> selectedAccountList = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Choose the accounts you want to monitor',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Cash, credit card, or others\nSelect what you'd like to keep a close eye on.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          ListView(
            padding: const EdgeInsets.only(top: 10),
            shrinkWrap: true,
            children: [
              AccountListTile(
                account: Account(
                  name: 'Cash',
                  id: 0,
                  colorValue: 4278214515,
                  iconPath: 'assets/icons/cash.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedAccountList.add(
                      Account(
                        name: 'Cash',
                        id: 0,
                        colorValue: 4278214515,
                        iconPath: 'assets/icons/cash.svg',
                      ),
                    );
                  } else {
                    selectedAccountList
                        .removeWhere((element) => element.id == 0);
                  }
                },
              ),
              AccountListTile(
                account: Account(
                  name: 'Credit Card',
                  id: 1,
                  colorValue: 4291454722,
                  iconPath: 'assets/icons/credit_card.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedAccountList.add(
                      Account(
                        name: 'Credit Card',
                        id: 1,
                        colorValue: 4291454722,
                        iconPath: 'assets/icons/credit_card.svg',
                      ),
                    );
                  } else {
                    selectedAccountList
                        .removeWhere((element) => element.id == 1);
                  }
                },
              ),
              AccountListTile(
                account: Account(
                  name: 'Debit Card',
                  id: 2,
                  colorValue: 4289472825,
                  iconPath: 'assets/icons/credit_card.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedAccountList.add(
                      Account(
                        name: 'Debit Card',
                        id: 2,
                        colorValue: 4289472825,
                        iconPath: 'assets/icons/credit_card.svg',
                      ),
                    );
                  } else {
                    selectedAccountList
                        .removeWhere((element) => element.id == 2);
                  }
                },
              ),
              AccountListTile(
                account: Account(
                  name: 'Savings',
                  id: 3,
                  colorValue: 4283990359,
                  iconPath: 'assets/icons/savings.svg',
                ),
                onTap: (selected) {
                  if (selected) {
                    selectedAccountList.add(
                      Account(
                        name: 'Savings',
                        id: 3,
                        colorValue: 4283990359,
                        iconPath: 'assets/icons/savings.svg',
                      ),
                    );
                  } else {
                    selectedAccountList
                        .removeWhere((element) => element.id == 3);
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
