import 'package:expense_tracker/models/transaction.dart';

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
                transaction.date.toIso8601String().substring(0, 10),
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
              Text(
                transaction.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (transaction.accountId != null)
                Text(
                  transaction.accountId.toString(),
                  style: const TextStyle(fontSize: 10, color: Colors.black54),
                ),
            ],
          ),
          const Spacer(),
          _buildValue()
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

  Widget _buildValue() {
    return Text(
      transaction.value.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: transaction.value >= 0 ? Colors.green : Colors.red,
      ),
    );
  }
}
