import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/CreateAccountUseCase.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  String _name = "";
  final _companySecretController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fetchUsersName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_name),
            TextField(
              controller: _companySecretController,
              decoration: InputDecoration(
                hintText: "Enter your studio secret"
              ),
            ),
            RaisedButton(
              onPressed: () => _createAccount(),
              child: Text("Create account"),
            )
          ],
        )
      ),
    );
  }

  void _fetchUsersName() async {
    var authService = Provider.of<AuthService>(context);
    var currentUser = await authService.currentUser;

    setState(() {
      _name = currentUser.displayName;
    });
  }

  void _createAccount() async {
    var useCase = Provider.of<CreateAccountUseCase>(context);

    await useCase.createAccount(_companySecretController.text);
  }
}
