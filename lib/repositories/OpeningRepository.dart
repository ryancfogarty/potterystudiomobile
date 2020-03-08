import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/services/OpeningService.dart';

class OpeningRepository {
  OpeningService _service;

  OpeningRepository() {
    _service = OpeningService();
  }

  Future<Iterable<Opening>> getAll() async {
    var openingDtos = await _service.getAll();

    return openingDtos.map((dto) => dto.toModel());
  }
}