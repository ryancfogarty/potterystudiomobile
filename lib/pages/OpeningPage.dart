import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/pages/ManageOpeningPage.dart';
import 'package:seven_spot_mobile/usecases/DeleteOpeningUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetOpeningUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';

class OpeningPage extends StatefulWidget {
  OpeningPage({Key key, @required this.openingId}) : super(key: key);

  final String openingId;

  @override
  State<StatefulWidget> createState() => _OpeningPageState();
}

class _OpeningPageState extends State<OpeningPage> {
  bool _edited = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _getOpening);
  }

  _getOpening() {
    var useCase = Provider.of<GetOpeningUseCase>(context, listen: false);
    useCase.clear();
    useCase.invoke(widget.openingId);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _edited);

        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Opening")),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<GetOpeningUseCase>(
        builder: (context, useCase, child) {
          var opening = useCase.opening;
          var reserved;

          if (opening != null) {
            reserved = "${opening.reservedUserIds.length}/${opening.size}";
          } else {
            reserved = "loading...";
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      opening != null
                          ? DateFormatter()
                              .formatDateTimeRange(opening.start, opening.end)
                          : "Loading...",
                      style: TextStyles().bigRegularStyle)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Reserved users ($reserved)",
                    style: TextStyles().bigRegularStyle),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 1.0, color: Colors.black12),
              ),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (buildContext, index) {
                      var user = useCase.opening.reservedUsers.elementAt(index);

                      return Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            user.name,
                            style: TextStyles().mediumRegularStyle,
                          ),
                        ),
                      );
                    },
                    itemCount: useCase.opening != null
                        ? useCase.opening.reservedUsers.length
                        : 0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _editButton(),
                  _deleteButton()
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _editButton() {
    var getUserUseCase = Provider.of<GetUserUseCase>(context);

    return Visibility(
      visible: getUserUseCase.user?.isAdmin ?? true,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: Theme.of(context).accentColor)),
        onPressed: _editOpening,
        child: Text(
          "Edit opening",
          style: TextStyles()
              .mediumRegularStyle
              .copyWith(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

  Widget _deleteButton() {
    var getUserUseCase = Provider.of<GetUserUseCase>(context);

    return Visibility(
      visible: getUserUseCase.user?.isAdmin ?? true,
      child: Consumer<DeleteOpeningUseCase>(
          builder: (context, deleteOpeningUseCase, _) {
        return Visibility(
          visible: !deleteOpeningUseCase.deleting,
          replacement: Column(
            children: <Widget>[
              CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).errorColor)),
            ],
          ),
          child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: Theme.of(context).errorColor)),
              onPressed: _deleteOpening,
              child: Text(
                "Delete opening",
                style: TextStyles()
                    .mediumRegularStyle
                    .copyWith(color: Theme.of(context).errorColor),
              )),
        );
      }),
    );
  }

  void _deleteOpening() async {
    try {
      await Provider.of<DeleteOpeningUseCase>(context, listen: false)
          .deleteOpening(widget.openingId);
      Navigator.pop(context, true);
    } catch (e) {
      // todo: show error
    }
  }

  void _editOpening() async {
    var edited = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ManageOpeningPage(openingId: widget.openingId)));

    if (edited == true) {
      _getOpening();
      _edited = true;
    }
  }
}
