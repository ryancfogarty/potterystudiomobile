import 'package:seven_spot_mobile/models/User.dart';

import 'OpeningDto.dart';

class Opening {
  String id;
  DateTime start;
  DateTime end;
  int size;
  List<String> reservedUserIds;
  bool loggedInUserReserved;
  List<User> reservedUsers;

  Opening.empty() {
    var now = DateTime.now();
    start = DateTime(now.year, now.month, now.day, 18);
    end = start.add(Duration(hours: 2));
    size = 0;
  }

  Opening(String id, DateTime start, DateTime end, int size, List<String> reservedUserIds, bool loggedInUserReserved, List<User> reservedUsers) {
    this.id = id;
    this.start = start;
    this.end = end;
    this.size = size;
    this.reservedUserIds = reservedUserIds;
    this.loggedInUserReserved = loggedInUserReserved;
    this.reservedUsers = reservedUsers;
  }

  OpeningDto toDto() {
    return OpeningDto(id, start.toIso8601String(), end.difference(start).inSeconds,
        size, reservedUserIds, loggedInUserReserved,
        [for (User user in (reservedUsers ?? [])) user.toDto()]);
  }
}