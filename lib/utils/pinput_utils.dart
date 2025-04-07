import 'package:flutter/material.dart';
import 'package:guardian_angel/utils.dart';
import 'package:pinput/pinput.dart';

class PinputUtils {
  final defaultPinTheme = PinTheme(
    width: 46,
    height: 46,
    textStyle: TextStyle(
      fontFamily: 'Poppins_Medium',
      fontSize: 22,
      color: ColorConstant.lightBlackColor,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: ColorConstant.pinBoxBorderColor, width: 1),
      boxShadow: [
        BoxShadow(
          color: ColorConstant.pinBoxShadowColor, // 30% opacity
          offset: Offset(0, 4),
          blurRadius: 4,
        ),
      ],
    ),
  );
}
