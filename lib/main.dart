import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/pages/CreateAccountPage.dart';
import 'package:seven_spot_mobile/pages/LoginPage.dart';
import 'package:seven_spot_mobile/pages/MainPage.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/CreateAccountUseCase.dart';

void main() async {
  var authService = AuthService();
  var createAccountUseCase = CreateAccountUseCase(authService);

  return await runZoned<Future<Null>>(
    () async {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>(
              create: (_) => authService,
            ),
            Provider<CreateAccountUseCase>(
              create: (_) => createAccountUseCase,
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
          switch(auth.state) {
            case AppState.VALIDATED:
              return MainPage();
            case AppState.AUTHENTICATED:
              return CreateAccountPage();
            default:
              return LoginPage();
          }
        },
      )
    );
  }
}
