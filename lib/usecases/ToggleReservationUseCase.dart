import 'package:flutter/cupertino.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/repositories/OpeningRepository.dart';

abstract class ToggleReservationUseCase extends ChangeNotifier {
  Future<void> toggleReservationForOpening(Opening opening);
}

class ToggleReservationUseCaseImpl extends ToggleReservationUseCase {
  OpeningRepository _openingRepository;

  ToggleReservationUseCaseImpl(OpeningRepository openingRepository) {
    _openingRepository = openingRepository;
  }

  @override
  Future<void> toggleReservationForOpening(Opening opening) async {
    if (opening.loggedInUserReserved) {
      await _openingRepository.removeReservation(opening);

      print("Removed reservation!");
    } else {
      await _openingRepository.reserveOpening(opening);

      print("Reserved!");
    }
  }
}