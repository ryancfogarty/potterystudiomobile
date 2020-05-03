import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      body: Consumer<AuthService>(
        builder: (context, service, _) {
          return Center(
            child: service.signingIn
                ? CircularProgressIndicator()
                : RaisedButton(
                onPressed: () => _loginWithGoogle(context),
                child: Text("Sign in with Google")),
          );
        }
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