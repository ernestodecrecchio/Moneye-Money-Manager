import 'package:expense_tracker/application/common/notifiers/app_localizations_provider.dart';
import 'package:expense_tracker/presentation/pages/common/custom_modal_bottom_sheet.dart';
import 'package:expense_tracker/presentation/pages/common/widgets/icon_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showIconBottomSheet({
  required BuildContext context,
  required Color backgroundColor,
  required List<String> iconPathList,
  required Function(String selectedIconPath) onSelectedIcon,
  String? initialSelectionIconPath,
}) async {
  await showCustomModalBottomSheet(
    context: context,
    builder: (context) {
      return IconSelectorContent(
        backgroundColor: backgroundColor,
        iconPathList: iconPathList,
        currentSelectionIconPath: initialSelectionIconPath,
        onSelectedIcon: onSelectedIcon,
      );
    },
  );
}

class IconSelectorContent extends ConsumerStatefulWidget {
  final Color backgroundColor;
  final List<String> iconPathList;
  final String? currentSelectionIconPath;
  final Function(String selectedIconPath) onSelectedIcon;

  const IconSelectorContent({
    super.key,
    required this.backgroundColor,
    required this.iconPathList,
    required this.onSelectedIcon,
    this.currentSelectionIconPath,
  });

  @override
  ConsumerState<IconSelectorContent> createState() =>
      _IconSelectorContentState();
}

class _IconSelectorContentState extends ConsumerState<IconSelectorContent> {
  String? _selectedIconPath;

  @override
  void initState() {
    super.initState();
    _selectedIconPath = widget.currentSelectionIconPath;
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = ref.watch(appLocalizationsProvider);

    return SafeArea(
      child: Container(
        color: Colors.white,
        padding:
            const EdgeInsets.only(top: 10, left: 17, right: 17, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.selectIcon,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: widget.iconPathList
                      .map(
                        (path) => IconItem(
                          iconPath: path,
                          isSelected: path == _selectedIconPath,
                          backgroundColor: widget.backgroundColor,
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onSelectedIcon(path);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
