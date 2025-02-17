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
    return Container(
      height: 114,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: CustomColors.lightBlue,
          borderRadius: BorderRadius.circular(25)),
      child: _buildGridView(), //_buildPageView(),
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

  // Widget _buildPageView() {
  //   return PageView(
  //     controller: _controller,
  //     children: [
  //       _buildPage1(),
  //     ],
  //   );
  // }

  // _buildPage1() {
  //   return Wrap(
  //     spacing: 18,
  //     alignment: WrapAlignment.spaceEvenly,
  //     runSpacing: 14,
  //     children: [
  //       _buildColorItem(CustomColors.red1),
  //       _buildColorItem(CustomColors.blue1),
  //       _buildColorItem(CustomColors.green1),
  //       _buildColorItem(CustomColors.orange1),
  //       _buildColorItem(CustomColors.brown1),
  //       _buildColorItem(CustomColors.black),
  //       _buildColorItem(CustomColors.red2),
  //       _buildColorItem(CustomColors.blue2),
  //       _buildColorItem(CustomColors.green2),
  //       _buildColorItem(CustomColors.yellow1),
  //       _buildColorItem(CustomColors.brown2),
  //       _buildColorItem(CustomColors.grey),
  //     ],
  //   );
  // }
}
