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
              top: 32,
              left: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image(
                          color: Theme.of(context).primaryColor,
                          image: AssetImage("assets/ic_launcher.png"),
                          width: 32.0),
                      Text(
                        "Pottery Studio",
                        style:
                            TextStyles().bigBoldStyle.copyWith(fontSize: 24.0),
                      ),
                      // hack to center "Pottery Studio" text
                      Image(
                          color: Colors.transparent,
                          image: AssetImage("assets/ic_launcher.png"),
                          width: 32.0),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 0, left: 16, right: 16, child: _loginOrAutoLogin()),
            Positioned(
                top: 0, bottom: 0, left: 16, right: 16, child: _emailLogin())
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
          obscureText: true,
          decoration: InputDecoration(labelText: "Password"),
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
                    child: Text("Sign up", style: TextStyles().mediumRegularStyle),
                    onPressed: _signUpWithEmail,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: Theme.of(context).accentColor))),
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
                      borderColor: Colors.black,
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
            borderColor: Colors.black,
          ),
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
