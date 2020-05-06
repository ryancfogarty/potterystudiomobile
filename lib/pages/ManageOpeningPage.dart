import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seven_spot_mobile/pages/DateTimeView.dart';
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
  TextEditingController _capacityTextController = new TextEditingController();

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
    var response = await Provider.of<ManageOpeningUseCase>(context, listen: false).save();

    if (response == SaveResponse.SUCCESS) {
      Navigator.pop(context, true);
    } else if (response == SaveResponse.INVALID) {
      var dialogDisplayer = defaultTargetPlatform == TargetPlatform.android ? showDialog : showCupertinoDialog;

      dialogDisplayer(
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
          }
      );
    }
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
                Container(height: 12.0),
                _start(),
                Container(height: 24.0),
                _end(),
                Container(height: 24.0),
                _size()
              ],
            ),
          ),
          replacement: Center(child: CircularProgressIndicator())
        );
      }
    );
  }

  Widget _start() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        return DateTimeView(
          title: "Start:",
          onDateChanged: useCase.updateStartDate,
          onTimeChanged: useCase.updateStartTime,
          dateTime: useCase.opening.start,
          isValid: useCase.opening.start.difference(useCase.opening.end).inMilliseconds < 0,
        );
      }
    );
  }

  Widget _end() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        return DateTimeView(
          title: "End:",
          onDateChanged: useCase.updateEndDate,
          onTimeChanged: useCase.updateEndTime,
          dateTime: useCase.opening.end,
          isValid: useCase.opening.start.difference(useCase.opening.end).inMilliseconds < 0,
        );
      }
    );
  }

  Widget _size() {
    return Consumer<ManageOpeningUseCase>(
      builder: (context, useCase, _) {
        if (_capacityTextController.text != useCase.opening.size.toString()) {
          _capacityTextController.text = useCase.opening.size.toString();
        }

        _capacityTextController.selection = TextSelection.fromPosition(
            TextPosition(offset: _capacityTextController.text.length));

        return TextField(
          controller: _capacityTextController,
          decoration: new InputDecoration(labelText: "Capacity"),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly
          ], // Only numbers can be entered
          onChanged: (input) {
            var capacity = num.tryParse(input) ?? 0;

            useCase.updateSize(capacity);
          },
        );
      }
    );
  }
}