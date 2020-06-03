import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:seven_spot_mobile/views/EditPhotoOptions.dart';
import 'package:seven_spot_mobile/views/ProfileImage.dart';

class EditablePhoto extends StatefulWidget {
  final Future Function(ImageSource imageSource, String filePath) onChange;
  final Function onDelete;
  final String imageUrl;
  final Widget imageSubtitle;

  EditablePhoto(
      {Key key,
      this.onChange,
      this.onDelete,
      this.imageUrl,
      this.imageSubtitle = const SizedBox.shrink()})
      : super(key: key);

  _EditablePhotoState createState() => _EditablePhotoState();
}

class _EditablePhotoState extends State<EditablePhoto> {
  bool _frontCamera = true;
  bool _takingPhoto = false;

  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
  }

  Future _initCamera() async {
    var firstCamera = (await availableCameras()).firstWhere((camera) =>
        camera.lensDirection ==
        (_frontCamera ? CameraLensDirection.front : CameraLensDirection.back));

    _controller = CameraController(firstCamera, ResolutionPreset.medium,
        enableAudio: false);

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
            visible: _takingPhoto,
            child: _camera(),
            replacement: Column(
              children: <Widget>[
                Container(height: 16),
                ProfileImage(imageUri: widget.imageUrl),
                widget.imageSubtitle
              ],
            )),
        EditPhotoOptions(
          onClickChange: _change,
          onClickDelete: widget.onDelete,
        )
      ],
    );
  }

  Widget _camera() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return _cameraPreview();
        } else {
          return Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }

  Widget _cameraPreview() {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: ClipRect(
            child: Transform.scale(
              scale: 1 / _controller.value.aspectRatio,
              child: Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: CameraPreview(_controller),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkResponse(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Icon(_frontCamera ? Icons.camera_front : Icons.camera_rear,
                  color: Colors.white),
            ),
            onTap: () {
              setState(() {
                _frontCamera = !_frontCamera;
              });

              _initCamera();
            },
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 40),
                ),
                onPressed: _takePicture))
      ],
    );
  }

  void _takePicture() async {
    setState(() {
      _takingPhoto = false;
    });

    final path = Path.join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );

    await _controller.takePicture(path);

    var resizedPath = await _cropSquare(path, flip: _frontCamera);

    await widget.onChange(ImageSource.camera, resizedPath);
  }

  Future<String> _cropSquare(String srcFilePath, {bool flip = true}) async {
    var bytes = await File(srcFilePath).readAsBytes();
    IMG.Image src = IMG.decodeImage(bytes);

    var cropSize = min(src.width, src.height);
    int offsetX = (src.width - min(src.width, src.height)) ~/ 2;
    int offsetY = (src.height - min(src.width, src.height)) ~/ 2;

    IMG.Image destImage =
        IMG.copyCrop(src, offsetX, offsetY, cropSize, cropSize);

    if (flip) {
      destImage = IMG.flipHorizontal(destImage);
    }

    var jpg = IMG.encodeJpg(destImage);
    var destFilePath = Path.join(
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );
    await File(destFilePath).writeAsBytes(jpg);
    return destFilePath;
  }

  void _change(ImageSource source) async {
    if (source == ImageSource.camera) {
      await _initCamera();

      setState(() {
        _takingPhoto = true;
      });
    } else {
      widget.onChange(source, null);
    }
  }
}
