import 'package:encrypt/encrypt.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class CreateUserUseCase {
  UserRepository _repo;
  AuthService _authService;
  Encrypter _encrypter;

  CreateUserUseCase(AuthService authService, Encrypter encrypter) {
    _repo = UserRepository();
    _authService = authService;
    _encrypter = encrypter;
  }

  Future<void> createUser(String companySecret, String companyName) async {
    var encryptedCompanySecret = _encrypter.encrypt(companySecret).base64;

    var success = await _repo.createUser(encryptedCompanySecret, companyName);

    if (success) {
      _authService.updateState(AppState.REGISTERED);
    }
  }
}