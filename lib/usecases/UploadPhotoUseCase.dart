import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoUseCase {
  Future<String> changePhoto(ImageSource source) async {
    File imageFile = await ImagePicker.pickImage(
        source: source, preferredCameraDevice: CameraDevice.front);

    if (imageFile == null) return null;

    File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 50);

    if (croppedImage == null) return null;

    try {
      StorageReference ref = FirebaseStorage.instance.ref().child("image.jpg");
      StorageUploadTask uploadTask = ref.putFile(croppedImage);
      return (await (await uploadTask.onComplete).ref.getDownloadURL());
    } catch (e) {
      print("Uploading image error $e");
    }

    return null;
  }
}
