import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryColor = Color(0xff2196f3);
  static const int primarySwatch = 0xffBE0B19;
  static const Color secondaryColor = Color(0xfff50057);

  static const Color errorColor = Colors.red;
  static const Color enableColor = Colors.green;
  static const Color disableColor = Colors.grey;
  static const Color warningColor = Color.fromARGB(255, 217, 155, 9);

  static const Color appBodyBg = Colors.white;
  static final Color drawerHeaderBg = Colors.blueGrey.shade50;
  static const Color cardColor = Color(0xffFFFFFF);
  static const Color bottomSheetColor = Color(0xffFFFFFF);
  static const Color navBarBgColor = primaryColor;

  static const Color textFieldHintColor = Color(0xff9CA3AF);
  static const Color textFieldIconColor = Color(0xff9CA3AF);
  static const Color textFieldOutlineColor = Colors.grey;

  static final Color textColor = Colors.grey.shade800;
  static const Color secondaryTextColor = Color(0xff79767E);

  static const Map<int, Color> primaryColorMap = {
    50: Color.fromRGBO(33, 150, 243, .1),
    100: Color.fromRGBO(33, 150, 243, .2),
    200: Color.fromRGBO(33, 150, 243, .3),
    300: Color.fromRGBO(33, 150, 243, .4),
    400: Color.fromRGBO(33, 150, 243, .5),
    500: Color.fromRGBO(33, 150, 243, .6),
    600: Color.fromRGBO(33, 150, 243, .7),
    700: Color.fromRGBO(33, 150, 243, .8),
    800: Color.fromRGBO(33, 150, 243, .9),
    900: Color.fromRGBO(33, 150, 243, 1)
  };
}
