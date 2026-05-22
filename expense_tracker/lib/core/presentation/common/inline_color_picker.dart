import 'package:expense_tracker/core/configuration/constants.dart';
import 'package:expense_tracker/core/presentation/common/expand_hint_button.dart';
import 'package:expense_tracker/core/presentation/common/widgets/color_selector_bottom_sheet.dart';
import 'package:expense_tracker/core/style/style.dart';
import 'package:expense_tracker/core/style/app_theme.dart';
import 'package:flutter/material.dart';

class InlineColorPicker extends StatefulWidget {
  final BoxShape itemShape;
  final Color? selectedColor;
  final Function(Color selectedColor) onSelectedColor;

  const InlineColorPicker({
    super.key,
    required this.itemShape,
    required this.onSelectedColor,
    this.selectedColor = CustomColors.defaultPickerColor,
  });

  @override
  State<InlineColorPicker> createState() => _InlineColorPickerState();
}

class _InlineColorPickerState extends State<InlineColorPicker> {
  late final ScrollController _scrollController;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _selectedColor = widget.selectedColor;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedColor();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedColor() {
    if (_selectedColor == null) return;

    final index = CustomColors.pickerColorList.indexOf(_selectedColor!);
    if (index == -1) return;

    // Each column (2 colors) has width 40 and spacing 14.
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
            onTap: () => showColorBottomSheet(
              context: context,
              itemShape: widget.itemShape,
              onSelectedColor: (newColor) {
                widget.onSelectedColor(newColor);
                setState(() {
                  _selectedColor = newColor;
                });
                _scrollToSelectedColor();
              },
              initialSelectedColor: _selectedColor,
            ),
            backgroundColor: colors.divider,
          ),
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
      itemCount: CustomColors.pickerColorList.length,
      itemBuilder: (context, index) {
        return _buildColorItem(CustomColors.pickerColorList[index]);
      },
    );
  }

  GestureDetector _buildColorItem(Color color) {
    return GestureDetector(
      onTap: () {
        widget.onSelectedColor(color);
        setState(() {
          _selectedColor = color;
        });
      },
      child: Center(
        child: Container(
          height: Constants.defaultIconItemHeight,
          width: Constants.defaultIconItemWidth,
          decoration: BoxDecoration(
            color: color,
            shape: widget.itemShape,
            borderRadius: widget.itemShape == BoxShape.rectangle
                ? BorderRadius.circular(8)
                : null,
          ),
          child: color == _selectedColor
              ? const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
