// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get aboutAndSupport => 'About & Support';

  @override
  String get accept => 'Accept';

  @override
  String get account => 'Account';

  @override
  String get accounts => 'Accounts';

  @override
  String get accountsOptionDescription =>
      'Manage the accounts and create new ones';

  @override
  String get addOne => 'add one';

  @override
  String get allTransactions => 'All transactions';

  @override
  String get amount => 'Amount';

  @override
  String get amountIsMandatory => 'The amount is mandatory';

  @override
  String get analyticsAlertDescription =>
      'Your privacy is important.\nIf you accept, anonymous usage data will be collected to understand how features are used and how to improve the app.\nNo personal data, location data, transaction details, account information, or other sensitive information will be collected.\n\nThis option can be disabled at any time in Settings.';

  @override
  String get analyticsAlertTitle => 'Help improve the app';

  @override
  String get analyticsOptionDescription =>
      'Anonymous data about feature usage used to plan future developments.\nNo personal data is collected.';

  @override
  String get analyticsOptionTitle => 'Anonymous usage statistics';

  @override
  String get applyChanges => 'Apply changes';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get atTheEnd => 'At the end';

  @override
  String get atTheStart => 'At the start';

  @override
  String get back => 'Back';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get backupAndRestoreOptionDescription => 'Export or import your data';

  @override
  String get balance => 'Balance';

  @override
  String get bills => 'Bills';

  @override
  String get billsAndUtilities => 'Bills & Utilities';

  @override
  String get byCategory => 'By category';

  @override
  String get byList => 'By list';

  @override
  String get cancel => 'Cancel';

  @override
  String get cash => 'Cash';

  @override
  String get categories => 'Categories';

  @override
  String get categoriesOptionDescription =>
      'Manage the categories and create new ones';

  @override
  String get budgeting => 'Budgeting';

  @override
  String get statistics => 'Statistics';

  @override
  String get statisticsOverviewTitle => 'Overview';

  @override
  String get statisticsOverviewDescription =>
      'Summary of your financial activity';

  @override
  String get statisticsOverviewPreviewSubtitle =>
      'Quick snapshot of the selected period';

  @override
  String get statisticsSpendingTitle => 'Spending';

  @override
  String get statisticsSpendingDescription => 'Track where your money goes';

  @override
  String get statisticsIncomeTitle => 'Income';

  @override
  String get statisticsIncomeDescription => 'See your earnings over time';

  @override
  String get statisticsCashflowTitle => 'Cashflow';

  @override
  String get statisticsCashflowDescription => 'Income and expenses balance';

  @override
  String get statisticsCategoriesTitle => 'Categories';

  @override
  String get statisticsCategoriesDescription =>
      'Spending breakdown by category';

  @override
  String get statisticsInsightsTitle => 'Insights';

  @override
  String get statisticsInsightsDescription =>
      'Patterns and highlights from your data';

  @override
  String get statisticsNetBalance => 'Net balance';

  @override
  String get statisticsPlaceholderValue => '—';

  @override
  String get statisticsSelectedPeriod => 'Selected period';

  @override
  String get statisticsChartsComingSoon => 'Charts coming soon';

  @override
  String get statisticsChartFullscreen => 'View chart fullscreen';

  @override
  String get statisticsChartExitFullscreen => 'Close fullscreen';

  @override
  String get statisticsOverviewComingSoon =>
      'Charts and summaries of income, expenses, and net balance for the selected period will appear here.';

  @override
  String get statisticsSpendingComingSoon =>
      'Spending trends, totals, and breakdowns for the selected period will appear here.';

  @override
  String get statisticsIncomeComingSoon =>
      'Income trends and totals for the selected period will appear here.';

  @override
  String get statisticsIncomeByCategory => 'Income by category';

  @override
  String get statisticsIncomeByCategoryError =>
      'Unable to load income by category.';

  @override
  String get statisticsIncomeMonthlyTrend => 'Monthly income trend';

  @override
  String get statisticsIncomeMonthlyTrendInsufficientData =>
      'Not enough data to show monthly income trend for this period.';

  @override
  String get statisticsIncomeMonthlyTrendError =>
      'Unable to load monthly income trend.';

  @override
  String get statisticsIncomeAverageMonthly => 'Average monthly income';

  @override
  String get statisticsIncomeAverageMonthlyDescription =>
      'Total income divided by the months in the selected period.';

  @override
  String get statisticsIncomeAverageMonthlyError =>
      'Unable to load average monthly income.';

  @override
  String get statisticsSpendingAverageMonthly => 'Average monthly spending';

  @override
  String get statisticsSpendingAverageMonthlyDescription =>
      'Total expenses divided by the months in the selected period.';

  @override
  String get statisticsSpendingAverageMonthlyError =>
      'Unable to load average monthly spending.';

  @override
  String statisticsAverageMonthlyMonths(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Based on $count months',
      one: 'Based on 1 month',
    );
    return '$_temp0';
  }

  @override
  String get statisticsCashflowComingSoon =>
      'Cashflow trends comparing income and expenses for the selected period will appear here.';

  @override
  String get statisticsCashflowMonthlyChart => 'Monthly cashflow';

  @override
  String get statisticsCashflowMonthlyChartInsufficientData =>
      'Not enough data to show monthly cashflow for this period.';

  @override
  String get statisticsCashflowMonthlyChartError =>
      'Unable to load monthly cashflow chart.';

  @override
  String get statisticsNetCashflow => 'Net cashflow';

  @override
  String get statisticsCashflowMonthlyList => 'Monthly cashflow list';

  @override
  String get statisticsCashflowMonthlyListError =>
      'Unable to load monthly cashflow list.';

  @override
  String get statisticsCashflowCumulativeChart => 'Cumulative cashflow';

  @override
  String get statisticsCashflowCumulativeChartSubtitle =>
      'Running net cashflow within the selected period, starting from zero. This is not your account balance.';

  @override
  String get statisticsCashflowCumulativeChartInsufficientData =>
      'Not enough data to show cumulative cashflow for this period.';

  @override
  String get statisticsCashflowCumulativeChartError =>
      'Unable to load cumulative cashflow chart.';

  @override
  String get statisticsCategoriesComingSoon =>
      'Category spending breakdowns and comparisons for the selected period will appear here.';

  @override
  String get statisticsCategoriesListError =>
      'Unable to load category statistics.';

  @override
  String get statisticsCategoryShareOfExpenses => 'Share of total expenses';

  @override
  String get statisticsCategoryShareOfIncome => 'Share of total income';

  @override
  String get statisticsCategoryDetailComingSoon =>
      'Detailed charts and breakdowns for this category will appear here.';

  @override
  String get statisticsCategoryDetailError =>
      'Unable to load category statistics.';

  @override
  String get statisticsCategoryMonthlyTrend => 'Monthly trend';

  @override
  String get statisticsCategoryMonthlyTrendInsufficientData =>
      'Not enough data to show monthly trend for this category in the selected period.';

  @override
  String get statisticsCategoryAccountBreakdown => 'Account breakdown';

  @override
  String get statisticsScrollToTop => 'Back to top';

  @override
  String get statisticsInsightsComingSoon =>
      'Automated insights and highlights based on your financial activity will appear here.';

  @override
  String get statisticsInsightsEmptyTitle => 'No insights available';

  @override
  String get statisticsInsightsEmptyMessage =>
      'There are no insights for the selected period. Insights will appear here when patterns are detected in your data.';

  @override
  String get statisticsInsightsError => 'Unable to load insights.';

  @override
  String get statisticsInsightSpendingChangeIncreasedTitle =>
      'Spending increased';

  @override
  String statisticsInsightSpendingChangeIncreasedDescription(
      String amount, String percent) {
    return '$amount more than last period ($percent).';
  }

  @override
  String get statisticsInsightSpendingChangeDecreasedTitle =>
      'Spending decreased';

  @override
  String statisticsInsightSpendingChangeDecreasedDescription(
      String amount, String percent) {
    return '$amount less than last period ($percent).';
  }

  @override
  String get statisticsInsightTopCategoryWeightTitle => 'Top category share';

  @override
  String statisticsInsightTopCategoryWeightDescription(
      String category, String percent) {
    return '$category accounts for $percent of expenses.';
  }

  @override
  String get statisticsInsightBestMonthTitle => 'Best month';

  @override
  String statisticsInsightBestMonthDescription(String month, String amount) {
    return '$month with $amount net result.';
  }

  @override
  String get statisticsInsightWorstMonthTitle => 'Worst month';

  @override
  String statisticsInsightWorstMonthDescription(String month, String amount) {
    return '$month with $amount net result.';
  }

  @override
  String get statisticsSelectGranularity => 'Select granularity';

  @override
  String get statisticsPeriodQuarter => 'Quarter';

  @override
  String get statisticsKeyFigures => 'KEY FIGURES';

  @override
  String get statisticsExpenses => 'Expenses';

  @override
  String get statisticsNetResult => 'Net result';

  @override
  String get statisticsSavingsRate => 'Savings rate';

  @override
  String get statisticsNetWorthTrend => 'Net worth trend';

  @override
  String get statisticsIncomeVsExpenses => 'Income vs expenses';

  @override
  String get statisticsNoTransactionsInPeriod =>
      'No transactions in this period.';

  @override
  String get statisticsNoExpensesInPeriod => 'No expenses in this period.';

  @override
  String get statisticsNoIncomeInPeriod => 'No income in this period.';

  @override
  String get statisticsInsightsErrorTitle => 'Couldn\'t load insights';

  @override
  String get statisticsOverviewKpisError => 'Unable to load key figures.';

  @override
  String get statisticsNetWorthTrendInsufficientData =>
      'Not enough data to show net worth trend for this period.';

  @override
  String get statisticsNetWorthTrendError => 'Unable to load net worth trend.';

  @override
  String get statisticsIncomeVsExpensesError =>
      'Unable to load income vs expenses chart.';

  @override
  String get statisticsSpendingExpensesByCategory => 'Expenses by category';

  @override
  String get statisticsSpendingExpensesByCategoryError =>
      'Unable to load expenses by category.';

  @override
  String get statisticsSpendingMonthlyTrend => 'Monthly spending trend';

  @override
  String get statisticsSpendingMonthlyTrendInsufficientData =>
      'Not enough data to show monthly spending trend for this period.';

  @override
  String get statisticsSpendingMonthlyTrendError =>
      'Unable to load monthly spending trend.';

  @override
  String get statisticsSpendingCategoryComparison => 'Category comparison';

  @override
  String get statisticsSpendingCategoryComparisonSubtitle =>
      'Top categories compared month by month';

  @override
  String get statisticsSpendingCategoryComparisonInsufficientData =>
      'Not enough data to compare categories across months for this period.';

  @override
  String get statisticsSpendingCategoryComparisonError =>
      'Unable to load category comparison.';

  @override
  String get statisticsSpendingInsightsPreview => 'Spending insights';

  @override
  String get statisticsSpendingInsightsPreviewSubtitle =>
      'Highlights from your spending patterns';

  @override
  String get newBudget => 'New budget';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get amountSpentOf => 'spent of';

  @override
  String get amountRemaining => 'remaining';

  @override
  String get overBudget => 'over budget';

  @override
  String get rollover => 'Rollover';

  @override
  String get budgetDuration => 'Budget duration';

  @override
  String get selectCategories => 'Select categories';

  @override
  String get allCategories => 'All categories';

  @override
  String get allCategoriesDescription =>
      'Includes every category, including ones you add later';

  @override
  String get category => 'Category';

  @override
  String get color => 'Color';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactsDescription =>
      'Contact the developer to report a bug or suggest a feature';

  @override
  String get contactsPageHeader =>
      'You can contact me to report a bug, suggest a feature, or whatever you want!';

  @override
  String get continueCTA => 'Continue';

  @override
  String get crashTest => 'Crash Test (Debug Only)';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get currency => 'Currency';

  @override
  String get currencyConversionDisclaimer =>
      'Note: Changing the currency displayed in the app will not result in transaction amount conversions.';

  @override
  String get currencyPosition => 'Position of the currency symbol';

  @override
  String get daily => 'Daily';

  @override
  String dailyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Daily',
    );
    return '$_temp0';
  }

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get dailyReminderChannelDescription =>
      'Notifications to remind you to enter your daily transactions.';

  @override
  String get dailyReminderChannelName => 'Daily Reminders';

  @override
  String get darkTheme => 'Dark';

  @override
  String get dataAndPrivacy => 'Data & Privacy';

  @override
  String get date => 'Date';

  @override
  String get day => 'Day';

  @override
  String get debitCard => 'Debit Card';

  @override
  String get decline => 'Decline';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccountAlertBody =>
      'Deleting an account will not remove the transactions associated with it.';

  @override
  String get deleteCategoryAlertBody =>
      'Deleting a category will not remove the transactions associated with it.';

  @override
  String get deleteCategoryTitle => 'Delete Category';

  @override
  String deleteCategoryTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return 'This category contains $_temp0. What would you like to do?';
  }

  @override
  String get description => 'Description';

  @override
  String get done => 'Done';

  @override
  String get confirm => 'Confirm';

  @override
  String get edit => 'Edit';

  @override
  String get editAccount => 'Edit account';

  @override
  String get editCategory => 'Edit category';

  @override
  String get editRecurringTransaction => 'Edit repeating transaction';

  @override
  String get editRuleInfo =>
      'Changes to this recurring rule will not affect transactions that have already been generated.';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get education => 'Education';

  @override
  String get endConfigurationMsg1 =>
      'Congratulations! Moneye is now configured and ready to help you manage your expenses efficiently.';

  @override
  String get endConfigurationMsg2 =>
      'Don\'t forget to explore other exciting features to optimize your financial journey.';

  @override
  String get endDate => 'End date';

  @override
  String get endDateInfo =>
      'The date after which no other transactions of this kind will be automatically generated.';

  @override
  String endedOn(String date) {
    return 'Ended on $date';
  }

  @override
  String get entertainment => 'Entertainment';

  @override
  String get essentialDataOptionDescription =>
      'Anonymous data about crashes and errors used to ensure the proper functioning of the app.';

  @override
  String get essentialDataOptionTitle => 'Essential technical data';

  @override
  String get expense => 'Expense';

  @override
  String get expenses => 'Expenses';

  @override
  String get exportError => 'An error occurred while exporting data';

  @override
  String get exportSuccess => 'Data exported successfully';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackAndReviewOptionDescription =>
      'Do you like Moneye? Let us know!';

  @override
  String get finance => 'Finance';

  @override
  String get financialOverviewForThisMonth =>
      'The financial overview for this month';

  @override
  String get foodAndDining => 'Food & Dining';

  @override
  String get frequency => 'Frequency';

  @override
  String get generatedTransactions => 'Generated transactions';

  @override
  String generatedTransactionsSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recurring transactions generated',
      one: '1 recurring transaction generated',
    );
    return '$_temp0';
  }

  @override
  String get health => 'Health';

  @override
  String get icon => 'Icon';

  @override
  String get importData => 'Import data';

  @override
  String get importError => 'An error occurred while importing data';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get importWarning =>
      'Importing a backup will delete all current data. Are you sure you want to proceed?';

  @override
  String get includeInReports => 'Include in reports';

  @override
  String get income => 'Income';

  @override
  String get incomes => 'Incomes';

  @override
  String get initialBalance => 'Initial balance';

  @override
  String get initialBalancePlaceholder =>
      'Insert the initial balance of the account';

  @override
  String get insertTheAccountName => 'Insert the account name';

  @override
  String get insertTheAmountOfTheTransaction =>
      'Insert the amount of the transaction';

  @override
  String get insertTheDescription => 'Insert a description';

  @override
  String get insertTheTitleOfTheCategory => 'Insert the title of the category';

  @override
  String get insertTheTitleOfTheTransaction =>
      'Insert the title of the transaction';

  @override
  String get interval => 'Interval';

  @override
  String get language => 'Language';

  @override
  String get languageOptionDescription => 'Select the language used in the app';

  @override
  String get lastTransactions => 'Last transactions';

  @override
  String get lightTheme => 'Light';

  @override
  String get management => 'Management';

  @override
  String get month => 'Month';

  @override
  String get monthly => 'Monthly';

  @override
  String monthlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Monthly',
    );
    return '$_temp0';
  }

  @override
  String get newAccount => 'New account';

  @override
  String get newCategory => 'New category';

  @override
  String get newRecurringTransaction => 'New repeating transaction';

  @override
  String get newTransaction => 'New transaction';

  @override
  String get nextDate => 'Next date';

  @override
  String get no => 'no';

  @override
  String get noAccountAdded => 'No account added,';

  @override
  String get noAccounts => 'No accounts';

  @override
  String get noAccountsListMessage =>
      'No accounts yet. Create one to track your balances.';

  @override
  String get noBudgetsYet => 'No budgets yet';

  @override
  String get noCategories => 'No categories';

  @override
  String get noCategoriesListMessage =>
      'No categories yet. Create one to organize your transactions.';

  @override
  String get none => 'None';

  @override
  String get notificationSubtitle =>
      'Remember to enter your daily transactions!';

  @override
  String get notificationTitle => 'Moneye';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get other => 'Other';

  @override
  String get personalization => 'Personalization';

  @override
  String get petExpenses => 'Pet Expenses';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyAssurance =>
      'Privacy is a priority. Names, emails, transaction amounts, or any data that could identify the user are never collected. All reports are strictly anonymous.';

  @override
  String get privacyAssuranceLabel => 'Privacy Assurance';

  @override
  String get privacyIntroduction =>
      'Choose which data can be collected to help improve the app and ensure its stability.';

  @override
  String get privacyOptionDescription =>
      'Configure how data is collected and used';

  @override
  String get recurringTransactions => 'Recurring Transactions';

  @override
  String get recurringTransactionsOptionDescription =>
      'Manage your recurring transaction rules';

  @override
  String get noRecurringTransactions =>
      'No recurring transactions yet. Create one to automate regular entries.';

  @override
  String get transactionShortcuts => 'Transaction Shortcuts';

  @override
  String get transactionShortcutsOptionDescription =>
      'Create presets for quick transaction entry';

  @override
  String get shortcuts => 'Shortcuts';

  @override
  String get newTransactionShortcut => 'New Shortcut';

  @override
  String get editTransactionShortcut => 'Edit Shortcut';

  @override
  String get noTransactionShortcuts =>
      'No shortcuts yet. Create one to add transactions with a single tap.';

  @override
  String get shortcutTransactionAdded => 'Transaction added successfully';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderDescription =>
      'Moneye will remind you every day, at a set time, to enter new transactions.\n\nYou will never forget to keep your data updated!';

  @override
  String get reminderOptionDescription =>
      'Set a reminder to remember to insert new transactions';

  @override
  String get repeatTransaction => 'Repeat transaction';

  @override
  String get reportBug => 'Report a bug';

  @override
  String get resetData => 'Erase all data';

  @override
  String get resetError => 'An error occurred while erasing data';

  @override
  String get saveError => 'Unable to save. Please try again.';

  @override
  String get resetSuccess => 'All data erased successfully';

  @override
  String get resetWarning =>
      'All your data will be permanently deleted. This action cannot be undone. Are you sure you want to proceed?';

  @override
  String get ruleDetails => 'Rule details';

  @override
  String get save => 'Save';

  @override
  String get saveToDevice => 'Save to device';

  @override
  String get savings => 'Savings';

  @override
  String get selectAccount => 'Select account';

  @override
  String get selectAccountMsg1 => 'Choose the accounts you want to monitor';

  @override
  String get selectAccountMsg2 =>
      'Cash, credit card, or others\nSelect what you\'d like to keep a close eye on.';

  @override
  String get selectCategory => 'Select the category';

  @override
  String get selectCategoryMsg1 =>
      'Make the most of Moneye by categorizing your transactions';

  @override
  String get selectCategoryMsg2 =>
      'Select from the preconfigured list or create your custom categories later';

  @override
  String get selectColor => 'Select color';

  @override
  String get selectCurrency => 'Select the currency';

  @override
  String get selectDate => 'Select the date';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get selectIcon => 'Select icon';

  @override
  String get selectTargetCategory => 'Select target category';

  @override
  String get selectTimeInterval => 'Select the time interval';

  @override
  String get sendTestNotification => 'Show me how it will appear';

  @override
  String get settings => 'Settings';

  @override
  String get shareBackup => 'Share backup';

  @override
  String get shopping => 'Shopping';

  @override
  String get skip => 'Skip';

  @override
  String get sports => 'Sports';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get suggestFeature => 'Suggest a feature';

  @override
  String get systemLanguageOption => 'Automatic (based on the system)';

  @override
  String get systemTheme => 'Automatic';

  @override
  String get testNotificationSent => 'Test notification sent!';

  @override
  String get theme => 'Theme';

  @override
  String get themeOptionDescription => 'Change the app appearance';

  @override
  String get title => 'Title';

  @override
  String get titleIsMandatory => 'The title is mandatory';

  @override
  String get today => 'Today';

  @override
  String get total => 'Total';

  @override
  String get totalBalance => 'Total balance';

  @override
  String get startDate => 'Start date';

  @override
  String get startsOnDayOfMonth => 'Starts on day of month';

  @override
  String get startsOnWeekday => 'Starts on weekday';

  @override
  String get selectAtLeastOneCategory => 'Please select at least one category';

  @override
  String get deleteBudgetConfirmation => 'Do you want to delete this budget?';

  @override
  String get budgetTitleHint => 'e.g. My Monthly Grocery Budget';

  @override
  String get budgetAmountHint => 'e.g. 500.00';

  @override
  String get budgetAmountInvalid => 'Enter a positive amount';

  @override
  String get rolloverMode => 'Rollover mode';

  @override
  String get carryRemaining => 'Carry forward remaining';

  @override
  String get carryOverspending => 'Carry forward overspending';

  @override
  String get rolloverModeNoneDescription =>
      'Unused money is not carried over. Each budget period starts fresh.';

  @override
  String get rolloverModeCarryRemainingDescription =>
      'Any unspent money is added to next period\'s budget.';

  @override
  String get rolloverModeCarryOverspendingDescription =>
      'If you overspend, the negative balance is carried into the next period.';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get transactionGeneratedByDeletedRule =>
      'This transaction was generated by a recurring rule that has since been deleted.';

  @override
  String get transactionGeneratedByRule =>
      'This transaction was generated automatically by a recurring rule. Editing this transaction will not affect future generated ones.';

  @override
  String get transactionList => 'Transaction list';

  @override
  String get transferTransactions => 'Transfer Transactions';

  @override
  String transferTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return 'Transfer $_temp0 to:';
  }

  @override
  String get transportation => 'Transportation';

  @override
  String get updateHistory => 'Update history';

  @override
  String get updateHistoryEmptyList => 'No updates found.';

  @override
  String get updateHistoryOptionDescription =>
      'View the latest features and updates';

  @override
  String get version => 'Version';

  @override
  String get viewAll => 'View all';

  @override
  String get viewRule => 'View rule';

  @override
  String get week => 'Week';

  @override
  String get weekly => 'Weekly';

  @override
  String weeklyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Weekly',
    );
    return '$_temp0';
  }

  @override
  String get welcomePageMsg1 => 'Welcome to Moneye!';

  @override
  String get welcomePageMsg2 =>
      'Let\'s get you started on your journey towards financial control.\nI’ll help you configure the app in just a few steps.';

  @override
  String get whatsNew => 'What\'s new';

  @override
  String get work => 'Work';

  @override
  String get year => 'Year';

  @override
  String get yearly => 'Yearly';

  @override
  String yearlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Yearly',
    );
    return '$_temp0';
  }

  @override
  String get yes => 'yes';

  @override
  String get correctBalance => 'Correct balance';

  @override
  String get currentCalculatedBalance => 'Current balance';

  @override
  String get realBalance => 'Real balance';

  @override
  String get realBalancePlaceholder =>
      'Enter the actual balance of the account';

  @override
  String get rebalanceAdjustment => 'Adjustment';

  @override
  String get rebalanceSuccess => 'Balance corrected successfully';

  @override
  String confirmTransferTransactionsMessage(
      int count, String source, String target) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0 will be transferred from $source to $target. Are you sure?';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get yourAccounts => 'Your accounts';

  @override
  String get yourCategories => 'Your categories';
}

