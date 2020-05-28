import 'package:seven_spot_mobile/repositories/UserRepository.dart';

class CheckInUseCase {
  UserRepository _repo;

  CheckInUseCase(UserRepository repo) {
    _repo = repo;
  }

  Future<void> invoke() async {
    print("checking in");

    await _repo.checkIn();
  }
}
