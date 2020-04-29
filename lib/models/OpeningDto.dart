import 'package:seven_spot_mobile/models/UserDto.dart';

import 'Opening.dart';

class OpeningDto {
  String id;
  String start;
  int lengthSeconds;
  int size;
  List<String> reservedUserIds;
  List<UserDto> reservedUsers;
  bool loggedInUserReserved;

  OpeningDto(String id, String start, int lengthSeconds, int size, List<String> reservedUserIds, bool loggedInUserReserved, List<UserDto> reservedUsers) {
    this.id = id;
    this.start = start;
    this.lengthSeconds = lengthSeconds;
    this.size = size;
    this.reservedUserIds = reservedUserIds;
    this.loggedInUserReserved = loggedInUserReserved;
    this.reservedUsers = reservedUsers;
  }

  Opening toModel() {
    var startDateTime = DateTime.parse(start);

    return Opening(id, startDateTime, startDateTime.add(Duration(seconds: lengthSeconds)),
        size, reservedUserIds, loggedInUserReserved,
        reservedUsers.map((UserDto dto) => dto.toModel()).toList());
  }
}