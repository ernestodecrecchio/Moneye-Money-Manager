import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/currency.dart';
import 'package:expense_tracker/pages/initial_configuration_page/account_selection/account_selection.dart';
import 'package:expense_tracker/pages/initial_configuration_page/categories_selection.dart';
import 'package:expense_tracker/pages/initial_configuration_page/configuration_complete.dart';
import 'package:expense_tracker/pages/initial_configuration_page/currency_selection.dart';
import 'package:expense_tracker/pages/initial_configuration_page/floating_element.dart';
import 'package:expense_tracker/pages/initial_configuration_page/welcome.dart';
import 'package:expense_tracker/pages/tab_bar_page.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final List<Widget> pages = const [
    Welcome(),
    CurrencySelection(),
    AccountSelectionPage(),
    CategoriesSelection(),
    ConfigurationComplete(),
  ];

  Currency? selectedCurrency;
  List<Account> selectedAccounts = [];
  List<Category> selectedCategory = [];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (currentIndex != pages.length - 1)
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.setBool('needs_configuration', false);

                if (mounted) {
                  Navigator.pushReplacementNamed(context, TabBarPage.routeName);
                }
              },
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // ..._buildFloatingElements(),
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
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.setBool('needs_configuration', false);

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
                      currentIndex == pages.length - 1 ? 'Done' : 'Continue',
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
                  fontSize: 150,
                  color: Colors.white.withOpacity(0.05),
                  fontWeight: FontWeight.w700),
            ),
            coordinateX: -10,
            coordinateY: 0,
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
                  fontSize: 120,
                  color: Colors.white.withOpacity(0.05),
                  fontWeight: FontWeight.w700),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.6,
            coordinateY: MediaQuery.of(context).size.height * 0.8,
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
        ];
      case 2:
        return [
          FloatingElement(
            widget: SizedBox(
              height: 150,
              width: 150,
              child: SvgPicture.asset(
                'assets/icons/cash.svg',
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.05),
                  BlendMode.srcIn,
                ),
              ),
            ),
            coordinateX: -10,
            coordinateY: 0,
          ),
          FloatingElement(
            widget: SizedBox(
              height: 100,
              width: 100,
              child: SvgPicture.asset(
                'assets/icons/picker_icons/visa.svg',
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.05), BlendMode.srcIn),
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.15,
            coordinateY: MediaQuery.of(context).size.height * 0.40,
          ),
          FloatingElement(
            widget: SizedBox(
              height: 150,
              width: 150,
              child: SvgPicture.asset(
                'assets/icons/food.svg',
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.05), BlendMode.srcIn),
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.6,
            coordinateY: MediaQuery.of(context).size.height * 0.8,
          ),
          FloatingElement(
            widget: SizedBox(
              height: 150,
              width: 250,
              child: SvgPicture.asset(
                'assets/icons/food.svg',
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.05), BlendMode.srcIn),
              ),
            ),
            coordinateX: MediaQuery.of(context).size.width * 0.8,
            coordinateY: MediaQuery.of(context).size.height * 0.2,
          ),
        ];
      case 3:
        return [];
      default:
        return [];
    }
  }
}
