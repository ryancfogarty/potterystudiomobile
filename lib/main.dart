import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seven_spot_mobile/usecases/GetAllOpeningsUseCase.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _openings = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_openings),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("Refresh"),
              onPressed: () => getOpenings(),
            )
          ],
        ),
      ),
    );
  }

  void getOpenings() async {
    GetAllOpeningsUseCase useCase = GetAllOpeningsUseCase();

    var openings = await useCase.invoke();

    if (openings.length > 0) {
      _openings = openings.first.start.toIso8601String();
    }
  }
}