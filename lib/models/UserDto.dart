import 'package:seven_spot_mobile/models/User.dart';

class UserDto {
  String id;
  String studioName;
  String name;
  bool isAdmin;
  String studioCode;
  String studioAdminCode;

  UserDto(String id, String studioName, String name, bool isAdmin,
      String studioCode, String studioAdminCode) {
    this.id = id;
    this.studioName = studioName;
    this.name = name;
    this.isAdmin = isAdmin;
    this.studioCode = studioCode;
    this.studioAdminCode = studioAdminCode;
  }

  User toModel() {
    return User(id, studioName, name, isAdmin, studioCode, studioAdminCode);
  }
}
