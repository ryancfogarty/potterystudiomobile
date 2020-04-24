import 'package:seven_spot_mobile/models/User.dart';

class UserDto {
  String id;
  String companyName;
  String name;

  UserDto(String id, String companyName, String name) {
    this.id = id;
    this.companyName = companyName;
    this.name = name;
  }

  User toModel() {
    return User(id, companyName, name);
  }
}