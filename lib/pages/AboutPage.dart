import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:pottery_studio/common/TextStyles.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                "Thanks for checking out this app! I've created it in hopes that it makes managing ceramics studios easier.\n\nAs this is a side project of mine, I will add on to it when I have free time, and welcome any and all support via bug reports and feature requests!\n\nAlongside being an app developer, I'm also a beginner potter myself. Check out my pottery instagram account below 😀",
                style: TextStyles.mediumRegularStyle),
          ),
          Container(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(color: Theme.of(context).accentColor)),
                child: Text("Instagram",
                    style: TextStyles.mediumRegularStyle
                        .copyWith(color: Theme.of(context).accentColor)),
                onPressed: _instagram,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(color: Colors.black)),
                child: Text("Legal info", style: TextStyles.mediumRegularStyle),
                onPressed: () => _legal(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _legal(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    showAboutDialog(
        context: context,
        applicationName: "Pottery Studio",
        applicationVersion: packageInfo.version,
        applicationLegalese: "© Ryan Fogarty 2020",
        applicationIcon: Image(
            height: 30,
            width: 30,
            image: AssetImage("assets/ic_launcher.png")));
  }

  Future _instagram() async {
    await launcher.launch("https://instagram.com/potter.ry");
  }
}
