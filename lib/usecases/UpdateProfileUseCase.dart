import 'package:pottery_studio/repositories/UserRepository.dart';
import 'package:pottery_studio/usecases/GetUserUseCase.dart';

class UpdateProfileUseCase {
  UserRepository _repo;
  GetUserUseCase _getUserUseCase;

  UpdateProfileUseCase(UserRepository repo, GetUserUseCase getUserUseCase) {
    _repo = repo;
    _getUserUseCase = getUserUseCase;
  }

  Future<void> invoke(String name) async {
    await _repo.updateUser(name, null);
    await _getUserUseCase.getUser(clearCache: false);
  }
}
