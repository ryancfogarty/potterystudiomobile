import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pottery_studio/common/HttpRetryDialog.dart';
import 'package:pottery_studio/common/TextStyles.dart';
import 'package:pottery_studio/usecases/RegisterAsAdminUseCase.dart';

class RegisterAsAdminPage extends StatefulWidget {
  @override
  _RegisterAsAdminPageState createState() => _RegisterAsAdminPageState();
}

class _RegisterAsAdminPageState extends State<RegisterAsAdminPage> {
  final _adminCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register as admin"),
        ),
        body: _body());
  }

  Widget _body() {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "To register as an admin for your studio, enter the admin code.",
                  style: TextStyles.mediumRegularStyle,
                ),
                TextField(
                    controller: _adminCodeController,
                    decoration: InputDecoration(labelText: "Admin code")),
                _submitButton()
              ],
            )));
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<RegisterAsAdminUseCase>(builder: (context, useCase, _) {
        return Visibility(
          visible: !useCase.loading,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: Theme.of(context).accentColor)),
            onPressed: _registerAsAdmin,
            child: Text(
              "Submit",
              style: TextStyles
                  .mediumRegularStyle
                  .copyWith(color: Theme.of(context).accentColor),
            ),
          ),
          replacement: CircularProgressIndicator(),
        );
      }),
    );
  }

  void _registerAsAdmin() async {
    try {
      await Provider.of<RegisterAsAdminUseCase>(context, listen: false)
          .registerAsAdmin(_adminCodeController.text);
      Navigator.of(context).pop();
    } catch (e) {
      HttpRetryDialog().retry(context, _registerAsAdmin);
    }
  }
}
