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
  bool recurring;
  String recurrenceType;
  int numberOfOccurrences;

  OpeningDto(
      String id,
      String start,
      int lengthSeconds,
      int size,
      List<String> reservedUserIds,
      bool loggedInUserReserved,
      List<UserDto> reservedUsers,
      {bool recurring = false,
      String recurrenceType = "DAILY",
      int numberOfOccurrences = 1}) {
    this.id = id;
    this.start = start;
    this.lengthSeconds = lengthSeconds;
    this.size = size;
    this.reservedUserIds = reservedUserIds;
    this.loggedInUserReserved = loggedInUserReserved;
    this.reservedUsers = reservedUsers;
    this.recurring = recurring;
    this.recurrenceType = recurrenceType;
    this.numberOfOccurrences = numberOfOccurrences;
  }

  OpeningDto.fromJson(dynamic openingJson, String currentUserId) {
    List<String> reservedUserIds =
    openingJson["reservedUserIds"].cast<String>();
    List<UserDto> reservedUserDtos = [
      for (var userJson in (openingJson["reservedUsers"] ?? []))
        UserDto.fromJson(userJson)
    ];

    this.id = openingJson["id"];
    this.start = openingJson["start"];
    this.lengthSeconds = openingJson["lengthSeconds"];
    this.size = openingJson["size"];
    this.reservedUserIds = reservedUserIds;
    this.loggedInUserReserved = reservedUserIds.contains(currentUserId);
    this.reservedUsers = reservedUserDtos;
  }

  Opening toModel() {
    var startDateTime = DateTime.parse(start);

    return Opening(
        id,
        startDateTime,
        startDateTime.add(Duration(seconds: lengthSeconds)),
        size,
        reservedUserIds,
        loggedInUserReserved,
        reservedUsers.map((UserDto dto) => dto.toModel()).toList());
  }
}
