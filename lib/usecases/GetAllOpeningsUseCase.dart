import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:seven_spot_mobile/models/Opening.dart';
import 'package:seven_spot_mobile/models/OpeningGroup.dart';
import 'package:seven_spot_mobile/repositories/OpeningRepository.dart';
import "package:collection/collection.dart";

class GetAllOpeningsUseCase extends ChangeNotifier {
  Iterable<Opening> _openings = Iterable.empty();

  Iterable<Opening> get openings => _openings;

  bool _includePast = false;

  bool get includePast => _includePast;

  void setIncludePast(bool i) {
    _includePast = i;
    notifyListeners();
  }

  OpeningRepository _repo;

  GetAllOpeningsUseCase() {
    _repo = OpeningRepository();
  }

  Future<void> invoke() async {
    _openings = await _repo.getAll(_includePast);

    notifyListeners();
  }

  Future<Iterable<OpeningGroup>> invoke2() async {
    var openings = await _repo.getAll(_includePast);
    var today = DateTime.now();

    var groups = groupBy(openings, (Opening opening) {
      if (opening.start.difference(today).inDays == 0 &&
          opening.start.day == today.day) {
        return "Today";
      } else if (opening.start.month == today.month &&
          opening.start.year == today.year) {
        return "This month";
      } else {
        return "Future";
      }
    });
    return groups.keys.map((key) => OpeningGroup(groups[key], key));
  }
}
