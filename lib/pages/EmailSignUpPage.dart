import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class EmailSignUpPage extends StatefulWidget {
  _EmailSignUpPageState createState() => _EmailSignUpPageState();
}

class _EmailSignUpPageState extends State<EmailSignUpPage> {
  bool _autovalidate = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();

  FocusNode _emailNode = FocusNode();
  FocusNode _passwordNode = FocusNode();
  FocusNode _verifyPasswordNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autovalidate,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _emailNode.unfocus();
                  FocusScope.of(context).requestFocus(_passwordNode);
                },
                validator: (String email) {
                  Pattern pattern =
                      r"""(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])""";
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(email))
                    return 'Invalid email';
                  else
                    return null;
                },
                focusNode: _emailNode,
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _passwordNode.unfocus();
                  FocusScope.of(context).requestFocus(_verifyPasswordNode);
                },
                focusNode: _passwordNode,
                controller: _passwordController,
                obscureText: true,
                validator: (password) =>
                    password.compareTo(_verifyPasswordController.text) == 0
                        ? null
                        : "Passwords do not match",
                decoration: InputDecoration(labelText: "Password"),
              ),
              TextFormField(
                focusNode: _verifyPasswordNode,
                controller: _verifyPasswordController,
                obscureText: true,
                validator: (password) =>
                    password.compareTo(_passwordController.text) == 0
                        ? null
                        : "Passwords do not match",
                decoration: InputDecoration(labelText: "Verify password"),
              ),
              Container(height: 16.0),
              Container(
                width: double.infinity,
                child: FlatButton(
                    child:
                        Text("Sign up", style: TextStyles().mediumRegularStyle),
                    onPressed: _signUp,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side:
                            BorderSide(color: Theme.of(context).accentColor))),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _autovalidate = true;
      });
      return;
    }

    try {
      await Provider.of<AuthService>(context)
          .createAccount(_emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text("Invalid email or password"),
            content:
                Text("Email is malformed or password is not strong enough."),
            actions: <Widget>[
              FlatButton(
                child: Text("Dismiss"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
      return;
    }

    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Verify email"),
          content: Text(
              "A verification link has been sent to your email address. Please click on it to verify your email before logging in."),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(HashMap.from({
                  "email": _emailController.text,
                  "password": _passwordController.text
                }));
              },
            )
          ],
        ));
  }
}
