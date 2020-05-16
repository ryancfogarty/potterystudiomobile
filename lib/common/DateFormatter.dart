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
}
