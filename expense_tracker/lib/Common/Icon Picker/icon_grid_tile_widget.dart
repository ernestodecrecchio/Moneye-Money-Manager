import 'package:flutter/material.dart';

class IconGridTileWidget extends StatelessWidget {
  final Map<String, Object> iconInfo;
  final bool isSelected;
  final ValueChanged<Map<String, Object>> onSelectedType;

  const IconGridTileWidget(
      {Key? key,
      required this.iconInfo,
      required this.isSelected,
      required this.onSelectedType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GridTile(
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? Colors.blue : Colors.transparent,
          ),
          child: Icon(
            iconInfo['icon'] as IconData,
            color: Colors.blue,
          ),
        ),
      ),
      onTap: () => onSelectedType(iconInfo),
    );
  }
}
