import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/repositories/OpeningRepository.dart';

class GetAllOpeningsUseCase {
  OpeningRepository _repo;

  GetAllOpeningsUseCase() {
    _repo = OpeningRepository();
  }

  Future<Iterable<Opening>> invoke() async {
    return await _repo.getAll();
  }
}