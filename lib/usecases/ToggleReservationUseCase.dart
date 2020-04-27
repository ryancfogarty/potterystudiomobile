import 'package:flutter/cupertino.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/repositories/OpeningRepository.dart';

abstract class ToggleReservationUseCase extends ChangeNotifier {
  Future<void> toggleReservationForOpening(Opening opening);

  String get openingLoadingId;
  Iterable<String> get openingLoadingIds;
}

class ToggleReservationUseCaseImpl extends ToggleReservationUseCase {
  OpeningRepository _openingRepository;
  String _openingLoadingId;
  Set<String> _openingLoadingIds = new Set.of([]);

  String get openingLoadingId => _openingLoadingId;
  Iterable<String> get openingLoadingIds => _openingLoadingIds;

  ToggleReservationUseCaseImpl(OpeningRepository openingRepository) {
    _openingRepository = openingRepository;
  }

  @override
  Future<void> toggleReservationForOpening(Opening opening) async {
    _openingLoadingId = opening.id;
    _openingLoadingIds.add(opening.id);
    notifyListeners();

    try {
      if (opening.loggedInUserReserved) {
        await _openingRepository.removeReservation(opening);
      } else {
        await _openingRepository.reserveOpening(opening);
      }
    } finally {
      _openingLoadingId = null;
      _openingLoadingIds.remove(opening.id);
      notifyListeners();
    }
  }
}