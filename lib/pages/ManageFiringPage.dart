import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pottery_studio/common/HttpRetryDialog.dart';
import 'package:pottery_studio/common/TextStyles.dart';
import 'package:pottery_studio/pages/DateTimeView.dart';
import 'package:pottery_studio/usecases/ManageFiringUseCase.dart';
import 'package:pottery_studio/views/DurationPicker.dart';

class ManageFiringPage extends StatefulWidget {
  ManageFiringPage({Key key, this.firingId}) : super(key: key);

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
        Provider.of<ManageFiringUseCase>(context, listen: false)
            .getFiring(widget.firingId);
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
      floatingActionButton: Consumer<ManageFiringUseCase>(
        builder: (context, useCase, _) {
          if (useCase.saving) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            );
          } else {
            return FloatingActionButton.extended(
                onPressed: _save, icon: Icon(Icons.save), label: Text("Save"));
          }
        },
      ),
    );
  }

  _save() async {
    try {
      await Provider.of<ManageFiringUseCase>(context, listen: false).save();
      Navigator.pop(context, true);
    } catch (e) {
      HttpRetryDialog().retry(context, _save);
    }
  }

  Widget _body() {
    return Consumer<ManageFiringUseCase>(builder: (context, useCase, _) {
      return Visibility(
        visible: useCase.loading,
        child: Center(child: CircularProgressIndicator()),
        replacement: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(height: 12.0),
                _start(),
                Container(height: 24.0),
                _firingDuration(),
                Container(height: 24.0),
                _cooldownDuration(),
                Container(height: 24.0),
                _type(),
                Container(height: 100.0),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _start() {
    return Consumer<ManageFiringUseCase>(
      builder: (context, useCase, _) {
        return DateTimeView(
          title: "Start",
          onDateChanged: useCase.updateStartDate,
          onTimeChanged: useCase.updateStartTime,
          dateTime: useCase.firing.start,
          isValid: true,
        );
      },
    );
  }

  Widget _firingDuration() {
    return Consumer<ManageFiringUseCase>(
      builder: (context, useCase, _) {
        var hours = (useCase.firing.durationSeconds / 3600).floor();
        var minutes = (useCase.firing.durationSeconds / 60 % 60).floor();

        return DurationPicker(
          title: "Firing duration",
          hours: hours,
          minutes: minutes,
          onHoursChanged: (newHours) =>
              useCase.updateDuration(newHours, minutes),
          onMinutesChanged: (newMinutes) =>
              useCase.updateDuration(hours, newMinutes % 60),
        );
      },
    );
  }

  Widget _cooldownDuration() {
    return Consumer<ManageFiringUseCase>(
      builder: (context, useCase, _) {
        var hours = (useCase.firing.cooldownSeconds / 3600).floor();
        var minutes = (useCase.firing.cooldownSeconds / 60 % 60).floor();

        return DurationPicker(
          title: "Cooldown duration",
          hours: hours,
          minutes: minutes,
          onHoursChanged: (newHours) =>
              useCase.updateCooldown(newHours, minutes),
          onMinutesChanged: (newMinutes) =>
              useCase.updateCooldown(hours, newMinutes % 60),
        );
      },
    );
  }

  Widget _type() {
    return Consumer<ManageFiringUseCase>(
      builder: (context, useCase, _) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Type",
                style: TextStyles().bigRegularStyle,
              ),
              Row(
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        children: [
                          Text("Bisque"),
                          Radio(
                            value: "BISQUE",
                            groupValue: useCase.firing.type,
                            onChanged: useCase.updateType,
                          ),
                        ],
                      ),
                    ),
                    onTap: () => useCase.updateType("BISQUE"),
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Row(
                        children: [
                          Text("Glaze"),
                          Radio(
                            value: "GLAZE",
                            groupValue: useCase.firing.type,
                            onChanged: useCase.updateType,
                          ),
                        ],
                      ),
                    ),
                    onTap: () => useCase.updateType("GLAZE"),
                  ),
                ],
              )
            ]);
      },
    );
  }
}
