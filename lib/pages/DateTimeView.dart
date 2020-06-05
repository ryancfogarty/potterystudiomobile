import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pottery_studio/common/DateFormatter.dart';
import 'package:pottery_studio/common/TextStyles.dart';

class DateTimeView extends StatelessWidget {
  const DateTimeView(
      {Key key,
      this.title,
      this.onDateChanged,
      this.onTimeChanged,
      this.dateTime,
      this.isValid})
      : super(key: key);

  final String title;
  final Function(DateTime) onDateChanged;
  final Function(TimeOfDay) onTimeChanged;
  final DateTime dateTime;
  final bool isValid;

  static final TextStyle _errorTextStyle =
      TextStyles().mediumSkinnyStyle.apply(color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        title,
        style: TextStyles().bigRegularStyle,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(),
        FlatButton(
            child: Text(
              DateFormatter().EEE_dd_MMMM_y.format(dateTime),
              style: isValid ? TextStyles().mediumSkinnyStyle : _errorTextStyle,
            ),
            onPressed: () => _editDate(context)),
        FlatButton(
            child: Text(
              DateFormatter().HH_mm.format(dateTime),
              style: isValid ? TextStyles().mediumSkinnyStyle : _errorTextStyle,
            ),
            onPressed: () => _editTime(context))
      ]),
    ]);
  }

  void _editDate(BuildContext context) async {
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime.now().add(Duration(days: -30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate != null) {
      onDateChanged(selectedDate);
    }
  }

  void _editTime(BuildContext context) async {
    var timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));

    if (timeOfDay != null) {
      onTimeChanged(timeOfDay);
    }
  }
}
