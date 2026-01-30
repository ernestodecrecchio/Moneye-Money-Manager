import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/application/transactions/notifiers/mutations/transaction_mutation_notifier.dart';
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
  final appLocalizations = ref.read(appLocalizationsProvider);
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(appLocalizations.transactionDeleted),
      backgroundColor: CustomColors.blue,
      behavior: SnackBarBehavior.floating,
      persist: false,
      action: SnackBarAction(
        label: appLocalizations.cancel,
        textColor: Colors.white,
        onPressed: () async {
          await ref.read(transactionMutationProvider.notifier).add(transaction);
        },
      ),
    ),
  );
}
