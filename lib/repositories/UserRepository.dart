import 'package:seven_spot_mobile/services/UserService.dart';

class UserRepository {
  UserService _service;

  UserRepository() {
    _service = UserService();
  }

  Future<bool> createUser(String companySecret) async {
    return await _service.createUser(companySecret);
  }
}