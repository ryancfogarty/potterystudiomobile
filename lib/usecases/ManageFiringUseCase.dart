import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pottery_studio/models/Firing.dart';
import 'package:pottery_studio/repositories/FiringRepository.dart';

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

  Future<void> getFiring(String firingId) async {
    _loading = true;
    notifyListeners();

    try {
      _firing = await _repo.getFiring(firingId);
    } catch (e) {
      throw e;
    } finally {
      _loading = false;
      notifyListeners();
    }
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
    print("$hours:$minutes");

    var initialHours = (_firing.durationSeconds / 3600).floor();
    var initialMinutes = (_firing.durationSeconds / 60 % 60).floor();

    _firing.durationSeconds =
        (hours ?? initialHours) * 3600 + (minutes ?? initialMinutes) * 60;

    notifyListeners();
  }

  void updateCooldown(int hours, int minutes) {
    var initialHours = (_firing.cooldownSeconds / 3600).floor();
    var initialMinutes = (_firing.cooldownSeconds / 60 % 60).floor();

    _firing.cooldownSeconds =
        (hours ?? initialHours) * 3600 + (minutes ?? initialMinutes) * 60;

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
        await _repo.updateFiring(_firing);
      } else {
        await _repo.createFiring(_firing);
      }
    } catch (e) {
      throw e;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
