import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pottery_studio/usecases/GetUserUseCase.dart';

enum AppState { UNAUTHENTICATED, AUTHENTICATED, REGISTERED }

class AuthService extends ChangeNotifier {
  GetUserUseCase _getUserUseCase;

  AuthService(GetUserUseCase getUserUseCase) {
    _getUserUseCase = getUserUseCase;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId:
          "");

  AppState state = AppState.UNAUTHENTICATED;

  Future<FirebaseUser> get currentUser => _auth.currentUser();

  bool _authenticating = false;

  bool get authenticating => _authenticating;

  Future<void> autoSignIn() async {
    _authenticating = true;
    notifyListeners();

    try {
      if (await _isRegistered()) {
        state = AppState.REGISTERED;
      }
    } catch (e) {
      print(e);
    } finally {
      _authenticating = false;
      notifyListeners();
    }
  }

  Future<void> createAccount(String email, String password) async {
    var result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    result.user.sendEmailVerification();
  }

  Future<void> loginWithEmail(String email, String password) async {
    _authenticating = true;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      var currentUser = await _auth.currentUser();

      if (!currentUser.isEmailVerified) {
        await _auth.signOut();
        throw Exception();
      }

      state =
          await _isRegistered() ? AppState.REGISTERED : AppState.AUTHENTICATED;
      notifyListeners();
    } catch (e) {
      throw e;
    } finally {
      _authenticating = false;
      notifyListeners();
    }
  }

  Future<void> continueWithApple() async {
    _authenticating = true;
    notifyListeners();

    try {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          try {
            print("successfull sign in");
            final AppleIdCredential appleIdCredential = result.credential;

            OAuthProvider oAuthProvider =
                new OAuthProvider(providerId: "apple.com");

            final AuthCredential credential = oAuthProvider.getCredential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken),
              accessToken:
                  String.fromCharCodes(appleIdCredential.authorizationCode),
            );

            final FirebaseUser user =
                (await _auth.signInWithCredential(credential)).user;

            if (user.isAnonymous || await user.getIdToken() == null) {
              throw Exception("Invalid user");
            }

            UserUpdateInfo userUpdateInfo = UserUpdateInfo();
            userUpdateInfo.displayName =
                "${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}";
            await user.updateProfile(userUpdateInfo);

            state = await _isRegistered()
                ? AppState.REGISTERED
                : AppState.AUTHENTICATED;
          } catch (e) {
            print("error $e");
          }
          break;
        case AuthorizationStatus.error:
          print("apple error ${result.error.localizedDescription}");
          break;

        case AuthorizationStatus.cancelled:
          print("User cancelled");
          break;
      }
    } catch (error) {
      print("error with apple sign in");
    }

    _authenticating = false;
    notifyListeners();
  }

  Future<void> continueWithGoogle() async {
    _authenticating = true;
    notifyListeners();

    try {
      final account = await _googleSignIn.signIn();
      final GoogleSignInAuthentication authentication =
          await account.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );

      final AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser user = result.user;

      if (user.isAnonymous || await user.getIdToken() == null) {
        throw Exception("Invalid user");
      }

      state =
          await _isRegistered() ? AppState.REGISTERED : AppState.AUTHENTICATED;
    } catch (e) {
      print(e);
    } finally {
      _authenticating = false;
      notifyListeners();
    }
  }

  void updateState(AppState newState) {
    state = newState;
    notifyListeners();
  }

  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    Navigator.popUntil(context, ModalRoute.withName("/"));

    state = AppState.UNAUTHENTICATED;
    notifyListeners();
  }

  Future<bool> _isRegistered() async {
    try {
      await _getUserUseCase.getUser();
      return _getUserUseCase.user != null;
    } catch (e) {
      return false;
    }
  }
}
