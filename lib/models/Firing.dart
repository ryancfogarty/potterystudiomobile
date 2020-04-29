class Firing {
  String id;
  DateTime start;
  DateTime end;
  DateTime cooldownEnd;
  String type;

  Firing(String id, DateTime start, DateTime end, DateTime cooldownEnd, String type) {
    this.id = id;
    this.start = start;
    this.end = end;
    this.cooldownEnd = cooldownEnd;
    this.type = type;
  }
}