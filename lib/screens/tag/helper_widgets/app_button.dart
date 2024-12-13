import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/value/app_color.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.title,
    required this.onTap,
    this.margin,
    super.key,
  });

  final String title;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(top: 20.h, bottom: 25.h, left: 33.w, right: 33.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: HexColor.fromHex('#00AFAA').withOpacity(0.8),
        borderRadius: BorderRadius.all(Radius.circular(30.h)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                : Colors.white.withOpacity(0.9),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(-5.w, -5.h),
          ),
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.75)
                : HexColor.fromHex('#D1D9E6'),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(5.w, 5.h),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('clickonAddtagButton'),
          borderRadius: BorderRadius.circular(30.h),
          splashColor: HexColor.fromHex('#00AFAA').withOpacity(0.8),
          onTap: onTap,
          child: Container(
            decoration: ConcaveDecoration(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.h)),
              depression: 10,
              colors: [
                Colors.white.withOpacity(0.8),
                HexColor.fromHex('#D1D9E6').withOpacity(0.8),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Center(
                child: AutoSizeText(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : Colors.white,
                  ),
                  maxLines: 1,
                  minFontSize: 8,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
