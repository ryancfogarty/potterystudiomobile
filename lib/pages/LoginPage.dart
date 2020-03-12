import 'package:flutter/material.dart';
import 'package:seven_spot_mobile/pages/MainPage.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : RaisedButton(
            onPressed: () => _loginWithGoogle(context),
            child: Text("Sign in with Google")),
      ),
    );
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    _isLoading = true;
    final authService = AuthService();
    await authService.signInWithGoogle();
    _isLoading = false;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) {
        return MainPage();
      }),
    );
  }
}