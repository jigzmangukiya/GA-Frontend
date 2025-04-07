import 'package:flutter/material.dart';

class ColorConstant {
  static const Color primaryColor = Color(0XFF3E2EF5);
  static const Color whiteColor = Color(0XFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color lightBlackColor = Color(0XFF5F5F63);
  static const Color greyTextColor = Color(0XFFC2C2C2);
  static const Color darkGreyTextColor = Color(0XFF181818);
  static const Color subtitleColor = Color(0XFFA8A2A2);
  static const Color borderTextFieldColor = Color(0XFFB9B3FC);
  static const Color hintTextColor = Color(0XFFC7C7C7);
  static const Color redTextColor = Color(0XFFF00000);
  static const Color secondaryColor = Color(0XFFFFBC11);
  static const Color dividerColor = Color(0XFFCCC0C0);
  static const Color selectedColor = Color(0XFF3E2EF5);
  static const Color lightGreenColor = Color(0XFF0CC863);
  static const Color shadowColor = Color(0X0D000000);
  static const Color checkedColor = Color(0XFF555555);
  static const Color pinBoxBorderColor = Color(0XFFB9B3FC);
  static const Color pinBoxShadowColor = Color(0XFFCAC5FF);
  static const Color timerColor = Color(0XFF6355FF);
  static const Color boldgreyColor = Color(0XFF909090);
  static const Color categoryTextColor = Color(0XFFA6A6A6);
  static const Color textfieldBorderColor = Color(0XFFADA6FF);

  static Color getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
