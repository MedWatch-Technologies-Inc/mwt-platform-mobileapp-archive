import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';

class CustomContainerBox extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  const CustomContainerBox(
      {this.height, this.width, this.child, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      // width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : Colors.white.withOpacity(0.7),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(-4, -4),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.75)
                  : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(4, 4),
            ),
          ]),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
