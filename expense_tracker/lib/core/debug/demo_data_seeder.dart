import 'dart:math';

import 'package:expense_tracker/core/database/database_helper.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/features/accounts/data/database/database_account_helper.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_with_balance_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budget_progress_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budgets_list_notifier.dart';
import 'package:expense_tracker/features/categories/data/database/database_category_helper.dart';
import 'package:expense_tracker/features/categories/domain/models/category.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/net_worth_trend_notifier.dart';
import 'package:expense_tracker/features/statistics/presentation/providers/queries/overview_kpis_notifier.dart';
import 'package:expense_tracker/features/transactions/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/features/transactions/domain/models/transaction.dart'
    as trans;
import 'package:expense_tracker/features/transactions/presentation/providers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seeds the local database with demo accounts, categories, and transactions.
///
/// Debug-only helper. Delete this file and remove [DemoDataSeedButton] from the
/// privacy settings page when no longer needed.
class DemoDataSeeder {
  DemoDataSeeder._();

  static const _demoPrefix = '[Demo] ';
  static const _transactionsWithoutAccount = 8;

  static Future<DemoDataSeedResult> seed() async {
    final random = Random();
    final accountHelper = DatabaseAccountHelper.instance;
    final categoryHelper = DatabaseCategoryHelper.instance;
    final db = await DatabaseHelper.instance.database;

    final existingAccounts = await _findDemoAccounts(accountHelper);
    final existingCategories = await _findDemoCategories(categoryHelper);

    final accounts = existingAccounts.isNotEmpty
        ? existingAccounts
        : await _insertAccounts(accountHelper);
    final categories = existingCategories.isNotEmpty
        ? existingCategories
        : await _insertCategories(categoryHelper);

    final transactions = _buildTransactions(
      random: random,
      accountIds: accounts.map((account) => account.id!).toList(),
      categoryIds: categories.map((category) => category.id!).toList(),
    );

    final batch = db.batch();
    for (final transaction in transactions) {
      batch.insert(
        transactionsTable,
        TransactionMapper.toJson(transaction),
      );
    }
    await batch.commit(noResult: true);

    return DemoDataSeedResult(
      accountsCreated: existingAccounts.isEmpty ? accounts.length : 0,
      categoriesCreated: existingCategories.isEmpty ? categories.length : 0,
      transactionsCreated: transactions.length,
      reusedExistingAccounts: existingAccounts.isNotEmpty,
      reusedExistingCategories: existingCategories.isNotEmpty,
    );
  }

  static Future<List<Account>> _findDemoAccounts(
    DatabaseAccountHelper helper,
  ) async {
    final accounts = await helper.getAllAccounts();
    return accounts
        .where((account) => account.name.startsWith(_demoPrefix))
        .toList();
  }

  static Future<List<Category>> _findDemoCategories(
    DatabaseCategoryHelper helper,
  ) async {
    final categories = await helper.getAllCategories();
    return categories
        .where((category) => category.name.startsWith(_demoPrefix))
        .toList();
  }

  static Future<List<Account>> _insertAccounts(
    DatabaseAccountHelper helper,
  ) async {
    final templates = [
      (
        name: '${_demoPrefix}Checking',
        description: 'Primary day-to-day account',
        color: Colors.blue,
        iconPath: 'assets/icons/wallet.svg',
      ),
      (
        name: '${_demoPrefix}Savings',
        description: 'Long-term savings',
        color: Colors.green,
        iconPath: 'assets/icons/savings.svg',
      ),
      (
        name: '${_demoPrefix}Credit Card',
        description: 'Monthly card spending',
        color: Colors.deepOrange,
        iconPath: 'assets/icons/credit-card.svg',
      ),
      (
        name: '${_demoPrefix}Cash',
        description: 'Petty cash and ATM withdrawals',
        color: Colors.teal,
        iconPath: 'assets/icons/cash.svg',
      ),
    ];

    final accounts = <Account>[];
    for (final template in templates) {
      accounts.add(
        await helper.insertAccount(
          account: Account(
            name: template.name,
            description: template.description,
            colorValue: template.color.toARGB32(),
            iconPath: template.iconPath,
          ),
        ),
      );
    }
    return accounts;
  }

  static Future<List<Category>> _insertCategories(
    DatabaseCategoryHelper helper,
  ) async {
    final templates = [
      (
        name: '${_demoPrefix}Groceries',
        iconPath: 'assets/icons/food.svg',
        color: Colors.lightGreen,
      ),
      (
        name: '${_demoPrefix}Rent',
        iconPath: 'assets/icons/house.svg',
        color: Colors.brown,
      ),
      (
        name: '${_demoPrefix}Transport',
        iconPath: 'assets/icons/bus.svg',
        color: Colors.indigo,
      ),
      (
        name: '${_demoPrefix}Entertainment',
        iconPath: 'assets/icons/popcorn.svg',
        color: Colors.purple,
      ),
      (
        name: '${_demoPrefix}Health',
        iconPath: 'assets/icons/healthcare.svg',
        color: Colors.pink,
      ),
      (
        name: '${_demoPrefix}Shopping',
        iconPath: 'assets/icons/shopping-cart.svg',
        color: Colors.orange,
      ),
      (
        name: '${_demoPrefix}Salary',
        iconPath: 'assets/icons/cash.svg',
        color: Colors.green,
      ),
      (
        name: '${_demoPrefix}Utilities',
        iconPath: 'assets/icons/bill.svg',
        color: Colors.blueGrey,
      ),
    ];

    final categories = <Category>[];
    for (final template in templates) {
      categories.add(
        await helper.insertCategory(
          category: Category(
            name: template.name,
            description: 'Demo category for debugging charts and lists',
            colorValue: template.color.toARGB32(),
            iconPath: template.iconPath,
          ),
        ),
      );
    }
    return categories;
  }

