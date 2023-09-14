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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
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
            children: [..._buildPageIndicator()],
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
              iconPath: widget.indicatorIconPathList != null
                  ? widget.indicatorIconPathList![i]
                  : null)
          : _indicator(
              isActive: false,
              iconPath: widget.indicatorIconPathList != null
                  ? widget.indicatorIconPathList![i]
                  : null));
    }
    return list;
  }

  Widget _indicator({required bool isActive, String? iconPath}) {
    if (iconPath != null) {
      return SizedBox(
        child: AnimatedContainer(
          height: isActive ? 18 : 14,
          width: isActive ? 18 : 14,
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(
              isActive ? CustomColors.blue : CustomColors.grey,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 10,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: isActive ? 8 : 4,
          width: isActive ? 8 : 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? CustomColors.blue : CustomColors.grey,
          ),
        ),
      );
    }
  }
}
