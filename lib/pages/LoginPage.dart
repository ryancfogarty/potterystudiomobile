import 'package:blobs/blobs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/SupportsAppleLogin.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/pages/EmailSignUpPage.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/views/ThirdPartySignInButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Stack(
          children: <Widget>[
            Positioned(
              top: -100,
              left: -100,
              child: Blob.fromID(
                styles: BlobStyles(
                  color: Theme.of(context).primaryColor.withAlpha(50),
                ),
                size: 200,
                id: ["8-8-8"],
              ),
            ),
            Positioned(
              left: -50,
              top: MediaQuery.of(context).size.height / 1.8,
              child: Blob.fromID(
                styles: BlobStyles(
                  color: Theme.of(context).primaryColor.withAlpha(50),
                ),
                size: 200,
                id: ["6-6-10"],
              ),
            ),
            Positioned(
              right: -70,
              top: MediaQuery.of(context).size.height / 10,
              child: Blob.fromID(
                styles: BlobStyles(
                  color: Theme.of(context).primaryColor.withAlpha(50),
                ),
                size: 200,
                id: ["7-7-7"],
              ),
            ),
            Positioned(
              top: 32,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Pottery Studio",
                  style: TextStyles().bigBoldStyle.copyWith(fontSize: 24.0),
                ),
              ),
            ),
            Positioned(
                bottom: 0, left: 16, right: 16, child: _loginOrAutoLogin()),
            Positioned(
                top: 0, bottom: 0, left: 16, right: 16, child: _emailLogin()),
          ],
        )),
      ),
    );
  }

  Widget _emailLogin() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _emailNode.unfocus();
            FocusScope.of(context).requestFocus(_passwordNode);
          },
          focusNode: _emailNode,
          controller: _emailController,
          decoration: InputDecoration(labelText: "Email"),
        ),
        TextFormField(
          focusNode: _passwordNode,
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
              labelText: "Password",
              suffixIcon: IconButton(
                icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() {
                  _obscurePassword = !_obscurePassword;
                }),
              )),
        ),
        Container(height: 16.0),
        Container(
          width: double.infinity,
          child: FlatButton(
              child: Text("Sign in", style: TextStyles().mediumRegularStyle),
              onPressed: _logInWithEmailAndPassword,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Theme.of(context).accentColor))),
        ),
        Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0,
          child: Column(
            children: <Widget>[
              Divider(),
              Container(
                width: double.infinity,
                child: FlatButton(
                    child:
                        Text("Sign up", style: TextStyles().mediumRegularStyle),
                    onPressed: _signUpWithEmail,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side:
                            BorderSide(color: Theme.of(context).accentColor))),
              )
            ],
          ),
        )
      ],
    );
  }

  void _signUpWithEmail() async {
    var map = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => EmailSignUpPage()));

    if (map != null) {
      _emailController.text = map["email"];
      _passwordController.text = map["password"];
    }
  }

  void _logInWithEmailAndPassword() async {
    try {
      await Provider.of<AuthService>(context)
          .loginWithEmail(_emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Error"),
            content: Text(
                "Incorrect email or password, or email has not been verified."),
            actions: <Widget>[
              FlatButton(
                child: Text("Dismiss"),
                onPressed: Navigator.of(context).pop,
              )
            ],
          ));
    }
  }

  Widget _loginOrAutoLogin() {
    var keyboardOpen = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Consumer<AuthService>(
      builder: (context, authService, _) {
        return Visibility(
          visible: authService.authenticating,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
          replacement: Column(
            children: <Widget>[
              Visibility(
                visible: keyboardOpen,
                child: Column(
                  children: <Widget>[
                    ThirdPartySignInButton(
                      logoUri: "assets/google_logo.png",
                      thirdPartyProvider: "Google",
                      onPressed: _continueWithGoogle,
                      borderColor: Colors.black.withAlpha(150),
                    ),
                    _appleSignInButton(),
                  ],
                ),
              ),
              FlatButton(
                  child: Text("About",
                      style: TextStyles().mediumRegularStyle.copyWith(
                          color: Theme.of(context).accentColor,
                          decoration: TextDecoration.underline)),
                  onPressed: () {
                    showAboutDialog(
                        context: context,
                        applicationName: "Pottery Studio",
                        applicationVersion: "0.1.0",
                        applicationLegalese: "© Ryan Fogarty 2020 ",
                        applicationIcon: Image(
                            height: 30,
                            width: 30,
                            image: AssetImage("assets/ic_launcher.png")));
                  })
            ],
          ),
        );
      },
    );
  }

  Widget _appleSignInButton() {
    return Visibility(
        visible: SupportsAppleLogin().supported,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ThirdPartySignInButton(
              logoUri: "assets/apple_logo.png",
              thirdPartyProvider: "Apple",
              onPressed: _continueWithApple,
              borderColor: Colors.black.withAlpha(150)),
        ));
  }

  Future<void> _continueWithGoogle() async {
    try {
      final authService = Provider.of<AuthService>(context);
      await authService.continueWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _continueWithApple() async {
    try {
      final authService = Provider.of<AuthService>(context);
      await authService.continueWithApple();
    } catch (e) {
      print(e.toString());
    }
  }
}
