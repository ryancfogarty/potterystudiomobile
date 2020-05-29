import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HttpRetryDialog {
  static bool shown = false;

  static final HttpRetryDialog _httpRetryDialog = HttpRetryDialog._internal();

  factory HttpRetryDialog() {
    return _httpRetryDialog;
  }

  HttpRetryDialog._internal();

  void retry(BuildContext context, Function retry) async {
    if (!shown) {
      shown = true;

      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Error"),
            content: Text("An error has occurred"),
            actions: <Widget>[
              FlatButton(
                child: Text("Dismiss"),
                onPressed: () {
                  shown = false;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Retry"),
                onPressed: () {
                  shown = false;
                  Navigator.of(context).pop();

                  retry();
                },
              )
            ],
          ));
    }
  }
}
