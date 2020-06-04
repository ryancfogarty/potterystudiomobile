import 'package:seven_spot_mobile/repositories/UserRepository.dart';

class CheckInUseCase {
  UserRepository _repo;

  CheckInUseCase(UserRepository repo) {
    _repo = repo;
  }

  Future<void> invoke() async {
    return await _repo.checkIn();
  }
}
