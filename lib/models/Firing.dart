import 'package:seven_spot_mobile/models/FiringDto.dart';

class Firing {
  String id;
  DateTime start;
  int durationSeconds;
  int cooldownSeconds;
  String type;

  DateTime get end => start.add(Duration(seconds: durationSeconds));
  DateTime get cooldownEnd => end.add(Duration(seconds: cooldownSeconds));

  Firing(String id, DateTime start, int durationSeconds, int cooldownSeconds, String type) {
    this.id = id;
    this.start = start;
    this.durationSeconds = durationSeconds;
    this.cooldownSeconds = cooldownSeconds;
    this.type = type;
  }

  Firing.empty() {
    var now = DateTime.now();
    start = DateTime(now.year, now.month, now.day);
    durationSeconds = 86400;
    cooldownSeconds = 86400;
    type = "BISQUE";
  }

  FiringDto toDto() {
    return FiringDto(id, start.toIso8601String(), durationSeconds, cooldownSeconds, type);
  }
}