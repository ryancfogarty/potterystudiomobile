import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pottery_studio/common/HttpRetryDialog.dart';
import 'package:pottery_studio/common/TextStyles.dart';
import 'package:pottery_studio/usecases/GetUserUseCase.dart';
import 'package:pottery_studio/usecases/UpdateStudioBannerUseCase.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class StudioNotes extends StatefulWidget {
  _StudioNotesState createState() => _StudioNotesState();
}

class _StudioNotesState extends State<StudioNotes> {
  bool _isEditing = false;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _controller.text =
          Provider.of<GetUserUseCase>(context).user?.studioBanner ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Studio notes"),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16, top: 16, bottom: 96),
            child: Consumer<GetUserUseCase>(
              builder: (context, useCase, _) {
                return Visibility(
                  visible: _isEditing,
                  child: TextField(
                    scrollPadding: EdgeInsets.only(top: 36, bottom: 96),
                    maxLines: 20,
                    controller: _controller,
                  ),
                  replacement: Linkify(
                    text: useCase.user?.studioBanner ?? "",
                    style: TextStyles.mediumRegularStyle,
                    onOpen: (link) => _launch(link.url),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child:
                Consumer<GetUserUseCase>(builder: (context, getUserUseCase, _) {
              return Visibility(
                visible: getUserUseCase?.user?.isAdmin == true,
                child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  color: Theme.of(context).backgroundColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(
                                color: Theme.of(context).accentColor)),
                        child: Text("Edit",
                            style: TextStyles.mediumRegularStyle.copyWith(
                                color: Theme.of(context).accentColor)),
                        onPressed: () => setState(() {
                          _isEditing = true;
                        }),
                      ),
                      Consumer<UpdateStudioBannerUseCase>(
                        builder: (context, updateStudioBannerUseCase, _) {
                          return Visibility(
                            visible: updateStudioBannerUseCase.loading,
                            child: CircularProgressIndicator(),
                            replacement: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                        color: _isEditing
                                            ? Theme.of(context).accentColor
                                            : Colors.transparent)),
                                child: Text("Save",
                                    style: TextStyles.mediumRegularStyle
                                        .copyWith(
                                            color: _isEditing
                                                ? Theme.of(context).accentColor
                                                : Colors.grey)),
                                disabledColor: Colors.grey.withAlpha(100),
                                onPressed: _isEditing ? _save : null),
                          );
                        },
                      )
                    ],
                  ),
                ),
              );
            }))
      ],
    );
  }

  Future _save() async {
    try {
      await Provider.of<UpdateStudioBannerUseCase>(context, listen: false)
          .invoke(_controller.text);

      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      HttpRetryDialog().retry(context, _save);
    }
  }

  Future _launch(String url) async {
    if (await launcher.canLaunch(url)) {
      await launcher.launch(url);
    }
  }
}
