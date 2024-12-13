
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';

class MeasurementContainer extends StatelessWidget {
  final String title;
  MeasurementContainer(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
      height: 171.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : HexColor.fromHex('#FFFFFF'),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(-4, -4),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#000000').withOpacity(0.75)
                  : HexColor.fromHex('#D1D9E6'),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(4, 4),
            ),
          ]),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384143'))),
          SizedBox(height: 40.h),
          Text('0',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384143')))
        ],
      ),
    );
  }
}