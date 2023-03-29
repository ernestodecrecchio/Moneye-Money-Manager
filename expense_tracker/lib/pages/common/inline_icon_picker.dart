import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';

class InlineIconPicker extends StatefulWidget {
  final IconData? selectedIconData;
  final Function(IconData selectedIconData) onSelectedIconData;
  final Color? backgorundColor;

  const InlineIconPicker({
    super.key,
    required this.onSelectedIconData,
    this.selectedIconData,
    this.backgorundColor,
  });

  @override
  State<InlineIconPicker> createState() => _InlineIconPickerState();
}

class _InlineIconPickerState extends State<InlineIconPicker> {
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
        _buildIconItem(Icons.house),
        _buildIconItem(Icons.car_rental),
        _buildIconItem(Icons.air),
        _buildIconItem(Icons.money),
        _buildIconItem(Icons.donut_large),
        _buildIconItem(Icons.pets),
        _buildIconItem(Icons.catching_pokemon),
        _buildIconItem(Icons.search),
        _buildIconItem(Icons.place_rounded),
        _buildIconItem(Icons.trending_neutral),
        _buildIconItem(Icons.earbuds),
        _buildIconItem(Icons.album),
      ],
    );
  }

  _buildIconItem(IconData iconData) {
    final backgroundColor = widget.backgorundColor ?? CustomColors.darkBlue;

    return InkWell(
      onTap: () {
        widget.onSelectedIconData(iconData);
      },
      child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: iconData == widget.selectedIconData
                ? backgroundColor
                : backgroundColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            iconData,
            color: Colors.white,
          )),
    );
  }
}
