import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

class ConcaveDecoration extends Decoration {
  final ShapeBorder shape;
  final double depression;
  final List<Color>? colors;

  ConcaveDecoration({
    required this.shape,
    required this.depression,
    this.colors,
  })  : assert(depression >= 0),
        assert(colors == null || colors.length == 2);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ConcaveDecorationPainter(shape, depression, colors);
  }

  @override
  EdgeInsetsGeometry get padding => shape.dimensions;
}

class _ConcaveDecorationPainter extends BoxPainter {
  ShapeBorder shape;
  double depression;
  List<Color>? colors;

  _ConcaveDecorationPainter(this.shape, this.depression, this.colors) {
    colors ??= [Colors.black87, Colors.white];
  }

  @override
  void paint(ui.Canvas canvas, ui.Offset offset, ImageConfiguration configuration) {
    final rect = offset & (configuration.size ?? Size.zero);
    final shapePath = shape.getOuterPath(rect);

    final delta = 10 / rect.longestSide;
    final stops = [0.5 - delta, 0.5 + delta];

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(depression * 2))
      ..addPath(shapePath, Offset.zero);
    canvas.save();
    canvas.clipPath(shapePath);

    final paint = Paint()..maskFilter = MaskFilter.blur(BlurStyle.normal, depression);
    final clipSize = rect.size.aspectRatio > 1
        ? Size(rect.width + 5, (rect.height / 2) + 5)
        : Size((rect.width / 2) + 5, rect.height + 5);
    for (final alignment in [Alignment.topLeft, Alignment.bottomRight]) {
      final shaderRect = alignment.inscribe(Size.square(rect.longestSide), rect);
      paint
        ..shader =
        ui.Gradient.linear(shaderRect.topLeft, shaderRect.bottomRight, [Colors.transparent,Colors.transparent], stops);

      canvas.save();
      canvas.clipRect(alignment.inscribe(clipSize, rect));
      canvas.drawPath(path, paint);
      canvas.restore();
    }
    canvas.restore();
  }
}
