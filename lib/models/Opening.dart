import 'OpeningDto.dart';

class Opening {
  String id;
  DateTime start;
  DateTime end;
  int size;
  List<String> reservedUserIds;
  bool loggedInUserReserved;

  Opening(String id, DateTime start, DateTime end, int size, List<String> reservedUserIds, bool loggedInUserReserved) {
    this.id = id;
    this.start = start;
    this.end = end;
    this.size = size;
    this.reservedUserIds = reservedUserIds;
    this.loggedInUserReserved = loggedInUserReserved;
  }

  OpeningDto toDto() {
    return OpeningDto(id, start.toIso8601String(), end.difference(start).inSeconds, size, reservedUserIds, loggedInUserReserved);
  }
}