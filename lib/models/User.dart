import 'package:seven_spot_mobile/models/UserDto.dart';

class User {
  String id;
  String studioName;
  String name;
  bool isAdmin;

  User(String id, String studioName, String name, bool isAdmin) {
    this.id = id;
    this.studioName = studioName;
    this.name = name;
    this.isAdmin = isAdmin;
  }

  UserDto toDto() => UserDto(id, studioName, name, isAdmin);
}
