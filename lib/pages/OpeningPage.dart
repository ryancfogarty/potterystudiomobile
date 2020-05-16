import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/pages/ManageOpeningPage.dart';
import 'package:seven_spot_mobile/usecases/DeleteOpeningUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetOpeningUseCase.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Opening")),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Consumer<GetOpeningUseCase>(
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
              children: [
                Text("Start: ", style: TextStyles().mediumBoldStyle),
                Text(opening != null
                    ? DateFormatter().dd_MMMM_HH_mm.format(opening.start)
                    : "Loading...")
              ],
            ),
            Row(
              children: [
                Text("End: ", style: TextStyles().mediumBoldStyle),
                Text(opening != null
                    ? DateFormatter().dd_MMMM_HH_mm.format(opening.end)
                    : "Loading...")
              ],
            ),
            Text("Reserved users ($reserved)",
                style: TextStyles().mediumBoldStyle),
            Expanded(
              child: ListView.builder(
                  itemBuilder: (buildContext, index) {
                    var user = useCase.opening.reservedUsers.elementAt(index);

                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(user.name),
                    ));
                  },
                  itemCount: useCase.opening != null
                      ? useCase.opening.reservedUsers.length
                      : 0),
            ),
            RaisedButton(
                child: Text("Delete opening"), onPressed: _deleteOpening),
            RaisedButton(child: Text("Edit opening"), onPressed: _editOpening)
          ],
        );
      },
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
