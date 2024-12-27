import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class LibTheme {
  LibTheme._();

  static Color colorPrimary = HexColor('#07C1FF');
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color background = Color(0xF9F9F9F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  // icon
  static Color iconColor = HexColor('#44546F');
  static double iconSize = 16;

  static Color iconClearColor = HexColor('#44546F');
  static const double iconClearSize = 16;

  // border
  static Color borderColor = HexColor('#E8EDFE');
  static const double borderWidth = 1;
  static const double radius = 8;
  static BoxBorder border = Border.all(color: borderColor, width: borderWidth);
  static BorderRadiusGeometry borderRadius =
      BorderRadius.all(Radius.circular(radius));
  static Color hintColor = HexColor('#182A4E');
}