  static List<trans.Transaction> _buildTransactions({
    required Random random,
    required List<int> accountIds,
    required List<int> categoryIds,
  }) {
    final now = DateTime.now();
    final periodDays = 480 + random.nextInt(121);
    final startDate = now.subtract(Duration(days: periodDays));
    final transactionCount = 200 + random.nextInt(31);
    final transactions = <trans.Transaction>[];

    final expenseTemplates = [
      ('Supermarket run', -12.50),
      ('Coffee shop', -4.20),
      ('Monthly rent', -850.00),
      ('Bus pass', -45.00),
      ('Cinema tickets', -28.00),
      ('Pharmacy', -18.75),
      ('Online order', -64.90),
      ('Electric bill', -92.30),
      ('Gas bill', -48.60),
      ('Restaurant dinner', -56.40),
      ('Train ticket', -22.10),
      ('Gym membership', -39.99),
      ('Grocery delivery', -73.15),
      ('Streaming subscription', -14.99),
      ('Home supplies', -31.80),
    ];

    final incomeTemplates = [
      ('Monthly salary', 2800.00),
      ('Freelance payment', 450.00),
      ('Cashback reward', 12.50),
      ('Interest payout', 8.40),
      ('Bonus', 320.00),
      ('Refund', 55.00),
    ];

    final indicesWithoutAccount =
        List.generate(transactionCount, (index) => index)..shuffle(random);
    final withoutAccountIndices =
        indicesWithoutAccount.take(_transactionsWithoutAccount).toSet();

    final withoutCategoryCount = 4 + random.nextInt(5);
    final indicesWithoutCategory =
        List.generate(transactionCount, (index) => index)..shuffle(random);
    final withoutCategoryIndices =
        indicesWithoutCategory.take(withoutCategoryCount).toSet();

    for (var index = 0; index < transactionCount; index++) {
      final hasNoAccount = withoutAccountIndices.contains(index);
      final hasNoCategory = withoutCategoryIndices.contains(index);
      final isIncome = random.nextDouble() < 0.18;

      final template = isIncome
          ? incomeTemplates[random.nextInt(incomeTemplates.length)]
          : expenseTemplates[random.nextInt(expenseTemplates.length)];

      final amountVariance = isIncome
          ? 0.85 + random.nextDouble() * 0.35
          : 0.7 + random.nextDouble() * 0.6;
      final amount = template.$2 * amountVariance;

      final dayOffset = random.nextInt(periodDays + 1);
      final date = startDate.add(Duration(days: dayOffset));

      transactions.add(
        trans.Transaction(
          title: '$_demoPrefix${template.$1}',
          description: 'Generated demo transaction #$index',
          amount: double.parse(amount.toStringAsFixed(2)),
          date: date,
          categoryId: hasNoCategory
              ? null
              : categoryIds[random.nextInt(categoryIds.length)],
          accountId: hasNoAccount
              ? null
              : accountIds[random.nextInt(accountIds.length)],
          includeInReports: true,
        ),
      );
    }

    transactions.sort((left, right) => left.date.compareTo(right.date));
    return transactions;
  }
}

class DemoDataSeedResult {
  const DemoDataSeedResult({
    required this.accountsCreated,
    required this.categoriesCreated,
    required this.transactionsCreated,
    required this.reusedExistingAccounts,
    required this.reusedExistingCategories,
  });

  final int accountsCreated;
  final int categoriesCreated;
  final int transactionsCreated;
  final bool reusedExistingAccounts;
  final bool reusedExistingCategories;

  String get message {
    final parts = <String>[];

    if (accountsCreated > 0) {
      parts.add('$accountsCreated accounts');
    } else if (reusedExistingAccounts) {
      parts.add('reused demo accounts');
    }

    if (categoriesCreated > 0) {
      parts.add('$categoriesCreated categories');
    } else if (reusedExistingCategories) {
      parts.add('reused demo categories');
    }

    parts.add('$transactionsCreated transactions');
    return 'Demo data loaded: ${parts.join(', ')}.';
  }
}

/// Debug button that seeds demo data and refreshes app providers.
class DemoDataSeedButton extends ConsumerStatefulWidget {
  const DemoDataSeedButton({super.key});

  @override
  ConsumerState<DemoDataSeedButton> createState() => _DemoDataSeedButtonState();
}

class _DemoDataSeedButtonState extends ConsumerState<DemoDataSeedButton> {
  bool _isLoading = false;

  Future<void> _seedDemoData() async {
    setState(() => _isLoading = true);

    try {
      final result = await DemoDataSeeder.seed();
      _refreshAppState(ref);

      if (!mounted) return;

      final colors = context.appColors;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: colors.income,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      final colors = context.appColors;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load demo data: $error'),
          backgroundColor: colors.expense,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _refreshAppState(WidgetRef ref) {
    ref.invalidate(accountsListProvider);
    ref.invalidate(categoriesListProvider);
    ref.invalidate(transactionsListProvider);
    ref.invalidate(totalBalanceProvider);
    ref.invalidate(accountsWithBalanceProvider);
    ref.invalidate(budgetsListProvider);
    ref.invalidate(budgetProgressProvider);
    ref.invalidate(overviewKpisProvider);
    ref.invalidate(netWorthTrendProvider);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _seedDemoData,
        icon: _isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.onPrimary,
                ),
              )
            : const Icon(Icons.dataset),
        label: Text(
          _isLoading ? 'Loading demo data...' : 'Load demo data (debug)',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
        ),
      ),
    );
  }
}
