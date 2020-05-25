import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seven_spot_mobile/common/DateFormatter.dart';
import 'package:seven_spot_mobile/common/FiringTypeFormatter.dart';
import 'package:seven_spot_mobile/common/TextStyles.dart';
import 'package:seven_spot_mobile/models/Firing.dart';
import 'package:seven_spot_mobile/pages/FiringPage.dart';

class FiringCard extends StatefulWidget {
  final Firing firing;
  final Function promptRefresh;

  FiringCard({Key key, this.firing, this.promptRefresh}) : super(key: key);

  @override
  _FiringCardState createState() => _FiringCardState();
}

class _FiringCardState extends State<FiringCard> {
  @override
  Widget build(BuildContext context) {
    var firing = widget.firing;

    return Card(
      elevation: 2.0,
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          var shouldRefreshList = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => FiringPage(firingId: firing.id)));

          if (shouldRefreshList == true && widget.promptRefresh != null) {
            widget.promptRefresh();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      DateFormatter()
                          .formatDateTimeRange(firing.start, firing.end),
                      style: TextStyles().mediumRegularStyle),
                  Text(
                      "Done cooling down: ${DateFormatter().dd_MMMM.format(firing.cooldownEnd)} ${DateFormatter().HH_mm.format(firing.cooldownEnd)}",
                      style: TextStyles().mediumRegularStyle),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(FiringTypeFormatter().format(firing.type),
                  style: TextStyles().mediumBoldStyle),
            ),
          ],
        ),
      ),
    );
  }
}
