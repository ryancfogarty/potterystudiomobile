import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/pages/CreateAccountPage.dart';
import 'package:seven_spot_mobile/pages/LoginPage.dart';
import 'package:seven_spot_mobile/pages/MainPage.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

void main() async {
  var authService = AuthService();

  return await runZoned<Future<Null>>(
    () async {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>(
              create: (_) => authService,
            )
          ],
          child: MyApp()
        ),
      );
    }
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<AuthService>(
        builder: (context, auth, child) {
          print("state: " + auth.state.toString());

          if (auth.state == AppState.VALIDATED) {
            return MainPage();
          } else if (auth.state == AppState.AUTHENTICATED) {
            return CreateAccountPage();
          } else {
            return LoginPage();
          }
        },
      )
    );
  }
}
