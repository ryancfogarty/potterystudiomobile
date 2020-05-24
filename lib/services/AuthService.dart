import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

enum AppState { UNAUTHENTICATED, AUTHENTICATED, REGISTERED }

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppState state = AppState.UNAUTHENTICATED;

  Future<FirebaseUser> get currentUser => _auth.currentUser();

  bool _continuingWithApple = false;

  bool get continuingWithApple => _continuingWithApple;

  bool _continuingWithGoogle = false;

  bool get signingInGoogle => _continuingWithGoogle;

  bool _autoLogIn = false;

  bool get autoLogIn => _autoLogIn;

  Future<void> autoSignIn() async {
    _autoLogIn = true;
    notifyListeners();

    try {
      if (await _isRegistered()) {
        state = AppState.REGISTERED;
      }
    } catch (e) {
      print(e);
    } finally {
      _autoLogIn = false;
      notifyListeners();
    }
  }

  Future<void> continueWithApple() async {
    _continuingWithApple = true;
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

            state = await _isRegistered()
                ? AppState.REGISTERED
                : AppState.AUTHENTICATED;
          } catch (e) {
            print("error");
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

    _continuingWithApple = false;
    notifyListeners();
  }

  Future<void> continueWithGoogle() async {
    _continuingWithGoogle = true;
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
      _continuingWithGoogle = false;
      notifyListeners();
    }
  }

  void updateState(AppState newState) {
    state = newState;
    notifyListeners();
  }

  Future<void> signOutOfGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    state = AppState.UNAUTHENTICATED;
    notifyListeners();
  }

  String _baseUrl = "https://us-central1-spot-629a6.cloudfunctions.net";

//  String _baseUrl = "http://10.0.2.2:5001/spot-629a6/us-central1";
  Future<bool> _isRegistered() async {
    var idToken = await (await currentUser)?.getIdToken(refresh: true);

    if (idToken == null) return false;

    var url = "$_baseUrl/api/user/valid";
    var response =
        await http.get(url, headers: {"Authorization": idToken.token});

    return response.statusCode == 200;
  }
}
