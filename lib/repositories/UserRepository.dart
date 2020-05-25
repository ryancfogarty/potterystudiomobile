import 'package:seven_spot_mobile/models/User.dart';
import 'package:seven_spot_mobile/services/UserService.dart';

class UserRepository {
  UserService _service;

  UserRepository() {
    _service = UserService();
  }

  Future<bool> createUser(
      String studioCode, String displayName, String imageUrl) async {
    return await _service.createUser(studioCode, displayName, imageUrl);
  }

  Future<User> getUser() async {
    var userDto = await _service.getUser();

    return userDto.toModel();
  }

  Future<void> deleteUser() async {
    return await _service.deleteUser();
  }

  Future<void> registerAsAdmin(String adminCode) async {
    return await _service.registerAsAdmin(adminCode);
  }
}
