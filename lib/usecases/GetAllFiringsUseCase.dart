import 'package:seven_spot_mobile/models/Firing.dart';
import 'package:seven_spot_mobile/repositories/FiringRepository.dart';

class GetAllFiringsUseCase {
  FiringRepository _repo;

  GetAllFiringsUseCase(FiringRepository repo) {
    _repo = repo;
  }

  Future<Iterable<Firing>> invoke() async {
    return await _repo.getAll();
  }
}