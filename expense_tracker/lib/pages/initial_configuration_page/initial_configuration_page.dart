import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/currency.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/pages/initial_configuration_page/account_selection/account_selection.dart';
import 'package:expense_tracker/pages/initial_configuration_page/categories_selection/categories_selection.dart';
import 'package:expense_tracker/pages/initial_configuration_page/configuration_complete.dart';
import 'package:expense_tracker/pages/initial_configuration_page/currency_selection.dart';
import 'package:expense_tracker/pages/initial_configuration_page/floating_element.dart';
import 'package:expense_tracker/pages/initial_configuration_page/welcome.dart';
import 'package:expense_tracker/pages/tab_bar_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InitialConfigurationPage extends ConsumerStatefulWidget {
  static const routeName = '/initialConfigurationPage';

  const InitialConfigurationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<InitialConfigurationPage> createState() =>
      _InitialConfigurationPageState();
}

class _InitialConfigurationPageState
    extends ConsumerState<InitialConfigurationPage> {
  final double horizontalPadding = 28;

  final PageController pageController = PageController();
  int currentIndex = 0;

  Currency? selectedCurrency;
  List<Account> selectedAccounts = [];
  List<Category> selectedCategory = [];

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      const Welcome(),
      CurrencySelectionPage(
        onCurrencySelected: (newCurrency) {
          selectedCurrency = newCurrency;
        },
      ),
      AccountSelectionPage(
        onSelectedAccountListChanged: (newList) {
          selectedAccounts = newList;
        },
      ),
      CategoriesSelection(
        onSelectedCategoryListChanged: (newList) {
          selectedCategory = newList;
        },
      ),
      const ConfigurationComplete(),
    ];
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkBlue,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (currentIndex != pages.length - 1)
            TextButton(
              onPressed: () async {
                if (mounted) {
                  Navigator.pushReplacementNamed(context, TabBarPage.routeName);
                }
              },
              child: Text(
                AppLocalizations.of(context)!.skip,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          ..._buildFloatingElements(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      currentIndex = index;
                      setState(() {});
                    },
                    children: pages,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ..._buildPageIndicator(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                  ),
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (currentIndex != pages.length - 1) {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut);
                      } else {
                        await onConfigurationEnd();

                        if (mounted) {
                          Navigator.pushReplacementNamed(
                              context, TabBarPage.routeName);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      currentIndex == pages.length - 1
                          ? AppLocalizations.of(context)!.done
                          : AppLocalizations.of(context)!.toContinue,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.darkBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < pages.length; i++) {
      list.add(i == currentIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 4,
      width: isActive ? 20 : 5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10 / 2),
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
      ),
    );
  }

  List<Widget> _buildFloatingElements() {
    switch (currentIndex) {
      case 1:
        return [
          FloatingElement(
            widget: Text(
              '\$',
              style: TextStyle(
                  fontSize: 170,
                  color: Colors.white.withOpacity(0.05),
                  fontWeight: FontWeight.w700),
            ),
            coordinateX: -10,
            coordinateY: 0,
          ),
          FloatingElement(
            widget: Text(
              '£',
              style: TextStyle(
                  fontSize: 150,
                  color: Colors.white.withOpacity(0.05),
                  fontWeight: FontWeight.w700),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.8,
            coordinateY: MediaQuery.of(context).size.height * 0.2,
          ),
          FloatingElement(
            widget: Text(
              '€',
              style: TextStyle(
                  fontSize: 100,
                  color: Colors.white.withOpacity(0.05),
                  fontWeight: FontWeight.w700),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.15,
            coordinateY: MediaQuery.of(context).size.height * 0.40,
          ),
          FloatingElement(
            widget: Text(
              '¥',
              style: TextStyle(
                  fontSize: 200,
                  color: Colors.white.withOpacity(0.05),
                  fontWeight: FontWeight.w700),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.7,
            coordinateY: MediaQuery.of(context).size.height * 0.6,
          ),
          FloatingElement(
            widget: Text(
              '₹',
              style: TextStyle(
                  fontSize: 180,
                  color: Colors.white.withOpacity(0.05),
                  fontWeight: FontWeight.w700),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0,
            coordinateY: MediaQuery.of(context).size.height * 0.75,
          ),
        ];
      case 2:
        return [
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/cash.svg',
              height: 170,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: -10,
            coordinateY: 0,
          ),
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/credit_card.svg',
              height: 150,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.05), BlendMode.srcIn),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.8,
            coordinateY: MediaQuery.of(context).size.height * 0.2,
          ),
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/savings.svg',
              height: 100,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.05), BlendMode.srcIn),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.14,
            coordinateY: MediaQuery.of(context).size.height * 0.40,
          ),
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/savings.svg',
              height: 200,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.05), BlendMode.srcIn),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.7,
            coordinateY: MediaQuery.of(context).size.height * 0.6,
          ),
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/wallet.svg',
              height: 180,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.05), BlendMode.srcIn),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0,
            coordinateY: MediaQuery.of(context).size.height * 0.75,
          ),
        ];
      case 3:
        return [
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/food.svg',
              height: 170,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: -10,
            coordinateY: 0,
          ),
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/popcorn.svg',
              height: 150,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.8,
            coordinateY: MediaQuery.of(context).size.height * 0.2,
          ),
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/bill.svg',
              height: 100,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.15,
            coordinateY: MediaQuery.of(context).size.height * 0.40,
          ),
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/bus.svg',
              height: 200,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.7,
            coordinateY: MediaQuery.of(context).size.height * 0.6,
          ),
          FloatingElement(
            widget: SvgPicture.asset(
              'assets/icons/paw.svg',
              height: 180,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0,
            coordinateY: MediaQuery.of(context).size.height * 0.75,
          ),
        ];
      default:
        return [];
    }
  }

  onConfigurationEnd() async {
    if (selectedCurrency != null) {
      ref
          .read(currentCurrencyProvider.notifier)
          .updateCurrency(selectedCurrency!);
    }

    await Future.forEach(
        selectedAccounts,
        (account) async =>
            await p.Provider.of<AccountProvider>(context, listen: false)
                .addNewAccount(account: account));

    await Future.forEach(
        selectedCategory,
        (category) async =>
            await p.Provider.of<CategoryProvider>(context, listen: false)
                .addNewCategory(category: category));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('needs_configuration', false);
  }
}
