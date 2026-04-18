import 'package:expense_tracker/core/widgets/widgets/adaptive_dialog_action.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteAccountAlert(
    BuildContext context, AppLocalizations appLocalizations) async {
  final result = await showAdaptiveDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(
        appLocalizations.areYouSure,
      ),
      content: Text(
        appLocalizations.deleteAccountAlertBody,
      ),
      actions: [
        adaptiveAction(
          context: context,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            appLocalizations.cancel,
          ),
        ),
        adaptiveAction(
          context: context,
          onPressed: () => Navigator.of(context).pop(true),
          isDestructiveAction: true,
          child: Text(
            appLocalizations.delete,
          ),
        )
      ],
    ),
  );

  return result ?? false;
}

enum CategoryDeletionResult {
  cancel,
  deleteCategoryAndTransactions,
  transferTransactions,
}

Future<CategoryDeletionResult> showDeleteCategoryAlert({
  required BuildContext context,
  required AppLocalizations appLocalizations,
  required int transactionCount,
}) async {
  final hasTransactions = transactionCount > 0;

  final result = await showAdaptiveDialog<CategoryDeletionResult>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(
        hasTransactions
            ? appLocalizations.deleteCategoryTitle
            : appLocalizations.areYouSure,
      ),
      content: Text(
        hasTransactions
            ? appLocalizations
                .deleteCategoryTransactionsMessage(transactionCount)
            : appLocalizations.deleteCategoryAlertBody,
      ),
      actions: [
        adaptiveAction(
          context: context,
          onPressed: () =>
              Navigator.of(context).pop(CategoryDeletionResult.cancel),
          child: Text(appLocalizations.cancel),
        ),
        if (hasTransactions)
          adaptiveAction(
            context: context,
            onPressed: () => Navigator.of(context)
                .pop(CategoryDeletionResult.transferTransactions),
            child: Text(appLocalizations.transferTransactions),
          ),
        adaptiveAction(
          context: context,
          onPressed: () => Navigator.of(context)
              .pop(CategoryDeletionResult.deleteCategoryAndTransactions),
          isDestructiveAction: true,
          child: Text(appLocalizations.delete),
        ),
      ],
    ),
  );

  return result ?? CategoryDeletionResult.cancel;
}
