import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/common/FiringTypeFormatter.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/interactors/FiringListInteractor.dart';
import 'package:seven_spot_mobile/models/Firing.dart';
import 'package:seven_spot_mobile/pages/FiringPage.dart';
import 'package:seven_spot_mobile/views/ToggleButtonView.dart';

class FiringsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FiringListState();
}

class _FiringListState extends State<FiringsList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

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
    return Scaffold(
      body: Consumer<FiringListInteractor>(
        builder: (context, interactor, _) {
          return SmartRefresher(
            onRefresh: _onRefresh,
            controller: _refreshController,
            child: ListView.builder(
                itemBuilder: (buildContext, index) {
                  if (index == 0) {
                    return Consumer<FiringListInteractor>(
                      builder: (context, useCase, _) {
                        return ToggleButtonView(
                          title: "firings",
                          toggleOn: useCase.includePast,
                          onToggle: _togglePastFiringsShown,
                        );
                      },
                    );
                  } else if (interactor.firings.length == 0) {
                    return Center(child: Text("No firings to show"));
                  } else {
                    var firing = interactor.firings.elementAt(index - 1);

                    return _firingCard(firing);
                  }
                },
                itemCount: interactor.firings.length == 0
                    ? 2
                    : interactor.firings.length + 1),
          );
        },
      ),
    );
  }

  void _togglePastFiringsShown() {
    var interactor = Provider.of<FiringListInteractor>(context, listen: false);

    interactor.setIncludePast(!interactor.includePast);
    _refreshController.requestRefresh();
  }

  Widget _firingCard(Firing firing) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          var shouldRefreshList = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => FiringPage(firingId: firing.id)));

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
                      DateFormatter()
                          .formatDateTimeRange(firing.start, firing.end),
                      style: TextStyles().mediumRegularStyle),
                  Text(
                      "Done cooling down: ${DateFormatter().dd_MMMM.format(firing.cooldownEnd)} ${DateFormatter().HH_mm.format(firing.cooldownEnd)}",
                      style: TextStyles().mediumRegularStyle),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(FiringTypeFormatter().format(firing.type),
                  style: TextStyles().mediumBoldStyle),
            ),
          ],
        ),
      ),
    );
  }
}
