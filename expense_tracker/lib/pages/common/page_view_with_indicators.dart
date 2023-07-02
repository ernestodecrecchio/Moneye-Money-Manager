import 'package:expense_tracker/style.dart';
import 'package:flutter/material.dart';

class PageViewWithIndicators extends StatefulWidget {
  final List<Widget> widgetList;

  const PageViewWithIndicators({super.key, required this.widgetList});

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
      list.add(i == _selectedIndex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
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
