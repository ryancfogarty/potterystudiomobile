import 'OpeningDto.dart';

class Opening {
  DateTime start;
  DateTime end;
  int size;
  List<String> reservedUserIds;
  bool loggedInUserReserved;

  Opening(DateTime start, DateTime end, int size, List<String> reservedUserIds, bool loggedInUserReserved) {
    this.start = start;
    this.end = end;
    this.size = size;
    this.reservedUserIds = reservedUserIds;
    this.loggedInUserReserved = loggedInUserReserved;
  }

  OpeningDto toDto() {
    return OpeningDto(start.toIso8601String(), end.difference(start).inSeconds, size, reservedUserIds, loggedInUserReserved);
  }
}