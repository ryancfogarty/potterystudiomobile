import 'OpeningDto.dart';

class Opening {
  DateTime start;

  Opening(DateTime start) {
    this.start = start;
  }

  OpeningDto toDto() {
    return OpeningDto(start.toIso8601String());
  }
}