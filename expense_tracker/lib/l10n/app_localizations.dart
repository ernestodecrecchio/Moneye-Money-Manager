import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

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
    Locale('en', 'GB'),
    Locale('en', 'US'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('tr')
  ];

  /// No description provided for @aboutAndSupport.
  ///
  /// In en, this message translates to:
  /// **'About & Support'**
  String get aboutAndSupport;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

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

  /// No description provided for @addOne.
  ///
  /// In en, this message translates to:
  /// **'add one'**
  String get addOne;

  /// No description provided for @allTransactions.
  ///
  /// In en, this message translates to:
  /// **'All transactions'**
  String get allTransactions;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountIsMandatory.
  ///
  /// In en, this message translates to:
  /// **'The amount is mandatory'**
  String get amountIsMandatory;

  /// No description provided for @analyticsAlertDescription.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important.\nIf you accept, anonymous usage data will be collected to understand how features are used and how to improve the app.\nNo personal data, location data, transaction details, account information, or other sensitive information will be collected.\n\nThis option can be disabled at any time in Settings.'**
  String get analyticsAlertDescription;

  /// No description provided for @analyticsAlertTitle.
  ///
  /// In en, this message translates to:
  /// **'Help improve the app'**
  String get analyticsAlertTitle;

  /// No description provided for @analyticsOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Anonymous data about feature usage used to plan future developments.\nNo personal data is collected.'**
  String get analyticsOptionDescription;

  /// No description provided for @analyticsOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Anonymous usage statistics'**
  String get analyticsOptionTitle;

  /// No description provided for @applyChanges.
  ///
  /// In en, this message translates to:
  /// **'Apply changes'**
  String get applyChanges;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @atTheEnd.
  ///
  /// In en, this message translates to:
  /// **'At the end'**
  String get atTheEnd;

  /// No description provided for @atTheStart.
  ///
  /// In en, this message translates to:
  /// **'At the start'**
  String get atTheStart;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @backupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupAndRestore;

  /// No description provided for @backupAndRestoreOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Export or import your data'**
  String get backupAndRestoreOptionDescription;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @bills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get bills;

  /// No description provided for @billsAndUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills & Utilities'**
  String get billsAndUtilities;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get byCategory;

  /// No description provided for @byList.
  ///
  /// In en, this message translates to:
  /// **'By list'**
  String get byList;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @categoriesOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage the categories and create new ones'**
  String get categoriesOptionDescription;

  /// No description provided for @budgeting.
  ///
  /// In en, this message translates to:
  /// **'Budgeting'**
  String get budgeting;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @statisticsOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get statisticsOverviewTitle;

  /// No description provided for @statisticsOverviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Summary of your financial activity'**
  String get statisticsOverviewDescription;

  /// No description provided for @statisticsOverviewPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick snapshot of the selected period'**
  String get statisticsOverviewPreviewSubtitle;

  /// No description provided for @statisticsSpendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending'**
  String get statisticsSpendingTitle;

  /// No description provided for @statisticsSpendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Track where your money goes'**
  String get statisticsSpendingDescription;

  /// No description provided for @statisticsIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get statisticsIncomeTitle;

  /// No description provided for @statisticsIncomeDescription.
  ///
  /// In en, this message translates to:
  /// **'See your earnings over time'**
  String get statisticsIncomeDescription;

  /// No description provided for @statisticsCashflowTitle.
  ///
  /// In en, this message translates to:
  /// **'Cashflow'**
  String get statisticsCashflowTitle;

  /// No description provided for @statisticsCashflowDescription.
  ///
  /// In en, this message translates to:
  /// **'Income and expenses balance'**
  String get statisticsCashflowDescription;

  /// No description provided for @statisticsCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get statisticsCategoriesTitle;

  /// No description provided for @statisticsCategoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Spending breakdown by category'**
  String get statisticsCategoriesDescription;

  /// No description provided for @statisticsInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get statisticsInsightsTitle;

  /// No description provided for @statisticsInsightsDescription.
  ///
  /// In en, this message translates to:
  /// **'Patterns and highlights from your data'**
  String get statisticsInsightsDescription;

  /// No description provided for @statisticsNetBalance.
  ///
  /// In en, this message translates to:
  /// **'Net balance'**
  String get statisticsNetBalance;

  /// No description provided for @statisticsPlaceholderValue.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get statisticsPlaceholderValue;

  /// No description provided for @statisticsSelectedPeriod.
  ///
  /// In en, this message translates to:
  /// **'Selected period'**
  String get statisticsSelectedPeriod;

  /// No description provided for @statisticsChartsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Charts coming soon'**
  String get statisticsChartsComingSoon;

  /// No description provided for @statisticsOverviewComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Charts and summaries of income, expenses, and net balance for the selected period will appear here.'**
  String get statisticsOverviewComingSoon;

  /// No description provided for @statisticsSpendingComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Spending trends, totals, and breakdowns for the selected period will appear here.'**
  String get statisticsSpendingComingSoon;

  /// No description provided for @statisticsIncomeComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Income trends and totals for the selected period will appear here.'**
  String get statisticsIncomeComingSoon;

  /// No description provided for @statisticsIncomeByCategory.
  ///
  /// In en, this message translates to:
  /// **'Income by category'**
  String get statisticsIncomeByCategory;

  /// No description provided for @statisticsIncomeByCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load income by category.'**
  String get statisticsIncomeByCategoryError;

  /// No description provided for @statisticsIncomeMonthlyTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly income trend'**
  String get statisticsIncomeMonthlyTrend;

  /// No description provided for @statisticsIncomeMonthlyTrendInsufficientData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to show monthly income trend for this period.'**
  String get statisticsIncomeMonthlyTrendInsufficientData;

  /// No description provided for @statisticsIncomeMonthlyTrendError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load monthly income trend.'**
  String get statisticsIncomeMonthlyTrendError;

  /// No description provided for @statisticsIncomeAverageMonthly.
  ///
  /// In en, this message translates to:
  /// **'Average monthly income'**
  String get statisticsIncomeAverageMonthly;

  /// No description provided for @statisticsCashflowComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Cashflow trends comparing income and expenses for the selected period will appear here.'**
  String get statisticsCashflowComingSoon;

  /// No description provided for @statisticsCategoriesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Category spending breakdowns and comparisons for the selected period will appear here.'**
  String get statisticsCategoriesComingSoon;

  /// No description provided for @statisticsCategoriesListError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load category statistics.'**
  String get statisticsCategoriesListError;

  /// No description provided for @statisticsCategoryShareOfExpenses.
  ///
  /// In en, this message translates to:
  /// **'Share of total expenses'**
  String get statisticsCategoryShareOfExpenses;

  /// No description provided for @statisticsCategoryShareOfIncome.
  ///
  /// In en, this message translates to:
  /// **'Share of total income'**
  String get statisticsCategoryShareOfIncome;

  /// No description provided for @statisticsCategoryDetailComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Detailed charts and breakdowns for this category will appear here.'**
  String get statisticsCategoryDetailComingSoon;

  /// No description provided for @statisticsCategoryDetailError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load category statistics.'**
  String get statisticsCategoryDetailError;

  /// No description provided for @statisticsCategoryMonthlyTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly trend'**
  String get statisticsCategoryMonthlyTrend;

  /// No description provided for @statisticsCategoryMonthlyTrendInsufficientData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to show monthly trend for this category in the selected period.'**
  String get statisticsCategoryMonthlyTrendInsufficientData;

  /// No description provided for @statisticsCategoryAccountBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Account breakdown'**
  String get statisticsCategoryAccountBreakdown;

  /// No description provided for @statisticsScrollToTop.
  ///
  /// In en, this message translates to:
  /// **'Back to top'**
  String get statisticsScrollToTop;

  /// No description provided for @statisticsInsightsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Automated insights and highlights based on your financial activity will appear here.'**
  String get statisticsInsightsComingSoon;

  /// No description provided for @statisticsSelectGranularity.
  ///
  /// In en, this message translates to:
  /// **'Select granularity'**
  String get statisticsSelectGranularity;

  /// No description provided for @statisticsPeriodQuarter.
  ///
  /// In en, this message translates to:
  /// **'Quarter'**
  String get statisticsPeriodQuarter;

  /// No description provided for @statisticsKeyFigures.
  ///
  /// In en, this message translates to:
  /// **'KEY FIGURES'**
  String get statisticsKeyFigures;

  /// No description provided for @statisticsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get statisticsExpenses;

  /// No description provided for @statisticsNetResult.
  ///
  /// In en, this message translates to:
  /// **'Net result'**
  String get statisticsNetResult;

  /// No description provided for @statisticsSavingsRate.
  ///
  /// In en, this message translates to:
  /// **'Savings rate'**
  String get statisticsSavingsRate;

  /// No description provided for @statisticsNetWorthTrend.
  ///
  /// In en, this message translates to:
  /// **'Net worth trend'**
  String get statisticsNetWorthTrend;

  /// No description provided for @statisticsIncomeVsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Income vs expenses'**
  String get statisticsIncomeVsExpenses;

  /// No description provided for @statisticsNoTransactionsInPeriod.
  ///
  /// In en, this message translates to:
  /// **'No transactions in this period.'**
  String get statisticsNoTransactionsInPeriod;

  /// No description provided for @statisticsOverviewKpisError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load key figures.'**
  String get statisticsOverviewKpisError;

  /// No description provided for @statisticsNetWorthTrendInsufficientData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to show net worth trend for this period.'**
  String get statisticsNetWorthTrendInsufficientData;

  /// No description provided for @statisticsNetWorthTrendError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load net worth trend.'**
  String get statisticsNetWorthTrendError;

  /// No description provided for @statisticsIncomeVsExpensesError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load income vs expenses chart.'**
  String get statisticsIncomeVsExpensesError;

  /// No description provided for @statisticsSpendingExpensesByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expenses by category'**
  String get statisticsSpendingExpensesByCategory;

  /// No description provided for @statisticsSpendingExpensesByCategoryError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load expenses by category.'**
  String get statisticsSpendingExpensesByCategoryError;

  /// No description provided for @statisticsSpendingMonthlyTrend.
  ///
  /// In en, this message translates to:
  /// **'Monthly spending trend'**
  String get statisticsSpendingMonthlyTrend;

  /// No description provided for @statisticsSpendingMonthlyTrendInsufficientData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to show monthly spending trend for this period.'**
  String get statisticsSpendingMonthlyTrendInsufficientData;

  /// No description provided for @statisticsSpendingMonthlyTrendError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load monthly spending trend.'**
  String get statisticsSpendingMonthlyTrendError;

  /// No description provided for @statisticsSpendingCategoryComparison.
  ///
  /// In en, this message translates to:
  /// **'Category comparison'**
  String get statisticsSpendingCategoryComparison;

  /// No description provided for @statisticsSpendingCategoryComparisonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Top categories compared month by month'**
  String get statisticsSpendingCategoryComparisonSubtitle;

  /// No description provided for @statisticsSpendingCategoryComparisonInsufficientData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to compare categories across months for this period.'**
  String get statisticsSpendingCategoryComparisonInsufficientData;

  /// No description provided for @statisticsSpendingCategoryComparisonError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load category comparison.'**
  String get statisticsSpendingCategoryComparisonError;

  /// No description provided for @statisticsSpendingInsightsPreview.
  ///
  /// In en, this message translates to:
  /// **'Spending insights'**
  String get statisticsSpendingInsightsPreview;

  /// No description provided for @statisticsSpendingInsightsPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Highlights from your spending patterns'**
  String get statisticsSpendingInsightsPreviewSubtitle;

  /// No description provided for @newBudget.
  ///
  /// In en, this message translates to:
  /// **'New budget'**
  String get newBudget;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @amountSpentOf.
  ///
  /// In en, this message translates to:
  /// **'spent of'**
  String get amountSpentOf;

  /// No description provided for @amountRemaining.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get amountRemaining;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'over budget'**
  String get overBudget;

  /// No description provided for @rollover.
  ///
  /// In en, this message translates to:
  /// **'Rollover'**
  String get rollover;

  /// No description provided for @budgetDuration.
  ///
  /// In en, this message translates to:
  /// **'Budget duration'**
  String get budgetDuration;

  /// No description provided for @selectCategories.
  ///
  /// In en, this message translates to:
  /// **'Select categories'**
  String get selectCategories;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @allCategoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Includes every category, including ones you add later'**
  String get allCategoriesDescription;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contactsDescription.
  ///
  /// In en, this message translates to:
  /// **'Contact the developer to report a bug or suggest a feature'**
  String get contactsDescription;

  /// No description provided for @contactsPageHeader.
  ///
  /// In en, this message translates to:
  /// **'You can contact me to report a bug, suggest a feature, or whatever you want!'**
  String get contactsPageHeader;

  /// No description provided for @continueCTA.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueCTA;

  /// No description provided for @crashTest.
  ///
  /// In en, this message translates to:
  /// **'Crash Test (Debug Only)'**
  String get crashTest;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @currencyConversionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Note: Changing the currency displayed in the app will not result in transaction amount conversions.'**
  String get currencyConversionDisclaimer;

  /// No description provided for @currencyPosition.
  ///
  /// In en, this message translates to:
  /// **'Position of the currency symbol'**
  String get currencyPosition;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @dailyInterval.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Daily} other{Every {count} days}}'**
  String dailyInterval(int count);

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily reminder'**
  String get dailyReminder;

  /// No description provided for @dailyReminderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Notifications to remind you to enter your daily transactions.'**
  String get dailyReminderChannelDescription;

  /// No description provided for @dailyReminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get dailyReminderChannelName;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @dataAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataAndPrivacy;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @debitCard.
  ///
  /// In en, this message translates to:
  /// **'Debit Card'**
  String get debitCard;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

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

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryTransactionsMessage.
  ///
  /// In en, this message translates to:
  /// **'This category contains {count, plural, =1{1 transaction} other{{count} transactions}}. What would you like to do?'**
  String deleteCategoryTransactionsMessage(int count);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @editRecurringTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit repeating transaction'**
  String get editRecurringTransaction;

  /// No description provided for @editRuleInfo.
  ///
  /// In en, this message translates to:
  /// **'Changes to this recurring rule will not affect transactions that have already been generated.'**
  String get editRuleInfo;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit transaction'**
  String get editTransaction;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

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

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End date'**
  String get endDate;

  /// No description provided for @endDateInfo.
  ///
  /// In en, this message translates to:
  /// **'The date after which no other transactions of this kind will be automatically generated.'**
  String get endDateInfo;

  /// No description provided for @endedOn.
  ///
  /// In en, this message translates to:
  /// **'Ended on {date}'**
  String endedOn(String date);

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @essentialDataOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Anonymous data about crashes and errors used to ensure the proper functioning of the app.'**
  String get essentialDataOptionDescription;

  /// No description provided for @essentialDataOptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Essential technical data'**
  String get essentialDataOptionTitle;

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

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while exporting data'**
  String get exportError;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get exportSuccess;

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

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @financialOverviewForThisMonth.
  ///
  /// In en, this message translates to:
  /// **'The financial overview for this month'**
  String get financialOverviewForThisMonth;

  /// No description provided for @foodAndDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get foodAndDining;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @generatedTransactions.
  ///
  /// In en, this message translates to:
  /// **'Generated transactions'**
  String get generatedTransactions;

  /// No description provided for @generatedTransactionsSnackbar.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recurring transaction generated} other{{count} recurring transactions generated}}'**
  String generatedTransactionsSnackbar(int count);

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import data'**
  String get importData;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while importing data'**
  String get importError;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get importSuccess;

  /// No description provided for @importWarning.
  ///
  /// In en, this message translates to:
  /// **'Importing a backup will delete all current data. Are you sure you want to proceed?'**
  String get importWarning;

  /// No description provided for @includeInReports.
  ///
  /// In en, this message translates to:
  /// **'Include in reports'**
  String get includeInReports;

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

  /// No description provided for @insertTheAccountName.
  ///
  /// In en, this message translates to:
  /// **'Insert the account name'**
  String get insertTheAccountName;

  /// No description provided for @insertTheAmountOfTheTransaction.
  ///
  /// In en, this message translates to:
  /// **'Insert the amount of the transaction'**
  String get insertTheAmountOfTheTransaction;

  /// No description provided for @insertTheDescription.
  ///
  /// In en, this message translates to:
  /// **'Insert a description'**
  String get insertTheDescription;

  /// No description provided for @insertTheTitleOfTheCategory.
  ///
  /// In en, this message translates to:
  /// **'Insert the title of the category'**
  String get insertTheTitleOfTheCategory;

  /// No description provided for @insertTheTitleOfTheTransaction.
  ///
  /// In en, this message translates to:
  /// **'Insert the title of the transaction'**
  String get insertTheTitleOfTheTransaction;

  /// No description provided for @interval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get interval;

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

  /// No description provided for @lastTransactions.
  ///
  /// In en, this message translates to:
  /// **'Last transactions'**
  String get lastTransactions;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @monthlyInterval.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Monthly} other{Every {count} months}}'**
  String monthlyInterval(int count);

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New account'**
  String get newAccount;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get newCategory;

  /// No description provided for @newRecurringTransaction.
  ///
  /// In en, this message translates to:
  /// **'New repeating transaction'**
  String get newRecurringTransaction;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New transaction'**
  String get newTransaction;

  /// No description provided for @nextDate.
  ///
  /// In en, this message translates to:
  /// **'Next date'**
  String get nextDate;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @noAccountAdded.
  ///
  /// In en, this message translates to:
  /// **'No account added,'**
  String get noAccountAdded;

  /// No description provided for @noAccounts.
  ///
  /// In en, this message translates to:
  /// **'No accounts'**
  String get noAccounts;

  /// No description provided for @noAccountsListMessage.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet. Create one to track your balances.'**
  String get noAccountsListMessage;

  /// No description provided for @noBudgetsYet.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet'**
  String get noBudgetsYet;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get noCategories;

  /// No description provided for @noCategoriesListMessage.
  ///
  /// In en, this message translates to:
  /// **'No categories yet. Create one to organize your transactions.'**
  String get noCategoriesListMessage;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @notificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remember to enter your daily transactions!'**
  String get notificationSubtitle;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Moneye'**
  String get notificationTitle;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get noTransactions;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @personalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get personalization;

  /// No description provided for @petExpenses.
  ///
  /// In en, this message translates to:
  /// **'Pet Expenses'**
  String get petExpenses;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyAssurance.
  ///
  /// In en, this message translates to:
  /// **'Privacy is a priority. Names, emails, transaction amounts, or any data that could identify the user are never collected. All reports are strictly anonymous.'**
  String get privacyAssurance;

  /// No description provided for @privacyAssuranceLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy Assurance'**
  String get privacyAssuranceLabel;

  /// No description provided for @privacyIntroduction.
  ///
  /// In en, this message translates to:
  /// **'Choose which data can be collected to help improve the app and ensure its stability.'**
  String get privacyIntroduction;

  /// No description provided for @privacyOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure how data is collected and used'**
  String get privacyOptionDescription;

  /// No description provided for @recurringTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recurring Transactions'**
  String get recurringTransactions;

  /// No description provided for @recurringTransactionsOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your recurring transaction rules'**
  String get recurringTransactionsOptionDescription;

  /// No description provided for @noRecurringTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recurring transactions yet. Create one to automate regular entries.'**
  String get noRecurringTransactions;

  /// No description provided for @transactionShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Transaction Shortcuts'**
  String get transactionShortcuts;

  /// No description provided for @transactionShortcutsOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Create presets for quick transaction entry'**
  String get transactionShortcutsOptionDescription;

  /// No description provided for @shortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get shortcuts;

  /// No description provided for @newTransactionShortcut.
  ///
  /// In en, this message translates to:
  /// **'New Shortcut'**
  String get newTransactionShortcut;

  /// No description provided for @editTransactionShortcut.
  ///
  /// In en, this message translates to:
  /// **'Edit Shortcut'**
  String get editTransactionShortcut;

  /// No description provided for @noTransactionShortcuts.
  ///
  /// In en, this message translates to:
  /// **'No shortcuts yet. Create one to add transactions with a single tap.'**
  String get noTransactionShortcuts;

  /// No description provided for @shortcutTransactionAdded.
  ///
  /// In en, this message translates to:
  /// **'Transaction added successfully'**
  String get shortcutTransactionAdded;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @reminderDescription.
  ///
  /// In en, this message translates to:
  /// **'Moneye will remind you every day, at a set time, to enter new transactions.\n\nYou will never forget to keep your data updated!'**
  String get reminderDescription;

  /// No description provided for @reminderOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a reminder to remember to insert new transactions'**
  String get reminderOptionDescription;

  /// No description provided for @repeatTransaction.
  ///
  /// In en, this message translates to:
  /// **'Repeat transaction'**
  String get repeatTransaction;

  /// No description provided for @reportBug.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get reportBug;

  /// No description provided for @resetData.
  ///
  /// In en, this message translates to:
  /// **'Erase all data'**
  String get resetData;

  /// No description provided for @resetError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while erasing data'**
  String get resetError;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Unable to save. Please try again.'**
  String get saveError;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'All data erased successfully'**
  String get resetSuccess;

  /// No description provided for @resetWarning.
  ///
  /// In en, this message translates to:
  /// **'All your data will be permanently deleted. This action cannot be undone. Are you sure you want to proceed?'**
  String get resetWarning;

  /// No description provided for @ruleDetails.
  ///
  /// In en, this message translates to:
  /// **'Rule details'**
  String get ruleDetails;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveToDevice.
  ///
  /// In en, this message translates to:
  /// **'Save to device'**
  String get saveToDevice;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @selectAccount.
  ///
  /// In en, this message translates to:
  /// **'Select account'**
  String get selectAccount;

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

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select the category'**
  String get selectCategory;

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

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get selectColor;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select the currency'**
  String get selectCurrency;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select the date'**
  String get selectDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select icon'**
  String get selectIcon;

  /// No description provided for @selectTargetCategory.
  ///
  /// In en, this message translates to:
  /// **'Select target category'**
  String get selectTargetCategory;

  /// No description provided for @selectTimeInterval.
  ///
  /// In en, this message translates to:
  /// **'Select the time interval'**
  String get selectTimeInterval;

  /// No description provided for @sendTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Show me how it will appear'**
  String get sendTestNotification;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @shareBackup.
  ///
  /// In en, this message translates to:
  /// **'Share backup'**
  String get shareBackup;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @suggestFeature.
  ///
  /// In en, this message translates to:
  /// **'Suggest a feature'**
  String get suggestFeature;

  /// No description provided for @systemLanguageOption.
  ///
  /// In en, this message translates to:
  /// **'Automatic (based on the system)'**
  String get systemLanguageOption;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get systemTheme;

  /// No description provided for @testNotificationSent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent!'**
  String get testNotificationSent;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Change the app appearance'**
  String get themeOptionDescription;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @titleIsMandatory.
  ///
  /// In en, this message translates to:
  /// **'The title is mandatory'**
  String get titleIsMandatory;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total balance'**
  String get totalBalance;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get startDate;

  /// No description provided for @startsOnDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Starts on day of month'**
  String get startsOnDayOfMonth;

  /// No description provided for @startsOnWeekday.
  ///
  /// In en, this message translates to:
  /// **'Starts on weekday'**
  String get startsOnWeekday;

  /// No description provided for @selectAtLeastOneCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one category'**
  String get selectAtLeastOneCategory;

  /// No description provided for @deleteBudgetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this budget?'**
  String get deleteBudgetConfirmation;

  /// No description provided for @budgetTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My Monthly Grocery Budget'**
  String get budgetTitleHint;

  /// No description provided for @budgetAmountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 500.00'**
  String get budgetAmountHint;

  /// No description provided for @budgetAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive amount'**
  String get budgetAmountInvalid;

  /// No description provided for @rolloverMode.
  ///
  /// In en, this message translates to:
  /// **'Rollover mode'**
  String get rolloverMode;

  /// No description provided for @carryRemaining.
  ///
  /// In en, this message translates to:
  /// **'Carry forward remaining'**
  String get carryRemaining;

  /// No description provided for @carryOverspending.
  ///
  /// In en, this message translates to:
  /// **'Carry forward overspending'**
  String get carryOverspending;

  /// No description provided for @rolloverModeNoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Unused money is not carried over. Each budget period starts fresh.'**
  String get rolloverModeNoneDescription;

  /// No description provided for @rolloverModeCarryRemainingDescription.
  ///
  /// In en, this message translates to:
  /// **'Any unspent money is added to next period\'s budget.'**
  String get rolloverModeCarryRemainingDescription;

  /// No description provided for @rolloverModeCarryOverspendingDescription.
  ///
  /// In en, this message translates to:
  /// **'If you overspend, the negative balance is carried into the next period.'**
  String get rolloverModeCarryOverspendingDescription;

  /// No description provided for @transactionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction deleted'**
  String get transactionDeleted;

  /// No description provided for @transactionGeneratedByDeletedRule.
  ///
  /// In en, this message translates to:
  /// **'This transaction was generated by a recurring rule that has since been deleted.'**
  String get transactionGeneratedByDeletedRule;

  /// No description provided for @transactionGeneratedByRule.
  ///
  /// In en, this message translates to:
  /// **'This transaction was generated automatically by a recurring rule. Editing this transaction will not affect future generated ones.'**
  String get transactionGeneratedByRule;

  /// No description provided for @transactionList.
  ///
  /// In en, this message translates to:
  /// **'Transaction list'**
  String get transactionList;

  /// No description provided for @transferTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transfer Transactions'**
  String get transferTransactions;

  /// No description provided for @transferTransactionsMessage.
  ///
  /// In en, this message translates to:
  /// **'Transfer {count, plural, =1{1 transaction} other{{count} transactions}} to:'**
  String transferTransactionsMessage(int count);

  /// No description provided for @transportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get transportation;

  /// No description provided for @updateHistory.
  ///
  /// In en, this message translates to:
  /// **'Update history'**
  String get updateHistory;

  /// No description provided for @updateHistoryEmptyList.
  ///
  /// In en, this message translates to:
  /// **'No updates found.'**
  String get updateHistoryEmptyList;

  /// No description provided for @updateHistoryOptionDescription.
  ///
  /// In en, this message translates to:
  /// **'View the latest features and updates'**
  String get updateHistoryOptionDescription;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @viewRule.
  ///
  /// In en, this message translates to:
  /// **'View rule'**
  String get viewRule;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @weeklyInterval.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Weekly} other{Every {count} weeks}}'**
  String weeklyInterval(int count);

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

  /// No description provided for @whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get whatsNew;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @yearlyInterval.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Yearly} other{Every {count} years}}'**
  String yearlyInterval(int count);

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @correctBalance.
  ///
  /// In en, this message translates to:
  /// **'Correct balance'**
  String get correctBalance;

  /// No description provided for @currentCalculatedBalance.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get currentCalculatedBalance;

  /// No description provided for @realBalance.
  ///
  /// In en, this message translates to:
  /// **'Real balance'**
  String get realBalance;

  /// No description provided for @realBalancePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter the actual balance of the account'**
  String get realBalancePlaceholder;

  /// No description provided for @rebalanceAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get rebalanceAdjustment;

  /// No description provided for @rebalanceSuccess.
  ///
  /// In en, this message translates to:
  /// **'Balance corrected successfully'**
  String get rebalanceSuccess;

  /// No description provided for @confirmTransferTransactionsMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 transaction} other{{count} transactions}} will be transferred from {source} to {target}. Are you sure?'**
  String confirmTransferTransactionsMessage(
      int count, String source, String target);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @yourAccounts.
  ///
  /// In en, this message translates to:
  /// **'Your accounts'**
  String get yourAccounts;

  /// No description provided for @yourCategories.
  ///
  /// In en, this message translates to:
  /// **'Your categories'**
  String get yourCategories;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'it',
        'pt',
        'tr'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'GB':
            return AppLocalizationsEnGb();
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
