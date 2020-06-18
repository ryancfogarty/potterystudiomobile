import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pottery_studio/usecases/ChangePhotoUseCase.dart';
import 'package:pottery_studio/usecases/DeletePhotoUseCase.dart';
import 'package:pottery_studio/usecases/UpdateProfileUseCase.dart';

class ProfileInteractor extends ChangeNotifier {
  bool _changingPhoto = false;

  bool get changingPhoto => _changingPhoto;

  bool _deletingPhoto = false;

  bool get deletingPhoto => _deletingPhoto;

  bool _savingChanges = false;

  bool get savingChanges => _savingChanges;

  ChangePhotoUseCase _changePhotoUseCase;
  DeletePhotoUseCase _deletePhotoUseCase;
  UpdateProfileUseCase _updateProfileUseCase;

  ProfileInteractor(
      ChangePhotoUseCase changePhotoUseCase,
      DeletePhotoUseCase deletePhotoUseCase,
      UpdateProfileUseCase updateProfileUseCase) {
    _changePhotoUseCase = changePhotoUseCase;
    _deletePhotoUseCase = deletePhotoUseCase;
    _updateProfileUseCase = updateProfileUseCase;
  }

  Future<void> changePhoto(ImageSource source, String filePath) async {
    _changingPhoto = true;
    notifyListeners();

    try {
      await _changePhotoUseCase.invoke(source, filePath);
    } catch (e) {
      throw e;
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
      throw e;
    } finally {
      _deletingPhoto = false;
      notifyListeners();
    }
  }

  Future<void> saveChanges(String name) async {
    _savingChanges = true;
    notifyListeners();

    try {
      await _updateProfileUseCase.invoke(name);
    } catch (e) {
      throw e;
    } finally {
      _savingChanges = false;
      notifyListeners();
    }
  }
}
