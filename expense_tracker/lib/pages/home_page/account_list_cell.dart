import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:flutter/material.dart';

class AccountListCell extends StatelessWidget {
  final Account account;
  final double balance;

  const AccountListCell(
      {super.key, required this.account, required this.balance});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, AccountDetailPage.routeName,
          arguments: account),
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        width: 140,
        decoration: BoxDecoration(
          color: account.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              offset: Offset(0, 1),
              color: Colors.black54,
            ),
          ],
        ),
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    account.iconData,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      account.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white.withOpacity(0.5),
                    size: 15,
                  )
                ],
              ),
              Spacer(),
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                '${balance.toStringAsFixed(2)}€',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
      ),
    );
  }
}
