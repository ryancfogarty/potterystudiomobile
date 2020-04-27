import 'package:flutter/widgets.dart';

class TextStyles {
  static final TextStyles _textStyles = TextStyles._internal();

  final smallRegularStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal);
  final mediumRegularStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal);
  final bigRegularStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal);

  final smallBoldStyle = TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold);
  final mediumBoldStyle = TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold);
  final bigBoldStyle = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  factory TextStyles() {
    return _textStyles;
  }

  TextStyles._internal();
}