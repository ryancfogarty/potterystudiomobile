import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/FiringTypeFormatter.dart';
import 'package:seven_spot_mobile/common/HttpRetryDialog.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/pages/ManageFiringPage.dart';
import 'package:seven_spot_mobile/usecases/DeleteFiringUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetFiringUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';
import 'package:seven_spot_mobile/views/FiringStatus.dart';

class FiringPage extends StatefulWidget {
  FiringPage({Key key, @required this.firingId}) : super(key: key);

  final String firingId;

  @override
  State<StatefulWidget> createState() => _FiringPageState();
}

class _FiringPageState extends State<FiringPage> {
  bool _edited = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _getFiring);
  }

  void _getFiring({bool popOnErrorDismiss = true}) async {
    var useCase = Provider.of<GetFiringUseCase>(context, listen: false);
    useCase.clear();

    try {
      await useCase.invoke(widget.firingId);
    } catch (e) {
      HttpRetryDialog().retry(context, () => useCase.invoke(widget.firingId),
          onDismiss: () => popOnErrorDismiss && Navigator.of(context).pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_edited);

        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<GetFiringUseCase>(builder: (context, useCase, _) {
            return Text(useCase.firing != null
                ? "${FiringTypeFormatter().format(useCase.firing.type)} firing"
                : "");
          }),
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<GetFiringUseCase>(
        builder: (context, useCase, _) {
          return Column(
            children: [
              Expanded(
                child:
                    Consumer<GetFiringUseCase>(builder: (context, useCase, _) {
                  var firing = useCase.firing;

                  if (firing == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return FiringStatus(firing: firing);
                  }
                }),
              ),
              _edit(),
              _delete()
            ],
          );
        },
      ),
    );
  }

  Widget _delete() {
    var getUserUseCase = Provider.of<GetUserUseCase>(context);

    return Visibility(
      visible: getUserUseCase.user?.isAdmin ?? true,
      child: Consumer<DeleteFiringUseCase>(
        builder: (context, useCase, _) {
          return Visibility(
              visible: !useCase.loading,
              replacement: Column(
                children: <Widget>[
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).errorColor)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: Theme.of(context).errorColor)),
                    onPressed: _deleteFiring,
                    child: Text(
                      "Delete firing",
                      style: TextStyles()
                          .mediumRegularStyle
                          .copyWith(color: Theme.of(context).errorColor),
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }

  Widget _edit() {
    var getUserUseCase = Provider.of<GetUserUseCase>(context);

    return Visibility(
      visible: getUserUseCase.user?.isAdmin ?? true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Theme.of(context).accentColor)),
            onPressed: _editFiring,
            child: Text(
              "Edit firing",
              style: TextStyles()
                  .mediumRegularStyle
                  .copyWith(color: Theme.of(context).accentColor),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteFiring() async {
    try {
      await Provider.of<DeleteFiringUseCase>(context, listen: false)
          .deleteFiring(widget.firingId);
      Navigator.of(context).pop(true);
    } catch (e) {
      HttpRetryDialog().retry(context, _deleteFiring);
    }
  }

  void _editFiring() async {
    var edited = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManageFiringPage(firingId: widget.firingId)));

    if (edited == true) {
      _getFiring(popOnErrorDismiss: false);
      _edited = true;
    }
  }
}
