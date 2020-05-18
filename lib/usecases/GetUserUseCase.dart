import 'package:flutter/cupertino.dart';
import 'package:seven_spot_mobile/models/User.dart';
import 'package:seven_spot_mobile/repositories/UserRepository.dart';

abstract class GetUserUseCase extends ChangeNotifier {
  Future<void> getUser();

  User get user;
}

class GetUserUseCaseImpl extends GetUserUseCase {
  UserRepository _repo;

  User _user;

  User get user => _user;

  GetUserUseCaseImpl(UserRepository repo) {
    _repo = repo;
  }

  Future<void> getUser() async {
    _clear();

    _user = await _repo.getUser();
    notifyListeners();
  }

  void _clear() {
    _user = null;
    notifyListeners();
  }
}
