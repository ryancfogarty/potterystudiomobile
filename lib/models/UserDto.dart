import 'package:seven_spot_mobile/models/User.dart';

class UserDto {
  String id;
  String companyName;

  UserDto(String id, String companyName) {
    this.id = id;
    this.companyName = companyName;
  }

  User toModel() {
    return User(id, companyName);
  }
}