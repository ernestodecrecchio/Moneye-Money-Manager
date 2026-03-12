import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/currency.dart';
import 'package:expense_tracker/application/accounts/notifiers/mutations/account_mutation_notifier.dart';
import 'package:expense_tracker/application/categories/notifiers/mutations/category_mutation_notifier.dart';
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/presentation/pages/common/custom_elevated_button.dart';
import 'package:expense_tracker/presentation/pages/initial_configuration_page/account_selection/account_selection.dart';
import 'package:expense_tracker/presentation/pages/initial_configuration_page/categories_selection/categories_selection.dart';
import 'package:expense_tracker/presentation/pages/initial_configuration_page/configuration_complete.dart';
import 'package:expense_tracker/presentation/pages/initial_configuration_page/currency_selection.dart';
import 'package:expense_tracker/presentation/pages/initial_configuration_page/floating_element.dart';
import 'package:expense_tracker/presentation/pages/initial_configuration_page/welcome.dart';
import 'package:expense_tracker/presentation/pages/tab_bar_page.dart';
import 'package:expense_tracker/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_graphics/vector_graphics.dart';

class InitialConfigurationPage extends ConsumerStatefulWidget {
  static const routeName = '/initialConfigurationPage';

  const InitialConfigurationPage({super.key});

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
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      backgroundColor: CustomColors.darkBlue,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          if (currentIndex != pages.length - 1)
            TextButton(
              onPressed: () async {
                await onConfigurationEnd();

                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, TabBarPage.routeName);
                }
              },
              child: Text(
                appLocalizations.skip,
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          ..._buildFloatingElements(),
          SafeArea(
            minimum: const EdgeInsets.symmetric(vertical: 20),
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
                  margin: const EdgeInsets.only(top: 14),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      if (currentIndex != pages.length - 1) {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut);
                      } else {
                        await onConfigurationEnd();

                        if (context.mounted) {
                          Navigator.pushReplacementNamed(
                              context, TabBarPage.routeName);
                        }
                      }
                    },
                    isLoading: false,
                    text: currentIndex == pages.length - 1
                        ? appLocalizations.done
                        : appLocalizations.continueCTA,
                    mode: CustomElevatedButtonMode.light,
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
        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
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
                  color: Colors.white.withValues(alpha: 0.05),
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
                  color: Colors.white.withValues(alpha: 0.05),
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
                  color: Colors.white.withValues(alpha: 0.05),
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
                  color: Colors.white.withValues(alpha: 0.05),
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
                  color: Colors.white.withValues(alpha: 0.05),
                  fontWeight: FontWeight.w700),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0,
            coordinateY: MediaQuery.of(context).size.height * 0.75,
          ),
        ];
      case 2:
        return [
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/cash.svg'),
              height: 170,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: -10,
            coordinateY: 0,
          ),
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/credit_card.svg'),
              height: 150,
              colorFilter: ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.05), BlendMode.srcIn),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.8,
            coordinateY: MediaQuery.of(context).size.height * 0.2,
          ),
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/savings.svg'),
              height: 100,
              colorFilter: ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.05), BlendMode.srcIn),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.14,
            coordinateY: MediaQuery.of(context).size.height * 0.40,
          ),
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/savings.svg'),
              height: 200,
              colorFilter: ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.05), BlendMode.srcIn),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.7,
            coordinateY: MediaQuery.of(context).size.height * 0.6,
          ),
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/wallet.svg'),
              height: 180,
              colorFilter: ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.05), BlendMode.srcIn),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0,
            coordinateY: MediaQuery.of(context).size.height * 0.75,
          ),
        ];
      case 3:
        return [
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/food.svg'),
              height: 170,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: -10,
            coordinateY: 0,
          ),
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/popcorn.svg'),
              height: 150,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.8,
            coordinateY: MediaQuery.of(context).size.height * 0.2,
          ),
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/bill.svg'),
              height: 100,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.15,
            coordinateY: MediaQuery.of(context).size.height * 0.40,
          ),
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/bus.svg'),
              height: 200,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.05),
                BlendMode.srcIn,
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.7,
            coordinateY: MediaQuery.of(context).size.height * 0.6,
          ),
          FloatingElement(
            widget: VectorGraphic(
              loader: AssetBytesLoader('assets/icons/paw.svg'),
              height: 180,
              colorFilter: ColorFilter.mode(
                Colors.white.withValues(alpha: 0.05),
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

  Future onConfigurationEnd() async {
    final currencyNotifier = ref.read(currentCurrencyProvider.notifier);
    final accountNotifier = ref.read(accountMutationProvider.notifier);
    final categoryNotifier = ref.read(categoryMutationProvider.notifier);

    if (selectedCurrency != null) {
      currencyNotifier.updateCurrency(selectedCurrency!);
    }

    for (var account in selectedAccounts) {
      await accountNotifier.addAccount(account);
    }

    for (var category in selectedCategory) {
      await categoryNotifier.addCategory(category);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool('needs_configuration', false);
  }
}
