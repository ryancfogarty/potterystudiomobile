import 'package:pottery_studio/models/User.dart';

class UserDto {
  String id;
  String studioName;
  String name;
  bool isAdmin;
  String studioCode;
  String studioAdminCode;
  String imageUrl;

  UserDto(String id, String studioName, String name, bool isAdmin,
      String studioCode, String studioAdminCode, String imageUrl) {
    this.id = id;
    this.studioName = studioName;
    this.name = name;
    this.isAdmin = isAdmin;
    this.studioCode = studioCode;
    this.studioAdminCode = studioAdminCode;
    this.imageUrl = imageUrl;
  }

  UserDto.fromJson(dynamic userJson) {
    this.id = userJson["id"];
    this.studioName = userJson["studioName"];
    this.name = userJson["name"];
    this.isAdmin = userJson["isAdmin"] ?? false;
    this.studioCode = userJson["studioCode"];
    this.studioAdminCode = userJson["studioAdminCode"];
    this.imageUrl = userJson["profileImageUrl"];
  }

  User toModel() {
    return User(
        id, studioName, name, isAdmin, studioCode, studioAdminCode, imageUrl);
  }
}
