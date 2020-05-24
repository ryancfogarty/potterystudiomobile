import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/SupportsAppleLogin.dart';
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
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  child: _loginOrAutoLogin()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginOrAutoLogin() {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return Visibility(
          visible: authService.autoLogIn,
          child: CircularProgressIndicator(),
          replacement: Column(
            children: <Widget>[_googleSignInButton(), _appleSignInButton()],
          ),
        );
      },
    );
  }

  Widget _googleSignInButton() {
    return RaisedButton(
      color: Colors.white,
      onPressed: _continueWithGoogle,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(color: Theme.of(context).accentColor)),
      child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    image: AssetImage("assets/google_logo.png"), height: 32.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Consumer<AuthService>(builder: (context, service, _) {
                    return Text(
                        service.signingInGoogle
                            ? "Authenicating..."
                            : 'Continue with Google',
                        style: TextStyles().bigRegularStyle);
                  }),
                )
              ])),
    );
  }

  Widget _appleSignInButton() {
    return Visibility(
      visible: SupportsAppleLogin().supported,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: AppleSignInButton(
          style: ButtonStyle.whiteOutline,
          type: ButtonType.continueButton,
          onPressed: _continueWithApple,
        ),
      ),
    );
  }

  Future<void> _continueWithGoogle() async {
    try {
      final authService = Provider.of<AuthService>(context);
      await authService.continueWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _continueWithApple() async {
    try {
      final authService = Provider.of<AuthService>(context);
      await authService.continueWithApple();
    } catch (e) {
      print(e.toString());
    }
  }
}
