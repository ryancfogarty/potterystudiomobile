import 'package:flutter/cupertino.dart';
import 'package:pottery_studio/models/User.dart';
import 'package:pottery_studio/repositories/UserRepository.dart';

abstract class GetUserUseCase extends ChangeNotifier {
  Future<void> getUser({bool clearCache});

  User get user;
}

class GetUserUseCaseImpl extends GetUserUseCase {
  UserRepository _repo;

  User _user;

  User get user => _user;

  GetUserUseCaseImpl(UserRepository repo) {
    _repo = repo;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> getUser({bool clearCache = true}) async {
    if (clearCache) _clear();

    _user = await _repo.getUser();
    notifyListeners();
  }

  void _clear() {
    _user = null;
    notifyListeners();
  }
}
