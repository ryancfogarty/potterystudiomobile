import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pottery_studio/common/HttpRetryDialog.dart';
import 'package:pottery_studio/common/TextStyles.dart';
import 'package:pottery_studio/interactors/ProfileInteractor.dart';
import 'package:pottery_studio/services/AuthService.dart';
import 'package:pottery_studio/usecases/DeleteUserUseCase.dart';
import 'package:pottery_studio/usecases/GetUserUseCase.dart';
import 'package:pottery_studio/views/EditablePhoto.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Consumer<GetUserUseCase>(
              builder: (context, useCase, _) {
                return Consumer<ProfileInteractor>(
                  builder: (context, interactor, _) {
                    return EditablePhoto(
                      loading: interactor.deletingPhoto ||
                          interactor.changingPhoto ||
                          useCase.user == null,
                      onDelete: _deletePhoto,
                      onChange: _changePhoto,
                      imageUrl: useCase.user?.imageUrl,
                      imageSubWidget: Column(
                        children: <Widget>[
                          Text(
                            useCase.user?.name ?? "",
                            style: TextStyles().mediumRegularStyle,
                          ),
                          Visibility(
                            visible: useCase.user?.isAdmin == true,
                            child: Text(
                              "Admin",
                              style: TextStyles().smallRegularStyle,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(),
            ListTile(
                leading:
                    Icon(Icons.delete, color: Theme.of(context).accentColor),
                title: Text("Delete my account"),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete account"),
                          content: Text(
                              "Deleting your account will remove you from all reservations."),
                          actions: [
                            FlatButton(
                              child: Text("Cancel"),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Consumer<DeleteUserUseCase>(
                              builder: (context, useCase, _) {
                                return Visibility(
                                  visible: useCase.loading,
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.red)),
                                  replacement: FlatButton(
                                    color: Colors.red,
                                    child: Text("Delete"),
                                    onPressed: () async {
                                      var success =
                                          await Provider.of<DeleteUserUseCase>(
                                                  context,
                                                  listen: false)
                                              .invoke();

                                      if (success) {
                                        await Provider.of<AuthService>(context, listen: false).signOut(context);
                                      } else {
                                        Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Error"),
                                                content: Text(
                                                    "An error occurred while deleting your account. Please contact the developer."),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      child: Text("Dismiss"),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop()),
                                                ],
                                              );
                                            });
                                      }
                                    },
                                  ),
                                );
                              },
                            )
                          ],
                        );
                      });
                }),
          ],
        ),
      ),
    );
  }

  Future _changePhoto(ImageSource source, String filePath) async {
    try {
      await Provider.of<ProfileInteractor>(context).changePhoto(source, filePath);
    } catch (e) {
      HttpRetryDialog().retry(context, () => _changePhoto(source, filePath));
    }
  }

  Future _deletePhoto() async {
    try {
      await Provider.of<ProfileInteractor>(context).deletePhoto();
    } catch (e) {
      HttpRetryDialog().retry(context, _deletePhoto);
    }
  }
}
