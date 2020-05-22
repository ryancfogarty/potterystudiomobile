import 'package:seven_spot_mobile/models/UserDto.dart';

class User {
  String id;
  String studioName;
  String name;
  bool isAdmin;
  String studioCode;
  String studioAdminCode;

  User(String id, String studioName, String name, bool isAdmin,
      String studioCode, String studioAdminCode) {
    this.id = id;
    this.studioName = studioName;
    this.name = name;
    this.isAdmin = isAdmin;
    this.studioCode = studioCode;
    this.studioAdminCode = studioAdminCode;
  }

  UserDto toDto() =>
      UserDto(id, studioName, name, isAdmin, studioCode, studioAdminCode);
}
