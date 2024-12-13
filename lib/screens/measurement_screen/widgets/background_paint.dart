
import 'package:flutter/material.dart';

class BackgroundPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    final paint = Paint();

    var mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Colors.grey.withOpacity(0.2);
    paint.strokeWidth = 0.2;

    final heightLine = 10;
    final widthLine = 10;

    for (var i = 1; i < height; i++) {
      if (i % heightLine == 0) {
        var linePath = Path();
        linePath
            .addRect(Rect.fromLTRB(0, i.toDouble(), width, (i + 2).toDouble()));
        canvas.drawPath(linePath, paint);
      }
    }
    for (var i = 1; i < width; i++) {
      if (i % widthLine == 0) {
        var linePath = Path();
        linePath.addRect(
            Rect.fromLTRB(i.toDouble(), 0, (i + 2).toDouble(), height));
        canvas.drawPath(linePath, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}