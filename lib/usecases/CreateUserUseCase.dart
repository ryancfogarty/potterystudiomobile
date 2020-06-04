import 'package:encrypt/encrypt.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class CreateUserUseCase {
  UserRepository _repo;
  AuthService _authService;

  CreateUserUseCase(AuthService authService) {
    _repo = UserRepository();
    _authService = authService;
  }

  Future<void> createUser(
      String studioCode, String displayName, String imageUrl) async {
    await _repo.createUser(studioCode, displayName, imageUrl);

    _authService.updateState(AppState.REGISTERED);
  }
}
