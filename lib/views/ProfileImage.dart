import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  final String imageUrl;
  final double radius;

  ProfileImage({Key key, this.imageUrl, this.radius = 40.0})
      : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0, right: 16.0),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(1000),
          child: Image.network(
              widget.imageUrl ??
                  "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png",
              height: widget.radius * 2)),
    );
  }
}
