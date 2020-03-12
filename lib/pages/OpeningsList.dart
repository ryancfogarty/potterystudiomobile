import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seven_spot_mobile/models/Opening.dart';

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
    await widget.onRefresh();

    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      onRefresh: _onRefresh,
      controller: _refreshController,
      child: ListView.builder(
          itemBuilder: (buildContext, index) {
            var opening = widget.openings.elementAt(index);

            return Text(opening.start.toIso8601String());
          },
          itemCount: widget.openings.length
      )
    );
  }
}