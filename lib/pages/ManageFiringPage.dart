import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/pages/DateTimeView.dart';
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

  var hours = "";
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, _setup);
  }

  void _setup() async {
    Provider.of<ManageFiringUseCase>(context, listen: false).clear();

    if (!_isNewFiring) {
      try {
        Provider.of<ManageFiringUseCase>(context, listen: false).getFiring(widget.firingId);
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

  Widget _aaaa() {
    return TextField(
      decoration: new InputDecoration(labelText: "HH"),
      keyboardType: TextInputType.number,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.length == 3) {
            return newValue.copyWith(
              text: newValue.text.substring(1, 3),
              selection: TextSelection.fromPosition(TextPosition(offset: 2))
            );
          }

          return newValue;
        })
      ],
      onChanged: (text) {
        print(text);
      },
    );
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
                    _aaaa()
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
        return DateTimeView(
          title: "Start:",
          onDateChanged: useCase.updateStartDate,
          onTimeChanged: useCase.updateStartTime,
          dateTime: useCase.firing.start,
          isValid: true,
        );
      },
    );
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Type: ",
              style: TextStyles().mediumBoldStyle,
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
          ]
        );
      },
    );
  }
}