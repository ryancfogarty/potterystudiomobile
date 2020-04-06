import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/pages/CreateUserPage.dart';
import 'package:seven_spot_mobile/pages/LoginPage.dart';
import 'package:seven_spot_mobile/pages/MainPage.dart';
import 'package:seven_spot_mobile/repositories/OpeningRepository.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/CreateUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/ToggleReservationUseCase.dart';

void main() async {
  var authService = AuthService();
  var createUserUseCase = CreateUserUseCase(authService);
  var openingRepository = OpeningRepository();
  var userRepository = UserRepository();
  var toggleReservationUseCase = ToggleReservationUseCaseImpl(openingRepository);
  var getUserUseCase = GetUserUseCaseImpl(userRepository);

  return await runZoned<Future<Null>>(
    () async {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthService>(
              create: (_) => authService,
            ),
            Provider<CreateUserUseCase>(
              create: (_) => createUserUseCase,
            ),
            ChangeNotifierProvider<ToggleReservationUseCase>(
              create: (_) => toggleReservationUseCase
            ),
            ChangeNotifierProvider<GetUserUseCase>(
              create: (_) => getUserUseCase
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
              return CreateUserPage();
            default:
              return LoginPage();
          }
        },
      )
    );
  }
}
