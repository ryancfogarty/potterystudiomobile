import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';
import 'package:shimmer/shimmer.dart';

class UpcomingListPreview extends StatefulWidget {
  final Function onPressedAdd;
  final Function refreshList;
  final String itemType;
  final List<Widget> children;
  final Widget viewAll;
  final bool loading;

  UpcomingListPreview(
      {Key key,
      this.onPressedAdd,
      this.refreshList,
      this.itemType,
      this.children,
      this.viewAll,
      this.loading})
      : super(key: key);

  @override
  _UpcomingListPreviewState createState() => _UpcomingListPreviewState();
}

class _UpcomingListPreviewState extends State<UpcomingListPreview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: widget.loading,
            replacement: _loadingColumn(),
            child: Shimmer.fromColors(
                child: _loadingColumn(),
                baseColor: Colors.black.withAlpha(20),
                highlightColor: Theme.of(context).accentColor),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Visibility(
                    visible: widget.children.length != 0,
                    child: Column(children: widget.children),
                    replacement: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "There are no upcoming ${widget.itemType}",
                        style: TextStyles().mediumSkinnyStyle,
                      ),
                    )),
                _viewAllButton()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewAllButton() {
    return Consumer<GetUserUseCase>(builder: (context, getUserUseCase, _) {
      return Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 6.0, right: 6.0),
        child: FlatButton(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(color: Theme.of(context).accentColor)),
          onPressed: () async {
            var shouldRefresh = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => widget.viewAll));

            if (shouldRefresh == true && widget.refreshList != null) {
              widget.refreshList();
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "View all ${widget.itemType}",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _loadingColumn() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Upcoming ${widget.itemType}",
                  style: TextStyles().bigRegularStyle),
            ),
            Consumer<GetUserUseCase>(builder: (context, useCase, _) {
              return Visibility(
                visible: useCase.user?.isAdmin == true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                  child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                          side:
                              BorderSide(color: Theme.of(context).accentColor)),
                      onPressed: widget.onPressedAdd,
                      child: Icon(Icons.add,
                          color: Theme.of(context).accentColor)),
                ),
              );
            })
          ],
        ),
        Row(
          children: <Widget>[
            Visibility(
              visible: widget.loading,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child:
                    Text("Loading...", style: TextStyles().mediumRegularStyle),
              ),
            )
          ],
        )
      ],
    );
  }
}
