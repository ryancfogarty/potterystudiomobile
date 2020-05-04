import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/usecases/ManageFiringUseCase.dart';
import 'package:seven_spot_mobile/usecases/ManageOpeningUseCase.dart';

class ManageFiringPage extends StatefulWidget {
  ManageFiringPage({
    Key key,
    this.firingId
  }) : super(key: key);

  final String firingId;

  @override
  State<StatefulWidget> createState() => _ManageFiringPageState();
}

class _ManageFiringPageState extends State<ManageFiringPage> {
  bool get _isNewFiring => widget.firingId == null;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _setup);
  }

  void _setup() async {
    Provider.of<ManageFiringUseCase>(context, listen: false).clear();

    if (!_isNewFiring) {
      try {
        Provider.of<ManageOpeningUseCase>(context, listen: false).getOpening(widget.firingId);
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
        title: Text(_isNewFiring ? "Create firing" : "Edit firing"),
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
            return FloatingActionButton.extended(
                onPressed: _save,
                icon: Icon(Icons.save),
                label: Text("Save")
            );
          }
        },
      ),
    );
  }

  _save() async {
    try {
      await Provider.of<ManageFiringUseCase>(context, listen: false).save();
      Navigator.pop(context, true);
    } catch (e) {}
  }

  Widget _body() {
    return Consumer<ManageFiringUseCase>(
        builder: (context, useCase, _) {
          return Visibility(
              visible: !useCase.loading,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _start(),
                    _firingDuration(),
                    _cooldownDuration(),
                    _type()
                  ],
                ),
              ),
              replacement: Center(
                child: CircularProgressIndicator()
              )
          );
        }
    );
  }

  Widget _start() {
    return Consumer<ManageFiringUseCase>(
      builder: (context, useCase, _) {
        var text = "Start: ";

        if (useCase.firing.start != null) {
          text += DateFormatter().dd_MMMM_HH_mm.format(useCase.firing.start);
        } else {
          text += "Select a date and time";
        }

        return Card(
          child: FlatButton(
            child: Text(text),
            onPressed: _editStart,
          )
        );
      }
    );
  }

  void _editStart() async {
    var useCase = Provider.of<ManageFiringUseCase>(context, listen: false);

    var selectedDate = await showDatePicker(
      context: context,
      initialDate: useCase.firing?.start ?? DateTime.now(),
      firstDate: DateTime.now().add(Duration(days: -30)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (selectedDate == null) return;

    useCase.updateStartDate(selectedDate);

    var timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: useCase.firing?.start?.hour ?? 0,
            minute: useCase.firing?.start?.minute ?? 0)
    );

    if (timeOfDay != null) {
      useCase.updateStartTime(timeOfDay);
    }
  }

  Widget _firingDuration() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
            "Firing duration:",
            style: TextStyles().mediumBoldStyle
        ),
        Consumer<ManageFiringUseCase>(
          builder: (context, useCase, _) {
            var durationSeconds = useCase.firing.durationSeconds;

            var hours = (durationSeconds / 3600).floor();
            var minutes = (durationSeconds / 60 % 60).floor();

            var hoursPicker = NumberPicker.integer(
              initialValue: hours,
              minValue: 0,
              maxValue: 24,
              onChanged: (num) {
                useCase.updateDuration(num, null);
              },
            );

            var minutesPicker = NumberPicker.integer(
              initialValue: minutes,
              minValue: 0,
              maxValue: 55,
              step: 5,
              onChanged: (num) {
                print(num);
                useCase.updateDuration(null, num);
              },
            );

            try {
              // hack around https://github.com/MarcinusX/NumberPicker/issues/26
              Future.delayed(Duration(milliseconds: 200), () {
                hoursPicker.animateInt(hours);
                minutesPicker.animateInt(minutes);
              });
            } catch (e) {}

            return Row(
              children: [
                hoursPicker,
                Text(
                  ":",
                  style: TextStyles().bigBoldStyle
                ),
                minutesPicker
              ]
            );
          },
        )
      ],
    );
  }


  Widget _cooldownDuration() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
              "Cooldown duration:",
              style: TextStyles().mediumBoldStyle
          ),
          Consumer<ManageFiringUseCase>(
            builder: (context, useCase, _) {
              var cooldownSeconds = useCase.firing.cooldownSeconds;

              var hours = (cooldownSeconds / 3600).floor();
              var minutes = (cooldownSeconds / 60 % 60).floor();

              var hoursPicker = NumberPicker.integer(
                initialValue: hours,
                minValue: 0,
                maxValue: 24,
                onChanged: (num) {
                  useCase.updateCooldown(num, null);
                },
              );

              var minutesPicker = NumberPicker.integer(
                initialValue: minutes,
                minValue: 0,
                maxValue: 55,
                step: 5,
                onChanged: (num) {
                  useCase.updateCooldown(null, num);
                },
              );

              try {
                // hack around https://github.com/MarcinusX/NumberPicker/issues/26
                Future.delayed(Duration(milliseconds: 200), () {
                  hoursPicker.animateInt(hours);
                  minutesPicker.animateInt(minutes);
                });
              } catch (e) {}

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  hoursPicker,
                  Text(
                      ":",
                      style: TextStyles().bigBoldStyle
                  ),
                  minutesPicker
                ]
              );
            },
          ),
        ],
      ),
    );
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

  Widget _type() {
    return Consumer<ManageFiringUseCase>(
      builder: (context, useCase, _) {
        return Row(
          children: [
            Text(
              "Type: ",
              style: TextStyles().mediumBoldStyle,
            ),
            Text("BISQUE"),
            Radio(
              value: "BISQUE",
              groupValue: useCase.firing.type,
              onChanged: useCase.updateType,
            ),
            Text("GLAZE"),
            Radio(
              value: "GLAZE",
              groupValue: useCase.firing.type,
              onChanged: useCase.updateType,
            )
          ]
        );
      },
    );
  }
}