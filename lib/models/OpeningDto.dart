import 'Opening.dart';

class OpeningDto {
  String start;

  OpeningDto(String start) {
    this.start = start;
  }

  Opening toModel() {
    return Opening(DateTime.parse(start));
  }
}