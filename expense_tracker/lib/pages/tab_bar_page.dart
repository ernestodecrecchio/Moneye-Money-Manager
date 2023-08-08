import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/home_page/home_page.dart';
import 'package:expense_tracker/pages/options_page/options_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabBarPage extends StatefulWidget {
  static const routeName = '/TabBarPage';

  const TabBarPage({Key? key}) : super(key: key);

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int index = 0;

  final screen = [
    const HomePage(),
    const OptionsPage(),
  ];

  @override
  void initState() {
    super.initState();

    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
    Provider.of<AccountProvider>(context, listen: false).getAllAccounts();
    Provider.of<TransactionProvider>(context, listen: false)
        .getAllTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: index,
          backgroundColor: Colors.white,
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
              title: const Text('Dashboard'),
            ),
            SalomonBottomBarItem(
              icon: const Icon(CupertinoIcons.gear_solid),
              title: Text(AppLocalizations.of(context)!.settings),
            ),
          ],
        ),
        body: screen[index]);
  }
}
