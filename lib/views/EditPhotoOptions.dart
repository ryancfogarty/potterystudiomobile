import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pottery_studio/common/TextStyles.dart';

class EditPhotoOptions extends StatefulWidget {
  final Function(ImageSource) onClickChange;
  final Function onClickDelete;

  EditPhotoOptions({Key key, this.onClickChange, this.onClickDelete})
      : super(key: key);

  @override
  _EditPhotoOptionsState createState() => _EditPhotoOptionsState();
}

class _EditPhotoOptionsState extends State<EditPhotoOptions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
            child: Text("Change photo", style: TextStyles().mediumRegularStyle),
            onPressed: _showChangePhotoDialog),
        FlatButton(
          child: Text("Remove photo",
              style:
                  TextStyles().mediumRegularStyle.copyWith(color: Colors.red)),
          onPressed: widget.onClickDelete,
        ),
      ],
    );
  }

  void _showChangePhotoDialog() {
    showDialog(
        context: context,
        child: Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Camera"),
                onTap: () => _changePhoto(ImageSource.camera),
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Gallery"),
                onTap: () => _changePhoto(ImageSource.gallery),
              ),
            ],
          ),
        ));
  }

  void _changePhoto(ImageSource source) {
    Navigator.of(context).pop();

    widget.onClickChange(source);
  }
}
