import 'package:flutter/material.dart';

class CustomDecoration extends Decoration{
  final ShapeBorder shape;
  final Color outerColor;

  CustomDecoration({required this.shape,required this.outerColor});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomDecorationPainter(shape: shape,outerColor: outerColor);
  }
}

class _CustomDecorationPainter extends BoxPainter {
  final ShapeBorder shape;
  final Color outerColor;
  _CustomDecorationPainter({required this.shape,required this.outerColor});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & (configuration.size ?? Size.zero);
    final shapePath = shape.getOuterPath(rect);

    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(rect.inflate(2.0 * 0.5))
      ..addPath(shapePath, Offset.zero);
    canvas.save();
    canvas.clipPath(shapePath);

    var paint = Paint()
      ..color = outerColor
      ..maskFilter = MaskFilter.blur(BlurStyle.outer, 2.0);

    canvas.save();
    canvas.drawPath(path, paint);
    canvas.restore();

    canvas.restore();
  }

}