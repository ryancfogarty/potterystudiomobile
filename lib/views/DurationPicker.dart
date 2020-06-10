import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pottery_studio/common/TextStyles.dart';

class DurationPicker extends StatefulWidget {
  DurationPicker(
      {Key key,
      this.title,
      this.hours,
      this.minutes,
      this.onHoursChanged,
      this.onMinutesChanged})
      : super(key: key);

  final String title;
  final int hours;
  final int minutes;
  final Function(int) onHoursChanged;
  final Function(int) onMinutesChanged;

  @override
  _DurationPickerState createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  final TextEditingController _hoursController = new TextEditingController();

  final TextEditingController _minutesController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: TextStyles.bigRegularStyle,
        ),
        Container(
          width: 110,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _hoursWidget(),
              Text(
                ":",
                style: TextStyles.mediumRegularStyle,
              ),
              _minutesWidget()
            ],
          ),
        ),
      ],
    );
  }

  Widget _hoursWidget() {
    if (widget.hours != null &&
        _hoursController.text != widget.hours.toString()) {
      _hoursController.text = widget.hours.toString();
    }

    _hoursController.selection = TextSelection.fromPosition(
        TextPosition(offset: _hoursController.text.length));

    return Container(
      width: 30,
      child: TextField(
        controller: _hoursController,
        decoration: new InputDecoration(
            labelText: "hh", isDense: true, border: InputBorder.none),
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.length == 3) {
              return newValue.copyWith(
                  text: newValue.text.substring(1, 3),
                  selection:
                      TextSelection.fromPosition(TextPosition(offset: 2)));
            }

            return newValue;
          })
        ],
        onChanged: (text) => widget.onHoursChanged(num.tryParse(text) ?? 0),
      ),
    );
  }

  Widget _minutesWidget() {
    if (widget.minutes != null &&
        _minutesController.text != widget.minutes.toString()) {
      _minutesController.text = widget.minutes.toString();
    }

    _minutesController.selection = TextSelection.fromPosition(
        TextPosition(offset: _minutesController.text.length));

    return Container(
      width: 30,
      child: TextField(
        controller: _minutesController,
        decoration: new InputDecoration(
            labelText: "mm", isDense: true, border: InputBorder.none),
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.text.length == 3) {
              return newValue.copyWith(
                  text: newValue.text.substring(1, 3),
                  selection:
                      TextSelection.fromPosition(TextPosition(offset: 2)));
            }

            return newValue;
          })
        ],
        onChanged: (text) => widget.onMinutesChanged(num.tryParse(text) ?? 0),
      ),
    );
  }
}
