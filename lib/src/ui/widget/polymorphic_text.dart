import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PolymorphicText extends StatefulWidget {
  final String text;
  final String textExpand;
  final String textCollapse;
  final TextDirection? textDirection;
  final int? maxLinesExpand;
  final int? maxLinesCollapse;
  final TextStyle? style;
  final TextStyle? styleExpand;
  final TextStyle? styleCollapse;

  const PolymorphicText({
    super.key,
    required this.text,
    required this.textExpand,
    required this.textCollapse,
    this.textDirection,
    this.maxLinesExpand,
    this.maxLinesCollapse,
    this.style,
    this.styleExpand,
    this.styleCollapse,
  });

  @override
  State<StatefulWidget> createState() => _PolymorphicTextState();
}

class _PolymorphicTextState extends State<PolymorphicText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    TextStyle? style = widget.style;
    if (style == null || style.inherit) {
      style = DefaultTextStyle.of(context).style.merge(style);
    }
    if (MediaQuery.boldTextOf(context)) {
      style = style.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = widget.textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr;
    final textSpan = TextSpan(text: widget.text, style: style);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (_expanded) {
          final collapseTextSpan = TextSpan(
            text: widget.textCollapse,
            style: widget.styleCollapse,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                setState(() => _expanded = false);
              },
          );
          if (widget.maxLinesExpand != null) {
            final textPainter = TextPainter(
              text: textSpan,
              textScaler: textScaler,
              textDirection: textDirection,
              maxLines: widget.maxLinesExpand,
            )..layout(maxWidth: constraints.maxWidth);
            if (textPainter.didExceedMaxLines) {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: textPainter.height,
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Text.rich(
                    TextSpan(children: [
                      textSpan,
                      collapseTextSpan,
                    ]),
                    textScaler: textScaler,
                    textDirection: textDirection,
                  ),
                ),
              );
            }
          }
          return Text.rich(
            TextSpan(children: [
              textSpan,
              collapseTextSpan,
            ]),
            textScaler: textScaler,
            textDirection: textDirection,
          );
        } else {
          final textPainter = TextPainter(
            text: textSpan,
            textScaler: textScaler,
            textDirection: textDirection,
            maxLines: widget.maxLinesCollapse,
          )..layout(maxWidth: constraints.maxWidth);
          if (textPainter.didExceedMaxLines) {
            final ellipsisTextSpan = TextSpan(text: "...", style: style);
            final expandTextSpan = TextSpan(
              text: widget.textExpand,
              style: widget.styleExpand,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() => _expanded = true);
                },
            );
            final lines = textPainter.computeLineMetrics();
            int endOffset = textPainter.getPositionForOffset(Offset(lines.last.width, lines.last.baseline)).offset;
            while (endOffset > 0) {
              final testPainter = TextPainter(
                text: TextSpan(
                  children: [
                    TextSpan(text: widget.text.substring(0, endOffset), style: style),
                    ellipsisTextSpan,
                    expandTextSpan,
                  ],
                ),
                textScaler: textScaler,
                textDirection: textDirection,
                maxLines: widget.maxLinesCollapse,
              );
              try {
                testPainter.layout(maxWidth: constraints.maxWidth);
                if (testPainter.didExceedMaxLines) {
                  endOffset--;
                } else {
                  break;
                }
              } finally {
                testPainter.dispose();
              }
            }
            return Text.rich(
              TextSpan(children: [
                TextSpan(text: widget.text.substring(0, endOffset), style: style),
                ellipsisTextSpan,
                expandTextSpan,
              ]),
              textScaler: textScaler,
              textDirection: textDirection,
            );
          } else {
            return Text.rich(
              textSpan,
              textScaler: textScaler,
              textDirection: textDirection,
            );
          }
        }
      },
    );
  }
}
