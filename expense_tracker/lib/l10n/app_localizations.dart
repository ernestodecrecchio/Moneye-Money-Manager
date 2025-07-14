import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('it')
  ];

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @financialOverviewForThisMonth.
  ///
  /// In en, this message translates to:
  /// **'The financial overview for this month'**
  String get financialOverviewForThisMonth;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get totalBalance;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @incomes.
  ///
  /// In en, this message translates to:
  /// **'Incomes'**
  String get incomes;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @yourAccounts.
  ///
  /// In en, this message translates to:
  /// **'Your accounts'**
  String get yourAccounts;

  /// No description provided for @lastTransactions.
  ///
  /// In en, this message translates to:
  /// **'Last transactions'**
  String get lastTransactions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @yourCategories.
  ///
  /// In en, this message translates to:
  /// **'Your categories'**
  String get yourCategories;

  /// No description provided for @categoriesOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage the categories and create new ones'**
  String get categoriesOptionDescription;

  /// No description provided for @accounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accounts;

  /// No description provided for @accountsOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage the accounts and create new ones'**
  String get accountsOptionDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the language used in the app'**
  String get languageOptionDescription;

  /// No description provided for @allTransactions.
  ///
  /// In en, this message translates to:
  /// **'All transactions'**
  String get allTransactions;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select the category'**
  String get selectCategory;

  /// No description provided for @selectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select account'**
  String get selectAccount;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select the date'**
  String get selectDate;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get newTransaction;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get newAccount;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// No description provided for @insertTheTitleOfTheTransaction.
  ///
  /// In en, this message translates to:
  /// **'Insert the title of the trasnaction'**
  String get insertTheTitleOfTheTransaction;

  /// No description provided for @titleIsMandatory.
  ///
  /// In en, this message translates to:
  /// **'The title is mandatory'**
  String get titleIsMandatory;

  /// No description provided for @insertTheDescription.
  ///
  /// In en, this message translates to:
  /// **'Insert a description'**
  String get insertTheDescription;

  /// No description provided for @insertTheAmountOfTheTransaction.
  ///
  /// In en, this message translates to:
  /// **'Insert the amount of the trasnaction'**
  String get insertTheAmountOfTheTransaction;

  /// No description provided for @amountIsMandatory.
  ///
  /// In en, this message translates to:
  /// **'The amount is mandatory'**
  String get amountIsMandatory;

  /// No description provided for @insertTheTitleOfTheCategory.
  ///
  /// In en, this message translates to:
  /// **'Insert the title of the category'**
  String get insertTheTitleOfTheCategory;

  /// No description provided for @insertTheAccountName.
  ///
  /// In en, this message translates to:
  /// **'Insert the account name'**
  String get insertTheAccountName;

  /// No description provided for @applyChanges.
  ///
  /// In en, this message translates to:
  /// **'Apply changes'**
  String get applyChanges;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @selectTimeInterval.
  ///
  /// In en, this message translates to:
  /// **'Select the time interval'**
  String get selectTimeInterval;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @noAccounts.
  ///
  /// In en, this message translates to:
  /// **'No accounts'**
  String get noAccounts;

  /// No description provided for @noAccountAdded.
  ///
  /// In en, this message translates to:
  /// **'No account added,'**
  String get noAccountAdded;

  /// No description provided for @addOne.
  ///
  /// In en, this message translates to:
  /// **'add one'**
  String get addOne;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get noCategories;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select the currency'**
  String get selectCurrency;

  /// No description provided for @currencyOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Select and customize the used currency'**
  String get currencyOptionDescription;

  /// No description provided for @currencyPosition.
  ///
  /// In en, this message translates to:
  /// **'Position of the currency symbol'**
  String get currencyPosition;

  /// No description provided for @selectCurrencyPosition.
  ///
  /// In en, this message translates to:
  /// **'Select the currency symbol position'**
  String get selectCurrencyPosition;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @atTheStart.
  ///
  /// In en, this message translates to:
  /// **'At the start'**
  String get atTheStart;

  /// No description provided for @atTheEnd.
  ///
  /// In en, this message translates to:
  /// **'At the end'**
  String get atTheEnd;

  /// No description provided for @currencyConversionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Note: Changing the currency displayed in the app will not result in transaction amount conversions.'**
  String get currencyConversionDisclaimer;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @infoOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'App credits and other info'**
  String get infoOptionDescription;

  /// No description provided for @infoDescription.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Moneye, an app developed by me, Ernesto De Crecchio, with the goal of providing an easy-to-use and effective tool for managing personal finances.\n\nMoneye enables you to effortlessly track your expenses, view insightful graphs, and gain a better understanding of your spending habits.\n\nAs the developer of the app, I am dedicated to constantly improving its features, and have planned new updates to be released in the future, ensuring that my users have access to the most up-to-date and comprehensive tools for managing their finances.\n\nMy aim is to provide an intuitive experience for all users, and I hope that you find Moneye helpful in achieving your financial goals.'**
  String get infoDescription;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @byList.
  ///
  /// In en, this message translates to:
  /// **'By list'**
  String get byList;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @systemLanguageOption.
  ///
  /// In en, this message translates to:
  /// **'Automatic (based on the system)'**
  String get systemLanguageOption;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @debitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get debitCard;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @foodAndDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get foodAndDining;

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @billsAndUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills & Utilities'**
  String get billsAndUtilities;

  /// No description provided for @petExpenses.
  ///
  /// In en, this message translates to:
  /// **'Pet Expenses'**
  String get petExpenses;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @toContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get toContinue;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get done;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @welcomePageMsg1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Moneye!'**
  String get welcomePageMsg1;

  /// No description provided for @welcomePageMsg2.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get you started on your journey towards financial control.\nI’ll help you configure the app in just a few steps.'**
  String get welcomePageMsg2;

  /// No description provided for @selectCurrencyMsg1.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred currency'**
  String get selectCurrencyMsg1;

  /// No description provided for @selectCurrencyMsg2.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry, you can always change it later to match your needs.'**
  String get selectCurrencyMsg2;

  /// No description provided for @selectAccountMsg1.
  ///
  /// In en, this message translates to:
  /// **'Choose the accounts you want to monitor'**
  String get selectAccountMsg1;

  /// No description provided for @selectAccountMsg2.
  ///
  /// In en, this message translates to:
  /// **'Cash, credit card, or others\nSelect what you\'d like to keep a close eye on.'**
  String get selectAccountMsg2;

  /// No description provided for @selectCategoryMsg1.
  ///
  /// In en, this message translates to:
  /// **'Make the most of Moneye by categorizing your transactions'**
  String get selectCategoryMsg1;

  /// No description provided for @selectCategoryMsg2.
  ///
  /// In en, this message translates to:
  /// **'Select from the preconfigured list or create your custom categories later'**
  String get selectCategoryMsg2;

  /// No description provided for @endConfigurationMsg1.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Moneye is now configured and ready to help you manage your expenses efficiently.'**
  String get endConfigurationMsg1;

  /// No description provided for @endConfigurationMsg2.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to explore other exciting features to optimize your financial journey.'**
  String get endConfigurationMsg2;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Moneye'**
  String get notificationTitle;

  /// No description provided for @notificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remember to enter your daily transactions!'**
  String get notificationSubtitle;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @reminderOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a reminder to remember to insert new transactions'**
  String get reminderOptionDescription;

  /// No description provided for @reminderDescription.
  ///
  /// In en, this message translates to:
  /// **'Moneye will remind you every day, at a set time, to enter new transactions.\n\nYou will never forget to keep your data updated!'**
  String get reminderDescription;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedbackAndReviewOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you like Moneye? Let us know!'**
  String get feedbackAndReviewOptionDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @deleteAccountAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Deleting an account will not remove the transactions associated with it.'**
  String get deleteAccountAlertBody;

  /// No description provided for @deleteCategoryAlertBody.
  ///
  /// In en, this message translates to:
  /// **'Deleting a category will not remove the transactions associated with it.'**
  String get deleteCategoryAlertBody;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @transactionList.
  ///
  /// In en, this message translates to:
  /// **'Transaction list'**
  String get transactionList;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @initialBalance.
  ///
  /// In en, this message translates to:
  /// **'Initial balance'**
  String get initialBalance;

  /// No description provided for @initialBalancePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Insert the initial balance of the account'**
  String get initialBalancePlaceholder;

  /// No description provided for @includeInReports.
  ///
  /// In en, this message translates to:
  /// **'Include in reports'**
  String get includeInReports;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
