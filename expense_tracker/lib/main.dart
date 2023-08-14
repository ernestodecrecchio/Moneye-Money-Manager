import 'dart:async';
import 'dart:io';
import 'package:expense_tracker/Configuration/notification_manager.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart' as c;
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/central_provider.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/notifiers/locale_provider.dart';
import 'package:expense_tracker/notifiers/notification_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/pages/initial_configuration_page/initial_configuration_page.dart';
import 'package:expense_tracker/pages/options_page/about_page/about_page.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/pages/options_page/categories_page/categories_list_page.dart';
import 'package:expense_tracker/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/pages/common/helper/dismiss_keyboard.dart';
import 'package:expense_tracker/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/pages/options_page/currency_page/currency_page.dart';
import 'package:expense_tracker/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/pages/options_page/notification_page/notification_page.dart';
import 'package:expense_tracker/pages/tab_bar_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:provider/provider.dart' as p;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';
import 'pages/account_detail_page/transaction_list_page.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.red,
    ),
  );

  await _configureLocalTimeZone();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final container = r.ProviderContainer();

  // SETTING UP LOCALE
  final localeString = prefs.getString('locale');

  if (localeString != null) {
    final localeProviderNotifier = container.read(localeProvider.notifier);

    localeProviderNotifier.setFromLocalStorage(localeString);
  }

  // SETTING UP CURRENCY SYMBOL

  final currencySymbolString = prefs.getString('selected_currency');

  if (currencySymbolString != null) {
    final currentCurrencyProviderNotifier =
        container.read(currentCurrencyProvider.notifier);

    currentCurrencyProviderNotifier.setFromLocalStorage(currencySymbolString);
  }

  // SETTING UP CURRENCY SYMBOL POSITION

  final currencySymbolPositionString =
      prefs.getString('selected_currency_position');

  if (currencySymbolPositionString != null) {
    final currentCurrencyPositionProviderNotifier =
        container.read(currentCurrencySymbolPositionProvider.notifier);

    currentCurrencyPositionProviderNotifier
        .setFromLocalStorage(currencySymbolPositionString);
  }

  // SETTING UP NOTIFICATIONS
  final notificationEnabledLocalStorageValue =
      prefs.getBool('notifications_enabled');

  if (notificationEnabledLocalStorageValue != null) {
    final notificiationProviderNotifier =
        container.read(notificationsEnabledProvider.notifier);

    notificiationProviderNotifier
        .setFromLocalStorage(notificationEnabledLocalStorageValue);
  }

  final notificationTimeEnablednLocalStorageValue =
      prefs.getString('notification_time');

  if (notificationTimeEnablednLocalStorageValue != null) {
    final notificiationTrimeProviderNotifier =
        container.read(notificationTimeProvider.notifier);

    notificiationTrimeProviderNotifier
        .setFromLocalStorage(notificationTimeEnablednLocalStorageValue);
  }

  await NotificationManager.initNotificationManager();

  // SETTING UP NEEDS CONFIGURATION

  runApp(
    r.UncontrolledProviderScope(
      container: container,
      child: MyApp(
        needsConfiguration: prefs.getBool('needs_configuration') ?? true,
      ),
    ),
  );
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  setLocalLocation(getLocation(timeZoneName));
}

class MyApp extends r.ConsumerWidget {
  final bool needsConfiguration;

  const MyApp({
    Key? key,
    required this.needsConfiguration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, r.WidgetRef ref) {
    return r.ProviderScope(
      child: p.MultiProvider(
        providers: [
          p.ChangeNotifierProvider(create: (_) => CategoryProvider()),
          p.ChangeNotifierProvider(create: (_) => AccountProvider()),
          p.ChangeNotifierProxyProvider<AccountProvider, TransactionProvider>(
              create: (_) => TransactionProvider(),
              update: (context, accountProvider, transactionProvider) =>
                  transactionProvider!..accountProvider = accountProvider),
          p.ChangeNotifierProxyProvider3<TransactionProvider, AccountProvider,
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
        child: DismissKeyboard(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Moneye',
            theme: ThemeData(
              fontFamily: 'Ubuntu',
              primarySwatch: Colors.blue,
            ),
            locale: ref.watch(localeProvider),
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            initialRoute: '/',
            routes: {
              '/': (context) => needsConfiguration
                  ? const InitialConfigurationPage()
                  : const TabBarPage(),
              TabBarPage.routeName: (context) => const TabBarPage(),
              CategoriesListPage.routeName: (context) =>
                  const CategoriesListPage(),
              AccountsListPage.routeName: (context) => const AccountsListPage(),
              LanguagesListPage.routeName: (context) =>
                  const LanguagesListPage(),
              CurrencyPage.routeName: (context) => const CurrencyPage(),
              ReminderPage.routeName: (context) => const ReminderPage(),
              AboutPage.routeName: (context) => const AboutPage(),
            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case TransactionListPage.routeName:
                  {
                    final args = settings.arguments as List<Transaction>;

                    return MaterialPageRoute(
                      builder: (context) =>
                          TransactionListPage(transactionList: args),
                    );
                  }
                case AccountDetailPage.routeName:
                  {
                    final args = settings.arguments as Account?;

                    return MaterialPageRoute(
                      builder: (context) => AccountDetailPage(
                        account: args,
                      ),
                    );
                  }
                case NewEditTransactionPage.routeName:
                  {
                    final args = settings.arguments
                        as NewEditTransactionPageScreenArguments?;

                    final transaction = args?.transaction;
                    final account = args?.account;

                    return MaterialPageRoute(
                      builder: (context) => NewEditTransactionPage(
                        initialTransactionSettings: transaction,
                        initialAccountSettings: account,
                      ),
                    );
                  }
                case NewAccountPage.routeName:
                  {
                    final args = settings.arguments as Account?;

                    return MaterialPageRoute(
                      builder: (context) => NewAccountPage(
                        initialAccountSettings: args,
                      ),
                    );
                  }
                case NewEditCategoryPage.routeName:
                  {
                    final args = settings.arguments as c.Category?;

                    return MaterialPageRoute(
                      builder: (context) => NewEditCategoryPage(
                        initialCategorySettings: args,
                      ),
                    );
                  }
              }

              assert(false, 'Need to implement ${settings.name}');
              return null;
            },
          ),
        ),
      ),
    );
  }
}
