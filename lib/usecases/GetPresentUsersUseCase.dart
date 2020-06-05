import 'package:flutter/material.dart';
import 'package:pottery_studio/models/User.dart';
import 'package:pottery_studio/repositories/UserRepository.dart';

class GetPresentUsersUseCase extends ChangeNotifier {
  UserRepository _repo;

  bool _loading = false;

  bool get loading => _loading;

  Iterable<User> _presentUsers = Iterable.empty();

  Iterable<User> get presentUsers => _presentUsers;

  GetPresentUsersUseCase(UserRepository repo) {
    _repo = repo;
  }

  Future<void> invoke() async {
    _loading = true;
    notifyListeners();

    try {
      _presentUsers = await _repo.presentUsers();
    } catch (e) {
      throw e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
