import 'package:flutter/widgets.dart';
import 'package:pottery_studio/models/Firing.dart';
import 'package:pottery_studio/repositories/FiringRepository.dart';

class GetFiringUseCase extends ChangeNotifier {
  Firing _firing;

  Firing get firing => _firing;

  FiringRepository _repo;

  GetFiringUseCase(FiringRepository repo) {
    _repo = repo;
  }

  Future<void> invoke(String firingId) async {
    _firing = await _repo.getFiring(firingId);

    notifyListeners();
  }

  void clear() {
    _firing = null;

    notifyListeners();
  }
}
