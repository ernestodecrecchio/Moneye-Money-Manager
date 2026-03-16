import 'dart:convert';
import 'dart:io';
import 'package:expense_tracker/data/database/database_account_helper.dart';
import 'package:expense_tracker/data/database/database_category_helper.dart';
import 'package:expense_tracker/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/transaction.dart' as trans;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
    );

    final data = {
      'categories': categories.map((e) => e.toJson()).toList(),
      'accounts': accounts.map((e) => e.toJson()).toList(),
      'transactions': transactions.map((e) => e.toJson()).toList(),
      'exportDate': DateTime.now().toIso8601String(),
      'version': 1,
    };

    return jsonEncode(data);
  }

  Future<void> exportDatabase() async {
    final jsonString = await _generateBackupJson();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/moneye_backup.json');
    await file.writeAsString(jsonString);

    await SharePlus.instance.share(
      ShareParams(
        text: 'Moneye Backup',
        subject: 'subject',
        title: 'title',
        files: [XFile(file.path)],
      ),
    );
  }

  Future<bool> saveDatabaseLocally() async {
    final jsonString = await _generateBackupJson();

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save Moneye Backup',
      fileName: 'moneye_backup.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
      bytes: utf8.encode(jsonString),
    );

    return result != null;
  }

  Future<bool> importDatabase() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null || result.files.single.path == null) {
      return false;
    }

    final file = File(result.files.single.path!);
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    if (!data.containsKey('categories') ||
        !data.containsKey('accounts') ||
        !data.containsKey('transactions')) {
      throw Exception('Invalid backup file');
    }

    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      // Clear existing data
      await txn.delete(trans.transactionsTable);
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

      // Import Transactions
      final transactionsJson = data['transactions'] as List;
      for (var transJson in transactionsJson) {
        await txn.insert(
            trans.transactionsTable, transJson as Map<String, dynamic>);
      }
    });

    return true;
  }
}
