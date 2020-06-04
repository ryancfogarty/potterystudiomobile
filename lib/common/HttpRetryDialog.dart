import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HttpRetryDialog {
  static bool showing = false;

  static final HttpRetryDialog _httpRetryDialog = HttpRetryDialog._internal();

  factory HttpRetryDialog() {
    return _httpRetryDialog;
  }

  HttpRetryDialog._internal();

  void retry(BuildContext context, Function retry, {Function onDismiss}) async {
    if (!showing) {
      showing = true;

      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Error"),
            content: Text("An error has occurred"),
            actions: <Widget>[
              FlatButton(
                child: Text("Dismiss"),
                onPressed: () {
                  if (onDismiss != null) onDismiss();

                  showing = false;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Retry"),
                onPressed: () {
                  showing = false;
                  Navigator.of(context).pop();

                  retry();
                },
              )
            ],
          ));
    }
  }
}
