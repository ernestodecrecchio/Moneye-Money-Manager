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
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 17, right: 17, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLocalizations.selectIcon, style: textTheme.titleMedium),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: widget.iconPathList.length,
                itemBuilder: (context, index) {
                  final path = widget.iconPathList[index];
                  return Center(
                    child: IconItem(
                      iconPath: path,
                      isSelected: path == _selectedIconPath,
                      backgroundColor: widget.backgroundColor,
                      onTap: () {
                        Navigator.of(context).pop();
                        widget.onSelectedIcon(path);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
