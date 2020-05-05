import 'package:flutter/widgets.dart';

class TextStyles {
  static final TextStyles _textStyles = TextStyles._internal();

  static final _fontSizeSmall = 12.0;
  static final _fontSizeMedium = 16.0;
  static final _fontSizeBig = 20.0;

  final smallSkinnyStyle = TextStyle(fontSize: _fontSizeSmall, fontWeight: FontWeight.w300);
  final mediumSkinnyStyle = TextStyle(fontSize: _fontSizeMedium, fontWeight: FontWeight.w300);
  final bigSkinnyStyle = TextStyle(fontSize: _fontSizeBig, fontWeight: FontWeight.w300);

  final smallRegularStyle = TextStyle(fontSize: _fontSizeSmall, fontWeight: FontWeight.normal);
  final mediumRegularStyle = TextStyle(fontSize: _fontSizeMedium, fontWeight: FontWeight.normal);
  final bigRegularStyle = TextStyle(fontSize: _fontSizeBig, fontWeight: FontWeight.normal);

  final smallBoldStyle = TextStyle(fontSize: _fontSizeSmall, fontWeight: FontWeight.bold);
  final mediumBoldStyle = TextStyle(fontSize: _fontSizeMedium, fontWeight: FontWeight.bold);
  final bigBoldStyle = TextStyle(fontSize: _fontSizeBig, fontWeight: FontWeight.bold);

  factory TextStyles() {
    return _textStyles;
  }

  TextStyles._internal();
}