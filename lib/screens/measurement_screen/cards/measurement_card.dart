import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class MeasurementCard extends StatelessWidget {
  final hr;
  final bp;
  final hrv;
  final double mAIDbp;
  final double mAISbp;

  const MeasurementCard({
    required this.mAIDbp,
    required this.mAISbp,
    required this.hr,
    required this.bp,
    required this.hrv,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 18.h),
      width: 265.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Container(
              height: 61.h,
              width: 90.w,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.darkBackgroundColor
                    : HexColor.fromHex('#E5E5E5'),
                borderRadius: BorderRadius.all(Radius.circular(10.h)),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white.withOpacity(0.9),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(-4.w, -4.h),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.8)
                        : HexColor.fromHex('#9F2DBC').withOpacity(0.2),
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
                                HexColor.fromHex('#CC0A00').withOpacity(0.15),
                                HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                              ])
                        : RadialGradient(colors: [
                            HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                            HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                          ], stops: [
                            0.4,
                            1
                          ])),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 6.h),
                    SizedBox(
                      height: 25.h,
                      child: Body1AutoText(
                        text: '$hr',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        minFontSize: 12,
                        align: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: SizedBox(
                        height: 19.h,
                        child: Body1AutoText(
                          align: TextAlign.center,
                          maxLine: 1,
                          text: StringLocalization.of(context).getText(StringLocalization.hrBPM),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                              : HexColor.fromHex('#5D6A68'),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Container(
                height: 61.h,
                width: 90.w,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : HexColor.fromHex('#E5E5E5'),
                    borderRadius: BorderRadius.all(Radius.circular(10.h)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white.withOpacity(0.9),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(-4, -4),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.8)
                            : HexColor.fromHex('#9F2DBC').withOpacity(0.2),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(4, 4),
                      ),
                    ]),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.h)),
                      color: Colors.white,
                      gradient: Theme.of(context).brightness == Brightness.dark
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                  HexColor.fromHex('#CC0A00').withOpacity(0.15),
                                  HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                ])
                          : RadialGradient(colors: [
                              HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                              HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                            ], stops: [
                              0.4,
                              1
                            ])),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 6.h,
                      ),
                      SizedBox(
                        height: 25.h,
                        child: Body1AutoText(
                          text: isTflSelected.value || isAISelected.value
                              ? '${mAISbp.toInt() > mAIDbp.toInt() ? mAISbp.toInt() : mAIDbp.toInt()} / ${mAISbp.toInt() < mAIDbp.toInt() ? mAISbp.toInt() : mAIDbp.toInt()}'
                              : '$bp',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          align: TextAlign.center,
                          minFontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: SizedBox(
                          height: 19.h,
                          child: Body1AutoText(
                            align: TextAlign.center,
                            maxLine: 1,
                            text: StringLocalization.of(context).getText(StringLocalization.bpMmHg),
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                : HexColor.fromHex('#5D6A68'),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Container(
              height: 61.h,
              width: 90.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.h)),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E5E5E5'),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                          : Colors.white.withOpacity(0.9),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(-4.w, -4.h),
                    ),
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : HexColor.fromHex('#9F2DBC').withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: Offset(4.w, 4.h),
                    ),
                  ]),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                    gradient: Theme.of(context).brightness == Brightness.dark
                        ? LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                                HexColor.fromHex('#CC0A00').withOpacity(0.15),
                                HexColor.fromHex('#9F2DBC').withOpacity(0.15)
                              ])
                        : RadialGradient(colors: [
                            HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                            HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                          ], stops: [
                            0.4,
                            1
                          ])),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 6.h,
                    ),
                    SizedBox(
                      height: 25.h,
                      child: Body1AutoText(
                        text: '$hrv',
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        align: TextAlign.center,
                        minFontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Padding(
                      padding: EdgeInsets.only(left: 2.w),
                      child: SizedBox(
                        height: 19.h,
                        child: Body1AutoText(
                          align: TextAlign.center,
                          maxLine: 1,
                          text: StringLocalization.of(context).getText(StringLocalization.hrv),
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                              : HexColor.fromHex('#5D6A68'),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
