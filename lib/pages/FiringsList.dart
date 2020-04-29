import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/interactors/FiringListInteractor.dart';
import 'package:seven_spot_mobile/models/Firing.dart';
import 'package:seven_spot_mobile/pages/FiringPage.dart';

class FiringsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FiringListState();
}

class _FiringListState extends State<FiringsList> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _refreshController.requestRefresh);
  }

  void _onRefresh() async {
    try {
      await Provider.of<FiringListInteractor>(context, listen: false).getAll();
    } catch (e) {
      print(e);
    } finally {
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FiringListInteractor>(
      builder: (context, interactor, _) {
        return SmartRefresher(
            onRefresh: _onRefresh,
            controller: _refreshController,
            child: ListView.builder(
                itemBuilder: (buildContext, index) {
                  var firing = interactor.firings.elementAt(index);

                  return _firingCard(firing);
                },
                itemCount: interactor.firings.length
            )
        );
      },
    );
  }

  Widget _firingCard(Firing firing) {
    return Card(
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          var shouldRefreshList = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => FiringPage(firingId: firing.id)));

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
                    "Start: ${DateFormatter().dd_MMMM.format(firing.start)} ${DateFormatter().HH_mm.format(firing.start)}",
                    style: TextStyle(fontSize: 16.0)
                  ),
                  Text(
                    "Firing end: ${DateFormatter().dd_MMMM.format(firing.end)} ${DateFormatter().HH_mm.format(firing.end)}",
                    style: TextStyle(fontSize: 16.0)
                  ),
                  Text(
                    "Cooldown end: ${DateFormatter().dd_MMMM.format(firing.cooldownEnd)} ${DateFormatter().HH_mm.format(firing.cooldownEnd)}",
                    style: TextStyle(fontSize: 16.0)
                  ),
                  Text(
                    "Type: ${firing.type.toLowerCase()}",
                    style: TextStyle(fontSize: 16.0)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}