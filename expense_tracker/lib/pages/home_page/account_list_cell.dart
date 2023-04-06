import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountListCell extends StatelessWidget {
  final Account account;
  final double balance;

  const AccountListCell({
    super.key,
    required this.account,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        AccountDetailPage.routeName,
        arguments: account,
      ),
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (account.iconPath != null)
                SizedBox(
                  height: 14,
                  width: 14,
                  child: SvgPicture.asset(
                    account.iconPath!,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
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
          const Spacer(),
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
