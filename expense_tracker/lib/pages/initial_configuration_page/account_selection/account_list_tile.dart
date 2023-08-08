import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountListTile extends StatefulWidget {
  final Account account;
  final Function(bool)? onTap;

  const AccountListTile({
    super.key,
    required this.account,
    this.onTap,
  });

  @override
  State<AccountListTile> createState() => _AccountListTileState();
}

class _AccountListTileState extends State<AccountListTile> {
  bool isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isSelected ? 1 : 0.3,
      child: ListTile(
        onTap: () {
          isSelected = !isSelected;

          setState(() {});
          if (widget.onTap != null) {
            widget.onTap!(isSelected);
          }
        },
        title: Text(
          widget.account.name,
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: _buildAccountIcon(widget.account),
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
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: account.color,
          borderRadius: BorderRadius.circular(8)),
      child: accountIcon,
    );
  }
}
