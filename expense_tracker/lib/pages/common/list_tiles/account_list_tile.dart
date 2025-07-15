import 'package:expense_tracker/Helper/double_helper.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/currency_provider.dart';
import 'package:expense_tracker/pages/account_detail_page/account_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AccountListTile extends ConsumerWidget {
  final Account account;
  final double balance;

  const AccountListTile({
    super.key,
    required this.account,
    required this.balance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(currentCurrencyProvider);
    final currentCurrencyPosition =
        ref.watch(currentCurrencySymbolPositionProvider);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AccountDetailPage.routeName,
        arguments: account,
      ),
      child: Container(
        width: 145,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: account.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 2),
              color: Colors.black26,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (account.iconPath != null)
                  SizedBox(
                    height: 14,
                    width: 14,
                    child: VectorGraphic(
                      loader: AssetBytesLoader(account.iconPath!),
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        account.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 20,
                )
              ],
            ),
            //   const Spacer(),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.total,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        balance.toStringAsFixedRoundedWithCurrency(
                            2, currentCurrency, currentCurrencyPosition),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
