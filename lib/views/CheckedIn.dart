import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/HttpRetryDialog.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/interactors/CheckedInInteractor.dart';
import 'package:seven_spot_mobile/usecases/GetPresentUsersUseCase.dart';
import 'package:seven_spot_mobile/views/ProfileImage.dart';
import 'package:shimmer/shimmer.dart';

class CheckedIn extends StatefulWidget {
  @override
  _CheckedInState createState() => _CheckedInState();
}

class _CheckedInState extends State<CheckedIn> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GetPresentUsersUseCase>(builder: (context, useCase, _) {
      var userWidgets = useCase.presentUsers.map((user) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              ProfileImage(
                  imageUri: user.imageUrl, heroTag: null, height: 60.0),
              Text(
                  user.name
                          .split(" ")
                          .map((s) => s[0].toUpperCase())
                          .join(".") +
                      ".",
                  style: TextStyles().smallRegularStyle)
            ],
          ),
        );
      }).toList();

      var headerText = Text(
        "In the studio",
        style: TextStyles().bigRegularStyle,
      );

      return Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Visibility(
                          visible: useCase.loading,
                          child: Shimmer.fromColors(
                              child: headerText,
                              baseColor: Colors.black.withAlpha(20),
                              highlightColor: Theme.of(context).accentColor),
                          replacement: headerText,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10000),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                              color: Colors.grey.withAlpha(150),
                              child: Text(
                                useCase.presentUsers.length.toString(),
                                style: TextStyles().mediumRegularStyle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _togglePresence()
                  ],
                ),
              ),
              SingleChildScrollView(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  scrollDirection: Axis.horizontal,
                  child: Row(children: userWidgets)),
            ],
          ),
        ),
      );
    });
  }

  Widget _togglePresence() {
    return Consumer<CheckedInInteractor>(
      builder: (context, interactor, _) {
        var text = interactor.checkedIn ? "Check out" : "Check in";

        return Visibility(
          visible: interactor.checkingInOrOut || interactor.loadingPresentUsers,
          child: CircularProgressIndicator(),
          replacement: FlatButton(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme.of(context).accentColor),
                  borderRadius: BorderRadius.circular(24.0)),
              onPressed: _toggle,
              child: Text(
                text,
                style: TextStyles()
                    .mediumRegularStyle
                    .copyWith(color: Theme.of(context).accentColor),
              )),
        );
      },
    );
  }

  Future _toggle() async {
    try {
      await Provider.of<CheckedInInteractor>(context, listen: false).toggle();
    } catch (e) {
      HttpRetryDialog().retry(context, _toggle);
    }
  }
}
