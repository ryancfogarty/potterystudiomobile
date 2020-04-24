import 'package:seven_spot_mobile/models/UserDto.dart';

class User {
  String id;
  String companyName;
  String name;

  User(String id, String companyName, String name) {
    this.id = id;
    this.companyName = companyName;
    this.name = name;
  }

  UserDto toDto() => UserDto(id, companyName, name);
}