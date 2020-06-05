import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pottery_studio/common/TextStyles.dart';

class ThirdPartySignInButton extends StatelessWidget {
  final String logoUri;
  final String thirdPartyProvider;
  final Function onPressed;
  final Color borderColor;

  ThirdPartySignInButton(
      {Key key,
      this.logoUri,
      this.thirdPartyProvider,
      this.onPressed,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: borderColor)),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage(logoUri), height: 20.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Continue with $thirdPartyProvider",
                        style: TextStyles().bigRegularStyle),
                  )
                ])),
      ),
    );
  }
}
