import 'package:expense_tracker/core/presentation/common/account_ui_extension.dart';
import 'package:expense_tracker/features/accounts/domain/models/account.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:flutter/material.dart';

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
          style: const TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        leading: _buildAccountIcon(widget.account),
        trailing: widget.selected
            ? const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }

  Widget _buildAccountIcon(Account account) {
    return IconItem(
      backgroundColor: account.color,
      iconPath: account.iconPath,
      shape: BoxShape.rectangle,
      isSelected: widget.selected,
    );
  }
}
