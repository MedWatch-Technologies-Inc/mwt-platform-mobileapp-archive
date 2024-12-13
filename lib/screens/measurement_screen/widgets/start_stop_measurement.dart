import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_gauge/screens/measurement_screen/cards/progress_card.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartStopMeasurement extends StatelessWidget {
  final GestureTapCallback onPressed;
  final DateTime lastStartTime;
  final ValueNotifier<bool> isMeasuring;
  final ValueNotifier<Timer?> timer;
  final bool enabled;

  const StartStopMeasurement({
    required this.onPressed,
    required this.lastStartTime,
    required this.isMeasuring,
    required this.timer,
    this.enabled = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
      padding: EdgeInsets.only(left: 20.w,top: 10.h, bottom: 23.h),
      child: GestureDetector(
        key: Key('clickOnStartMeasurementButton'),
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.h),
            color: isDarkMode(context)
                ? HexColor.fromHex('#00AFAA').withOpacity(enabled ? 0.9 : 0.5)
                : HexColor.fromHex('#00AFAA').withOpacity(enabled ? 0.7 : 0.3),
            boxShadow: [
              BoxShadow(
                color: isDarkMode(context)
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white,
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(-5.w, -5.h),
              ),
              BoxShadow(
                color: isDarkMode(context)
                    ? Colors.black.withOpacity(0.75)
                    : HexColor.fromHex('#D1D9E6'),
                blurRadius: 5,
                spreadRadius: 0,
                offset: Offset(5.w, 5.h),
              ),
            ],
          ),
          child: Container(
            decoration: ConcaveDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.h),
              ),
              depression: 8,
              colors: [
                Colors.transparent,
                Colors.transparent,
              ],
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: ValueListenableBuilder(
                  valueListenable: isMeasuring,
                  builder: (context, value, child) {
                    return ValueListenableBuilder(
                      valueListenable: timer,
                      builder: (context, value, child) {
                        return TitleText(
                          text: (timer.value?.isActive ?? false)
                              ? StringLocalization.of(context)
                                  .getText(StringLocalization.stopMeasurement)
                                  .toUpperCase()
                              : StringLocalization.of(context)
                                  .getText(StringLocalization.startMeasurement)
                                  .toUpperCase(),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode(context)
                              ? HexColor.fromHex('#111B1A')
                              : Colors.white,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        onTap: enabled ? onPressed : null,
      ),
    );
  }
}
