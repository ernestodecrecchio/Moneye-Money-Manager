import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';

class InlineColorPicker extends StatefulWidget {
  final Color? selectedColor;
  final Function(Color selectedColor) onSelectedColor;

  const InlineColorPicker({
    super.key,
    required this.onSelectedColor,
    this.selectedColor,
  });

  @override
  State<InlineColorPicker> createState() => _InlineColorPickerState();
}

class _InlineColorPickerState extends State<InlineColorPicker> {
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 116,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
      decoration: BoxDecoration(
          color: CustomColors.lightBlue,
          borderRadius: BorderRadius.circular(25)),
      child: _buildPageView(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Widget _buildPageView() {
    return PageView(
      controller: _controller,
      children: [
        _buildPage1(),
      ],
    );
  }

  _buildPage1() {
    return Wrap(
      spacing: 18,
      alignment: WrapAlignment.spaceEvenly,
      runSpacing: 14,
      children: [
        _buildColorItem(CustomColors.red1),
        _buildColorItem(CustomColors.blue1),
        _buildColorItem(CustomColors.green1),
        _buildColorItem(CustomColors.orange1),
        _buildColorItem(CustomColors.brown1),
        _buildColorItem(CustomColors.black),
        _buildColorItem(CustomColors.red2),
        _buildColorItem(CustomColors.blue2),
        _buildColorItem(CustomColors.green2),
        _buildColorItem(CustomColors.yellow1),
        _buildColorItem(CustomColors.brown2),
        _buildColorItem(CustomColors.grey),
      ],
    );
  }

  _buildColorItem(Color color) {
    return InkWell(
      onTap: () {
        widget.onSelectedColor(color);
      },
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: color == widget.selectedColor
            ? const Icon(
                Icons.check_rounded,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