/// The translations for English, as used in the United Kingdom (`en_GB`).
class AppLocalizationsEnGb extends AppLocalizationsEn {
  AppLocalizationsEnGb() : super('en_GB');

  @override
  String get aboutAndSupport => 'About & Support';

  @override
  String get accept => 'Accept';

  @override
  String get account => 'Account';

  @override
  String get accounts => 'Accounts';

  @override
  String get accountsOptionDescription =>
      'Manage the accounts and create new ones';

  @override
  String get addOne => 'add one';

  @override
  String get allTransactions => 'All transactions';

  @override
  String get amount => 'Amount';

  @override
  String get amountIsMandatory => 'The amount is mandatory';

  @override
  String get analyticsAlertDescription =>
      'Your privacy is important.\nIf you accept, anonymous usage data will be collected to understand how features are used and how to improve the app.\nNo personal data, location data, transaction details, account information, or other sensitive information will be collected.\n\nThis option can be disabled at any time in Settings.';

  @override
  String get analyticsAlertTitle => 'Help improve the app';

  @override
  String get analyticsOptionDescription =>
      'Anonymous data about feature usage used to plan future developments.\nNo personal data is collected.';

  @override
  String get analyticsOptionTitle => 'Anonymous usage statistics';

  @override
  String get applyChanges => 'Apply changes';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get atTheEnd => 'At the end';

