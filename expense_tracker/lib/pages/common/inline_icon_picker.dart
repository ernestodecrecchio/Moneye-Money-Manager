import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:vector_graphics/vector_graphics.dart';

class InlineIconPicker extends StatefulWidget {
  final String? selectedIconPath;
  final Function(String selectedIconPath) onSelectedIcon;
  final Color? backgorundColor;

  const InlineIconPicker({
    super.key,
    required this.onSelectedIcon,
    this.selectedIconPath,
    this.backgorundColor,
  });

  @override
  State<InlineIconPicker> createState() => _InlineIconPickerState();
}

class _InlineIconPickerState extends State<InlineIconPicker> {
  final _controller = PageController();
  int selectedIndex = 0;

  //late List<Widget> _pageList;

  List<String> iconPathList = [
    'assets/icons/box.svg',
    'assets/icons/boar.svg',
    'assets/icons/cat.svg',
    'assets/icons/cow.svg',
    'assets/icons/paw.svg',
    'assets/icons/car.svg',
    'assets/icons/bus.svg',
    'assets/icons/cinema.svg',
    'assets/icons/food.svg',
    'assets/icons/graduate.svg',
    'assets/icons/house.svg',
    'assets/icons/netflix.svg',
    'assets/icons/popcorn.svg',
    'assets/icons/university.svg',
    'assets/icons/bag.svg',
    'assets/icons/hamburger.svg',
    'assets/icons/paypal.svg',
    'assets/icons/shirt.svg',
    'assets/icons/twitch-logo.svg',
    'assets/icons/visa.svg',
    'assets/icons/cash.svg',
    'assets/icons/healthcare.svg',
    'assets/icons/travel.svg',
    'assets/icons/book.svg',
    'assets/icons/present.svg',
    'assets/icons/doctor.svg',
    'assets/icons/bill.svg',
    'assets/icons/calendar.svg'
  ];

  @override
  void initState() {
    super.initState();

    // _pageList = [
    //   _buildPage1(),
    //   _buildPage2(),
    // ];
  }

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
      itemCount: iconPathList.length,
      itemBuilder: (context, index) {
        return _buildIconItem(iconPathList[index]);
      },
    );
  }

  InkWell _buildIconItem(String iconPath) {
    final backgroundColor = widget.backgorundColor ?? CustomColors.darkBlue;

    return InkWell(
      onTap: () {
        widget.onSelectedIcon(iconPath);
      },
      child: Container(
        height: 35,
        width: 35,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: iconPath == widget.selectedIconPath
              ? backgroundColor
              : backgroundColor.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: VectorGraphic(
          loader: AssetBytesLoader(iconPath),
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
