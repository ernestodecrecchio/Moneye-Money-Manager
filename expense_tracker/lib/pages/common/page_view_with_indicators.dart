import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageViewWithIndicators extends StatefulWidget {
  final List<Widget> widgetList;
  final List<String>? indicatorIconPathList;

  const PageViewWithIndicators({
    super.key,
    required this.widgetList,
    this.indicatorIconPathList,
  }) : assert((indicatorIconPathList != null &&
                indicatorIconPathList.length == widgetList.length) ||
            indicatorIconPathList == null);

  @override
  State<PageViewWithIndicators> createState() => _PageViewWithIndicatorsState();
}

class _PageViewWithIndicatorsState extends State<PageViewWithIndicators> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            itemCount: widget.widgetList.length,
            itemBuilder: (context, index) {
              return widget.widgetList[index];
            },
            onPageChanged: (newIndex) => setState(() {
              _selectedIndex = newIndex;
            }),
          ),
        ),
        if (widget.widgetList.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._buildPageIndicator(),
            ],
          )
      ],
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];

    for (int i = 0; i < widget.widgetList.length; i++) {
      list.add(i == _selectedIndex
          ? _indicator(
              isActive: true,
              index: i,
              iconPath: widget.indicatorIconPathList != null
                  ? widget.indicatorIconPathList![i]
                  : null)
          : _indicator(
              isActive: false,
              index: i,
              iconPath: widget.indicatorIconPathList != null
                  ? widget.indicatorIconPathList![i]
                  : null));
    }
    return list;
  }

  Widget _indicator({
    required bool isActive,
    required int index,
    String? iconPath,
  }) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
        _selectedIndex = index;
      },
      child: AnimatedContainer(
        height: isActive ? 18 : 14,
        width: isActive ? 18 : 14,
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: iconPath != null
            ? SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isActive ? CustomColors.blue : CustomColors.grey,
                  BlendMode.srcIn,
                ),
              )
            : null,
      ),
    );
  }
}
