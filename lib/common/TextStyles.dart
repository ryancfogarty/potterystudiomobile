import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextStyles {
  static const _fontSizeSmall = 12.0;
  static const _fontSizeMedium = 16.0;
  static const _fontSizeBig = 20.0;

  static const smallSkinnyStyle = TextStyle(
      fontSize: _fontSizeSmall,
      fontWeight: FontWeight.w300,
      color: Colors.black);
  static const mediumSkinnyStyle = TextStyle(
      fontSize: _fontSizeMedium,
      fontWeight: FontWeight.w300,
      color: Colors.black);
  static const bigSkinnyStyle = TextStyle(
      fontSize: _fontSizeBig, fontWeight: FontWeight.w300, color: Colors.black);

  static const smallRegularStyle = TextStyle(
      fontSize: _fontSizeSmall,
      fontWeight: FontWeight.normal,
      color: Colors.black);
  static const mediumRegularStyle = TextStyle(
      fontSize: _fontSizeMedium,
      fontWeight: FontWeight.normal,
      color: Colors.black);
  static const bigRegularStyle = TextStyle(
      fontSize: _fontSizeBig,
      fontWeight: FontWeight.normal,
      color: Colors.black);

  static const smallBoldStyle = TextStyle(
      fontSize: _fontSizeSmall,
      fontWeight: FontWeight.bold,
      color: Colors.black);
  static const mediumBoldStyle = TextStyle(
      fontSize: _fontSizeMedium,
      fontWeight: FontWeight.bold,
      color: Colors.black);
  static const bigBoldStyle = TextStyle(
      fontSize: _fontSizeBig, fontWeight: FontWeight.bold, color: Colors.black);
}
