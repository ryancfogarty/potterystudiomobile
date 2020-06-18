import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pottery_studio/common/SupportsAppleLogin.dart';
import 'package:pottery_studio/interactors/CheckedInInteractor.dart';
import 'package:pottery_studio/interactors/CreateAccountInteractor.dart';
import 'package:pottery_studio/interactors/FiringListInteractor.dart';
import 'package:pottery_studio/interactors/ProfileInteractor.dart';
import 'package:pottery_studio/pages/CreateAccountPage.dart';
import 'package:pottery_studio/pages/HomePage.dart';
import 'package:pottery_studio/pages/LoginPage.dart';
import 'package:pottery_studio/repositories/FiringRepository.dart';
import 'package:pottery_studio/repositories/OpeningRepository.dart';
import 'package:pottery_studio/repositories/StudioRepository.dart';
import 'package:pottery_studio/repositories/UserRepository.dart';
import 'package:pottery_studio/services/AuthService.dart';
import 'package:pottery_studio/services/FiringService.dart';
import 'package:pottery_studio/services/OpeningService.dart';
import 'package:pottery_studio/services/StudioService.dart';
import 'package:pottery_studio/usecases/ChangePhotoUseCase.dart';
import 'package:pottery_studio/usecases/CheckInUseCase.dart';
import 'package:pottery_studio/usecases/CheckOutUseCase.dart';
import 'package:pottery_studio/usecases/CreateStudioUseCase.dart';
import 'package:pottery_studio/usecases/CreateUserUseCase.dart';
import 'package:pottery_studio/usecases/DeleteFiringUseCase.dart';
import 'package:pottery_studio/usecases/DeleteOpeningUseCase.dart';
import 'package:pottery_studio/usecases/DeletePhotoUseCase.dart';
import 'package:pottery_studio/usecases/DeleteUserUseCase.dart';
import 'package:pottery_studio/usecases/GetAllFiringsUseCase.dart';
import 'package:pottery_studio/usecases/GetAllOpeningsUseCase.dart';
import 'package:pottery_studio/usecases/GetFiringUseCase.dart';
import 'package:pottery_studio/usecases/GetOpeningUseCase.dart';
import 'package:pottery_studio/usecases/GetPresentUsersUseCase.dart';
import 'package:pottery_studio/usecases/GetUserUseCase.dart';
import 'package:pottery_studio/usecases/ManageFiringUseCase.dart';
import 'package:pottery_studio/usecases/ManageOpeningUseCase.dart';
import 'package:pottery_studio/usecases/RegisterAsAdminUseCase.dart';
import 'package:pottery_studio/usecases/ToggleReservationUseCase.dart';
import 'package:pottery_studio/usecases/UpdateProfileUseCase.dart';
import 'package:pottery_studio/usecases/UpdateStudioBannerUseCase.dart';
import 'package:pottery_studio/usecases/UploadPhotoUseCase.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseAuth auth = FirebaseAuth.instance;
  var authenticatedDio = Dio();
  authenticatedDio.options.baseUrl =
      "https://us-central1-spot-629a6.cloudfunctions.net";
  //  dio.options.baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";
  authenticatedDio.options.connectTimeout = 15000;
  authenticatedDio.interceptors
      .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
    var idToken = await (await auth.currentUser()).getIdToken(refresh: true);

    options.headers.addAll({"Authorization": idToken.token});
  }, onResponse: (Response<dynamic> response) async {
    // todo
//    if (response.statusCode == 401) {
//      var idToken = await (await auth.currentUser()).getIdToken(refresh: true);
//
//      var request = response.request;
//      request.headers.addAll({"Authorization": idToken.token});
//      authenticatedDio.request(request.path,
//          data: request.data,
//          queryParameters: request.queryParameters,
//          cancelToken: request.cancelToken);
//    }
  }));

//  var publicKeyString = await rootBundle.loadString('assets/public.pem');
//  var keyParser = RSAKeyParser();
//  var publicKey = keyParser.parse(publicKeyString);
//  var encrypter = Encrypter(RSA(publicKey: publicKey));

  var openingService = OpeningService(authenticatedDio);
  var openingRepository = OpeningRepository(openingService);
  var userRepository = UserRepository();
  var toggleReservationUseCase =
      ToggleReservationUseCaseImpl(openingRepository);
  var getUserUseCase = GetUserUseCaseImpl(userRepository);
  var authService = AuthService(getUserUseCase);
  var createUserUseCase = CreateUserUseCase(authService);
  var getAllOpeningsUseCase = GetAllOpeningsUseCase(openingRepository);
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
  var updateProfileUseCase =
      UpdateProfileUseCase(userRepository, getUserUseCase);
  var profileInteractor = ProfileInteractor(
      changePhotoUseCase, deletePhotoUseCase, updateProfileUseCase);
  var getPresentUsersUseCase = GetPresentUsersUseCase(userRepository);
  var checkInUseCase = CheckInUseCase(userRepository);
  var checkOutUseCase = CheckOutUseCase(userRepository);
  var checkedInInteractor = CheckedInInteractor(
      getUserUseCase, checkInUseCase, checkOutUseCase, getPresentUsersUseCase);
  var updateStudioBannerUseCase =
      UpdateStudioBannerUseCase(studioRepository, getUserUseCase);

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
        ),
        ChangeNotifierProvider<GetPresentUsersUseCase>(
          create: (_) => getPresentUsersUseCase,
        ),
        ChangeNotifierProxyProvider2<GetUserUseCase, GetPresentUsersUseCase,
            CheckedInInteractor>(
          create: (context) => checkedInInteractor,
          update: (context, A, B, R) => checkedInInteractor..update(),
        ),
        ChangeNotifierProvider<UpdateStudioBannerUseCase>(
            create: (_) => updateStudioBannerUseCase)
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
        debugShowCheckedModeBanner: false,
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
