import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

class HrvWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final GestureTapCallback onClickHRVWidget;
  // final ValueNotifier<MeasurementHistoryModel?> ecgInfoReadingModelNotifier;
  final ValueNotifier<num?> currentHRVNotifier;

  const HrvWidget({
    Key? key,
    required this.isAnimatingNotifier,
    // required this.ecgInfoReadingModelNotifier,
    required this.onClickHRVWidget,
    required this.selectedWidgetNotifier, required, required this.currentHRVNotifier
  }) : super(key: key);

  @override
  _HrvWidgetState createState() => _HrvWidgetState();
}

class _HrvWidgetState extends State<HrvWidget> {
  String strHrv = '';
  String hrvValue = '';
  String lastEcgMeasurementDetail = '';

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    return ValueListenableBuilder(
      valueListenable: widget.currentHRVNotifier,
      builder: (BuildContext context, num? hrvValues,
          Widget? child) {
        strHrv = stringLocalization.getText(StringLocalization.hrv);

        hrvValue = hrvValues?.toString() ?? '0';

        // try {
        //   DateTime date = DateTime.parse(
        //       widget.ecgInfoReadingModelNotifier.value?.date ??
        //           DateTime.now().toString());
        //   lastEcgMeasurementDetail = DateUtil().getDateDifference(date);
        // } catch (e) {
        //   print('exception in BloodPressureWidget $e');
        // }

        return ValueListenableBuilder(
          valueListenable: widget.isAnimatingNotifier,
          builder: (BuildContext context, bool? value, Widget? child) {
            return Visibility(
                visible: !(value ?? false), child: child ?? Container());
          },
          child:  GestureDetector(
            onTap: widget.onClickHRVWidget,
            child: Center(
              child: Container(
                height: 180.h,
                width: 200.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'asset/strees_55.png',
                      height: widget.selectedWidgetNotifier.value == 'hrv' ? 55.h : 50.h,
                      width: widget.selectedWidgetNotifier.value == 'hrv' ? 55.h : 50.h,
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    SizedBox(
                      width: 30.w,
                      child: AutoSizeText(
                        strHrv.toUpperCase(),
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                            fontSize: 16.sp),
                        textAlign: TextAlign.center,
                        minFontSize: 8,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: 30.w,
                      child: AutoSizeText(
                        hrvValue.toUpperCase(),
                        style: TextStyle(
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        minFontSize: 8,
                        maxLines: 1,
                      ),
                    ),
                    // SizedBox(
                    //   height: 2.h,
                    // ),
                    // Container(
                    //   height: (lastEcgMeasurementDetail
                    //           .trim()
                    //           .isEmpty)
                    //       ? 0
                    //       : 17.h,
                    //   width: 80.w,
                    //   child: Center(
                    //     child: AutoSizeText(
                    //       '$lastEcgMeasurementDetail',
                    //       style: TextStyle(
                    //         fontSize: 12.sp,
                    //         color: Theme
                    //             .of(context)
                    //             .brightness == Brightness.dark
                    //             ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    //             : HexColor.fromHex('#384341'),
                    //       ),
                    //       maxLines: 1,
                    //       minFontSize: 6,
                    //       textAlign: TextAlign.center,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },

    );
  }
}
