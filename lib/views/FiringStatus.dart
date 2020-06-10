import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:pottery_studio/common/DateFormatter.dart';
import 'package:pottery_studio/common/TextStyles.dart';
import 'package:pottery_studio/models/Firing.dart';

class FiringStatus extends StatefulWidget {
  final Firing firing;

  FiringStatus({Key key, this.firing}) : super(key: key);

  @override
  _FiringStatusState createState() => _FiringStatusState();
}

class _FiringStatusState extends State<FiringStatus> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _row("Start", widget.firing.start),
        Divider(height: 16.0, thickness: 1.0, color: Colors.black12),
        _row("End", widget.firing.end),
        Divider(height: 16.0, thickness: 1.0, color: Colors.black12),
        _row("Cooled down", widget.firing.cooldownEnd)
      ],
    );
  }

  Widget _row(String title, DateTime dateTime) {
    var done = dateTime.difference(DateTime.now()).inMilliseconds <= 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("$title", style: TextStyles.bigRegularStyle),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                          DateFormatter().dd_MMMM_HH_mm.format(dateTime),
                          style: TextStyles.bigRegularStyle),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Visibility(
                          visible: DateTime.now()
                                  .difference(dateTime)
                                  .inMilliseconds <=
                              0,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CountdownTimer(
                              daysSymbol:
                                  dateTime.difference(DateTime.now()).inDays >= 2
                                      ? " days, "
                                      : " day, ",
                              endTime: dateTime.millisecondsSinceEpoch,
                              textStyle: TextStyles.bigRegularStyle,
                              onEnd: () => Future.delayed(
                                  Duration(seconds: 1), () => setState(() {})),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Icon(done ? Icons.check : Icons.timelapse,
            color: done ? Colors.green : Colors.orange)
      ],
    );
  }
}
