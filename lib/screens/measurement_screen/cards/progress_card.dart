import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/count_down_circle.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/measuring_text.dart';
import 'package:health_gauge/services/logging/logging_service.dart';

import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class ProgressCard extends StatefulWidget {
  final DeviceModel? connectedDevice;
  final ValueNotifier<Timer?> timer;
  final ValueNotifier<bool> isAISelected;
  final ValueNotifier<bool> isLeadOff;
  final ValueNotifier<bool> isMeasuring;
  final ValueNotifier<bool> poorConductivityNotifier;
  final DateTime lastRecordedDateForEcg;
  final int leadOffCount;
  final MeasurementHistoryModel? measurementHistoryModel;
  Function callAPIAfter30Seconds;

  final ecgPointList;

  ProgressCard(
    this.callAPIAfter30Seconds, {
    required this.timer,
    required this.connectedDevice,
    required this.isAISelected,
    required this.isLeadOff,
    required this.isMeasuring,
    required this.poorConductivityNotifier,
    required this.lastRecordedDateForEcg,
    required this.leadOffCount,
    required this.measurementHistoryModel,
    required this.ecgPointList,
    Key? key,
  }) : super(key: key);

  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  late int leadOffCount;

  @override
  void initState() {
    leadOffCount = widget.leadOffCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.timer,
        builder: (context, Timer? timerValue, child) {
          var progressColor = HexColor.fromHex('#62CBC9');
          var countDown = 0;
          var limit = 30;
          try {
            if (widget.connectedDevice?.sdkType == Constants.e66) {
              // limit = 60;
              // limit = 30;
              limit = measurementTime.value;
            }
            if ((timerValue?.tick ?? 0) <= limit) {
              countDown = timerValue?.tick ?? 0;
            } else {
              timerValue?.cancel();
            }

            try {
              if (widget.connectedDevice?.sdkType == Constants.e66 && widget.isMeasuring.value) {
                if (widget.isLeadOff.value) {
                  leadOffCount = leadOffCount + 1;
                }
              }
            } catch (e) {
              debugPrint('Exception at progressCard $e');
              LoggingService().warning('Measurement', 'Exception at progressCard', error: e);
            }
          } catch (e) {
            debugPrint('Exception at progressCard $e');
            LoggingService().warning('Measurement', 'Exception at progressCard', error: e);
          }
          return Container(
            height: 79.h,
            margin: EdgeInsets.only(top: 15.h, bottom: 15.h),
            decoration: BoxDecoration(
                color: isDarkMode(context) ? HexColor.fromHex('#111B1A') : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode(context)
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.2)
                        : Colors.white.withOpacity(0.7),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(-4.w, -4.h),
                  ),
                  BoxShadow(
                    color: isDarkMode(context)
                        ? Colors.black
                        : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(4.w, 4.h),
                  ),
                ]),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.h),
                color: Colors.white,
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isDarkMode(context)
                          ? HexColor.fromHex('#9F2DBC').withOpacity(0.15)
                          : HexColor.fromHex('#FFDFDE').withOpacity(0.4),
                      isDarkMode(context)
                          ? HexColor.fromHex('#9F2DBC').withOpacity(0.0)
                          : HexColor.fromHex('#FFDFDE').withOpacity(0.0),
                    ]),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          ValueListenableBuilder(
                            valueListenable: widget.isLeadOff,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 10.h),
                                  child: SizedBox(
                                    height: 25.h,
                                    child: TitleText(
                                      text: stringLocalization.getText(StringLocalization.leadOff),
                                      color: isDarkMode(context)
                                          ? HexColor.fromHex('#FF6259')
                                          : HexColor.fromHex('#FF6259'),
                                      align: TextAlign.start,
                                      fontSize: 16.sp,
                                      maxLine: 1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                SizedBox(
                                  height: 38.h,
                                  child: Body1AutoText(
                                    text: stringLocalization.getText(StringLocalization.leadDesc),
                                    align: TextAlign.start,
                                    maxLine: 2,
                                    fontSize: 12.sp,
                                    color: isDarkMode(context)
                                        ? Colors.white.withOpacity(0.7)
                                        : HexColor.fromHex('#384341'),
                                  ),
                                )
                              ],
                            ),
                            builder: (BuildContext context, bool leadOffValue, Widget? child) {
                              if (leadOffValue && widget.isMeasuring.value) {
                                return child ?? Container();
                              }
                              if (!leadOffValue && !widget.poorConductivityNotifier.value) {
                                return MeasuringText(
                                  isMeasuring: widget.isMeasuring,
                                  leadOfNotifier: widget.isLeadOff,
                                  poorConductivityNotifier: widget.poorConductivityNotifier,
                                );
                              }
                              return Container();
                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: widget.poorConductivityNotifier,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TitleText(
                                  text:
                                      stringLocalization.getText(StringLocalization.poorConductive),
                                  color: Colors.red,
                                  align: TextAlign.start,
                                  maxLine: 5,
                                ),
                                SizedBox(height: 5.h),
                                Body1AutoText(
                                  text: stringLocalization
                                      .getText(StringLocalization.poorConductiveDesc),
                                  align: TextAlign.start,
                                  maxLine: 5,
                                )
                              ],
                            ),
                            builder: (BuildContext context, value, Widget? child) {
                              return Container();
                            },
                          ),
                          // !widget.leadOfNotifier.value && !widget.poorConductivityNotifier.value ?
                          // MeasuringText(
                          //   isMeasuring: widget.isMeasuring,
                          //   leadOfNotifier: widget.leadOfNotifier,
                          //   poorConductivityNotifier: widget.poorConductivityNotifier,
                          // ) : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 25.w,
                    ),
                    CountDownCircle(
                      countDown: widget.isMeasuring.value ? countDown : 0,
                      progressColor: progressColor,
                      connectedDevice: widget.connectedDevice,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}
