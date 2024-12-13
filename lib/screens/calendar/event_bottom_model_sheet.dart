import 'package:flutter/material.dart';

import 'package:health_gauge/utils/concave_decoration.dart';

import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

Widget buttons(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 33.w),
    child: Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.h),
                    color: HexColor.fromHex('#FF6259').withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(-5, -5),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#D1D9E6'),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(5, 5),
                      ),
                    ]),
                child: Container(
                  decoration: ConcaveDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      depression: 10,
                      colors: [
                        Colors.white,
                        HexColor.fromHex('#D1D9E6'),
                      ]),
                  child: Center(
                    child: Text(
                      stringLocalization
                          .getText(StringLocalization.cancel)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {}),
        ),
        SizedBox(width: 17.w),
        Expanded(
          child: GestureDetector(
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.h),
                    color: HexColor.fromHex('#00AFAA'),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white,
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(-5, -5),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#D1D9E6'),
                        blurRadius: 5,
                        spreadRadius: 0,
                        offset: Offset(5, 5),
                      ),
                    ]),
                child: Container(
                  decoration: ConcaveDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      depression: 10,
                      colors: [
                        Colors.white,
                        HexColor.fromHex('#D1D9E6'),
                      ]),
                  child: Center(
                    child: Text(
                      stringLocalization
                          .getText(StringLocalization.save)
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {}),
        ),
      ],
    ),
  );
}
