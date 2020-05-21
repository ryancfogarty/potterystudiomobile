import 'package:encrypt/encrypt.dart';
import 'package:flutter/widgets.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class CreateUserUseCase extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  UserRepository _repo;
  AuthService _authService;
  Encrypter _encrypter;

  CreateUserUseCase(AuthService authService, Encrypter encrypter) {
    _repo = UserRepository();
    _authService = authService;
    _encrypter = encrypter;
  }

  Future<void> createUser(String studioCode, String displayName) async {
    _loading = true;
    notifyListeners();

    try {
      var success = await _repo.createUser(studioCode, displayName);

      if (success) {
        _authService.updateState(AppState.REGISTERED);
      }
    } catch (e) {
      print(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
