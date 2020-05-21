import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/CreateUserUseCase.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _usersNameController = TextEditingController();
  final _studioCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _fetchUsersName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkResponse(
              onTap: _cancel,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          title: Text("Create account"),
        ),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "To register with your studio, enter the studio code."),
                    TextField(
                        controller: _usersNameController,
                        decoration: InputDecoration(labelText: "Display name")),
                    TextField(
                      controller: _studioCodeController,
                      decoration: InputDecoration(labelText: "Studio code"),
                    ),
                    _submitButton()
                  ],
                ))));
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<CreateUserUseCase>(builder: (context, useCase, _) {
        return Visibility(
          visible: !useCase.loading,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Theme.of(context).accentColor)),
            onPressed: () => _createUser(),
            child: Text(
              "Submit",
              style: TextStyles()
                  .mediumRegularStyle
                  .copyWith(color: Theme.of(context).accentColor),
            ),
          ),
          replacement: CircularProgressIndicator(),
        );
      }),
    );
  }

  void _cancel() async {
    var authService = Provider.of<AuthService>(context);
    await authService.signOutOfGoogle();
  }

  void _fetchUsersName() async {
    var authService = Provider.of<AuthService>(context);
    var currentUser = await authService.currentUser;

    _usersNameController.text = currentUser.displayName;
  }

  void _createUser() async {
    var useCase = Provider.of<CreateUserUseCase>(context);

    await useCase.createUser(
        _studioCodeController.text, _usersNameController.text);
  }
}
