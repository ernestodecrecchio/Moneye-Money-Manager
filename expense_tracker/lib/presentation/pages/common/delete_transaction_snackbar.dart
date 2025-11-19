import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/domain/models/transaction.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showDeleteTransactionSnackbar(
  BuildContext context,
  WidgetRef ref,
  Transaction transaction,
  int index,
) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(AppLocalizations.of(context)!.transactionDeleted),
      backgroundColor: CustomColors.blue,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.cancel,
        textColor: Colors.white,
        onPressed: () async {
          await ref.read(transactionMutationProvider.notifier).add(transaction);
        },
      ),
    ),
  );
}
