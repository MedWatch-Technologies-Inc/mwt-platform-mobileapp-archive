import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';

class RaisedBtn extends StatelessWidget {
  final GestureTapCallback? onPressed;
  final String text;
  final double? elevation;
  final double? radius;
  final Color? textColor;

  RaisedBtn({this.onPressed, required this.text, this.elevation, this.textColor, this.radius});

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: elevation ?? 8.0,
        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
        backgroundColor: AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 12.0)),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class FlatBtn extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final Color? color;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double radius;

  FlatBtn({
    required this.onPressed,
    required this.text,
    this.color,
    this.backgroundColor,
    this.padding,
    this.radius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.width, height: Constants.height, allowFontScaling: true);

    if (color != null) {
      return GestureDetector(
        onTap: onPressed,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          color: backgroundColor,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: Text(
              text,
              style: TextStyle(
                color: color,
              ),
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Text(text),
      ),
    );
  }
}

class BorderBtn extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final Widget? child;
  final Color? color;

  BorderBtn({required this.onPressed, required this.text, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    //ScreenUtil.init(context, width: Constants.width, height: Constants.height, allowFontScaling: true);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: color ?? AppColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
      ),
      onPressed: onPressed,
      child: child ?? Text(text),
    );
  }
}

class BorderedBtn extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final double? elevation;
  final Color? textColor;

  BorderedBtn({required this.onPressed, required this.text, this.elevation, this.textColor});

  @override
  Widget build(BuildContext context) {
    //ScreenUtil.init(context, width: Constants.width, height: Constants.height, allowFontScaling: true);
    return Padding(
      padding: EdgeInsets.all(12.h),
      child: GestureDetector(
        onTap: onPressed,
        child: Card(
          color: AppColor.white,
          elevation: elevation ?? 8.h,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: textColor ?? AppColor.trans),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? AppColor.white,
            ),
          ),
        ),
      ),
    );
  }
}

class MaterialBtn extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String text;
  final Color color;
  final Color? textColor;
  final double? padding;

  MaterialBtn(
      {required this.onPressed,
      required this.text,
      required this.color,
      this.padding,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      textColor: textColor,
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0.0),
        child: Text(text),
      ),
      color: color,
    );
  }
}
