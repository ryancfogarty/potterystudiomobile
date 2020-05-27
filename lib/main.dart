import 'dart:async';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/SupportsAppleLogin.dart';
import 'package:seven_spot_mobile/interactors/CreateAccountInteractor.dart';
import 'package:seven_spot_mobile/interactors/FiringListInteractor.dart';
import 'package:seven_spot_mobile/interactors/ProfileInteractor.dart';
import 'package:seven_spot_mobile/pages/CreateAccountPage.dart';
import 'package:seven_spot_mobile/pages/HomePage.dart';
import 'package:seven_spot_mobile/pages/LoginPage.dart';
import 'package:seven_spot_mobile/repositories/FiringRepository.dart';
import 'package:seven_spot_mobile/repositories/OpeningRepository.dart';
import 'package:seven_spot_mobile/repositories/StudioRepository.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/services/FiringService.dart';
import 'package:seven_spot_mobile/services/StudioService.dart';
import 'package:seven_spot_mobile/usecases/ChangePhotoUseCase.dart';
import 'package:seven_spot_mobile/usecases/CreateStudioUseCase.dart';
import 'package:seven_spot_mobile/usecases/CreateUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/DeleteFiringUseCase.dart';
import 'package:seven_spot_mobile/usecases/DeleteOpeningUseCase.dart';
import 'package:seven_spot_mobile/usecases/DeletePhotoUseCase.dart';
import 'package:seven_spot_mobile/usecases/DeleteUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetAllFiringsUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetAllOpeningsUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetFiringUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetOpeningUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/ManageFiringUseCase.dart';
import 'package:seven_spot_mobile/usecases/ManageOpeningUseCase.dart';
import 'package:seven_spot_mobile/usecases/RegisterAsAdminUseCase.dart';
import 'package:seven_spot_mobile/usecases/ToggleReservationUseCase.dart';
import 'package:seven_spot_mobile/usecases/UploadPhotoUseCase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var publicKeyString = await rootBundle.loadString('assets/public.pem');
  var keyParser = RSAKeyParser();
  var publicKey = keyParser.parse(publicKeyString);
  var encrypter = Encrypter(RSA(publicKey: publicKey));

  var authService = AuthService();
  var createUserUseCase = CreateUserUseCase(authService, encrypter);
  var openingRepository = OpeningRepository();
  var userRepository = UserRepository();
  var toggleReservationUseCase =
      ToggleReservationUseCaseImpl(openingRepository);
  var getUserUseCase = GetUserUseCaseImpl(userRepository);
  var getAllOpeningsUseCase = GetAllOpeningsUseCase();
  var getOpeningUseCase = GetOpeningUseCase(openingRepository);
  var manageOpeningUseCase = ManageOpeningUseCase(openingRepository);
  var deleteOpeningUseCase = DeleteOpeningUseCase(openingRepository);
  var firingService = FiringService();
  var firingRepository = FiringRepository(firingService);
  var getAllFiringsUseCase = GetAllFiringsUseCase(firingRepository);
  var firingListInteractor = FiringListInteractor(getAllFiringsUseCase);
  var deleteUserUseCase = DeleteUserUseCase(userRepository);
  var getFiringUseCase = GetFiringUseCase(firingRepository);
  var manageFiringUseCase = ManageFiringUseCase(firingRepository);
  var deleteFiringUseCase = DeleteFiringUseCase(firingRepository);
  var registerAsAdminUseCase =
      RegisterAsAdminUseCase(userRepository, getUserUseCase);
  var studioService = StudioService();
  var studioRepository = StudioRepository(studioService);
  var createStudioUseCase = CreateStudioUseCase(studioRepository, authService);
  var uploadPhotoUseCase = UploadPhotoUseCase();
  var createAccountInteractor = CreateAccountInteractor(
      createUserUseCase, createStudioUseCase, uploadPhotoUseCase);
  var changePhotoUseCase =
      ChangePhotoUseCase(userRepository, uploadPhotoUseCase, getUserUseCase);
  var deletePhotoUseCase = DeletePhotoUseCase(userRepository, getUserUseCase);
  var profileInteractor =
      ProfileInteractor(changePhotoUseCase, deletePhotoUseCase);

  await SupportsAppleLogin.init();
  authService.autoSignIn();

  return await runZoned<Future<Null>>(() async {
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => authService,
        ),
        ChangeNotifierProvider<ToggleReservationUseCase>(
            create: (_) => toggleReservationUseCase),
        ChangeNotifierProvider<GetUserUseCase>(create: (_) => getUserUseCase),
        ChangeNotifierProvider<GetOpeningUseCase>(
          create: (_) => getOpeningUseCase,
        ),
        ChangeNotifierProvider<ManageOpeningUseCase>(
          create: (_) => manageOpeningUseCase,
        ),
        ChangeNotifierProvider<DeleteOpeningUseCase>(
          create: (_) => deleteOpeningUseCase,
        ),
        ChangeNotifierProvider<FiringListInteractor>(
          create: (_) => firingListInteractor,
        ),
        ChangeNotifierProvider<DeleteUserUseCase>(
            create: (_) => deleteUserUseCase),
        ChangeNotifierProvider<GetFiringUseCase>(
          create: (_) => getFiringUseCase,
        ),
        ChangeNotifierProvider<ManageFiringUseCase>(
          create: (_) => manageFiringUseCase,
        ),
        ChangeNotifierProvider<DeleteFiringUseCase>(
          create: (_) => deleteFiringUseCase,
        ),
        ChangeNotifierProvider<GetAllOpeningsUseCase>(
          create: (_) => getAllOpeningsUseCase,
        ),
        ChangeNotifierProvider<RegisterAsAdminUseCase>(
            create: (_) => registerAsAdminUseCase),
        ChangeNotifierProvider<CreateAccountInteractor>(
          create: (_) => createAccountInteractor,
        ),
        ChangeNotifierProvider<ProfileInteractor>(
          create: (_) => profileInteractor,
        )
      ], child: MyApp()),
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.lightBlue,
            fontFamily: "Lato",
            appBarTheme: AppBarTheme(color: Colors.white),
            backgroundColor: Color.fromARGB(0xff, 0xf8, 0xf8, 0xf8)),
        home: Consumer<AuthService>(
          builder: (context, auth, child) {
            switch (auth.state) {
              case AppState.REGISTERED:
                return HomePage();
              case AppState.AUTHENTICATED:
                return CreateAccountPage();
              default:
                return LoginPage();
            }
          },
        ));
  }
}
