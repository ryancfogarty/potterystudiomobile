import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/CreateStudioUseCase.dart';
import 'package:seven_spot_mobile/usecases/CreateUserUseCase.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _usersNameController = TextEditingController();
  final _studioCodeController = TextEditingController();
  final _studioNameController = TextEditingController();

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
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                        controller: _usersNameController,
                        decoration: InputDecoration(labelText: "Display name")),
                    Container(height: 96.0),
                    Text(
                        "To register with an existing studio, enter the studio code."),
                    TextField(
                      controller: _studioCodeController,
                      decoration: InputDecoration(labelText: "Studio code"),
                    ),
                    _createUserButton(),
                    Container(height: 48.0),
                    Text(
                        "Or, to create a new studio, enter your desired studio name."),
                    TextField(
                      controller: _studioNameController,
                      decoration: InputDecoration(labelText: "Studio name"),
                    ),
                    _createStudioButton()
                  ],
                ))));
  }

  Widget _createUserButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<CreateUserUseCase>(builder: (context, useCase, _) {
        return Visibility(
          visible: !useCase.loading,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Theme.of(context).accentColor)),
            onPressed: _createUser,
            child: Text(
              "Create account",
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

  Widget _createStudioButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<CreateStudioUseCase>(builder: (context, useCase, _) {
        return Visibility(
          visible: !useCase.loading,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Theme.of(context).accentColor)),
            onPressed: _createStudio,
            child: Text(
              "Create studio",
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

  void _createStudio() async {
    var useCase = Provider.of<CreateStudioUseCase>(context);

    await useCase.createStudio(
        _usersNameController.text, _studioNameController.text);
  }
}
