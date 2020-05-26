import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  final String imageUrl;
  final double height;
  final bool circular;
  final String heroTag;

  ProfileImage(
      {Key key,
      this.imageUrl,
      this.height = 80.0,
      this.circular = true,
      this.heroTag = "profileimage"})
      : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag,
        child: _image(),
      );
    } else {
      return _image();
    }
  }

  Widget _image() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(widget.circular ? 10000 : 0),
        child: Image.network(
            widget.imageUrl ??
                "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png",
            filterQuality: FilterQuality.high,
            fit: BoxFit.fill,
            height: widget.height));
  }
}
