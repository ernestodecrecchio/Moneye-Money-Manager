import 'package:expense_tracker/style/app_theme.dart';
import 'package:flutter/material.dart';

class OptionListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData leadingIcon;
  final bool enableRightArrow;
  final List<Widget>? trailingWidgets;
  final Function()? onTap;

  const OptionListTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.leadingIcon,
    this.onTap,
    this.enableRightArrow = true,
    this.trailingWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final List<Widget> trailingChildren = [
      if (trailingWidgets != null) ...trailingWidgets!,
      if (enableRightArrow) const Icon(Icons.chevron_right_rounded),
    ];

    return ListTile(
      leading: SizedBox(
        height: double.infinity,
        child: Icon(
          leadingIcon,
          color: colors.secondary,
        ),
      ),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailingChildren.isNotEmpty
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: trailingChildren,
            )
          : null,
      onTap: onTap,
    );
  }
}
