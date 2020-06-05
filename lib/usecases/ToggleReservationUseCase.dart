import 'package:flutter/cupertino.dart';
import 'package:pottery_studio/models/Opening.dart';
import 'package:pottery_studio/repositories/OpeningRepository.dart';

abstract class ToggleReservationUseCase extends ChangeNotifier {
  Future<void> toggleReservationForOpening(Opening opening);

  Iterable<String> get openingLoadingIds;
}

class ToggleReservationUseCaseImpl extends ToggleReservationUseCase {
  OpeningRepository _openingRepository;
  Set<String> _openingLoadingIds = new Set.of([]);

  Iterable<String> get openingLoadingIds => _openingLoadingIds;

  ToggleReservationUseCaseImpl(OpeningRepository openingRepository) {
    _openingRepository = openingRepository;
  }

  @override
  Future<void> toggleReservationForOpening(Opening opening) async {
    _openingLoadingIds.add(opening.id);
    notifyListeners();

    try {
      if (opening.loggedInUserReserved) {
        await _openingRepository.removeReservation(opening);
      } else {
        await _openingRepository.reserveOpening(opening);
      }
    } catch (e) {
      throw e;
    } finally {
      _openingLoadingIds.remove(opening.id);
      notifyListeners();
    }
  }
}
