import 'package:seven_spot_mobile/repositories/UserRepository.dart';

class DeleteUserUseCase {
  UserRepository _repo;

  DeleteUserUseCase(UserRepository repo) {
    _repo = repo;
  }

  Future<bool> invoke() async {
    var success;

    try {
      await _repo.deleteUser();
      success = true;
    } catch (e) {
      success = false;
      print(e);
    }

    return success;
  }
}