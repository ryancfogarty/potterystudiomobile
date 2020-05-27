import 'package:flutter/material.dart';
import 'package:seven_spot_mobile/models/User.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';

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
      print(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
