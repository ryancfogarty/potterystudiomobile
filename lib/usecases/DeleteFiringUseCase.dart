import 'package:flutter/widgets.dart';
import 'package:seven_spot_mobile/repositories/FiringRepository.dart';

class DeleteFiringUseCase extends ChangeNotifier {
  FiringRepository _repo;

  bool _loading = false;

  bool get loading => _loading;

  DeleteFiringUseCase(FiringRepository repo) {
    _repo = repo;
  }

  Future<void> deleteFiring(String firingId) async {
    _loading = true;
    notifyListeners();

    try {
      await _repo.deleteFiring(firingId);
    } catch (e) {
      print(e);
      throw e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