  @override
  String get atTheStart => 'At the start';

  @override
  String get back => 'Back';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get backupAndRestoreOptionDescription => 'Export or import your data';

  @override
  String get balance => 'Balance';

  @override
  String get bills => 'Bills';

  @override
  String get billsAndUtilities => 'Bills & Utilities';

  @override
  String get byCategory => 'By category';

  @override
  String get byList => 'By list';

  @override
  String get cancel => 'Cancel';

  @override
  String get cash => 'Cash';

  @override
  String get categories => 'Categories';

  @override
  String get categoriesOptionDescription =>
      'Manage the categories and create new ones';

  @override
  String get budgeting => 'Budgeting';

  @override
  String get statistics => 'Statistics';

  @override
  String get newBudget => 'New budget';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get amountSpentOf => 'spent of';

  @override
  String get amountRemaining => 'remaining';

  @override
  String get overBudget => 'over budget';

  @override
  String get rollover => 'Rollover';

  @override
  String get budgetDuration => 'Budget duration';

  @override
  String get selectCategories => 'Select categories';

  @override
  String get allCategories => 'All categories';

  @override
  String get allCategoriesDescription =>
      'Includes every category, including ones you add later';

  @override
  String get category => 'Category';

  @override
  String get color => 'Colour';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactsDescription =>
      'Contact the developer to report a bug or suggest a feature';

