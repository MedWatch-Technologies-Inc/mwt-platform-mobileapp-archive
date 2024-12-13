import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class BloodPressureWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final GestureTapCallback onClickBloodPressureWidget;
  final ValueNotifier<num?> currentSysNotifier;
  final ValueNotifier<num?> currentDiaNotifier;
  // final ValueNotifier<MeasurementHistoryModel?> ecgInfoReadingModelNotifier;
  final bool isAiModeSelected;
  const BloodPressureWidget({
    Key? key,
    required this.isAnimatingNotifier,
    // required this.ecgInfoReadingModelNotifier,
    required this.onClickBloodPressureWidget,
    required this.selectedWidgetNotifier,
    required this.isAiModeSelected, required this.currentSysNotifier, required this.currentDiaNotifier
  }) : super(key: key);

  @override
  _BloodPressureWidgetState createState() => _BloodPressureWidgetState();
}

class _BloodPressureWidgetState extends State<BloodPressureWidget> {

  int sys = 0;
  int dia = 0;
  String lastEcgMeasurementDetail = '';

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return InkWell(
      onTap: widget.onClickBloodPressureWidget,
      child:  ValueListenableBuilder(
          valueListenable: widget.currentDiaNotifier,
          builder: (BuildContext context, num? diaValue,
              Widget? child) {
          return ValueListenableBuilder(
            valueListenable: widget.currentSysNotifier,
            builder: (BuildContext context, num? sysValue,
                Widget? child) {
              print('BPW isAiModeSelected :: ${widget.isAiModeSelected}');
              try {

                sys = sysValue?.toInt() ?? 0 ;


              } catch (e) {
                print('exception in BloodPressureWidget $e');
              }

              try {
                dia = diaValue?.toInt() ?? 0 ;


              } catch (e) {
                print('exception in BloodPressureWidget $e');
              }

              // try {
              //   DateTime date = DateTime.parse(widget.ecgInfoReadingModelNotifier.value?.date ?? DateTime.now().toString());
              //   // print('last_measurement_date $date');
              //   lastEcgMeasurementDetail = DateUtil().getDateDifference(date);
              // } catch (e) {
              //   print('exception in BloodPressureWidget $e');
              // }


              return ValueListenableBuilder(
                valueListenable: widget.isAnimatingNotifier,
                builder: (BuildContext context, bool? value, Widget? child) {
                  return Visibility(
                    visible: !(value ?? false),
                    child: child ?? Container(),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'asset/blood_ pressure_55.png',
                      height: widget.selectedWidgetNotifier.value == 'bloodPressure'
                          ? 55.h
                          : 50.h,
                      width: widget.selectedWidgetNotifier.value == 'bloodPressure'
                          ? 55.h
                          : 50.h,
                    ),
                    SizedBox(height: 5.9.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 25.w,
                          height: 23.h,
                          child: Center(
                            child: AutoSizeText(
                              stringLocalization
                                  .getText(StringLocalization.systolic)
                                  .toUpperCase(),
                              style: TextStyle(
                                color: isDarkMode()
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                                fontSize: 16.sp,
                              ),
                              minFontSize: 10,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          width: sys == 0 ? 15.w : 35.w,
                          height: 28.h,
                          child: Center(
                            child: AutoSizeText(
                              sys < 100 && sys != 0 ? '  $sys' : '$sys',
                              style: TextStyle(
                                  color: isDarkMode()
                                      ? HexColor.fromHex('#FFFFFF')
                                          .withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold),
                              minFontSize: 14,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        /*AutoSizeText(
                          ' est',
                          style: TextStyle(
                              color: isDarkMode()
                                  ? HexColor.fromHex('#FFFFFF')
                                  .withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                              fontSize: 16.sp),
                          minFontSize: 10,
                          maxLines: 1,
                        ),*/
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 25.w,
                          height: 23.h,
                          child: Center(
                            child: AutoSizeText(
                              stringLocalization
                                  .getText(StringLocalization.diastolic)
                                  .toUpperCase(),
                              style: TextStyle(
                                color: isDarkMode()
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                                fontSize: 16.sp,
                              ),
                              minFontSize: 10,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Container(
                          width: dia == 0 ? 15.w : 35.w,
                          height: 28.h,
                          child: Center(
                            child: AutoSizeText(
                              dia < 100 && dia != 0 ? '  $dia' : '$dia ',
                              style: TextStyle(
                                  color: isDarkMode()
                                      ? HexColor.fromHex('#FFFFFF')
                                          .withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold),
                              minFontSize: 14,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // Display2Text(text: '$dia',color: Colors.white),
                        /*AutoSizeText(
                          ' est',
                          style: TextStyle(
                              color: isDarkMode()
                                  ? HexColor.fromHex('#FFFFFF')
                                      .withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                              fontSize: 16.sp),
                          minFontSize: 10,
                          maxLines: 1,
                        ),*/
                        //TitleText(text: 'mmhg',color: Colors.white,fontSize: 14,),
                      ],
                    ),
                    // SizedBox(height: 2.h),
                    // Container(
                    //     width: 90.w,
                    //     height: 17.h,
                    //     child: Center(
                    //       child: AutoSizeText(
                    //         lastEcgMeasurementDetail,
                    //         style: TextStyle(
                    //             fontSize: 12.sp,
                    //             color: isDarkMode()
                    //                 ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    //                 : HexColor.fromHex('#384341')),
                    //         maxLines: 1,
                    //         minFontSize: 5,
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     )),
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
}
