import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/core/configuration/notification_manager.dart';
import 'package:expense_tracker/core/configuration/analytics_manager.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/backup_restore_page/backup_restore_page.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/pages/recurring_rules_page/recurring_rules_list_page.dart';
import 'package:expense_tracker/features/recurring_rules/presentation/pages/recurring_rules_page/recurring_rule_detail_page.dart';
import 'package:expense_tracker/core/services/asset_registry.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart' as c;
import 'package:expense_tracker/features/recurring_rules/domain/models/recurring_rule.dart';
import 'package:expense_tracker/core/presentation/providers/currency_provider.dart';
import 'package:expense_tracker/core/presentation/providers/locale_provider.dart';
import 'package:expense_tracker/core/presentation/providers/notification_provider.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/account_detail_page/account_detail_page.dart';
import 'package:expense_tracker/features/onboarding/presentation/pages/initial_configuration_page.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/accounts_list_page/accounts_list_page.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/categories_list_page.dart';
import 'package:expense_tracker/features/categories/presentation/pages/categories_list_page/new_edit_category_page.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/accounts_list_page/new_edit_account_page.dart';
import 'package:expense_tracker/core/presentation/common/helper/dismiss_keyboard.dart';
import 'package:expense_tracker/features/transactions/presentation/pages/new_edit_transaction_flow/new_edit_transaction_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/currency_page/currency_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/language_page/languages_list_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/notification_page/notification_page.dart';
import 'package:expense_tracker/features/home/presentation/pages/tab_bar_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/privacy_page/privacy_settings_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/theme_page/theme_selection_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/contacts_page/contacts_page.dart';
import 'package:expense_tracker/core/presentation/providers/analytics_consent_provider.dart';
import 'package:expense_tracker/core/presentation/providers/theme_provider.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as r;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expense_tracker/features/accounts/presentation/pages/account_detail_page/transaction_list_for_category_page.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/update_history_page/update_history_page.dart';
import 'package:expense_tracker/features/settings/presentation/pages/options_page/update_history_page/update_info_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/transactions_repository_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AssetRegistry to chache vector graphics (svg)
  await AssetRegistry.instance.init();

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

  // SETTING UP THEME
  final themeModeString = prefs.getString('theme_mode');
  final themeProviderNotifier = container.read(themeProvider.notifier);
  themeProviderNotifier.setFromLocalStorage(themeModeString);

  // Trigger lazy generation of recurring transactions on app startup
  final generatedCount = await container
      .read(transactionsRepositoryProvider)
      .generateRecurringTransactionsUntil(DateTime.now());

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

  if (generatedCount > 0) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Delaying slightly to ensure the context is fully mounted and themed
      Future.delayed(const Duration(milliseconds: 500), () {
        final context = navigatorKey.currentContext;
        if (context != null && context.mounted) {
          CustomSnackBar.show(
            context,
            message: AppLocalizations.of(context)!
                .generatedTransactionsSnackbar(generatedCount),
          );
        }
      });
    });
  }
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
        theme: ref.watch(themeProvider).themeData,
        darkTheme: ref.watch(themeProvider).darkThemeData,
        themeMode: ref.watch(themeProvider).flutterThemeMode,
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
          RecurringRulesListPage.routeName: (context) =>
              const RecurringRulesListPage(),
          UpdateInfoPage.routeName: (context) => const UpdateInfoPage(),
          UpdateHistoryPage.routeName: (context) => const UpdateHistoryPage(),
          PrivacySettingsPage.routeName: (context) =>
              const PrivacySettingsPage(),
          ThemeSelectionPage.routeName: (context) => const ThemeSelectionPage(),
          ContactsPage.routeName: (context) => const ContactsPage(),
          BackupRestorePage.routeName: (context) => const BackupRestorePage(),
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
                final recurringRule = args?.recurringRule;
                final isRecurringPreset = args?.isRecurringPreset ?? false;

                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => NewEditTransactionPage(
                    incomePreset: incomePreset,
                    initialTransactionSettings: transaction,
                    initialAccountSettings: account,
                    initialRecurringRule: recurringRule,
                    isRecurringPreset: isRecurringPreset,
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
            case RecurringRuleDetailPage.routeName:
              {
                final args = settings.arguments as RecurringRule;

                return MaterialPageRoute(
                  settings: settings,
                  builder: (context) => RecurringRuleDetailPage(
                    rule: args,
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
