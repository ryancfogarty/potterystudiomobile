import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/usecases/ToggleReservationUseCase.dart';

class OpeningsList extends StatefulWidget {
  OpeningsList({
    Key key,
    @required this.openings,
    this.onRefresh
  }) : super(key: key);

  final Iterable<Opening> openings;
  final AsyncCallback onRefresh;

  @override
  State<StatefulWidget> createState() => _OpeningsListState();
}

class _OpeningsListState extends State<OpeningsList> {
  RefreshController _refreshController = RefreshController(initialRefresh: true);

  void _onRefresh() async {
    try {
      await widget.onRefresh();
    } catch (e) {
      print(e);
    } finally {
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      onRefresh: _onRefresh,
      controller: _refreshController,
      child: ListView.builder(
          itemBuilder: (buildContext, index) {
            var opening = widget.openings.elementAt(index);

            return _openingCard(opening);
          },
          itemCount: widget.openings.length
      )
    );
  }

  Widget _openingCard(Opening opening) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${DateFormat("dd MMMM").format(opening.start)} ${DateFormat("HH:mm").format(opening.start)} - ${DateFormat("HH:mm").format(opening.end)}",
                  style: TextStyle(fontSize: 16.0)
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "${opening.reservedUserIds.length}/${opening.size} spots reserved",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: opening.loggedInUserReserved || opening.size > opening.reservedUserIds.length,
            child: FlatButton(
              onPressed: () => _toggleReservation(opening),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Icon(
                          opening.loggedInUserReserved ? Icons.remove_circle : Icons.check_circle,
                          color: opening.loggedInUserReserved ? Colors.red : Colors.green
                      ),
                      Text(opening.loggedInUserReserved ? "Leave" : "Join")
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _toggleReservation(Opening opening) async {
    ToggleReservationUseCase useCase = Provider.of<ToggleReservationUseCase>(context);

    _refreshController.headerMode.value = RefreshStatus.refreshing;

    try {
      await useCase.toggleReservationForOpening(opening);
      _onRefresh();
    } catch (e) {
      print(e.toString());
    }

    _refreshController.refreshCompleted();
  }
}