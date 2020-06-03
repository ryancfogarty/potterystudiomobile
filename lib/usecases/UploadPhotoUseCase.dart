import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UploadPhotoUseCase {
  Future<String> withSelection() async {
    PickedFile pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    File croppedImage = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 50);

    if (croppedImage == null) return null;

    try {
      return await _uploadToFirebase(croppedImage);
    } catch (e) {
      print("Uploading image error $e");
    }

    return null;
  }

  Future<String> withPhoto(String filePath) async {
    try {
      File file = File(filePath);

      return await _uploadToFirebase(file);
    } catch (e) {
      print("Uploading image error $e");
    }

    return null;
  }

  Future<String> _uploadToFirebase(File file) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(Uuid().v4());
    StorageUploadTask uploadTask = ref.putFile(file);
    return (await (await uploadTask.onComplete).ref.getDownloadURL());
  }
}
