import 'package:flutter/material.dart';

class AppTextStyle {
  static const textStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.normal,
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle copyWith({
    Color? color = Colors.white,
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
