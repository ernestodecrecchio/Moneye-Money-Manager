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
    final currentCategory = transaction.categoryId != null
        ? Provider.of<CategoryProvider>(context, listen: true)
            .getCategoryFromId(transaction.categoryId!)
        : null;
    final currentAccount = transaction.accountId != null
        ? Provider.of<AccountProvider>(context, listen: true)
            .geAccountFromId(transaction.accountId!)
        : null;

    return Container(
      height: 65,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              offset: Offset(-6, -6),
              blurRadius: 36,
              spreadRadius: 18,
              color: Color.fromRGBO(255, 255, 255, 0.5)),
          BoxShadow(
              offset: Offset(6, 6),
              blurRadius: 36,
              spreadRadius: 18,
              color: Color.fromRGBO(217, 217, 217, 0.5))
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  currentCategory != null ? currentCategory.color : Colors.red,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.date.toString(),
                style: const TextStyle(fontSize: 10),
              ),
              Text(transaction.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              if (currentAccount != null)
                Text(currentAccount.name, style: const TextStyle(fontSize: 10)),
            ],
          ),
          const Spacer(),
          _buildValue()
        ],
      ),
    );
  }

  Widget _buildValue() {
    return Text(
      transaction.value.toString(),
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: transaction.value >= 0 ? Colors.green : Colors.red),
    );
  }
}
