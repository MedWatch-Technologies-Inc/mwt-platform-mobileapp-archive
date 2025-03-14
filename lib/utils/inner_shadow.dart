import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InnerShadow extends SingleChildRenderObjectWidget {
  final double blur;
  final Color color;
  final Offset offset;

  const InnerShadow({
    Key? key,
    this.blur = 10,
    this.color = Colors.black38,
    this.offset = const Offset(10, 10),
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final _RenderInnerShadow renderObject = _RenderInnerShadow();
    updateRenderObject(context, renderObject);
    return renderObject;
  }

  @override
  void updateRenderObject(BuildContext context, _RenderInnerShadow renderObject) {
    renderObject
      ..color = color
      ..blur = blur
      ..dx = offset.dx
      ..dy = offset.dy;
  }
}

class _RenderInnerShadow extends RenderProxyBox {
  late double blur;
  late Color color;
  late double dx;
  late double dy;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) {
      return;
    } else {
      final Rect rectOuter = offset & size;
      final Rect rectInner = Rect.fromLTWH(
        offset.dx,
        offset.dy,
        size.width - dx,
        size.height - dy,
      );
      final Canvas canvas = context.canvas..saveLayer(rectOuter, Paint());
      context.paintChild(child!, offset);
      final Paint shadowPaint = Paint()
        ..blendMode = BlendMode.srcATop
        ..imageFilter = ImageFilter.blur(sigmaX: blur, sigmaY: blur)
        ..colorFilter = ColorFilter.mode(color, BlendMode.srcOut);

      canvas
        ..saveLayer(rectOuter, shadowPaint)
        ..saveLayer(rectInner, Paint())
        ..translate(dx, dy);
      context.paintChild(child!, offset);
      context.canvas..restore()..restore()..restore();
    }
  }
}