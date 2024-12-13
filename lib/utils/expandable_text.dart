import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int? trimLines;
  final Function? callback;

  const ExpandableText(
    this.text, {
    Key? key,
    this.trimLines = 2,
    this.callback,
  }) : super(key: key);

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    if(widget.callback != null) {
      widget.callback!();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextSpan link = TextSpan(
      children: [
        TextSpan(
          text: ' ... ',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex("#384341"),
            fontSize: 12,
          )
        ),
        TextSpan(
            text: "${stringLocalization.getText(StringLocalization.readMore)}",
            style: TextStyle(
              color:HexColor.fromHex("#00AFAA"),
              fontSize: 12,
            ),
            recognizer: TapGestureRecognizer()..onTap = _onTapLink
        ),
      ],

    );
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,//better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset)??0;
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.text.substring(0, endIndex)
                : widget.text,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.87)
                    : HexColor.fromHex("#384341"),
                fontSize: 12,
                height: 1.5,
                letterSpacing: 0.2
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}