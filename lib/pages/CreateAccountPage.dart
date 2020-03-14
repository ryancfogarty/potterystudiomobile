import 'package:flutter/material.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _authService = AuthService();

  String _name = "";

  @override
  void initState() {
    super.initState();

    _fetchUsersName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(_name),
      ),
    );
  }

  void _fetchUsersName() async {
    var currentUser = await _authService.currentUser;

    setState(() {
      _name = currentUser.displayName;
    });
  }
}
