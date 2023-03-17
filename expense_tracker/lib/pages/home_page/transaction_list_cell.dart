import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionListCell extends StatelessWidget {
  final Transaction transaction;
  const TransactionListCell({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.date.toIso8601String().substring(0, 10),
                style: const TextStyle(fontSize: 10),
              ),
              Text(transaction.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
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
