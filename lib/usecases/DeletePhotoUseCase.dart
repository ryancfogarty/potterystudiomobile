import 'package:pottery_studio/repositories/UserRepository.dart';
import 'package:pottery_studio/usecases/GetUserUseCase.dart';

class DeletePhotoUseCase {
  UserRepository _repo;
  GetUserUseCaseImpl _getUserUseCase;

  DeletePhotoUseCase(UserRepository repo, GetUserUseCaseImpl getUserUseCase) {
    _repo = repo;
    _getUserUseCase = getUserUseCase;
  }

  Future<void> invoke() async {
    var updatedUser = await _repo.updateUser(null, "");

    _getUserUseCase.setUser(updatedUser);
  }
}
