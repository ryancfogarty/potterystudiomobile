import 'package:flutter/material.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/pages/OpeningsList.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/GetAllOpeningsUseCase.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  Iterable<Opening> _openings = Iterable.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("7spot"),
        actions: [
          FlatButton(
            child: Icon(Icons.power),
            onPressed: () => AuthService().signOutOfGoogle(),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavBar(),
      backgroundColor: Colors.white,
      body: _currentIndex == 0
        ? OpeningsList(openings: _openings, onRefresh: _fetch)
        : Text("Firings")
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          title: Text("Slots"),
          icon: Icon(Icons.event_available)
        ),
        BottomNavigationBarItem(
          title: Text("Firings"),
          icon: Icon(Icons.hot_tub)
        )
      ],
      currentIndex: _currentIndex,
      onTap: (idx) {
        setState(() {
          _currentIndex = idx;
        });
      },
      selectedItemColor: Colors.amber
    );
  }

  Future<void> _fetch() async {
    var openings = await GetAllOpeningsUseCase().invoke();

    setState(() {
      _openings = openings;
    });
  }
}