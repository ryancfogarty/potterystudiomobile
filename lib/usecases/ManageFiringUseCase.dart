import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seven_spot_mobile/models/Firing.dart';
import 'package:seven_spot_mobile/repositories/FiringRepository.dart';

class ManageFiringUseCase extends ChangeNotifier {
  FiringRepository _repo;

  bool _loading = false;
  bool get loading => _loading;

  bool _saving = false;
  bool get saving => _saving;

  Firing _firing = Firing.empty();
  Firing get firing => _firing;

  ManageFiringUseCase(FiringRepository repo) {
    _repo = repo;
  }

  void clear() {
    _firing = Firing.empty();
    notifyListeners();
  }

  void updateStartDate(DateTime startDate) {
    _firing.start = DateTime(startDate.year, startDate.month, startDate.day,
        _firing.start.hour, _firing.start.minute);

    notifyListeners();
  }

  void updateStartTime(TimeOfDay startTime) {
    _firing.start = DateTime(_firing.start.year, _firing.start.month,
        _firing.start.day, startTime.hour, startTime.minute);

    notifyListeners();
  }

  void updateDuration(int hours, int minutes) {
    var initialHours = (_firing.durationSeconds / 3600).floor();
    var initialMinutes = (_firing.durationSeconds / 60 % 60).floor();

    _firing.durationSeconds = (hours ?? initialHours) * 3600 + (minutes ?? initialMinutes) * 60;

    notifyListeners();
  }

  void updateCooldown(int hours, int minutes) {
    var initialHours = (_firing.cooldownSeconds / 3600).floor();
    var initialMinutes = (_firing.cooldownSeconds / 60 % 60).floor();

    _firing.cooldownSeconds = (hours ?? initialHours) * 3600 + (minutes ?? initialMinutes) * 60;

    notifyListeners();
  }

  void updateType(String type) {
    _firing.type = type;
    notifyListeners();
  }

  Future<void> save() async {
    _saving = true;
    notifyListeners();

    try {
      if (_firing.id != null) {
        // todo: update firing
      } else {
        await _repo.createFiring(_firing);
      }
    } catch (e) {
      print(e);
      throw e;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}