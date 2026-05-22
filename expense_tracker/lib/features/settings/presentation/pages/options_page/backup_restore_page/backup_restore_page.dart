import 'package:expense_tracker/core/widgets/widgets/adaptive_dialog_action.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_list_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budget_progress_notifier.dart';
import 'package:expense_tracker/features/budgeting/presentation/providers/queries/budgets_list_notifier.dart';
import 'package:expense_tracker/features/categories/presentation/providers/queries/categories_list_notifier.dart';
import 'package:expense_tracker/core/presentation/providers/app_localizations_provider.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/total_balance_notifier.dart';
import 'package:expense_tracker/features/transactions/presentation/providers/queries/transactions_list_notifier.dart';
import 'package:expense_tracker/features/accounts/presentation/providers/queries/accounts_with_balance_notifier.dart';
import 'package:expense_tracker/core/services/database_export_import_service.dart';
import 'package:expense_tracker/core/presentation/common/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackupRestorePage extends ConsumerStatefulWidget {
  static const String routeName = '/backup-restore';

  const BackupRestorePage({super.key});

  @override
  ConsumerState<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends ConsumerState<BackupRestorePage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.backupAndRestore),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.share_rounded),
                    title: Text(appLocalizations.shareBackup),
                    enabled: !_isLoading,
                    onTap: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            try {
                              await DatabaseExportImportService.instance
                                  .exportDatabase();
                              if (context.mounted) {
                                CustomSnackBar.show(
                                  context,
                                  message: appLocalizations.exportSuccess,
                                  type: SnackBarType.success,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackBar.show(
                                  context,
                                  message: appLocalizations.exportError,
                                  type: SnackBarType.error,
                                );
                              }
                            } finally {
                              if (context.mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.save_rounded),
                    title: Text(appLocalizations.saveToDevice),
                    enabled: !_isLoading,
                    onTap: _isLoading
                        ? null
                        : () async {
                            setState(() => _isLoading = true);
                            try {
                              final success = await DatabaseExportImportService
                                  .instance
                                  .saveDatabaseLocally();
                              if (success && context.mounted) {
                                CustomSnackBar.show(
                                  context,
                                  message: appLocalizations.exportSuccess,
                                  type: SnackBarType.success,
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                CustomSnackBar.show(
                                  context,
                                  message: appLocalizations.exportError,
                                  type: SnackBarType.error,
                                );
                              }
                            } finally {
                              if (context.mounted) {
                                setState(() => _isLoading = false);
                              }
                            }
                          },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.file_download_rounded),
                    title: Text(appLocalizations.importData),
                    enabled: !_isLoading,
                    onTap: _isLoading
                        ? null
                        : () async {
                            final proceed = await showAdaptiveDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog.adaptive(
                                title: Text(appLocalizations.areYouSure),
                                content: Text(appLocalizations.importWarning),
                                actions: [
                                  adaptiveAction(
                                    context: context,
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(appLocalizations.cancel),
                                  ),
                                  adaptiveAction(
                                    context: context,
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    isDestructiveAction: true,
                                    child: Text(appLocalizations.delete),
                                  ),
                                ],
                              ),
                            );

                            if (proceed == true && context.mounted) {
                              setState(() => _isLoading = true);
                              try {
                                final success =
                                    await DatabaseExportImportService.instance
                                        .importDatabase();
                                if (success && context.mounted) {
                                  _refreshAppState();
                                  CustomSnackBar.show(
                                    context,
                                    message: appLocalizations.importSuccess,
                                    type: SnackBarType.success,
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  CustomSnackBar.show(
                                    context,
                                    message: appLocalizations.importError,
                                    type: SnackBarType.error,
                                  );
                                }
                              } finally {
                                if (context.mounted) {
                                  setState(() => _isLoading = false);
                                }
                              }
                            }
                          },
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.delete_forever_rounded),
                    title: Text(appLocalizations.resetData),
                    enabled: !_isLoading,
                    onTap: _isLoading
                        ? null
                        : () async {
                            final proceed = await showAdaptiveDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog.adaptive(
                                title: Text(appLocalizations.areYouSure),
                                content: Text(appLocalizations.resetWarning),
                                actions: [
                                  adaptiveAction(
                                    context: context,
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: Text(appLocalizations.cancel),
                                  ),
                                  adaptiveAction(
                                    context: context,
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    isDestructiveAction: true,
                                    child: Text(appLocalizations.delete),
                                  ),
                                ],
                              ),
                            );

                            if (proceed == true && context.mounted) {
                              setState(() => _isLoading = true);
                              try {
                                await DatabaseExportImportService.instance
                                    .resetDatabase();
                                if (context.mounted) {
                                  _refreshAppState();
                                  CustomSnackBar.show(
                                    context,
                                    message: appLocalizations.resetSuccess,
                                    type: SnackBarType.success,
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  CustomSnackBar.show(
                                    context,
                                    message: appLocalizations.resetError,
                                    type: SnackBarType.error,
                                  );
                                }
                              } finally {
                                if (context.mounted) {
                                  setState(() => _isLoading = false);
                                }
                              }
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _refreshAppState() {
    ref.invalidate(accountsListProvider);
    ref.invalidate(categoriesListProvider);
    ref.invalidate(transactionsListProvider);
    ref.invalidate(totalBalanceProvider);
    ref.invalidate(accountsWithBalanceProvider);
    ref.invalidate(budgetsListProvider);
    ref.invalidate(budgetProgressProvider);
  }
}
