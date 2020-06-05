import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pottery_studio/usecases/CreateStudioUseCase.dart';
import 'package:pottery_studio/usecases/CreateUserUseCase.dart';
import 'package:pottery_studio/usecases/UploadPhotoUseCase.dart';

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

  Future changeImage(ImageSource source, String filePath) async {
    _uploadingImage = true;
    notifyListeners();

    try {
      _profileImageUrl = (source == ImageSource.gallery
              ? await _uploadPhotoUseCase.withSelection()
              : await _uploadPhotoUseCase.withPhoto(filePath)) ??
          _profileImageUrl;
    } catch (e) {
      throw e;
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
      throw e;
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
      throw e;
    } finally {
      _loadingCreateStudio = false;
      notifyListeners();
    }
  }
}
