import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/notifiers/account_provider.dart';
import 'package:expense_tracker/notifiers/central_provider.dart';
import 'package:expense_tracker/pages/options_page/accounts_page/new_account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountListCell extends StatelessWidget {
  final Account account;

  const AccountListCell({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(account.id.toString()),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () async =>
              await Provider.of<CentralProvider>(context, listen: false)
                  .deleteAccount(account),
        ),
        children: [
          _buildDeleteAction(context),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () async =>
              await Provider.of<CentralProvider>(context, listen: false)
                  .deleteAccount(account),
        ),
        children: [
          _buildDeleteAction(context),
        ],
      ),
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(NewAccountPage.routeName, arguments: account),
        title: Text(
          account.name,
          style: const TextStyle(fontSize: 16),
        ),
        leading: _buildAccountIcon(account),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  _buildAccountIcon(Account account) {
    SvgPicture? accountIcon;
    if (account.iconPath != null) {
      accountIcon = SvgPicture.asset(
        account.iconPath!,
        colorFilter: const ColorFilter.mode(
          Colors.white,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(shape: BoxShape.circle, color: account.color),
      child: accountIcon,
    );
  }

  SlidableAction _buildDeleteAction(BuildContext context) {
    return SlidableAction(
      onPressed: (context) async =>
          await Provider.of<AccountProvider>(context, listen: false)
              .deleteAccount(account),
      backgroundColor: const Color(0xFFFE4A49),
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: AppLocalizations.of(context)!.delete,
    );
  }
}
