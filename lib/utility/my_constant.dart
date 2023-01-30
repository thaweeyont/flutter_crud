import 'package:flutter/material.dart';

class MyConstant {
  // version application
  static String version_app = '2.1.15';

  // size icon input
  final sizeIcon = BoxConstraints(minWidth: 45, minHeight: 45);

  //border input
  final border = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.transparent,
      width: 0,
    ),
    borderRadius: const BorderRadius.all(
      const Radius.circular(4.0),
    ),
  );

  // Color
  static Color primary = Color(0xff000000);
  static Color red = Color(0xffd60000);
  static Color light = Color(0xffffffff);
  static Color load = Color(0xffe6b980);
  // TextStyle
  TextStyle normal_text(Color color) => TextStyle(
        fontSize: 16,
        color: color,
        fontFamily: 'Prompt',
      );

  TextStyle small_text(Color color) => TextStyle(
        fontSize: 14,
        color: color,
        fontFamily: 'Prompt',
      );

  TextStyle title_text(Color color) => TextStyle(
        fontSize: 18,
        color: color,
        // fontWeight: FontWeight.bold,
        fontFamily: 'Prompt',
      );

  TextStyle bold_text(Color color) => TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.bold,
        fontFamily: 'Prompt',
      );

  SizedBox space_box(double height) => SizedBox(
        height: height,
        child: Container(
          color: Colors.grey[200],
        ),
      );

  //icons svg

  static String iconUser = 'icons/users.svg';
}
