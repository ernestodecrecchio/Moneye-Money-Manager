import 'package:expense_tracker/domain/models/account.dart';
import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';
import 'package:expense_tracker/style/app_theme.dart';

class AccountListTile extends StatefulWidget {
  final Account account;
  final bool selected;
  final Function(bool)? onTap;

  const AccountListTile({
    super.key,
    required this.account,
    required this.selected,
    this.onTap,
  });

  @override
  State<AccountListTile> createState() => _AccountListTileState();
}

class _AccountListTileState extends State<AccountListTile> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.selected ? 1 : 0.3,
      child: ListTile(
        onTap: () {
          setState(() {});
          if (widget.onTap != null) {
            widget.onTap!(!widget.selected);
          }
        },
        title: Text(
          widget.account.name,
          style: TextStyle(
              fontSize: 20,
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.w500),
        ),
        leading: _buildAccountIcon(widget.account),
        trailing: widget.selected
            ? Icon(
                Icons.check_circle,
                color: context.appColors.primary,
              )
            : null,
      ),
    );
  }

  Widget _buildAccountIcon(Account account) {
    VectorGraphic? accountIcon;
    if (account.iconPath != null) {
      accountIcon = VectorGraphic(
        loader: AssetBytesLoader(account.iconPath!),
        colorFilter: ColorFilter.mode(
          context.appColors.onPrimary,
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
