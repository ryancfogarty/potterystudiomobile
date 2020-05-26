import 'package:flutter/material.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';

class DeleteUserUseCase extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  UserRepository _repo;

  DeleteUserUseCase(UserRepository repo) {
    _repo = repo;
  }

  Future<bool> invoke() async {
    _loading = true;
    notifyListeners();

    var success;

    try {
      await _repo.deleteUser();
      success = true;
    } catch (e) {
      success = false;
      print(e);
    } finally {
      _loading = false;
      notifyListeners();
    }

    return success;
  }
}
