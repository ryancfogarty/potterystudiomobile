import 'package:flutter/widgets.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/repositories/OpeningRepository.dart';

class GetOpeningUseCase extends ChangeNotifier {
  Opening opening;

  OpeningRepository _repo;

  GetOpeningUseCase(OpeningRepository repo) {
    _repo = repo;
  }

  Future invoke(String openingId) async {
    opening = await _repo.getOpening(openingId);

    notifyListeners();
  }

  void clear() {
    opening = null;

    notifyListeners();
  }
}