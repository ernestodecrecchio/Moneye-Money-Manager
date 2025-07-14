import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/home_page/home_page.dart';
import 'package:expense_tracker/pages/options_page/options_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class TabBarPage extends ConsumerStatefulWidget {
  static const routeName = '/TabBarPage';

  const TabBarPage({super.key});

  @override
  ConsumerState<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends ConsumerState<TabBarPage> {
  int index = 0;

  final screen = [
    const HomePage(),
    const OptionsPage(),
  ];

  @override
  void initState() {
    super.initState();

    ref.read(categoryProvider.notifier).getCategoriesFromDb();
    ref.read(accountProvider.notifier).getAccountsFromDb();
    ref.read(transactionProvider.notifier).getTransactionsFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: index,
          selectedItemColor: CustomColors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (newIndex) {
            setState(() => index = newIndex);
          },
          items: [
            SalomonBottomBarItem(
              icon: SvgPicture.asset('assets/icons/transactions.svg',
                  colorFilter: ColorFilter.mode(
                      index == 0 ? CustomColors.blue : Colors.grey,
                      BlendMode.srcIn)),
              title: const Text(
                'Dashboard',
                style: TextStyle(fontFamily: 'Ubuntu'),
              ),
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.gear_solid),
              title: Text(
                AppLocalizations.of(context)!.settings,
                style: const TextStyle(fontFamily: 'Ubuntu'),
              ),
            ),
          ],
        ),
        body: screen[index]);
  }
}
