import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/central_provider.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/notifiers/locale_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/pages/options_page/about_page/about_page.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/pages/options_page/categories_page/categories_list_page.dart';
import 'package:expense_tracker/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_account_page.dart';
import 'package:expense_tracker/pages/common/helper/dismiss_keyboard.dart';
import 'package:expense_tracker/pages/home_page/all_transaction_list_page.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/new_transaction_page.dart';
import 'package:expense_tracker/pages/options_page/currency_page/currency_page.dart';
import 'package:expense_tracker/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/pages/tab_bar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final localeString = prefs.getString('locale');
  final currencySymbolString = prefs.getString('currency');
  final currencySymbolPositionString =
      prefs.getString('currencySymbolPosition');

  CurrencyEnum? currencySymbol;
  if (currencySymbolString != null) {
    currencySymbol = getCurrencyEnumFromString(currencySymbolString);
  }

  CurrencySymbolPosition? currencySymbolPosition;
  if (currencySymbolPositionString != null) {
    currencySymbolPosition =
        getCurrencySymbolPositionFromString(currencySymbolPositionString);
  }
  runApp(MyApp(
    savedLocale: localeString != null ? Locale(localeString) : null,
    currencyEnum: currencySymbol,
    currencySymbolPosition: currencySymbolPosition,
  ));
}

class MyApp extends StatelessWidget {
  final Locale? savedLocale;
  final CurrencyEnum? currencyEnum;
  final CurrencySymbolPosition? currencySymbolPosition;

  const MyApp({
    Key? key,
    this.savedLocale,
    this.currencyEnum,
    this.currencySymbolPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrencyProvider(
            savedCurrency: currencyEnum,
            savedCurrencySymbolPosition: currencySymbolPosition,
          ),
        ),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProxyProvider<AccountProvider, TransactionProvider>(
            create: (_) => TransactionProvider(),
            update: (context, accountProvider, transactionProvider) =>
                transactionProvider!..accountProvider = accountProvider),
        ChangeNotifierProxyProvider3<TransactionProvider, AccountProvider,
            CategoryProvider, CentralProvider>(
          create: (_) => CentralProvider(),
          update: (
            context,
            transactionProvider,
            accountProvider,
            categoryProvider,
            centralProvider,
          ) =>
              centralProvider!
                ..transactionProvider = transactionProvider
                ..accountProvider = accountProvider
                ..categoryProvider = categoryProvider,
        ),
      ],
      child: ChangeNotifierProvider(
        create: (context) => LocaleProvider(
          savedLocale: savedLocale,
        ),
        builder: (context, child) {
          return DismissKeyboard(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Moneye',
              theme: ThemeData(
                fontFamily: 'Ubuntu',
                primarySwatch: Colors.blue,
              ),
              locale: Provider.of<LocaleProvider>(context).locale,
              supportedLocales: L10n.all,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              initialRoute: '/',
              routes: {
                '/': (context) => const TabBarPage(),
                AllTransactionList.routeName: (context) =>
                    const AllTransactionList(),
                CategoriesListPage.routeName: (context) =>
                    const CategoriesListPage(),
                AccountsListPage.routeName: (context) =>
                    const AccountsListPage(),
                LanguagesListPage.routeName: (context) =>
                    const LanguagesListPage(),
                CurrencyPage.routeName: (context) => const CurrencyPage(),
                AboutPage.routeName: (context) => const AboutPage(),
              },
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case AccountDetailPage.routeName:
                    {
                      final args = settings.arguments as Account;

                      return MaterialPageRoute(
                        builder: (context) {
                          return AccountDetailPage(
                            account: args,
                          );
                        },
                      );
                    }
                  case NewEditTransactionPage.routeName:
                    {
                      final args = settings.arguments as Transaction?;

                      return MaterialPageRoute(
                        builder: (context) {
                          return NewEditTransactionPage(
                            initialTransactionSettings: args,
                          );
                        },
                      );
                    }
                  case NewAccountPage.routeName:
                    {
                      final args = settings.arguments as Account?;

                      return MaterialPageRoute(
                        builder: (context) {
                          return NewAccountPage(
                            initialAccountSettings: args,
                          );
                        },
                      );
                    }
                  case NewEditCategoryPage.routeName:
                    {
                      final args = settings.arguments as Category?;

                      return MaterialPageRoute(
                        builder: (context) {
                          return NewEditCategoryPage(
                            initialCategorySettings: args,
                          );
                        },
                      );
                    }
                }

                assert(false, 'Need to implement ${settings.name}');
                return null;
              },
            ),
          );
        },
      ),
    );
  }
}
