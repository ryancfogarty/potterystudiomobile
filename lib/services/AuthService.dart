import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

    state = AppState.AUTHENTICATED;
    notifyListeners();
  }

  Future<void> signOutOfGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    state = AppState.UNAUTHENTICATED;
    notifyListeners();
  }
}
