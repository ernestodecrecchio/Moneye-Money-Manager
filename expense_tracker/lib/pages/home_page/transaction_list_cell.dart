import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';

import 'package:expense_tracker/notifiers/category_provider.dart';
import 'package:expense_tracker/notifiers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

class TransactionListCell extends StatelessWidget {
  final Transaction transaction;
  final double horizontalPadding;

  const TransactionListCell({
    Key? key,
    required this.transaction,
    bool? dismissible = true,
    this.horizontalPadding = 17,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(transaction.id.toString()),
      confirmDismiss: (_) {
        return Provider.of<TransactionProvider>(context, listen: false)
            .deleteTransaction(transaction);
      },
      background: Container(
        padding: const EdgeInsets.only(right: 17),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: Container(
        height: 60,
        padding:
            EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
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
      ),
    );
  }

  _buildCategoryIcon(BuildContext context) {
    final category = Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryForTransaction(transaction);

    SvgPicture? categoryIcon;
    if (category != null) {
      categoryIcon = SvgPicture.asset(
        category.iconPath!,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 26,
      height: 26,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: category != null ? category.color : Colors.grey),
      child: categoryIcon,
    );
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
