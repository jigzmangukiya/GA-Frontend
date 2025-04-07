import 'package:guardian_angel/utils.dart';
import 'package:flutter/material.dart';

/// App theme
class AppTheme {
  const AppTheme._();

  /// Standard [ThemeData] for the app
  static ThemeData get standard {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: ColorConstant.primaryColor,
      fontFamily: 'Poppins',
      snackBarTheme: const SnackBarThemeData(
        contentTextStyle: TextStyle(fontFamily: 'Poppins'),
      ),
    );
  }
}
