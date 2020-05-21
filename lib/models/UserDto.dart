import 'package:seven_spot_mobile/models/User.dart';

class UserDto {
  String id;
  String studioName;
  String name;
  bool isAdmin;

  UserDto(String id, String studioName, String name, bool isAdmin) {
    this.id = id;
    this.studioName = studioName;
    this.name = name;
    this.isAdmin = isAdmin;
  }

  User toModel() {
    return User(id, studioName, name, isAdmin);
  }
}
