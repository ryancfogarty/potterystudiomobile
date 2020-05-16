import 'package:flutter/material.dart';
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
      backgroundColor: Theme.of(context).accentColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Pottery Studio",
                    style: TextStyles().bigBoldStyle,
                  ),
                  Text("v1.0.0")
                ],
              ),
            ),
            Icon(
              Icons.whatshot,
              size: 200,
              color: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 64.0),
              child: Consumer<AuthService>(
                builder: (context, service, _) {
                  return Center(
                    child: service.signingIn
                        ? Text("Loading...")
                        : FlatButton(
                          color: Colors.white,
                          onPressed: () => _loginWithGoogle(context),
                          child: Text("Sign in with Google")),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context);
      await authService.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }
}