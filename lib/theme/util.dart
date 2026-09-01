import 'package:flutter/material.dart';

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  final baseTextTheme = Theme.of(context).textTheme;
  return baseTextTheme.apply(
    fontFamily: bodyFontString,
  );
}
