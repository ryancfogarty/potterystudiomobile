import 'package:flutter/widgets.dart';
import 'package:pottery_studio/models/Firing.dart';
import 'package:pottery_studio/repositories/FiringRepository.dart';

class GetAllFiringsUseCase extends ChangeNotifier {
  FiringRepository _repo;

  GetAllFiringsUseCase(FiringRepository repo) {
    _repo = repo;
  }

  Future<Iterable<Firing>> invoke(bool includePast) async {
    return await _repo.getAll(includePast);
  }
}
