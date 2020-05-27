import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seven_spot_mobile/usecases/ChangePhotoUseCase.dart';
import 'package:seven_spot_mobile/usecases/DeletePhotoUseCase.dart';

class ProfileInteractor extends ChangeNotifier {
  bool _changingPhoto = false;

  bool get changingPhoto => _changingPhoto;

  bool _deletingPhoto = false;

  bool get deletingPhoto => _deletingPhoto;

  ChangePhotoUseCase _changePhotoUseCase;
  DeletePhotoUseCase _deletePhotoUseCase;

  ProfileInteractor(ChangePhotoUseCase changePhotoUseCase,
      DeletePhotoUseCase deletePhotoUseCase) {
    _changePhotoUseCase = changePhotoUseCase;
    _deletePhotoUseCase = deletePhotoUseCase;
  }

  Future<void> changePhoto(ImageSource source) async {
    _changingPhoto = true;
    notifyListeners();

    try {
      await _changePhotoUseCase.invoke(source);
    } catch (e) {
      print(e);
    } finally {
      _changingPhoto = false;
      notifyListeners();
    }
  }

  Future<void> deletePhoto() async {
    _deletingPhoto = true;
    notifyListeners();

    try {
      await _deletePhotoUseCase.invoke();
    } catch (e) {
      print(e);
    } finally {
      _deletingPhoto = false;
      notifyListeners();
    }
  }
}
