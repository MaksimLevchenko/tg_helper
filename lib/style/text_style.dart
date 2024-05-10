import 'package:flutter/material.dart';
import 'package:flutter_tg_helper/style/app_colors.dart';

class AppTextStyle {
  static const textStyle = TextStyle(
    color: DarkThemeAppColors.textColor,
    fontSize: 20,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );

  static const borderTextStyle = TextStyle(
    color: DarkThemeAppColors.unfocusedTextColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle copyWith({
    Color? color = DarkThemeAppColors.textColor,
    double? fontSize = 20,
    FontWeight? fontWeight = FontWeight.normal,
    TextOverflow? overflow = TextOverflow.ellipsis,
  }) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: overflow);
  }
}
