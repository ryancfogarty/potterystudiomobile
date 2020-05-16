import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ToggleButtonView extends StatelessWidget {
  ToggleButtonView({Key key, this.title, this.toggleOn, this.onToggle})
      : super(key: key);

  final String title;
  final bool toggleOn;
  final Function() onToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: Theme.of(context).accentColor)),
        onPressed: onToggle,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "${toggleOn ? "Hide" : "Show"} previous $title",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ),
        ),
      ),
    );
  }
}
