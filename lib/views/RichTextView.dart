import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pottery_studio/common/TextStyles.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: new TapGestureRecognizer()
              ..onTap = () => launcher.launch(url));
}

class RichTextView extends StatelessWidget {
  final String text;
  final TextStyle style;

  RichTextView(
      {@required this.text, this.style = TextStyles.mediumRegularStyle});

  bool _isLink(String input) {
    final matcher = new RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    final spaceSplit = text.split(" ");
    List<TextSpan> span = [];
    spaceSplit.forEach((word) {
      final lineSplit = word.split("\n");

      print(word);
      print(lineSplit);

      if (lineSplit.length > 1) {
        lineSplit.forEach((lineSplitWord) {
          span.add(_isLink(lineSplitWord)
              ? new LinkTextSpan(
                  text: "$lineSplitWord\n",
                  url: lineSplitWord,
                  style: style.copyWith(color: Colors.blue))
              : new TextSpan(text: "$lineSplitWord\n", style: style));
        });
      }

      span.add(_isLink(word)
          ? new LinkTextSpan(
              text: "$word ",
              url: word,
              style: style.copyWith(color: Colors.blue))
          : new TextSpan(text: "$word ", style: style));
    });
    if (span.length > 0) {
      return new RichText(
        text: new TextSpan(text: "", children: span),
      );
    } else {
      return Container();
    }
  }
}
