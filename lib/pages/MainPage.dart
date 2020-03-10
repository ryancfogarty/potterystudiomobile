import 'package:flutter/material.dart';
import 'package:seven_spot_mobile/usecases/GetAllOpeningsUseCase.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String test = "empty";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FlatButton(
          child: Text(test),
          onPressed: () => fetch(),
        )
      ),
    );
  }

  void fetch() async {
    var openings = await GetAllOpeningsUseCase().invoke();

    setState(() {
      test = openings.first?.start?.toIso8601String() ?? "none";
    });
  }
}