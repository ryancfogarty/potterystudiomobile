import 'Opening.dart';

class OpeningDto {
  String id;
  String start;
  int lengthSeconds;
  int size;
  List<String> reservedUserIds;
  bool loggedInUserReserved;

  OpeningDto(String id, String start, int lengthSeconds, int size, List<String> reservedUserIds, bool loggedInUserReserved) {
    this.id = id;
    this.start = start;
    this.lengthSeconds = lengthSeconds;
    this.size = size;
    this.reservedUserIds = reservedUserIds;
    this.loggedInUserReserved = loggedInUserReserved;
  }

  Opening toModel() {
    var startDateTime = DateTime.parse(start);

    return Opening(id, startDateTime, startDateTime.add(Duration(seconds: lengthSeconds)), size, reservedUserIds, loggedInUserReserved);
  }
}