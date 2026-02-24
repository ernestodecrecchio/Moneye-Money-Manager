import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/configuration/notification_manager.dart';
import 'package:expense_tracker/configuration/analytics_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/category.dart' as c;
import 'package:expense_tracker/application/common/notifiers/currency_provider.dart';
import 'package:expense_tracker/application/common/notifiers/locale_provider.dart';
import 'package:expense_tracker/application/common/notifiers/notification_provider.dart';
import 'package:expense_tracker/presentation/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/presentation/pages/initial_configuration_page/initial_configuration_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/about_page/about_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/accounts_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/categories_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/categories_page/new_edit_category_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/accounts_page/new_edit_account_page.dart';
import 'package:expense_tracker/presentation/pages/common/helper/dismiss_keyboard.dart';
import 'package:expense_tracker/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/currency_page/currency_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/notification_page/notification_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/privacy_page/privacy_settings_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/contacts_page/contacts_page.dart';
import 'package:expense_tracker/presentation/pages/tab_bar_page.dart';
import 'package:expense_tracker/application/common/notifiers/analytics_consent_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/pages/account_detail_page/transaction_list_for_category_page.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:expense_tracker/presentation/pages/options_page/update_history_page/update_history_page.dart';
import 'package:expense_tracker/presentation/pages/options_page/update_history_page/update_info_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // Explicitly enable Crashlytics for app stability diagnostics
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await _configureLocalTimeZone();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final container = r.ProviderContainer();

  // SETTING UP LOCALE
  final localeString = prefs.getString('locale');
  final localeProviderNotifier = container.read(localeProvider.notifier);
  localeProviderNotifier.setFromLocalStorage(localeString);

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

  // VERSION CHECK
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;
  final lastSeenVersion = prefs.getString('last_seen_version');

  bool versionHasEntry = false;
  try {
    final jsonString =
        await rootBundle.loadString('lib/configuration/update-history.json');
    final Map<String, dynamic> data = jsonDecode(jsonString);
    versionHasEntry = data.containsKey(currentVersion);
  } catch (e) {
    // If there's an error loading or parsing the JSON, we assume no entry exists
    versionHasEntry = false;
  }

  final showWhatsNew = lastSeenVersion != currentVersion &&
      lastSeenVersion != null &&
      versionHasEntry;

  // First startup
  if (lastSeenVersion == null) {
    await prefs.setString('last_seen_version', currentVersion);
  }

  // SETTING UP ANALYTICS CONSENT
  final analyticsConsentValue =
      prefs.getBool(AnalyticsConsentNotifier.consentKey);
  final analyticsConsentNotifier =
      container.read(analyticsConsentProvider.notifier);
  analyticsConsentNotifier.setFromLocalStorage(analyticsConsentValue);

  // SETTING UP NEEDS CONFIGURATION
  runApp(
    r.UncontrolledProviderScope(
      container: container,
      child: MyApp(
        needsConfiguration: prefs.getBool('needs_configuration') ?? true,
        showWhatsNew: showWhatsNew,
      ),
    ),
  );
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }

  initializeTimeZones();

  // Needed to correctly initialize local notifications management
  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  setLocalLocation(getLocation(timezoneInfo.identifier));
}

class MyApp extends r.ConsumerWidget {
  final bool needsConfiguration;
  final bool showWhatsNew;

  const MyApp({
    super.key,
    required this.needsConfiguration,
    required this.showWhatsNew,
  });

  @override
  Widget build(BuildContext context, r.WidgetRef ref) {
    return DismissKeyboard(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Moneye',
        navigatorObservers: [AnalyticsManager.observer],
        theme: ThemeData(
          fontFamily: 'Ubuntu',
          scaffoldBackgroundColor: Colors.white,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: CustomColors.blue,
            ),
          ),
          dividerTheme: const DividerThemeData(
            color: CustomColors.clearGrey,
            thickness: 1,
            space: 0,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: CustomColors.blue,
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              fontFamily: 'Ubuntu',
            ),
          ),
          tabBarTheme: const TabBarTheme(
            labelStyle: TextStyle(fontFamily: 'Ubuntu'),
          ).data,
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: CustomColors.darkBlue,
            foregroundColor: Colors.white,
          ),
        ),
        locale: ref.watch(localeProvider),
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        initialRoute: showWhatsNew
            ? UpdateInfoPage.routeName
            : (needsConfiguration ? '/' : TabBarPage.routeName),
        routes: {
          '/': (context) => needsConfiguration
              ? const InitialConfigurationPage()
              : const TabBarPage(),
          TabBarPage.routeName: (context) => const TabBarPage(),
          CategoriesListPage.routeName: (context) => const CategoriesListPage(),
          AccountsListPage.routeName: (context) => const AccountsListPage(),
          LanguagesListPage.routeName: (context) => const LanguagesListPage(),
          CurrencyPage.routeName: (context) => const CurrencyPage(),
          ReminderPage.routeName: (context) => const ReminderPage(),
          AboutPage.routeName: (context) => const AboutPage(),
          UpdateInfoPage.routeName: (context) => const UpdateInfoPage(),
          UpdateHistoryPage.routeName: (context) => const UpdateHistoryPage(),
          PrivacySettingsPage.routeName: (context) =>
              const PrivacySettingsPage(),
          ContactsPage.routeName: (context) => const ContactsPage(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case TransactionListForCategoryPage.routeName:
              {
                final args = settings.arguments
                    as TransactionListForCategoryPageArguments;

                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => TransactionListForCategoryPage(
                    category: args.category,
                    params: args.params,
                  ),
                );
              }
            case AccountDetailPage.routeName:
              {
                final args = settings.arguments as Account?;

                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => AccountDetailPage(
                    account: args,
                  ),
                );
              }
            case NewEditTransactionPage.routeName:
              {
                final args = settings.arguments
                    as NewEditTransactionPageScreenArguments?;

                final incomePreset = args?.incomePreset;
                final transaction = args?.transaction;
                final account = args?.account;

                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => NewEditTransactionPage(
                    incomePreset: incomePreset,
                    initialTransactionSettings: transaction,
                    initialAccountSettings: account,
                  ),
                );
              }
            case NewEditAccountPage.routeName:
              {
                final args = settings.arguments as Account?;

                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => NewEditAccountPage(
                    initialAccountSettings: args,
                  ),
                );
              }
            case NewEditCategoryPage.routeName:
              {
                final args = settings.arguments as c.Category?;

                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => NewEditCategoryPage(
                    initialCategorySettings: args,
                  ),
                );
              }
          }
          assert(false, 'Need to implement ${settings.name}');
          return null;
        },
        navigatorKey: navigatorKey,
      ),
    );
  }
}
