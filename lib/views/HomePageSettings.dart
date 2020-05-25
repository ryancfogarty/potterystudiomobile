import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/pages/RegisterAsAdminPage.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';
import 'package:seven_spot_mobile/usecases/DeleteUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';

class HomePageSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context, listen: false);

    return Column(
      children: <Widget>[
        ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Sign out"),
            onTap: authService.signOutOfGoogle),
        ListTile(
            leading: Icon(Icons.delete),
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
                        FlatButton(
                          color: Colors.red,
                          child: Text("Delete"),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            var success = await Provider.of<DeleteUserUseCase>(
                                context,
                                listen: false)
                                .invoke();

                            if (success) {
                              authService.signOutOfGoogle();
                            } else {
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
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                        )
                      ],
                    );
                  });
            }),
        ListTile(
            leading: Icon(Icons.person),
            title: Text("Register as admin"),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RegisterAsAdminPage()))),
        Consumer<GetUserUseCase>(builder: (context, getUserUseCase, _) {
          return Visibility(
            visible: getUserUseCase.user?.isAdmin ?? false,
            child: ListTile(
                leading: Icon(Icons.home),
                title: Text(
                    "Studio code: ${getUserUseCase.user?.studioCode} (tap to copy)"),
                onTap: () async {
                  await Clipboard.setData(
                      ClipboardData(text: getUserUseCase.user?.studioCode));

                  final snackBar =
                  SnackBar(content: Text('Copied to Clipboard'));

                  Scaffold.of(context).showSnackBar(snackBar);
                }),
          );
        }),
        Consumer<GetUserUseCase>(builder: (context, getUserUseCase, _) {
          return Visibility(
            visible: getUserUseCase.user?.isAdmin ?? false,
            child: ListTile(
                leading: Icon(Icons.book),
                title: Text(
                    "Admin code: ${getUserUseCase.user?.studioAdminCode} (tap to copy)"),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(
                      text: getUserUseCase.user?.studioAdminCode));

                  final snackBar =
                  SnackBar(content: Text('Copied to Clipboard'));

                  Scaffold.of(context).showSnackBar(snackBar);
                }),
          );
        }),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            onTap: () => showAboutDialog(
                context: context,
                applicationName: "Pottery World",
                applicationVersion: "0.1.0",
                applicationLegalese: "© Ryan Fogarty 2020 ",
                applicationIcon: Image(
                    height: 30,
                    width: 30,
                    image: AssetImage("assets/ic_launcher.png"))),
          ),
        )
      ],
    );
  }
}