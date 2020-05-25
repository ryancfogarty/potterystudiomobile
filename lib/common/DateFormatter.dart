import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._internal();

  static final DateFormatter _dateFormatter = DateFormatter._internal();

  factory DateFormatter() {
    return _dateFormatter;
  }

  // ignore: non_constant_identifier_names
  final dd_MMMM = DateFormat("dd MMMM");

  // ignore: non_constant_identifier_names
  final HH_mm = DateFormat("HH:mm");

  // ignore: non_constant_identifier_names
  final dd_MMMM_HH_mm = DateFormat("dd MMMM HH:mm");

  // ignore: non_constant_identifier_names
  final EEE_dd_MMMM_y = DateFormat("EEE dd MMMM y");

  // ignore: non_constant_identifier_names
  final EEEE = DateFormat("EEEE");

  // ignore: non_constant_identifier_names
  final dd = DateFormat("dd");

  String formatDateTimeRange(DateTime start, DateTime end) {
    if (start.day == end.day && start.month == end.month && start.year == end.year) {
      return "${dd_MMMM.format(start)} ${HH_mm.format(start)} - ${HH_mm.format(end)}";
    } else {
      return "${dd_MMMM_HH_mm.format(start)} - ${dd_MMMM_HH_mm.format(end)}";
    }
  }

  String formatTimeRange(DateTime start, DateTime end) {
    return "${HH_mm.format(start)} - ${HH_mm.format(end)}";
  }

  String formatDateRange(DateTime start, DateTime end) {
    return "${dd_MMMM.format(start)} - ${dd_MMMM.format(end)}";
  }
}
