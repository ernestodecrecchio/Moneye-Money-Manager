import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          await ref.read(transactionProvider.notifier).addTransaction(
                transaction: transaction,
                index: index,
              );
        },
      ),
    ),
  );
}
