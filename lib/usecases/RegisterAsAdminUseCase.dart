import 'package:flutter/widgets.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';
import 'package:seven_spot_mobile/usecases/GetUserUseCase.dart';

class RegisterAsAdminUseCase extends ChangeNotifier {
  UserRepository _repo;
  GetUserUseCase _getUserUseCase;

  bool _loading = false;

  bool get loading => _loading;

  RegisterAsAdminUseCase(UserRepository repo, GetUserUseCase getUserUseCase) {
    _repo = repo;
    _getUserUseCase = getUserUseCase;
  }

  Future<void> registerAsAdmin(String adminCode) async {
    _loading = true;
    notifyListeners();

    try {
      await _repo.registerAsAdmin(adminCode);
      await _getUserUseCase.getUser();
    } catch (e) {
      throw e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
