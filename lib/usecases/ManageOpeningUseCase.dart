import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pottery_studio/models/Opening.dart';
import 'package:pottery_studio/repositories/OpeningRepository.dart';

enum SaveResponse { SUCCESS, ERROR, INVALID }

class ManageOpeningUseCase extends ChangeNotifier {
  OpeningRepository _repo;

  Opening _opening = Opening.empty();

  Opening get opening => _opening;

  bool _saving = false;

  bool get saving => _saving;

  bool _loading = false;

  bool get loading => _loading;

  ManageOpeningUseCase(OpeningRepository repo) {
    _repo = repo;
  }

  Future<void> getOpening(String openingId) async {
    _loading = true;
    notifyListeners();

    try {
      _opening = await _repo.getOpening(openingId);
    } catch (e) {
      throw e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clear() {
    _opening = Opening.empty();
    notifyListeners();
  }

  void updateStartDate(DateTime startDate) {
    _opening.start = DateTime.utc(startDate.year, startDate.month,
        startDate.day, _opening.start.hour, _opening.start.minute);

    if (!_startBeforeEnd) {
      _opening.end = DateTime.utc(startDate.year, startDate.month,
          startDate.day, _opening.end.hour, _opening.end.minute);
    }

    notifyListeners();
  }

  void updateStartTime(TimeOfDay startTime) {
    _opening.start = DateTime.utc(_opening.start.year, _opening.start.month,
        _opening.start.day, startTime.hour, startTime.minute);

    notifyListeners();
  }

  void updateEndDate(DateTime endDate) {
    _opening.end = DateTime.utc(endDate.year, endDate.month, endDate.day,
        _opening.end.hour, _opening.end.minute);

    if (!_startBeforeEnd) {
      _opening.start = DateTime.utc(endDate.year, endDate.month, endDate.day,
          _opening.start.hour, _opening.start.minute);
    }

    notifyListeners();
  }

  bool get _startBeforeEnd => _opening.start.difference(_opening.end).isNegative;

  void updateEndTime(TimeOfDay endTime) {
    _opening.end = DateTime.utc(_opening.end.year, _opening.end.month,
        _opening.end.day, endTime.hour, endTime.minute);

    notifyListeners();
  }

  void updateSize(int size) {
    _opening.size = size;
    notifyListeners();
  }

  Future<SaveResponse> save() async {
    if (_opening.start.difference(_opening.end).inMilliseconds >= 0) {
      return SaveResponse.INVALID;
    }

    var response = SaveResponse.SUCCESS;

    _saving = true;
    notifyListeners();

    try {
      if (_opening.id != null) {
        await _repo.updateOpening(_opening);
      } else {
        await _repo.createOpening(_opening);
      }
    } catch (e) {
      response = SaveResponse.ERROR;
      print(e);
    } finally {
      _saving = false;
      notifyListeners();
    }

    return response;
  }

  void updateRecurrenceType(String newType) {
    _opening.recurrenceType = newType;
    notifyListeners();
  }

  void updateRecurring(bool recurring) {
    _opening.recurring = recurring;
    notifyListeners();
  }

  void updateNumberOfOccurrences(int occurrences) {
    _opening.numberOfOccurrences = occurrences;
    notifyListeners();
  }
}
