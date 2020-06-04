import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/common/HttpRetryDialog.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/pages/DateTimeView.dart';
import 'package:seven_spot_mobile/usecases/ManageOpeningUseCase.dart';

class ManageOpeningPage extends StatefulWidget {
  ManageOpeningPage({Key key, this.openingId}) : super(key: key);

  final String openingId;

  @override
  State<StatefulWidget> createState() => _ManageOpeningPageState();
}

class _ManageOpeningPageState extends State<ManageOpeningPage> {
  TextEditingController _capacityTextController = new TextEditingController();
  TextEditingController _occurrencesTextController =
      new TextEditingController();

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
        Provider.of<ManageOpeningUseCase>(context, listen: false)
            .getOpening(widget.openingId);
      } catch (e) {
        HttpRetryDialog().retry(context, _setup, onDismiss: Navigator.of(context).pop);
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
            return FloatingActionButton.extended(
                onPressed: _save, icon: Icon(Icons.save), label: Text("Save"));
          }
        },
      ),
    );
  }

  _save() async {
    var response =
        await Provider.of<ManageOpeningUseCase>(context, listen: false).save();

    if (response == SaveResponse.SUCCESS) {
      Navigator.pop(context, true);
    } else if (response == SaveResponse.INVALID) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Invalid opening"),
              content: Text("Start must be before end"),
              actions: [
                FlatButton(
                  child: Text("Dismiss"),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            );
          });
    } else {
      HttpRetryDialog().retry(context, _save);
    }
  }

  Widget _body() {
    return Consumer<ManageOpeningUseCase>(builder: (context, useCase, _) {
      return Visibility(
          visible: !useCase.loading,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(height: 12.0),
                  _start(),
                  Container(height: 24.0),
                  _end(),
                  Container(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Capacity", style: TextStyles().bigRegularStyle),
                      Container(width: 64, child: _size()),
                    ],
                  ),
                  Container(height: 24.0),
                  _recurring(),
                ],
              ),
            ),
          ),
          replacement: Center(child: CircularProgressIndicator()));
    });
  }

  Widget _start() {
    return Consumer<ManageOpeningUseCase>(builder: (context, useCase, _) {
      return DateTimeView(
        title: "Start",
        onDateChanged: useCase.updateStartDate,
        onTimeChanged: useCase.updateStartTime,
        dateTime: useCase.opening.start,
        isValid: useCase.opening.start
                .difference(useCase.opening.end)
                .inMilliseconds <
            0,
      );
    });
  }

  Widget _end() {
    return Consumer<ManageOpeningUseCase>(builder: (context, useCase, _) {
      return DateTimeView(
        title: "End",
        onDateChanged: useCase.updateEndDate,
        onTimeChanged: useCase.updateEndTime,
        dateTime: useCase.opening.end,
        isValid: useCase.opening.start
                .difference(useCase.opening.end)
                .inMilliseconds <
            0,
      );
    });
  }

  Widget _size() {
    return Consumer<ManageOpeningUseCase>(builder: (context, useCase, _) {
      if (_capacityTextController.text != useCase.opening.size.toString()) {
        _capacityTextController.text = useCase.opening.size.toString();
      }

      _capacityTextController.selection = TextSelection.fromPosition(
          TextPosition(offset: _capacityTextController.text.length));

      return TextField(
        controller: _capacityTextController,
        decoration: new InputDecoration(
          labelText: null,
          isDense: true,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        // Only numbers can be entered
        onChanged: (input) {
          var capacity = num.tryParse(input) ?? 0;

          useCase.updateSize(capacity);
        },
      );
    });
  }

  Widget _recurring() {
    if (!_isNewOpening) {
      return SizedBox.shrink();
    }

    return Column(
      children: <Widget>[
        Consumer<ManageOpeningUseCase>(builder: (context, useCase, _) {
          return FlatButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () =>
                useCase.updateRecurring(!useCase.opening.recurring),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Recurring", style: TextStyles().bigRegularStyle),
                      Text(
                          "Creates additional openings with the same details based on the pattern chosen.",
                          style: TextStyles().smallRegularStyle)
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Checkbox(
                      value: useCase.opening.recurring,
                      onChanged: useCase.updateRecurring),
                )
              ],
            ),
          );
        }),
        Container(height: 12.0),
        Consumer<ManageOpeningUseCase>(
          builder: (context, useCase, _) {
            return Visibility(
              visible: useCase.opening.recurring,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("Recurrence pattern",
                          style: TextStyles().bigRegularStyle),
                    ],
                  ),
                  _recurrencePattern(),
                  _numberOfOccurrences()
                ],
              ),
            );
          },
        ),
        Container(height: 200.0),
      ],
    );
  }

  Widget _recurrencePattern() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        return Wrap(
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.end,
          direction: Axis.horizontal,
          children: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Every day"),
                    Radio(
                      value: "DAILY",
                      groupValue: useCase.opening.recurrenceType,
                      onChanged: useCase.updateRecurrenceType,
                    ),
                  ],
                ),
              ),
              onTap: () => useCase.updateRecurrenceType("DAILY"),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Every ${DateFormatter().EEEE.format(useCase.opening.start)}"),
                    Radio(
                      value: "WEEKLY",
                      groupValue: useCase.opening.recurrenceType,
                      onChanged: useCase.updateRecurrenceType,
                    ),
                  ],
                ),
              ),
              onTap: () => useCase.updateRecurrenceType("WEEKLY"),
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        "Monthly on the ${DateFormatter().dd.format(useCase.opening.start)}"),
                    Radio(
                      value: "MONTHLY",
                      groupValue: useCase.opening.recurrenceType,
                      onChanged: useCase.updateRecurrenceType,
                    ),
                  ],
                ),
              ),
              onTap: () => useCase.updateRecurrenceType("MONTHLY"),
            ),
          ],
        );
      },
    );
  }

  Widget _numberOfOccurrences() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Number of occurrences", style: TextStyles().bigRegularStyle),
        Container(
            width: 64,
            child:
                Consumer<ManageOpeningUseCase>(builder: (context, useCase, _) {
              if (_occurrencesTextController.text !=
                  useCase.opening.numberOfOccurrences.toString()) {
                _occurrencesTextController.text =
                    useCase.opening.numberOfOccurrences.toString();
              }

              _occurrencesTextController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _occurrencesTextController.text.length));

              return TextField(
                controller: _occurrencesTextController,
                decoration: new InputDecoration(
                  labelText: null,
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                // Only numbers can be entered
                onChanged: (input) {
                  var occurrences = num.tryParse(input) ?? 0;

                  useCase.updateNumberOfOccurrences(occurrences);
                },
              );
            })),
      ],
    );
  }
}
