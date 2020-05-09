import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/interactors/FiringListInteractor.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/pages/FiringsList.dart';
import 'package:seven_spot_mobile/pages/ManageFiringPage.dart';
import 'package:seven_spot_mobile/pages/ManageOpeningPage.dart';
import 'package:seven_spot_mobile/pages/OpeningsList.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/DeleteUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetAllOpeningsUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  Iterable<Opening> _openings = Iterable.empty();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _getUser);
  }

  _getUser() {
    var useCase = Provider.of<GetUserUseCase>(context, listen: false);
    useCase.getUser();
  }

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Consumer<GetUserUseCase>(
          builder: (context, useCase, child) {
            return Text(useCase.user?.companyName ?? "Loading...");
          },
        )
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Pottery studio'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black
              ),
              title: Text("Sign out"),
              onTap: authService.signOutOfGoogle
            ),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Colors.black
              ),
              title: Text("Delete my account"),
              onTap: () async {
                var success = await Provider.of<DeleteUserUseCase>(context, listen: false).invoke();

                if (success) {
                  authService.signOutOfGoogle();
                } else {
                  // todo: show error message asking user to contact admin
                }
              }
            ),
            ListTile(
              title: Text("Become an admin (coming soon...)")
            ),
            ListTile(
              title: Text("Make a user an admin (coming soon...)")
            )
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
      backgroundColor: Colors.white,
      body: _currentIndex == 0
        ? Consumer<GetAllOpeningsUseCase>(
            builder: (context, useCase, _) {
              return OpeningsList(
                openings: useCase.openings,
                onRefresh: _fetch
              );
            }
        )
        : FiringsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFabPressed,
        icon: Icon(Icons.add),
        label: Text("Add ${_currentIndex == 0 ? "Opening" : "Firing"}"),
      )
    );
  }

  void _onFabPressed() async {
    if (_currentIndex == 0) {
      var shouldRefreshList = await Navigator.push(context, MaterialPageRoute(builder: (context) => ManageOpeningPage()));

      if (shouldRefreshList ?? false) _fetch();
    } else {
      var shouldRefreshList = await Navigator.push(context, MaterialPageRoute(builder: (context) => ManageFiringPage()));

      if (shouldRefreshList ?? false) Provider.of<FiringListInteractor>(context, listen: false).getAll();
    }
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          title: Text("Openings"),
          icon: Icon(Icons.event_available)
        ),
        BottomNavigationBarItem(
          title: Text("Firings"),
          icon: Icon(Icons.hot_tub)
        )
      ],
      currentIndex: _currentIndex,
      onTap: (idx) {
        // todo: move to interactor: ChangeNotifier
        setState(() {
          _currentIndex = idx;
        });
      },
      selectedItemColor: Colors.lightBlue
    );
  }

  Future<void> _fetch() async {
    await Provider.of<GetAllOpeningsUseCase>(context, listen: false).invoke();
  }
}