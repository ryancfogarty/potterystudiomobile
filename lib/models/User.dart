import 'package:seven_spot_mobile/models/UserDto.dart';

class User {
  String id;
  String companyName;
  String name;
  bool isAdmin;

  User(String id, String companyName, String name, bool isAdmin) {
    this.id = id;
    this.companyName = companyName;
    this.name = name;
    this.isAdmin = isAdmin;
  }

  UserDto toDto() => UserDto(id, companyName, name, isAdmin);
}
