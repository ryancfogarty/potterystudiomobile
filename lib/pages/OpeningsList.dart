import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/pages/OpeningPage.dart';
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
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          var shouldRefreshList = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => OpeningPage(openingId: opening.id)));

          if (shouldRefreshList ?? false) {
            _refreshController.requestRefresh();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${DateFormatter().dd_MMMM.format(opening.start)} ${DateFormatter().HH_mm.format(opening.start)} - ${DateFormatter().HH_mm.format(opening.end)}",
                    style: TextStyle(fontSize: 16.0)
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "${opening.reservedUserIds.length}/${opening.size} spots reserved${opening.reservedUserIds.length == opening.size ? " - FULL" : ""}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: opening.loggedInUserReserved || opening.size > opening.reservedUserIds.length,
              child: InkResponse(
                onTap: () => _toggleReservation(opening),
                child: Consumer<ToggleReservationUseCase>(
                  builder: (context, useCase, _) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: Visibility(
                        visible: !useCase.openingLoadingIds.contains(opening.id),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                        replacement: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _toggleReservation(Opening opening) async {
    ToggleReservationUseCase useCase = Provider.of<ToggleReservationUseCase>(context);

    try {
      await useCase.toggleReservationForOpening(opening);
      _refreshController.headerMode.value = RefreshStatus.refreshing;
      await widget.onRefresh();
    } catch (e) {
      print(e.toString());
    } finally {
      _refreshController.refreshCompleted();
    }
  }
}