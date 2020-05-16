import 'package:seven_spot_mobile/models/Opening.dart';

class OpeningGroup {
  List<Opening> openings;
  String name;

  OpeningGroup(List<Opening> openings, String name) {
    this.openings = openings;
    this.name = name;
  }
}
