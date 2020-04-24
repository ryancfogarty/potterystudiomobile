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

  Future<Opening> getOpening(String openingId) async {
    var openingDto = await _service.getOpening(openingId);

    return openingDto.toModel();
  }
  
  Future<Opening> reserveOpening(Opening opening) async {
    var openingDto = await _service.reserveOpening(opening.id);

    return openingDto.toModel();
  }

  Future<Opening> removeReservation(Opening opening) async {
    var openingDto = await _service.removeReservation(opening.id);

    return openingDto.toModel();
  }
}