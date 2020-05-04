import 'package:seven_spot_mobile/models/Firing.dart';

class FiringDto {
  String id;
  String start;
  int durationSeconds;
  int cooldownSeconds;
  String type;

  FiringDto(String id, String start, int durationSeconds, int cooldownSeconds, String type) {
    this.id = id;
    this.start = start;
    this.durationSeconds = durationSeconds;
    this.cooldownSeconds = cooldownSeconds;
    this.type = type;
  }

  Firing toModel() {
    var startDateTime = DateTime.parse(start);

    return Firing(id, startDateTime, durationSeconds, cooldownSeconds, type);
  }
}