import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/CreateUserUseCase.dart';

class CreateUserPage extends StatefulWidget {
  @override
  _CreateUserPageState createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  String _usersName = "";
  final _companyNameController = TextEditingController();
  final _companySecretController = TextEditingController();

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
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_usersName),
          TextField(
            controller: _companyNameController,
            decoration: InputDecoration(hintText: "Enter your studio name"),
          ),
          TextField(
            controller: _companySecretController,
            decoration: InputDecoration(hintText: "Enter your studio secret"),
          ),
          RaisedButton(
            onPressed: () => _createUser(),
            child: Text("Submit"),
          )
        ],
      )),
    );
  }

  void _fetchUsersName() async {
    var authService = Provider.of<AuthService>(context);
    var currentUser = await authService.currentUser;
    print(currentUser.displayName);

    setState(() {
      _usersName = currentUser.displayName;
    });
  }

  void _createUser() async {
    var useCase = Provider.of<CreateUserUseCase>(context);

    print(_companySecretController.text);
    print(_companyNameController.text);

    await useCase.createUser(
        _companySecretController.text, _companyNameController.text);
  }
}
