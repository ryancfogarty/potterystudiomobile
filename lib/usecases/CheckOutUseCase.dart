import 'package:seven_spot_mobile/repositories/UserRepository.dart';

class CheckOutUseCase {
  UserRepository _repo;

  CheckOutUseCase(UserRepository repo) {
    _repo = repo;
  }

  Future<void> invoke() async {
    print("checking out");

    await _repo.checkOut();
  }
}