import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OpeningPage extends StatefulWidget {
  OpeningPage({
    Key key,
    @required this.openingId
  }) : super(key: key);

  final String openingId;

  @override
  State<StatefulWidget> createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,



    );
  }
}