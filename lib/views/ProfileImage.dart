import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatefulWidget {
  final String imageUri;
  final double height;
  final bool circular;
  final String heroTag;

  ProfileImage(
      {Key key,
      this.imageUri,
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
    var image;

    if (widget.imageUri != null) {
      image = CachedNetworkImage(
          imageUrl: widget.imageUri,
          filterQuality: FilterQuality.high,
          height: widget.height,
          placeholder: (context, url) => Container(
              width: 40,
              height: 40,
              child: Center(child: CircularProgressIndicator())));
    } else {
      image = Image(
        image: AssetImage("assets/placeholder_image.png"),
        height: widget.height,
      );
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(widget.circular ? 10000 : 0),
        child: image);
  }
}
