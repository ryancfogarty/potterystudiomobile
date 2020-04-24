import 'package:flutter/cupertino.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/repositories/OpeningRepository.dart';

abstract class ToggleReservationUseCase extends ChangeNotifier {
  Future<void> toggleReservationForOpening(Opening opening);

  String get openingLoadingId;
}

class ToggleReservationUseCaseImpl extends ToggleReservationUseCase {
  OpeningRepository _openingRepository;
  String _openingLoadingId;

  String get openingLoadingId => _openingLoadingId;

  ToggleReservationUseCaseImpl(OpeningRepository openingRepository) {
    _openingRepository = openingRepository;
  }

  @override
  Future<void> toggleReservationForOpening(Opening opening) async {
    _openingLoadingId = opening.id;
    notifyListeners();

    try {
      if (opening.loggedInUserReserved) {
        await _openingRepository.removeReservation(opening);
      } else {
        await _openingRepository.reserveOpening(opening);
      }
    } finally {
      _openingLoadingId = null;
      notifyListeners();
    }
  }
}