  @override
  String get contactsPageHeader =>
      'You can contact me to report a bug, suggest a feature, or whatever you want!';

  @override
  String get continueCTA => 'Continue';

  @override
  String get crashTest => 'Crash Test (Debug Only)';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get currency => 'Currency';

  @override
  String get currencyConversionDisclaimer =>
      'Note: Changing the currency displayed in the app will not result in transaction amount conversions.';

  @override
  String get currencyPosition => 'Position of the currency symbol';

  @override
  String get daily => 'Daily';

  @override
  String dailyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Daily',
    );
    return '$_temp0';
  }

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get dailyReminderChannelDescription =>
      'Notifications to remind you to enter your daily transactions.';

  @override
  String get dailyReminderChannelName => 'Daily Reminders';

  @override
  String get darkTheme => 'Dark';

  @override
  String get dataAndPrivacy => 'Data & Privacy';

  @override
  String get date => 'Date';

  @override
  String get day => 'Day';

  @override
  String get debitCard => 'Debit Card';

  @override
  String get decline => 'Decline';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccountAlertBody =>
      'Deleting an account will not remove the transactions associated with it.';

  @override
  String get deleteCategoryAlertBody =>
      'Deleting a category will not remove the transactions associated with it.';

  @override
  String get deleteCategoryTitle => 'Delete Category';

  @override
  String deleteCategoryTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return 'This category contains $_temp0. What would you like to do?';
  }

  @override
  String get description => 'Description';

  @override
  String get done => 'Done';

  @override
  String get confirm => 'Confirm';

  @override
  String get edit => 'Edit';

  @override
  String get editAccount => 'Edit account';

  @override
  String get editCategory => 'Edit category';

  @override
  String get editRecurringTransaction => 'Edit repeating transaction';

  @override
  String get editRuleInfo =>
      'Changes to this recurring rule will not affect transactions that have already been generated.';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get education => 'Education';

  @override
  String get endConfigurationMsg1 =>
      'Congratulations! Moneye is now configured and ready to help you manage your expenses efficiently.';

  @override
  String get endConfigurationMsg2 =>
      'Don\'t forget to explore other exciting features to optimise your financial journey.';

  @override
  String get endDate => 'End date';

  @override
  String get endDateInfo =>
      'The date after which no other transactions of this kind will be automatically generated.';

  @override
  String endedOn(String date) {
    return 'Ended on $date';
  }

  @override
  String get entertainment => 'Entertainment';

  @override
  String get essentialDataOptionDescription =>
      'Anonymous data about crashes and errors used to ensure the proper functioning of the app.';

  @override
  String get essentialDataOptionTitle => 'Essential technical data';

  @override
  String get expense => 'Expense';

  @override
  String get expenses => 'Expenses';

  @override
  String get exportError => 'An error occurred while exporting data';

  @override
  String get exportSuccess => 'Data exported successfully';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackAndReviewOptionDescription =>
      'Do you like Moneye? Let us know!';

  @override
  String get finance => 'Finance';

  @override
  String get financialOverviewForThisMonth =>
      'The financial overview for this month';

  @override
  String get foodAndDining => 'Food & Dining';

  @override
  String get frequency => 'Frequency';

  @override
  String get generatedTransactions => 'Generated transactions';

  @override
  String generatedTransactionsSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recurring transactions generated',
      one: '1 recurring transaction generated',
    );
    return '$_temp0';
  }

  @override
  String get health => 'Health';

  @override
  String get icon => 'Icon';

  @override
  String get importData => 'Import data';

  @override
  String get importError => 'An error occurred while importing data';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get importWarning =>
      'Importing a backup will delete all current data. Are you sure you want to proceed?';

  @override
  String get includeInReports => 'Include in reports';

  @override
  String get income => 'Income';

  @override
  String get incomes => 'Incomes';

  @override
  String get initialBalance => 'Initial balance';

  @override
  String get initialBalancePlaceholder =>
      'Insert the initial balance of the account';

  @override
  String get insertTheAccountName => 'Insert the account name';

  @override
  String get insertTheAmountOfTheTransaction =>
      'Insert the amount of the transaction';

  @override
  String get insertTheDescription => 'Insert a description';

  @override
  String get insertTheTitleOfTheCategory => 'Insert the title of the category';

  @override
  String get insertTheTitleOfTheTransaction =>
      'Insert the title of the transaction';

  @override
  String get interval => 'Interval';

  @override
  String get language => 'Language';

  @override
  String get languageOptionDescription => 'Select the language used in the app';

  @override
  String get lastTransactions => 'Last transactions';

  @override
  String get lightTheme => 'Light';

  @override
  String get management => 'Management';

  @override
  String get month => 'Month';

  @override
  String get monthly => 'Monthly';

  @override
  String monthlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Monthly',
    );
    return '$_temp0';
  }

  @override
  String get newAccount => 'New account';

  @override
  String get newCategory => 'New category';

  @override
  String get newRecurringTransaction => 'New repeating transaction';

  @override
  String get newTransaction => 'New transaction';

  @override
  String get nextDate => 'Next date';

  @override
  String get no => 'no';

  @override
  String get noAccountAdded => 'No account added,';

  @override
  String get noAccounts => 'No accounts';

  @override
  String get noAccountsListMessage =>
      'No accounts yet. Create one to track your balances.';

  @override
  String get noBudgetsYet => 'No budgets yet';

  @override
  String get noCategories => 'No categories';

  @override
  String get noCategoriesListMessage =>
      'No categories yet. Create one to organize your transactions.';

  @override
  String get none => 'None';

  @override
  String get notificationSubtitle =>
      'Remember to enter your daily transactions!';

  @override
  String get notificationTitle => 'Moneye';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get other => 'Other';

  @override
  String get personalization => 'Personalisation';

  @override
  String get petExpenses => 'Pet Expenses';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyAssurance =>
      'Privacy is a priority. Names, emails, transaction amounts, or any data that could identify the user are never collected. All reports are strictly anonymous.';

  @override
  String get privacyAssuranceLabel => 'Privacy Assurance';

  @override
  String get privacyIntroduction =>
      'Choose which data can be collected to help improve the app and ensure its stability.';

  @override
  String get privacyOptionDescription =>
      'Configure how data is collected and used';

  @override
  String get recurringTransactions => 'Recurring Transactions';

  @override
  String get recurringTransactionsOptionDescription =>
      'Manage your recurring transaction rules';

  @override
  String get noRecurringTransactions =>
      'No recurring transactions yet. Create one to automate regular entries.';

  @override
  String get transactionShortcuts => 'Transaction Shortcuts';

  @override
  String get transactionShortcutsOptionDescription =>
      'Create presets for quick transaction entry';

  @override
  String get shortcuts => 'Shortcuts';

  @override
  String get newTransactionShortcut => 'New Shortcut';

  @override
  String get editTransactionShortcut => 'Edit Shortcut';

  @override
  String get noTransactionShortcuts =>
      'No shortcuts yet. Create one to add transactions with a single tap.';

  @override
  String get shortcutTransactionAdded => 'Transaction added successfully';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderDescription =>
      'Moneye will remind you every day, at a set time, to enter new transactions.\n\nYou will never forget to keep your data updated!';

  @override
  String get reminderOptionDescription =>
      'Set a reminder to remember to insert new transactions';

  @override
  String get repeatTransaction => 'Repeat transaction';

  @override
  String get reportBug => 'Report a bug';

  @override
  String get resetData => 'Erase all data';

  @override
  String get resetError => 'An error occurred while erasing data';

  @override
  String get resetSuccess => 'All data erased successfully';

  @override
  String get resetWarning =>
      'All your data will be permanently deleted. This action cannot be undone. Are you sure you want to proceed?';

  @override
  String get ruleDetails => 'Rule details';

  @override
  String get save => 'Save';

  @override
  String get saveToDevice => 'Save to device';

  @override
  String get savings => 'Savings';

  @override
  String get selectAccount => 'Select account';

  @override
  String get selectAccountMsg1 => 'Choose the accounts you want to monitor';

  @override
  String get selectAccountMsg2 =>
      'Cash, credit card, or others\nSelect what you\'d like to keep a close eye on.';

  @override
  String get selectCategory => 'Select the category';

  @override
  String get selectCategoryMsg1 =>
      'Make the most of Moneye by categorising your transactions';

  @override
  String get selectCategoryMsg2 =>
      'Select from the preconfigured list or create your custom categories later';

  @override
  String get selectColor => 'Select colour';

  @override
  String get selectCurrency => 'Select the currency';

  @override
  String get selectDate => 'Select the date';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get selectIcon => 'Select icon';

  @override
  String get selectTargetCategory => 'Select target category';

  @override
  String get selectTimeInterval => 'Select the time interval';

  @override
  String get sendTestNotification => 'Show me how it will appear';

  @override
  String get settings => 'Settings';

  @override
  String get shareBackup => 'Share backup';

  @override
  String get shopping => 'Shopping';

  @override
  String get skip => 'Skip';

  @override
  String get sports => 'Sports';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get suggestFeature => 'Suggest a feature';

  @override
  String get systemLanguageOption => 'Automatic (based on the system)';

  @override
  String get systemTheme => 'Automatic';

  @override
  String get testNotificationSent => 'Test notification sent!';

  @override
  String get theme => 'Theme';

  @override
  String get themeOptionDescription => 'Change the app appearance';

  @override
  String get title => 'Title';

  @override
  String get titleIsMandatory => 'The title is mandatory';

  @override
  String get today => 'Today';

  @override
  String get total => 'Total';

  @override
  String get totalBalance => 'Total balance';

  @override
  String get startDate => 'Start date';

  @override
  String get startsOnDayOfMonth => 'Starts on day of month';

  @override
  String get startsOnWeekday => 'Starts on weekday';

  @override
  String get selectAtLeastOneCategory => 'Please select at least one category';

  @override
  String get deleteBudgetConfirmation => 'Do you want to delete this budget?';

  @override
  String get budgetTitleHint => 'e.g. My Monthly Grocery Budget';

  @override
  String get budgetAmountHint => 'e.g. 500.00';

  @override
  String get budgetAmountInvalid => 'Enter a positive amount';

  @override
  String get rolloverMode => 'Rollover mode';

  @override
  String get carryRemaining => 'Carry forward remaining';

  @override
  String get carryOverspending => 'Carry forward overspending';

  @override
  String get rolloverModeNoneDescription =>
      'Unused money is not carried over. Each budget period starts fresh.';

  @override
  String get rolloverModeCarryRemainingDescription =>
      'Any unspent money is added to next period\'s budget.';

  @override
  String get rolloverModeCarryOverspendingDescription =>
      'If you overspend, the negative balance is carried into the next period.';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get transactionGeneratedByDeletedRule =>
      'This transaction was generated by a recurring rule that has since been deleted.';

  @override
  String get transactionGeneratedByRule =>
      'This transaction was generated automatically by a recurring rule. Editing this transaction will not affect future generated ones.';

  @override
  String get transactionList => 'Transaction list';

  @override
  String get transferTransactions => 'Transfer Transactions';

  @override
  String transferTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return 'Transfer $_temp0 to:';
  }

  @override
  String get transportation => 'Transport';

  @override
  String get updateHistory => 'Update history';

  @override
  String get updateHistoryEmptyList => 'No updates found.';

  @override
  String get updateHistoryOptionDescription =>
      'View the latest features and updates';

  @override
  String get version => 'Version';

  @override
  String get viewAll => 'View all';

  @override
  String get viewRule => 'View rule';

  @override
  String get week => 'Week';

  @override
  String get weekly => 'Weekly';

  @override
  String weeklyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Weekly',
    );
    return '$_temp0';
  }

  @override
  String get welcomePageMsg1 => 'Welcome to Moneye!';

  @override
  String get welcomePageMsg2 =>
      'Let\'s get you started on your journey towards financial control.\nI’ll help you configure the app in just a few steps.';

  @override
  String get whatsNew => 'What\'s new';

  @override
  String get work => 'Work';

  @override
  String get year => 'Year';

  @override
  String get yearly => 'Yearly';

  @override
  String yearlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Yearly',
    );
    return '$_temp0';
  }

  @override
  String get yes => 'yes';

  @override
  String get correctBalance => 'Correct balance';

  @override
  String get currentCalculatedBalance => 'Current balance';

  @override
  String get realBalance => 'Real balance';

  @override
  String get realBalancePlaceholder =>
      'Enter the actual balance of the account';

  @override
  String get rebalanceAdjustment => 'Adjustment';

  @override
  String get rebalanceSuccess => 'Balance corrected successfully';

  @override
  String confirmTransferTransactionsMessage(
      int count, String source, String target) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0 will be transferred from $source to $target. Are you sure?';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get yourAccounts => 'Your accounts';

  @override
  String get yourCategories => 'Your categories';
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get aboutAndSupport => 'About & Support';

  @override
  String get accept => 'Accept';

  @override
  String get account => 'Account';

  @override
  String get accounts => 'Accounts';

  @override
  String get accountsOptionDescription =>
      'Manage the accounts and create new ones';

  @override
  String get addOne => 'add one';

  @override
  String get allTransactions => 'All transactions';

  @override
  String get amount => 'Amount';

  @override
  String get amountIsMandatory => 'The amount is mandatory';

  @override
  String get analyticsAlertDescription =>
      'Your privacy is important.\nIf you accept, anonymous usage data will be collected to understand how features are used and how to improve the app.\nNo personal data, location data, transaction details, account information, or other sensitive information will be collected.\n\nThis option can be disabled at any time in Settings.';

  @override
  String get analyticsAlertTitle => 'Help improve the app';

  @override
  String get analyticsOptionDescription =>
      'Anonymous data about feature usage used to plan future developments.\nNo personal data is collected.';

  @override
  String get analyticsOptionTitle => 'Anonymous usage statistics';

  @override
  String get applyChanges => 'Apply changes';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get atTheEnd => 'At the end';

  @override
  String get atTheStart => 'At the start';

  @override
  String get back => 'Back';

  @override
  String get backupAndRestore => 'Backup & Restore';

  @override
  String get backupAndRestoreOptionDescription => 'Export or import your data';

  @override
  String get balance => 'Balance';

  @override
  String get bills => 'Bills';

  @override
  String get billsAndUtilities => 'Bills & Utilities';

  @override
  String get byCategory => 'By category';

  @override
  String get byList => 'By list';

  @override
  String get cancel => 'Cancel';

  @override
  String get cash => 'Cash';

  @override
  String get categories => 'Categories';

  @override
  String get categoriesOptionDescription =>
      'Manage the categories and create new ones';

  @override
  String get budgeting => 'Budgeting';

  @override
  String get statistics => 'Statistics';

  @override
  String get newBudget => 'New budget';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get amountSpentOf => 'spent of';

  @override
  String get amountRemaining => 'remaining';

  @override
  String get overBudget => 'over budget';

  @override
  String get rollover => 'Rollover';

  @override
  String get budgetDuration => 'Budget duration';

  @override
  String get selectCategories => 'Select categories';

  @override
  String get allCategories => 'All categories';

  @override
  String get allCategoriesDescription =>
      'Includes every category, including ones you add later';

  @override
  String get category => 'Category';

  @override
  String get color => 'Color';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactsDescription =>
      'Contact the developer to report a bug or suggest a feature';

  @override
  String get contactsPageHeader =>
      'You can contact me to report a bug, suggest a feature, or whatever you want!';

  @override
  String get continueCTA => 'Continue';

  @override
  String get crashTest => 'Crash Test (Debug Only)';

  @override
  String get creditCard => 'Credit Card';

  @override
  String get currency => 'Currency';

  @override
  String get currencyConversionDisclaimer =>
      'Note: Changing the currency displayed in the app will not result in transaction amount conversions.';

  @override
  String get currencyPosition => 'Position of the currency symbol';

  @override
  String get daily => 'Daily';

  @override
  String dailyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Daily',
    );
    return '$_temp0';
  }

  @override
  String get dailyReminder => 'Daily reminder';

  @override
  String get dailyReminderChannelDescription =>
      'Notifications to remind you to enter your daily transactions.';

  @override
  String get dailyReminderChannelName => 'Daily Reminders';

  @override
  String get darkTheme => 'Dark';

  @override
  String get dataAndPrivacy => 'Data & Privacy';

  @override
  String get date => 'Date';

  @override
  String get day => 'Day';

  @override
  String get debitCard => 'Debit Card';

  @override
  String get decline => 'Decline';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccountAlertBody =>
      'Deleting an account will not remove the transactions associated with it.';

  @override
  String get deleteCategoryAlertBody =>
      'Deleting a category will not remove the transactions associated with it.';

  @override
  String get deleteCategoryTitle => 'Delete Category';

  @override
  String deleteCategoryTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return 'This category contains $_temp0. What would you like to do?';
  }

  @override
  String get description => 'Description';

  @override
  String get done => 'Done';

  @override
  String get confirm => 'Confirm';

  @override
  String get edit => 'Edit';

  @override
  String get editAccount => 'Edit account';

  @override
  String get editCategory => 'Edit category';

  @override
  String get editRecurringTransaction => 'Edit repeating transaction';

  @override
  String get editRuleInfo =>
      'Changes to this recurring rule will not affect transactions that have already been generated.';

  @override
  String get editTransaction => 'Edit transaction';

  @override
  String get education => 'Education';

  @override
  String get endConfigurationMsg1 =>
      'Congratulations! Moneye is now configured and ready to help you manage your expenses efficiently.';

  @override
  String get endConfigurationMsg2 =>
      'Don\'t forget to explore other exciting features to optimize your financial journey.';

  @override
  String get endDate => 'End date';

  @override
  String get endDateInfo =>
      'The date after which no other transactions of this kind will be automatically generated.';

  @override
  String endedOn(String date) {
    return 'Ended on $date';
  }

  @override
  String get entertainment => 'Entertainment';

  @override
  String get essentialDataOptionDescription =>
      'Anonymous data about crashes and errors used to ensure the proper functioning of the app.';

  @override
  String get essentialDataOptionTitle => 'Essential technical data';

  @override
  String get expense => 'Expense';

  @override
  String get expenses => 'Expenses';

  @override
  String get exportError => 'An error occurred while exporting data';

  @override
  String get exportSuccess => 'Data exported successfully';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedbackAndReviewOptionDescription =>
      'Do you like Moneye? Let us know!';

  @override
  String get finance => 'Finance';

  @override
  String get financialOverviewForThisMonth =>
      'The financial overview for this month';

  @override
  String get foodAndDining => 'Food & Dining';

  @override
  String get frequency => 'Frequency';

  @override
  String get generatedTransactions => 'Generated transactions';

  @override
  String generatedTransactionsSnackbar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recurring transactions generated',
      one: '1 recurring transaction generated',
    );
    return '$_temp0';
  }

  @override
  String get health => 'Health';

  @override
  String get icon => 'Icon';

  @override
  String get importData => 'Import data';

  @override
  String get importError => 'An error occurred while importing data';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get importWarning =>
      'Importing a backup will delete all current data. Are you sure you want to proceed?';

  @override
  String get includeInReports => 'Include in reports';

  @override
  String get income => 'Income';

  @override
  String get incomes => 'Incomes';

  @override
  String get initialBalance => 'Initial balance';

  @override
  String get initialBalancePlaceholder =>
      'Insert the initial balance of the account';

  @override
  String get insertTheAccountName => 'Insert the account name';

  @override
  String get insertTheAmountOfTheTransaction =>
      'Insert the amount of the transaction';

  @override
  String get insertTheDescription => 'Insert a description';

  @override
  String get insertTheTitleOfTheCategory => 'Insert the title of the category';

  @override
  String get insertTheTitleOfTheTransaction =>
      'Insert the title of the transaction';

  @override
  String get interval => 'Interval';

  @override
  String get language => 'Language';

  @override
  String get languageOptionDescription => 'Select the language used in the app';

  @override
  String get lastTransactions => 'Last transactions';

  @override
  String get lightTheme => 'Light';

  @override
  String get management => 'Management';

  @override
  String get month => 'Month';

  @override
  String get monthly => 'Monthly';

  @override
  String monthlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Monthly',
    );
    return '$_temp0';
  }

  @override
  String get newAccount => 'New account';

  @override
  String get newCategory => 'New category';

  @override
  String get newRecurringTransaction => 'New repeating transaction';

  @override
  String get newTransaction => 'New transaction';

  @override
  String get nextDate => 'Next date';

  @override
  String get no => 'no';

  @override
  String get noAccountAdded => 'No account added,';

  @override
  String get noAccounts => 'No accounts';

  @override
  String get noAccountsListMessage =>
      'No accounts yet. Create one to track your balances.';

  @override
  String get noBudgetsYet => 'No budgets yet';

  @override
  String get noCategories => 'No categories';

  @override
  String get noCategoriesListMessage =>
      'No categories yet. Create one to organize your transactions.';

  @override
  String get none => 'None';

  @override
  String get notificationSubtitle =>
      'Remember to enter your daily transactions!';

  @override
  String get notificationTitle => 'Moneye';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get other => 'Other';

  @override
  String get personalization => 'Personalization';

  @override
  String get petExpenses => 'Pet Expenses';

  @override
  String get privacy => 'Privacy';

  @override
  String get privacyAssurance =>
      'Privacy is a priority. Names, emails, transaction amounts, or any data that could identify the user are never collected. All reports are strictly anonymous.';

  @override
  String get privacyAssuranceLabel => 'Privacy Assurance';

  @override
  String get privacyIntroduction =>
      'Choose which data can be collected to help improve the app and ensure its stability.';

  @override
  String get privacyOptionDescription =>
      'Configure how data is collected and used';

  @override
  String get recurringTransactions => 'Recurring Transactions';

  @override
  String get recurringTransactionsOptionDescription =>
      'Manage your recurring transaction rules';

  @override
  String get noRecurringTransactions =>
      'No recurring transactions yet. Create one to automate regular entries.';

  @override
  String get transactionShortcuts => 'Transaction Shortcuts';

  @override
  String get transactionShortcutsOptionDescription =>
      'Create presets for quick transaction entry';

  @override
  String get shortcuts => 'Shortcuts';

  @override
  String get newTransactionShortcut => 'New Shortcut';

  @override
  String get editTransactionShortcut => 'Edit Shortcut';

  @override
  String get noTransactionShortcuts =>
      'No shortcuts yet. Create one to add transactions with a single tap.';

  @override
  String get shortcutTransactionAdded => 'Transaction added successfully';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderDescription =>
      'Moneye will remind you every day, at a set time, to enter new transactions.\n\nYou will never forget to keep your data updated!';

  @override
  String get reminderOptionDescription =>
      'Set a reminder to remember to insert new transactions';

  @override
  String get repeatTransaction => 'Repeat transaction';

  @override
  String get reportBug => 'Report a bug';

  @override
  String get resetData => 'Erase all data';

  @override
  String get resetError => 'An error occurred while erasing data';

  @override
  String get resetSuccess => 'All data erased successfully';

  @override
  String get resetWarning =>
      'All your data will be permanently deleted. This action cannot be undone. Are you sure you want to proceed?';

  @override
  String get ruleDetails => 'Rule details';

  @override
  String get save => 'Save';

  @override
  String get saveToDevice => 'Save to device';

  @override
  String get savings => 'Savings';

  @override
  String get selectAccount => 'Select account';

  @override
  String get selectAccountMsg1 => 'Choose the accounts you want to monitor';

  @override
  String get selectAccountMsg2 =>
      'Cash, credit card, or others\nSelect what you\'d like to keep a close eye on.';

  @override
  String get selectCategory => 'Select the category';

  @override
  String get selectCategoryMsg1 =>
      'Make the most of Moneye by categorizing your transactions';

  @override
  String get selectCategoryMsg2 =>
      'Select from the preconfigured list or create your custom categories later';

  @override
  String get selectColor => 'Select color';

  @override
  String get selectCurrency => 'Select the currency';

  @override
  String get selectDate => 'Select the date';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get selectIcon => 'Select icon';

  @override
  String get selectTargetCategory => 'Select target category';

  @override
  String get selectTimeInterval => 'Select the time interval';

  @override
  String get sendTestNotification => 'Show me how it will appear';

  @override
  String get settings => 'Settings';

  @override
  String get shareBackup => 'Share backup';

  @override
  String get shopping => 'Shopping';

  @override
  String get skip => 'Skip';

  @override
  String get sports => 'Sports';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get suggestFeature => 'Suggest a feature';

  @override
  String get systemLanguageOption => 'Automatic (based on the system)';

  @override
  String get systemTheme => 'Automatic';

  @override
  String get testNotificationSent => 'Test notification sent!';

  @override
  String get theme => 'Theme';

  @override
  String get themeOptionDescription => 'Change the app appearance';

  @override
  String get title => 'Title';

  @override
  String get titleIsMandatory => 'The title is mandatory';

  @override
  String get today => 'Today';

  @override
  String get total => 'Total';

  @override
  String get totalBalance => 'Total balance';

  @override
  String get startDate => 'Start date';

  @override
  String get startsOnDayOfMonth => 'Starts on day of month';

  @override
  String get startsOnWeekday => 'Starts on weekday';

  @override
  String get selectAtLeastOneCategory => 'Please select at least one category';

  @override
  String get deleteBudgetConfirmation => 'Do you want to delete this budget?';

  @override
  String get budgetTitleHint => 'e.g. My Monthly Grocery Budget';

  @override
  String get budgetAmountHint => 'e.g. 500.00';

  @override
  String get budgetAmountInvalid => 'Enter a positive amount';

  @override
  String get rolloverMode => 'Rollover mode';

  @override
  String get carryRemaining => 'Carry forward remaining';

  @override
  String get carryOverspending => 'Carry forward overspending';

  @override
  String get rolloverModeNoneDescription =>
      'Unused money is not carried over. Each budget period starts fresh.';

  @override
  String get rolloverModeCarryRemainingDescription =>
      'Any unspent money is added to next period\'s budget.';

  @override
  String get rolloverModeCarryOverspendingDescription =>
      'If you overspend, the negative balance is carried into the next period.';

  @override
  String get transactionDeleted => 'Transaction deleted';

  @override
  String get transactionGeneratedByDeletedRule =>
      'This transaction was generated by a recurring rule that has since been deleted.';

  @override
  String get transactionGeneratedByRule =>
      'This transaction was generated automatically by a recurring rule. Editing this transaction will not affect future generated ones.';

  @override
  String get transactionList => 'Transaction list';

  @override
  String get transferTransactions => 'Transfer Transactions';

  @override
  String transferTransactionsMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return 'Transfer $_temp0 to:';
  }

  @override
  String get transportation => 'Transportation';

  @override
  String get updateHistory => 'Update history';

  @override
  String get updateHistoryEmptyList => 'No updates found.';

  @override
  String get updateHistoryOptionDescription =>
      'View the latest features and updates';

  @override
  String get version => 'Version';

  @override
  String get viewAll => 'View all';

  @override
  String get viewRule => 'View rule';

  @override
  String get week => 'Week';

  @override
  String get weekly => 'Weekly';

  @override
  String weeklyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Weekly',
    );
    return '$_temp0';
  }

  @override
  String get welcomePageMsg1 => 'Welcome to Moneye!';

  @override
  String get welcomePageMsg2 =>
      'Let\'s get you started on your journey towards financial control.\nI’ll help you configure the app in just a few steps.';

  @override
  String get whatsNew => 'What\'s new';

  @override
  String get work => 'Work';

  @override
  String get year => 'Year';

  @override
  String get yearly => 'Yearly';

  @override
  String yearlyInterval(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Yearly',
    );
    return '$_temp0';
  }

  @override
  String get yes => 'yes';

  @override
  String get correctBalance => 'Correct balance';

  @override
  String get currentCalculatedBalance => 'Current balance';

  @override
  String get realBalance => 'Real balance';

  @override
  String get realBalancePlaceholder =>
      'Enter the actual balance of the account';

  @override
  String get rebalanceAdjustment => 'Adjustment';

  @override
  String get rebalanceSuccess => 'Balance corrected successfully';

  @override
  String confirmTransferTransactionsMessage(
      int count, String source, String target) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
    );
    return '$_temp0 will be transferred from $source to $target. Are you sure?';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String get yourAccounts => 'Your accounts';

  @override
  String get yourCategories => 'Your categories';
}
