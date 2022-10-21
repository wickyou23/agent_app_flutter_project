import 'package:flutter/material.dart';

extension TextExt on Text {
  Size get textSize {
    final textPainter = TextPainter(
      text: TextSpan(text: data, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }

  Size getTextSize(double width) {
    final textPainter = TextPainter(
      text: TextSpan(text: data, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: width);
    return textPainter.size;
  }
}
