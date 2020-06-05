import 'package:pottery_studio/models/User.dart';
import 'package:pottery_studio/services/UserService.dart';

class UserRepository {
  UserService _service;

  UserRepository() {
    _service = UserService();
  }

  Future<void> createUser(
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

  Future<User> updateUser(String name, String profileImageUrl) async {
    var userDto = await _service.updateUser(name, profileImageUrl);

    return userDto.toModel();
  }

  Future<Iterable<User>> presentUsers() async {
    var userDtos = await _service.presentUsers();

    return userDtos.map((dto) => dto.toModel());
  }

  Future<void> checkIn() async {
    return await _service.checkIn();
  }

  Future<void> checkOut() async {
    return await _service.checkOut();
  }
}
