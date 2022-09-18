import 'package:flutter/material.dart';

import 'IconGridTileWidget.dart';

class IconPickerModalView extends StatelessWidget {
  final iconList = [
    {'name': 'Linkedin', 'icon': FontAwesomeIcons.linkedin},
    {'name': 'Twitter', 'icon': FontAwesomeIcons.twitter},
    {'name': 'Facebook', 'icon': FontAwesomeIcons.facebook},
    {'name': 'Instagram', 'icon': FontAwesomeIcons.instagram},
  ];

  final Map<String, Object>? alreadySelected;

  IconPickerModalView({this.alreadySelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Seleziona l'icona del campo",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Servirà a decorare l'informazione sul cv",
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
              child: GridView.builder(
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemCount: iconList.length,
            itemBuilder: (BuildContext context, i) {
              return IconGridTileWidget(
                iconInfo: iconList[i],
                isSelected: alreadySelected != null &&
                        alreadySelected!['name'] == iconList[i]['name']
                    ? true
                    : false,
                onSelectedType: (iconInfo) => selectIcon(context, iconInfo),
              );
            },
          ))
        ],
      ),
    );
  }

  void selectIcon(BuildContext context, Map<String, Object> iconInfo) {
    Navigator.pop(context, iconInfo);
  }
}
