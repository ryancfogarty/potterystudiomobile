import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:pottery_studio/common/HttpRetryDialog.dart';
import 'package:pottery_studio/usecases/GetAllOpeningsUseCase.dart';
import 'package:pottery_studio/views/OpeningCard.dart';
import 'package:pottery_studio/views/ToggleButtonView.dart';

class OpeningsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OpeningsListState();
}

class _OpeningsListState extends State<OpeningsList> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    try {
      await Provider.of<GetAllOpeningsUseCase>(context, listen: false).invoke();
    } catch (e) {
      HttpRetryDialog().retry(context, _refreshController.requestRefresh);
    } finally {
      _refreshController.refreshCompleted();
    }
  }

  Widget _toggleButton() {
    return Consumer<GetAllOpeningsUseCase>(builder: (context, useCase, _) {
      return ToggleButtonView(
        title: "openings",
        toggleOn: useCase.includePast,
        onToggle: _togglePastOpeningsShown,
      );
    });
  }

  void _togglePastOpeningsShown() {
    var useCase = Provider.of<GetAllOpeningsUseCase>(context, listen: false);

    useCase.setIncludePast(!useCase.includePast);
    _refreshController.requestRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Openings"),
          backgroundColor: Colors.white,
        ),
        body: Consumer<GetAllOpeningsUseCase>(
          builder: (context, useCase, _) {
            return SmartRefresher(
                onRefresh: _onRefresh,
                controller: _refreshController,
                child: ListView.builder(
                    itemBuilder: (buildContext, index) {
                      if (index == 0) {
                        return _toggleButton();
                      } else if (useCase.openings.length == 0 && index == 1) {
                        return Center(child: Text("No openings to show"));
                      } else if (index < useCase.openings.length + 1) {
                        var opening = useCase.openings.elementAt(index - 1);

                        return OpeningCard(
                            opening: opening,
                            refresh: _refreshController.requestRefresh);
                      } else {
                        return Container(
                            height: 72.0); // padding bottom of list
                      }
                    },
                    itemCount: useCase.openings.length == 0
                        ? 3
                        : useCase.openings.length + 2));
          },
        ));
  }
}
