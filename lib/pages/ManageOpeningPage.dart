import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/usecases/ManageOpeningUseCase.dart';

class ManageOpeningPage extends StatefulWidget {
  ManageOpeningPage({
    Key key,
    this.openingId
  }) : super(key: key);

  final String openingId;

  @override
  State<StatefulWidget> createState() => _ManageOpeningPageState();
}

class _ManageOpeningPageState extends State<ManageOpeningPage> {
  bool get _isNewOpening => widget.openingId == null;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _setup);
  }

  void _setup() async {
    Provider.of<ManageOpeningUseCase>(context, listen: false).clear();

    if (!_isNewOpening) {
      try {
        Provider.of<ManageOpeningUseCase>(context, listen: false).getOpening(widget.openingId);
      } catch (e) {
        // todo: throw error and prompt refresh instead
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNewOpening ? "Create opening" : "Edit opening"),
      ),
      body: _body(),
      floatingActionButton: Consumer<ManageOpeningUseCase>(
        builder: (context, useCase, _) {
          if (useCase.saving) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            );
          } else {
           return FloatingActionButton(
             onPressed: _save,
             child: Icon(Icons.save),
           );
          }
        },
      ),
    );
  }

  _save() async {
    try {
      await Provider.of<ManageOpeningUseCase>(context, listen: false).save();
      Navigator.pop(context, true);
    } catch (e) {}
  }

  Widget _body() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        return Visibility(
          visible: !useCase.loading,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                _startDate(),
                _startTime(),
                _endDate(),
                _endTime(),
                _size()
              ],
            ),
          ),
          replacement: Center(child: CircularProgressIndicator())
        );
      }
    );
  }

  Widget _startDate() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        var text = "Start date: ";

        if (useCase.opening.start != null) {
          text += DateFormatter().EEE_dd_MMMM_y.format(useCase.opening.start);
        } else {
          text += "Select a date";
        }

        return Card(
          child: FlatButton(
            child: Text(text),
            onPressed: _editStartDate
          )
        );
      },
    );
  }

  void _editStartDate() async {
    var useCase = Provider.of<ManageOpeningUseCase>(context, listen: false);

    var selectedDate = await showDatePicker(
      context: context,
      initialDate: useCase.opening?.start ?? DateTime.now(),
      firstDate: DateTime.now().add(Duration(days: -30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (selectedDate != null) {
      useCase.updateStartDate(selectedDate);
    }
  }

  Widget _startTime() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        var text = "Start time: ";

        if (useCase.opening.start != null) {
          text += DateFormatter().HH_mm.format(useCase.opening.start);
        } else {
          text += "Select a time";
        }

        return Card(
          child: FlatButton(
            child: Text(text),
            onPressed: _editStartTime,
          ),
        );
      },
    );
  }

  void _editStartTime() async {
    var useCase = Provider.of<ManageOpeningUseCase>(context, listen: false);

    var timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: useCase.opening?.start?.hour ?? 0,
            minute: useCase.opening?.start?.minute ?? 0)
    );

    if (timeOfDay != null) {
      useCase.updateStartTime(timeOfDay);
    }
  }

  Widget _endDate() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        var text = "End date: ";

        if (useCase.opening.end != null) {
          text += DateFormatter().EEE_dd_MMMM_y.format(useCase.opening.end);
        } else {
          text += "Select a date";
        }

        return Card(
          child: FlatButton(
            child: Text(text),
            onPressed: _editEndDate,
          ),
        );
      },
    );
  }

  void _editEndDate() async {
    var useCase = Provider.of<ManageOpeningUseCase>(context, listen: false);

    var selectedDate = await showDatePicker(
      context: context,
      initialDate: useCase.opening.end ?? DateTime.now(),
      firstDate: DateTime.now().add(Duration(days: -30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );

    if (selectedDate != null) {
      useCase.updateEndDate(selectedDate);
    }
  }

  Widget _endTime() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        var text = "End time: ";

        if (useCase.opening.end != null) {
          text += DateFormatter().HH_mm.format(useCase.opening.end);
        } else {
          text += "Select a time";
        }

        return Card(
          child: FlatButton(
            child: Text(text),
            onPressed: _editEndTime,
          ),
        );
      },
    );
  }

  void _editEndTime() async {
    var useCase = Provider.of<ManageOpeningUseCase>(context, listen: false);

    var timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: useCase.opening?.end?.hour ?? 0,
            minute: useCase.opening?.end?.minute ?? 0)
    );

    if (timeOfDay != null) {
      useCase.updateEndTime(timeOfDay);
    }
  }

  Widget _size() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Capacity:",
          style: TextStyles().mediumBoldStyle
        ),
        Consumer<ManageOpeningUseCase>(
          builder: (context, useCase, _) {
            var picker = NumberPicker.integer(
              initialValue: useCase.opening.size,
              minValue: 0,
              maxValue: 100,
              onChanged: (num) => useCase.updateSize(num),
            );

            try {
              // hack around https://github.com/MarcinusX/NumberPicker/issues/26
              Future.delayed(Duration(milliseconds: 200), () => picker.animateInt(useCase.opening.size));
            } catch (e) {}

            return picker;
          },
        )
      ],
    );
  }
}