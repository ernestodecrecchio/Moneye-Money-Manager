// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// String iconToJSONString(IconData data) {
//   Map<String, dynamic> map = <String, dynamic>{};
//   map['codePoint'] = data.codePoint;
//   map['fontFamily'] = data.fontFamily;
//   map['fontPackage'] = data.fontPackage;
//   map['matchTextDirection'] = data.matchTextDirection;

//   return jsonEncode(map);
// }

// IconData fromJSONStringToIcon(String jsonString) {
//   Map<String, dynamic> map = jsonDecode(jsonString);

//   return IconData(
//     map['codePoint'],
//     fontFamily: map['fontFamily'],
//     fontPackage: map['fontPackage'],
//     matchTextDirection: map['matchTextDirection'],
//   );
// }
