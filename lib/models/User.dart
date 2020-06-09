import 'package:pottery_studio/models/UserDto.dart';

class User {
  String id;
  String studioName;
  String name;
  bool isAdmin;
  String studioCode;
  String studioAdminCode;
  String imageUrl;
  String studioBanner;

  User(
      String id,
      String studioName,
      String name,
      bool isAdmin,
      String studioCode,
      String studioAdminCode,
      String imageUrl,
      String studioBanner) {
    this.id = id;
    this.studioName = studioName;
    this.name = name;
    this.isAdmin = isAdmin;
    this.studioCode = studioCode;
    this.studioAdminCode = studioAdminCode;
    this.imageUrl = imageUrl;
    this.studioBanner = studioBanner;
  }

  UserDto toDto() => UserDto(id, studioName, name, isAdmin, studioCode,
      studioAdminCode, imageUrl, studioBanner);
}
