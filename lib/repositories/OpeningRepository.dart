import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/services/OpeningService.dart';

class OpeningRepository {
  OpeningService _service;

  OpeningRepository() {
    _service = OpeningService();
  }

  Future<Iterable<Opening>> getAll(bool includePast) async {
    var openingDtos = await _service.getAll(includePast);

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

  Future<Opening> createOpening(Opening opening) async {
    var createdOpeningDto = await _service.createOpening(opening.toDto());

    return createdOpeningDto.toModel();
  }

  Future<Opening> updateOpening(Opening opening) async {
    var createdOpeningDto = await _service.updateOpening(opening.toDto());

    return createdOpeningDto.toModel();
  }

  Future<void> deleteOpening(String openingId) async {
    return await _service.deleteOpening(openingId);
  }
}