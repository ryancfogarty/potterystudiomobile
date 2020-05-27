import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seven_spot_mobile/usecases/CreateStudioUseCase.dart';
import 'package:seven_spot_mobile/usecases/CreateUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/UploadPhotoUseCase.dart';

class CreateAccountInteractor extends ChangeNotifier {
  CreateUserUseCase _createUserUseCase;
  CreateStudioUseCase _createStudioUseCase;
  UploadPhotoUseCase _uploadPhotoUseCase;

  CreateAccountInteractor(
      CreateUserUseCase createUserUseCase,
      CreateStudioUseCase createStudioUseCase,
      UploadPhotoUseCase uploadPhotoUseCase) {
    _createUserUseCase = createUserUseCase;
    _createStudioUseCase = createStudioUseCase;
    _uploadPhotoUseCase = uploadPhotoUseCase;
  }

  bool _loadingCreateUser = false;

  bool get loadingCreateUser => _loadingCreateUser;

  bool _loadingCreateStudio = false;

  bool get loadingCreateStudio => _loadingCreateStudio;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _uploadingImage = false;

  bool get uploadingImage => _uploadingImage;

  String _profileImageUrl;

  String get profileImageUrl => _profileImageUrl;

  void clear() {
    _profileImageUrl = null;
    notifyListeners();
  }

  void setProfileImageUrl(String profileImageUrl) {
    _profileImageUrl = profileImageUrl;
    notifyListeners();
  }

  void changeImage(ImageSource source) async {
    _uploadingImage = true;
    notifyListeners();

    try {
      _profileImageUrl =
          (await _uploadPhotoUseCase.changePhoto(source)) ?? _profileImageUrl;
    } catch (e) {
      print(e);
    } finally {
      _uploadingImage = false;
      notifyListeners();
    }
  }

  void initFromFirebaseUser() async {
    var user = await _auth.currentUser();

    print(user.photoUrl);

    _profileImageUrl = user.photoUrl;
    notifyListeners();
  }

  void removePhoto() async {
    _profileImageUrl = null;
    notifyListeners();
  }

  Future<void> createUser(String studioCode, String displayName) async {
    _loadingCreateUser = true;
    notifyListeners();

    try {
      await _createUserUseCase.createUser(
          studioCode, displayName, _profileImageUrl);
    } catch (e) {
      print(e);
    } finally {
      _loadingCreateUser = false;
      notifyListeners();
    }
  }

  Future<void> createStudio(String userName, String studioName) async {
    _loadingCreateStudio = true;
    notifyListeners();

    try {
      await _createStudioUseCase.createStudio(
          userName, studioName, _profileImageUrl);
    } catch (e) {
      print(e);
    } finally {
      _loadingCreateStudio = false;
      notifyListeners();
    }
  }
}
