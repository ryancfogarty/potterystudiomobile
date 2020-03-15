import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;


enum AppState {
  UNAUTHENTICATED,
  AUTHENTICATED,
  VALIDATED
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AppState state = AppState.UNAUTHENTICATED;

  Future<FirebaseUser> get currentUser => _auth.currentUser();

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication authentication = await account.authentication;

    final AuthCredential creds = GoogleAuthProvider.getCredential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    final AuthResult result = await _auth.signInWithCredential(creds);
    final FirebaseUser user = result.user;

    if (user.isAnonymous || await user.getIdToken() == null) {
      throw Exception("Invalid user");
    }

    state = await _isValid() ? AppState.VALIDATED : AppState.AUTHENTICATED;
    notifyListeners();
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
  Future<bool> _isValid() async {
    var idToken = await (await currentUser).getIdToken(refresh: true);

    var url = "$_baseUrl/api/user/valid";
    var response = await http.get(url,
        headers: { "Authorization": idToken.token });

    return response.statusCode == 200;
  }
}
