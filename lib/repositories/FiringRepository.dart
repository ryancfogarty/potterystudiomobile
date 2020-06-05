import 'package:pottery_studio/models/Firing.dart';
import 'package:pottery_studio/services/FiringService.dart';

class FiringRepository {
  FiringService _service;

  FiringRepository(FiringService service) {
    _service = service;
  }

  Future<Iterable<Firing>> getAll(bool includePast) async {
    var dtos = await _service.getAll(includePast);

    return dtos.map((dto) => dto.toModel()).toList();
  }

  Future<Firing> getFiring(String firingId) async {
    var dto = await _service.getFiring(firingId);

    return dto.toModel();
  }

  Future<Firing> createFiring(Firing firing) async {
    var createdFiringDto = await _service.createFiring(firing.toDto());

    return createdFiringDto.toModel();
  }

  Future<void> deleteFiring(String firingId) async {
    return await _service.deleteFiring(firingId);
  }

  Future<Firing> updateFiring(Firing firing) async {
    var updatedFiringDto = await _service.updateFiring(firing.toDto());

    return updatedFiringDto.toModel();
  }
}
