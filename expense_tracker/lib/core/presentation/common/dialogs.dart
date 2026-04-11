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

Future<bool> showDeleteCategoryAlert(
    BuildContext context, AppLocalizations appLocalizations) async {
  final result = await showAdaptiveDialog(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(
        appLocalizations.areYouSure,
      ),
      content: Text(
        appLocalizations.deleteCategoryAlertBody,
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
