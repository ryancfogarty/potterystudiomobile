import 'package:seven_spot_mobile/models/User.dart';

class UserDto {
  String id;
  String companyName;
  String name;
  bool isAdmin;

  UserDto(String id, String companyName, String name, bool isAdmin) {
    this.id = id;
    this.companyName = companyName;
    this.name = name;
    this.isAdmin = isAdmin;
  }

  User toModel() {
    return User(id, companyName, name, isAdmin);
  }
}
