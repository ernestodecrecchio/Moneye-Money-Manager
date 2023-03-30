import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';

import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class TransactionListCell extends StatelessWidget {
  final Transaction transaction;
  const TransactionListCell({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildCategoryIcon(context),
          const SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildDate(),
            ],
          ),
          const Spacer(),
          _buildValue(context),
        ],
      ),
    );
  }

  _buildCategoryIcon(BuildContext context) {
    final category = Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryForTransaction(transaction);

    Icon? categoryIcon;
    if (category != null) {
      categoryIcon = Icon(
        category.iconData,
        color: Colors.white,
        size: 12,
      );
    }

    return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category != null ? category.color : Colors.grey),
        child: categoryIcon);
  }

  Widget _buildDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    String dateString = transaction.date.toIso8601String().substring(0, 10);

    DateTime dateToCheck = DateTime(
        transaction.date.year, transaction.date.month, transaction.date.day);

    if (dateToCheck == today) {
      dateString = 'Oggi';
    } else if (dateToCheck == yesterday) {
      dateString = 'Ieri';
    }

    return Text(
      dateString,
      style: const TextStyle(fontSize: 10, color: Colors.black54),
    );
  }

  Widget _buildValue(BuildContext context) {
    Account? account;

    if (transaction.accountId != null) {
      account = Provider.of<AccountProvider>(context, listen: false)
          .getAccountFromId(transaction.accountId!);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          transaction.value.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: transaction.value >= 0 ? Colors.green : Colors.red,
          ),
        ),
        if (account != null)
          Text(
            account.name,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
      ],
    );
  }
}
