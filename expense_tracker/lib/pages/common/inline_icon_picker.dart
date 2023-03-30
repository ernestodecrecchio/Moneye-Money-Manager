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
  int selectedIndex = 0;

  late List<Widget> _pageList;

  @override
  void initState() {
    super.initState();

    _pageList = [
      _buildPage1(),
      _buildPage1(),
      _buildPage1(),
      _buildPage1(),
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
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (int page) {
              setState(() {
                selectedIndex = page;
              });
            },
            itemCount: _pageList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: _buildPage1(),
              );
            },
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
