import 'package:seven_spot_mobile/repositories/AccountRepository.dart';
import 'package:seven_spot_mobile/services/AuthService.dart';

class CreateAccountUseCase {
  AccountRepository _repo;
  AuthService _authService;

  CreateAccountUseCase(AuthService authService) {
    _repo = AccountRepository();
    _authService = authService;
  }

  Future<void> createAccount(companySecret) async {
    var success = await _repo.createAccount(companySecret);

    if (success) {
      _authService.updateState(AppState.VALIDATED);
    }
  }
}