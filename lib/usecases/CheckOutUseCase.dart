import 'package:pottery_studio/repositories/UserRepository.dart';

class CheckOutUseCase {
  UserRepository _repo;

  CheckOutUseCase(UserRepository repo) {
    _repo = repo;
  }

  Future<void> invoke() async {
    await _repo.checkOut();
  }
}