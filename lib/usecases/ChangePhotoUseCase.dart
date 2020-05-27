import 'package:image_picker/image_picker.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';
import 'package:seven_spot_mobile/usecases/UploadPhotoUseCase.dart';

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

  Future<void> invoke(ImageSource source) async {
    var imageUrl = await _uploadPhotoUseCase.changePhoto(source);

    if (imageUrl == null) return;

    var updatedUser = await _repo.updateUser(null, imageUrl);
    _getUserUseCase.setUser(updatedUser);
  }
}
