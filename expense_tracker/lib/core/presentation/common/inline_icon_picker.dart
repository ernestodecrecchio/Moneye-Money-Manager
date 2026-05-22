import 'package:expense_tracker/core/common/app_icons.dart';
import 'package:expense_tracker/core/presentation/common/expand_hint_button.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_item.dart';
import 'package:expense_tracker/core/presentation/common/widgets/icon_selector_bottom_sheet.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:flutter/material.dart';

class InlineIconPicker extends StatefulWidget {
  final BoxShape itemShape;
  final String? selectedIconPath;
  final Function(String selectedIconPath) onSelectedIcon;
  final Color? backgroundColor;

  const InlineIconPicker({
    super.key,
    required this.itemShape,
    required this.onSelectedIcon,
    this.selectedIconPath,
    this.backgroundColor,
  });

  @override
  State<InlineIconPicker> createState() => _InlineIconPickerState();
}

class _InlineIconPickerState extends State<InlineIconPicker> {
  late final ScrollController _scrollController;

  String? selectedIconPath;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    selectedIconPath = widget.selectedIconPath;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedIcon();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedIcon() {
    if (selectedIconPath == null) return;

    final index = AppIcons.iconPathList.indexOf(selectedIconPath!);
    if (index == -1) return;

    // Each column (2 icons) has width 40 and spacing 14.
    // (114 - 10*2 - 14) / 2 = 40 width for each icon/column
    final scrollOffset = (index ~/ 2) * (40 + 14).toDouble();

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        scrollOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutQuint,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 114,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.fieldBackground,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: _buildGridView(),
          ),
          ExpandHintButton(
            onTap: () => showIconBottomSheet(
                context: context,
                backgroundColor:
                    widget.backgroundColor ?? CustomColors.defaultPickerColor,
                itemShape: widget.itemShape,
                onSelectedIcon: (newSelectedIconPath) {
                  widget.onSelectedIcon(newSelectedIconPath);
                  selectedIconPath = newSelectedIconPath;
                  setState(() {});
                  _scrollToSelectedIcon();
                },
                initialSelectionIconPath: selectedIconPath),
            backgroundColor: colors.divider,
          )
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      physics: const ClampingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      scrollDirection: Axis.horizontal,
      itemCount: AppIcons.iconPathList.length,
      itemBuilder: (context, index) {
        final iconPath = AppIcons.iconPathList[index];

        // Center widget to constrain the children size inside the grid
        return Center(
          child: IconItem(
              iconPath: iconPath,
              shape: widget.itemShape,
              isSelected: iconPath == selectedIconPath,
              backgroundColor:
                  widget.backgroundColor ?? CustomColors.defaultPickerColor,
              onTap: () {
                widget.onSelectedIcon(iconPath);
                selectedIconPath = iconPath;
                setState(() {});
              }),
        );
      },
    );
  }
}
