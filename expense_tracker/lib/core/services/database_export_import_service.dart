import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:expense_tracker/features/accounts/data/database/database_account_helper.dart';
import 'package:expense_tracker/features/categories/data/database/database_category_helper.dart';
import 'package:expense_tracker/features/transactions/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/features/recurring_rules/data/database/database_recurring_rule_helper.dart';
import 'package:expense_tracker/features/budgeting/data/database/database_budget_helper.dart';
import 'package:expense_tracker/features/transaction_shortcuts/data/database/database_transaction_shortcut_helper.dart';
import 'package:expense_tracker/core/database/database_helper.dart';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseExportImportService {
  static final DatabaseExportImportService instance =
      DatabaseExportImportService._init();
  DatabaseExportImportService._init();

  Future<String> _generateBackupJson() async {
    final categories = await DatabaseCategoryHelper.instance.getAllCategories();
    final accounts = await DatabaseAccountHelper.instance.getAllAccounts();
    final transactions =
        await DatabaseTransactionHelper.instance.getTransactions(
      null,
      null,
      null,
      null,
      true,
      true,
      null,
      null,
    );
    final recurringRules =
        await DatabaseRecurringRuleHelper.instance.getRecurringRules();
    final budgets = await DatabaseBudgetHelper.instance.getAllBudgets();
    final transactionShortcuts = await DatabaseTransactionShortcutHelper
        .instance
        .getAllTransactionShortcuts();
    final db = await DatabaseHelper.instance.database;
    final dbVersion = await db.getVersion();

    final backupData = {
      'version': dbVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'app': 'Moneye',
      'data': {
        'categories': categories.map((e) => CategoryMapper.toJson(e)).toList(),
        'accounts': accounts.map((e) => AccountMapper.toJson(e)).toList(),
        'recurringRules':
            recurringRules.map((e) => RecurringRuleMapper.toJson(e)).toList(),
        'transactions':
            transactions.map((e) => TransactionMapper.toJson(e)).toList(),
        // Budgets are mapped manually to include category relationships which are stored
        // in a separate join table (budget_categories) in the database.
        'budgets': budgets.map((e) {
          final json = BudgetMapper.toJson(e);
          json['categoryIds'] = e.categoryIds;
          return json;
        }).toList(),
        'transactionShortcuts': transactionShortcuts
            .map((e) => TransactionShortcutMapper.toJson(e))
            .toList(),
      },
    };

    return jsonEncode(backupData);
  }

  Future<void> exportDatabase() async {
    final jsonString = await _generateBackupJson();
    final jsonBytes = utf8.encode(jsonString);
    final timestamp = getTimestamp();

    // Create ZIP archive
    final archive = Archive();
    archive.addFile(
      ArchiveFile('moneye_backup_$timestamp.json', jsonBytes.length, jsonBytes),
    );

    final zipBytes = ZipEncoder().encode(archive);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/moneye_backup_$timestamp.zip');
    await file.writeAsBytes(zipBytes);

    await SharePlus.instance.share(
      ShareParams(
        text: 'Moneye Backup',
        subject: 'Moneye Backup',
        title: 'Moneye Backup',
        files: [XFile(file.path)],
      ),
    );
  }

  Future<bool> saveDatabaseLocally() async {
    final jsonString = await _generateBackupJson();
    final jsonBytes = utf8.encode(jsonString);
    final timestamp = getTimestamp();

    // Create ZIP archive
    final archive = Archive();
    archive.addFile(
      ArchiveFile('moneye_backup_$timestamp.json', jsonBytes.length, jsonBytes),
    );

    final zipBytes = ZipEncoder().encode(archive);

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Moneye Backup',
      fileName: 'moneye_backup_$timestamp.zip',
      type: FileType.custom,
      allowedExtensions: ['zip'],
      bytes: Uint8List.fromList(zipBytes),
    );

    return result != null;
  }

  Future<bool> importDatabase() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null || result.files.single.path == null) {
      return false;
    }

    final file = File(result.files.single.path!);
    final zipBytes = await file.readAsBytes();

    // Decompress ZIP archive
    final archive = ZipDecoder().decodeBytes(zipBytes);

    // Find the backup JSON file (it should match moneye_backup_*.json)
    ArchiveFile? jsonFile;
    try {
      jsonFile = archive.files.firstWhere(
        (file) =>
            (file.name.startsWith('moneye_backup_')) &&
            file.name.endsWith('.json'),
      );
    } catch (_) {
      // Fallback for older backups or if naming convention changed slightly
      jsonFile = archive.findFile('moneye_backup.json');
    }

    if (jsonFile == null) {
      throw Exception('Invalid backup: Backup JSON file not found in ZIP');
    }

    final jsonString = utf8.decode(jsonFile.content as List<int>);
    final backup = jsonDecode(jsonString) as Map<String, dynamic>;

    if (!backup.containsKey('data') || backup['app'] != 'Moneye') {
      throw Exception('Invalid or incompatible backup file');
    }

    final data = backup['data'] as Map<String, dynamic>;

    if (!data.containsKey('categories') ||
        !data.containsKey('accounts') ||
        !data.containsKey('transactions') ||
        !data.containsKey('recurringRules')) {
      throw Exception('Backup file is missing required data components');
    }

    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      // Clear existing data
      await txn.delete(transactionShortcutsTable);
      await txn.delete(transactionsTable);
      await txn.delete(recurringRulesTable);
      await txn.delete(budgetCategoriesTable);
      await txn.delete(budgetsTable);
      await txn.delete(accountsTable);
      await txn.delete(categoriesTable);

      // Import Categories
      final categoriesJson = data['categories'] as List;
      for (var catJson in categoriesJson) {
        await txn.insert(categoriesTable, catJson as Map<String, dynamic>);
      }

      // Import Accounts
      final accountsJson = data['accounts'] as List;
      for (var accJson in accountsJson) {
        await txn.insert(accountsTable, accJson as Map<String, dynamic>);
      }

      // Import Recurring Rules
      final recurringRulesJson = data['recurringRules'] as List;
      for (var ruleJson in recurringRulesJson) {
        await txn.insert(recurringRulesTable, ruleJson as Map<String, dynamic>);
      }

      // Import Transactions
      final transactionsJson = data['transactions'] as List;
      for (var transJson in transactionsJson) {
        await txn.insert(transactionsTable, transJson as Map<String, dynamic>);
      }

      // Import Transaction Shortcuts
      if (data.containsKey('transactionShortcuts')) {
        final shortcutsJson = data['transactionShortcuts'] as List;
        for (var shortcutJson in shortcutsJson) {
          await txn.insert(
            transactionShortcutsTable,
            shortcutJson as Map<String, dynamic>,
          );
        }
      }

      // Import Budgets
      if (data.containsKey('budgets')) {
        final budgetsJson = data['budgets'] as List;
        for (var budgetEntry in budgetsJson) {
          final budgetMap = Map<String, dynamic>.from(budgetEntry as Map);
          // Extract category IDs stored in the JSON for the join table
          final categoryIds =
              (budgetMap['categoryIds'] as List?)?.cast<int>() ?? [];
          // Remove the temporary key before inserting into the budgets table
          budgetMap.remove('categoryIds');

          final budgetId = await txn.insert(budgetsTable, budgetMap);

          // Restore the many-to-many relationships in the budget_categories table
          final allCategories =
              (budgetMap[BudgetFields.allCategories] as int? ?? 0) == 1;
          if (!allCategories) {
            for (final categoryId in categoryIds) {
              await txn.insert(budgetCategoriesTable, {
                BudgetCategoryFields.budgetId: budgetId,
                BudgetCategoryFields.categoryId: categoryId,
              });
            }
          }
        }
      }
    });

    return true;
  }

  Future<void> resetDatabase() async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      await txn.delete(transactionShortcutsTable);
      await txn.delete(transactionsTable);
      await txn.delete(recurringRulesTable);
      await txn.delete(budgetCategoriesTable);
      await txn.delete(budgetsTable);
      await txn.delete(accountsTable);
      await txn.delete(categoriesTable);
    });
  }

  String getTimestamp() {
    final now = DateTime.now().toIso8601String();
    return now.replaceAll(':', '-').split('.').first;
  }
}
