/// Stable ids for coach marks. Order in [FeatureDiscoveryId.values] is not used
/// for display; each screen passes an explicit sequence list.
enum FeatureDiscoveryId {
  homeFab,
  budgetTab,
  repeatTransaction,
  includeInReports,
  budgetListFab,
  recurringTransactionsSettings,
  swipeToDelete,
  accountDetailCharts,
  budgetFormCategories,
  budgetFormRollover,
  balanceTrendBadge,
  homeBudgetSection,
  backupRestore,
}

extension FeatureDiscoveryIdX on FeatureDiscoveryId {
  String get storageKey => 'feature_discovery_seen_$name';

  String get title => switch (this) {
        FeatureDiscoveryId.homeFab => 'Log your first transaction',
        FeatureDiscoveryId.budgetTab => 'Plan with budgets',
        FeatureDiscoveryId.repeatTransaction => 'Automate recurring payments',
        FeatureDiscoveryId.includeInReports => 'Control what affects totals',
        FeatureDiscoveryId.budgetListFab => 'Create your first budget',
        FeatureDiscoveryId.recurringTransactionsSettings =>
          'Manage recurring rules',
        FeatureDiscoveryId.swipeToDelete => 'Swipe to delete',
        FeatureDiscoveryId.accountDetailCharts => 'Visual breakdown',
        FeatureDiscoveryId.budgetFormCategories => 'Limit specific spending',
        FeatureDiscoveryId.budgetFormRollover => 'Rollover unused budget',
        FeatureDiscoveryId.balanceTrendBadge => 'Balance trend',
        FeatureDiscoveryId.homeBudgetSection => 'Budgets on your dashboard',
        FeatureDiscoveryId.backupRestore => 'Back up your data',
      };

  String get description => switch (this) {
        FeatureDiscoveryId.homeFab =>
          'Tap here to add an expense or income. This is the fastest way to start tracking money.',
        FeatureDiscoveryId.budgetTab =>
          'Budgets live on their own tab. Set spending limits and track progress by category.',
        FeatureDiscoveryId.repeatTransaction =>
          'Turn this on for rent, subscriptions, or salary. Set frequency and an optional end date.',
        FeatureDiscoveryId.includeInReports =>
          'Turn off to keep a transaction in your history without affecting balances, charts, or budgets.',
        FeatureDiscoveryId.budgetListFab =>
          'Set a limit, pick categories, and choose how often the budget resets.',
        FeatureDiscoveryId.recurringTransactionsSettings =>
          'View and edit all repeating transactions in one place — separate from one-off entries.',
        FeatureDiscoveryId.swipeToDelete =>
          'Swipe a transaction left or right to delete it quickly.',
        FeatureDiscoveryId.accountDetailCharts =>
          'Swipe between charts to see spending patterns and category distribution for the selected period.',
        FeatureDiscoveryId.budgetFormCategories =>
          'Choose which categories count toward this budget. Spending outside them won\'t reduce the limit.',
        FeatureDiscoveryId.budgetFormRollover =>
          'Carry leftover money forward or carry overspending into the next period — or disable rollover entirely.',
        FeatureDiscoveryId.balanceTrendBadge =>
          'Compares your total balance at the end of this month vs last month.',
        FeatureDiscoveryId.homeBudgetSection =>
          'A quick preview of progress. Tap a budget to edit it, or open the Budget tab for the full list.',
        FeatureDiscoveryId.backupRestore =>
          'Export your database to share or save locally, then restore on a new device.',
      };
}
