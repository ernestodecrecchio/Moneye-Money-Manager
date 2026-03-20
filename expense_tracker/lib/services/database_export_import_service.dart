import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:expense_tracker/data/database/database_account_helper.dart';
import 'package:expense_tracker/data/database/database_category_helper.dart';
import 'package:expense_tracker/data/database/database_transaction_helper.dart';
import 'package:expense_tracker/data/database/database_recurring_rule_helper.dart';
import 'package:expense_tracker/data/database/database_helper.dart';
import 'package:expense_tracker/domain/models/account.dart';
import 'package:expense_tracker/domain/models/category.dart';
import 'package:expense_tracker/domain/models/recurring_rule.dart';
import 'package:expense_tracker/domain/models/transaction.dart' as trans;
import 'package:archive/archive.dart';
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
    final recurringRules =
        await DatabaseRecurringRuleHelper.instance.getRecurringRules();

    final backupData = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'app': 'Moneye',
      'data': {
        'categories': categories.map((e) => e.toJson()).toList(),
        'accounts': accounts.map((e) => e.toJson()).toList(),
        'recurringRules': recurringRules.map((e) => e.toJson()).toList(),
        'transactions': transactions.map((e) => e.toJson()).toList(),
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
      await txn.delete(trans.transactionsTable);
      await txn.delete(recurringRulesTable);
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
        await txn.insert(
            trans.transactionsTable, transJson as Map<String, dynamic>);
      }
    });

    return true;
  }

  Future<void> resetDatabase() async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      await txn.delete(trans.transactionsTable);
      await txn.delete(recurringRulesTable);
      await txn.delete(accountsTable);
      await txn.delete(categoriesTable);
    });
  }

  String getTimestamp() {
    final now = DateTime.now().toIso8601String();
    return now.replaceAll(':', '-').split('.').first;
  }
}
