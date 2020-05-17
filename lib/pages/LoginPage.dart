import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Pottery Studio",
                      style: TextStyles().bigBoldStyle,
                    ),
                    Text("(Beta)")
                  ],
                ),
              ),
              Image(
                  image: AssetImage("assets/ic_launcher.png"),
                  width: 128.0,
                  color: Theme.of(context).primaryColor),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 64.0),
                  child: _googleSignInButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _googleSignInButton() {
    return RaisedButton(
      onPressed: _loginWithGoogle,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/google_logo.png"), height: 35.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Consumer<AuthService>(builder: (context, service, _) {
                    return Text(
                        service.signingIn
                            ? "Signing in..."
                            : 'Sign in with Google',
                        style: TextStyles().bigRegularStyle);
                  }),
                )
              ])),
    );
  }

  Future<void> _loginWithGoogle() async {
    try {
      final authService = Provider.of<AuthService>(context);
      await authService.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }
}
