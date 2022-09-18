import 'package:cv_project/Helper/ColorCustom.dart';
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
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isSelected ? ColorCustom.ClearBlue : Colors.transparent,
          ),
          child: Icon(
            iconInfo['icon'] as IconData,
            color: ColorCustom.PrussianBlue,
          ),
        ),
      ),
      onTap: () => onSelectedType(iconInfo),
    );
  }
}
