import 'package:expense_tracker/style/style.dart';
import 'package:expense_tracker/style/app_theme.dart';
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

  List<Color> colorList = [
    CustomColors.red1,
    CustomColors.red2,
    CustomColors.pink1,
    CustomColors.pink2,
    CustomColors.blue1,
    CustomColors.blue2,
    CustomColors.green1,
    CustomColors.green2,
    CustomColors.orange1,
    CustomColors.yellow1,
    CustomColors.brown1,
    CustomColors.brown2,
    CustomColors.black,
    CustomColors.grey,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 114,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(25),
      ),
      child: _buildGridView(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      scrollDirection: Axis.horizontal,
      itemCount: colorList.length,
      itemBuilder: (context, index) {
        return _buildColorItem(colorList[index]);
      },
    );
  }

  GestureDetector _buildColorItem(Color color) {
    return GestureDetector(
      onTap: () {
        widget.onSelectedColor(color);
      },
      child: Center(
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
      ),
    );
  }
}
