import 'package:image_picker/image_picker.dart';
import 'package:pottery_studio/repositories/UserRepository.dart';
import 'package:pottery_studio/usecases/GetUserUseCase.dart';
import 'package:pottery_studio/usecases/UploadPhotoUseCase.dart';

class ChangePhotoUseCase {
  UserRepository _repo;
  UploadPhotoUseCase _uploadPhotoUseCase;
  GetUserUseCaseImpl _getUserUseCase;

  ChangePhotoUseCase(UserRepository repo, UploadPhotoUseCase uploadPhotoUseCase,
      GetUserUseCaseImpl getUserUseCase) {
    _repo = repo;
    _uploadPhotoUseCase = uploadPhotoUseCase;
    _getUserUseCase = getUserUseCase;
  }

  Future<void> invoke(ImageSource source, String filePath) async {
    var imageUrl = await (source == ImageSource.gallery
        ? _uploadPhotoUseCase.withSelection()
        : _uploadPhotoUseCase.withPhoto(filePath));

    if (imageUrl == null) return;

    var updatedUser = await _repo.updateUser(null, imageUrl);
    _getUserUseCase.setUser(updatedUser);
  }
}
