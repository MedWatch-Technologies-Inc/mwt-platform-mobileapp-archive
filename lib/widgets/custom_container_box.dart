import 'package:flutter/material.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBoxContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  const CustomBoxContainer({this.child, this.width, this.height, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex("#E5E5E5"),
        borderRadius: BorderRadius.all(Radius.circular(10.h)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex("#D1D9E6").withOpacity(0.1)
                : Colors.white.withOpacity(0.9),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(-4.w, -4.h),
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.8)
                : HexColor.fromHex("#9F2DBC").withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(4.w, 4.h),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.h)),
            gradient: Theme.of(context).brightness == Brightness.dark
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                        HexColor.fromHex("#CC0A00").withOpacity(0.15),
                        HexColor.fromHex("#9F2DBC").withOpacity(0.15),
                      ])
                : RadialGradient(colors: [
                    HexColor.fromHex("#FFDFDE").withOpacity(0.5),
                    HexColor.fromHex("#FFDFDE").withOpacity(0.0)
                  ], stops: [
                    0.6,
                    1
                  ])),
        child: Padding(
          padding: padding ?? EdgeInsets.all(12.h),
          child: child,
        ),
      ),
    );
  }
}
