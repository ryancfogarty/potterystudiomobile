import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/interactors/FiringListInteractor.dart';
import 'package:seven_spot_mobile/pages/FiringsList.dart';
import 'package:seven_spot_mobile/pages/ManageFiringPage.dart';
import 'package:seven_spot_mobile/pages/ManageOpeningPage.dart';
import 'package:seven_spot_mobile/pages/OpeningsList.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/GetAllOpeningsUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';
import 'package:seven_spot_mobile/views/FiringCard.dart';
import 'package:seven_spot_mobile/views/HomePageSettings.dart';
import 'package:seven_spot_mobile/views/OpeningCard.dart';
import 'package:seven_spot_mobile/views/UpcomingListPreview.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      _getOpenings();
      _getFirings();
      _getUser();
    });
  }

  _getOpenings() async {
    try {
      await Provider.of<GetAllOpeningsUseCase>(context, listen: false).invoke();
    } catch (e) {
      print(e);
    }
  }

  _getFirings() async {
    try {
      await Provider.of<FiringListInteractor>(context, listen: false).getAll();
    } catch (e) {
      print(e);
    }
  }

  _getUser() async {
    try {
      await Provider.of<GetUserUseCase>(context, listen: false).getUser();
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("An error occurred while fetching your details."),
              actions: [
                FlatButton(
                  child: Text("Sign out"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Provider.of<AuthService>(context, listen: false)
                        .signOutOfGoogle();
                  },
                ),
                FlatButton(
                  child: Text("Retry"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _getUser();
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        backgroundColor: Colors.white,
        title: Consumer<GetUserUseCase>(builder: (context, useCase, _) {
          return Text(useCase.user?.studioName ?? "Loading...",
              style: TextStyles().bigRegularStyle);
        }),
        actions: <Widget>[
          InkWell(
              onTap: () {},
              child: FutureBuilder<FirebaseUser>(
                future: authService.currentUser,
                builder: (context, snapshot) {
                  return Visibility(
                    visible: snapshot.hasData,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 4.0, bottom: 4.0, right: 16.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(snapshot.data?.photoUrl ??
                              "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png")),
                    ),
                    replacement: Row(
                      children: <Widget>[CircularProgressIndicator()],
                    ),
                  );
                },
              )),
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        _upcomingOpenings(),
        _upcomingFirings(),
        Divider(),
        Text("Do more", style: TextStyles().mediumRegularStyle),
        HomePageSettings(),
      ],
    ));
  }

  Widget _upcomingFirings() {
    return Consumer<FiringListInteractor>(builder: (context, interactor, _) {
      var upcomingFirings = interactor.firings
          .where(
              (opening) => !opening.end.difference(DateTime.now()).isNegative)
          .take(3);

      List<Widget> firingCards = upcomingFirings
          .map((firing) =>
              FiringCard(firing: firing, promptRefresh: _getFirings))
          .toList();

      return UpcomingListPreview(
        onPressedAdd: _addFiring,
        refreshList: _getFirings,
        itemType: "firings",
        children: firingCards,
        viewAll: FiringsList(),
        loading: interactor.loading,
      );
    });
  }

  Widget _upcomingOpenings() {
    return Consumer<GetAllOpeningsUseCase>(builder: (context, useCase, _) {
      var upcomingOpenings = useCase.openings
          .where(
              (opening) => !opening.end.difference(DateTime.now()).isNegative)
          .take(3);

      List<Widget> openingCards = upcomingOpenings
          .map(
              (opening) => OpeningCard(opening: opening, refresh: _getOpenings))
          .toList();

      return UpcomingListPreview(
        onPressedAdd: _addOpening,
        refreshList: _getOpenings,
        itemType: "openings",
        children: openingCards,
        viewAll: OpeningsList(),
        loading: useCase.loading,
      );
    });
  }

  void _addFiring() async {
    var shouldRefreshList = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ManageFiringPage()));

    if (shouldRefreshList ?? false)
      Provider.of<FiringListInteractor>(context, listen: false).getAll();
  }

  void _addOpening() async {
    var shouldRefreshList = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ManageOpeningPage()));

    if (shouldRefreshList ?? false)
      Provider.of<GetAllOpeningsUseCase>(context, listen: false).invoke();
  }
}
