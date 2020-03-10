import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seven_spot_mobile/pages/LoginPage.dart';
import 'package:seven_spot_mobile/pages/MainPage.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return MaterialApp(
      title: "7 Spot",
      home: FutureBuilder(
        future: authService.currentUser,
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) =>
            _getBody(snapshot)
      ),
    );
  }

  Widget _getBody(AsyncSnapshot<FirebaseUser> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (snapshot.error != null) {
      return Scaffold(body: Center(child: Text(snapshot.error.toString())));
    }
    return snapshot.data == null ? LoginPage() : MainPage();
  }
}
