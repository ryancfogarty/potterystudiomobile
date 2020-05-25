import 'package:seven_spot_mobile/models/UserDto.dart';

class User {
  String id;
  String studioName;
  String name;
  bool isAdmin;
  String studioCode;
  String studioAdminCode;
  String imageUrl;

  User(String id, String studioName, String name, bool isAdmin,
      String studioCode, String studioAdminCode, String imageUrl) {
    this.id = id;
    this.studioName = studioName;
    this.name = name;
    this.isAdmin = isAdmin;
    this.studioCode = studioCode;
    this.studioAdminCode = studioAdminCode;
    this.imageUrl = imageUrl;
  }

  UserDto toDto() => UserDto(
      id, studioName, name, isAdmin, studioCode, studioAdminCode, imageUrl);
}
