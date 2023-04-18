import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  late List<Widget> _pageList;

  @override
  void initState() {
    super.initState();

    _pageList = [
      _buildPage1(),
      _buildPage2(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 114,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(top: 10, bottom: 5),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            onPageChanged: (int page) {
              setState(() {
                selectedIndex = page;
              });
            },
            children: [
              _buildPage1(),
              _buildPage2(),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [..._buildPageIndicator()],
        )
      ],
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Wrap(
        spacing: 18,
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 14,
        children: [
          _buildIconItem('assets/icons/boar.svg'),
          _buildIconItem('assets/icons/box.svg'),
          _buildIconItem('assets/icons/car.svg'),
          _buildIconItem('assets/icons/cat.svg'),
          _buildIconItem('assets/icons/cinema.svg'),
          _buildIconItem('assets/icons/cow.svg'),
          _buildIconItem('assets/icons/food.svg'),
          _buildIconItem('assets/icons/graduate.svg'),
          _buildIconItem('assets/icons/house.svg'),
          _buildIconItem('assets/icons/paw.svg'),
          _buildIconItem('assets/icons/popcorn.svg'),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Wrap(
        spacing: 18,
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 14,
        children: [
          _buildIconItem('assets/icons/picker_icons/university.svg'),
          _buildIconItem('assets/icons/picker_icons/bag.svg'),
          _buildIconItem('assets/icons/picker_icons/hamburger.svg'),
          _buildIconItem('assets/icons/picker_icons/paypal.svg'),
          _buildIconItem('assets/icons/picker_icons/shirt.svg'),
          _buildIconItem('assets/icons/picker_icons/twitch-logo.svg'),
          _buildIconItem('assets/icons/picker_icons/visa.svg'),
        ],
      ),
    );
  }

  _buildIconItem(String iconPath) {
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
              : backgroundColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconPath,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pageList.length; i++) {
      list.add(i == selectedIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 4 : 4,
        width: isActive ? 4 : 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? const Color(0XFF6BC4C9) : const Color(0XFFEAEAEA),
        ),
      ),
    );
  }
}
