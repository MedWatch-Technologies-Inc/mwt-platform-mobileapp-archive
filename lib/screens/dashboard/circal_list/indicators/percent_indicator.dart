import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/dashboard/circal_list/indicators/blood_pressure_data_indicator.dart';
import 'package:health_gauge/screens/dashboard/circal_list/indicators/sleep_data_progress_Indicator.dart';
import 'package:health_gauge/screens/dashboard/circal_list/indicators/step_data_indicator.dart';
import 'package:health_gauge/screens/dashboard/progress_indicator_painter.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';

class CircularPercentIndicator extends StatefulWidget {
  final int superIndex;
  final String widgetName;
  final int subIndex;
  final List<double?> listOfPercentage;
  final ValueNotifier<String?> selectedWidgetNotifier;
  // final ValueNotifier<MeasurementHistoryModel?> ecgInfoReadingModelValueNotifier;
  final ValueNotifier<num?> currentSysNotifier;
  final ValueNotifier<num?> currentDiaNotifier;

  final Color progressColor;
  final bool isFixedSmallCircle;
  final bool? isAiModeSelected;

  const CircularPercentIndicator({
    Key? key,
    required this.currentSysNotifier,
    required this.currentDiaNotifier,
    required this.superIndex,
    required this.widgetName,
    required this.subIndex,
    required this.listOfPercentage,
    required this.progressColor,
    required this.isFixedSmallCircle,
    required this.selectedWidgetNotifier,
    // required this.ecgInfoReadingModelValueNotifier,

    this.isAiModeSelected,
  }) : super(key: key);

  @override
  _CircularPercentIndicatorState createState() =>
      _CircularPercentIndicatorState();
}

class _CircularPercentIndicatorState extends State<CircularPercentIndicator> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ValueListenableBuilder(
        valueListenable: widget.selectedWidgetNotifier,
        builder: (BuildContext context, String? value, Widget? child) {
          if (widget.widgetName == 'bloodPressure') {
            return BloodPressureDataIndicator(
              superIndex: widget.superIndex,
              widgetName: widget.widgetName,
              isFromFixedCircle: widget.isFixedSmallCircle,
              selectedWidgetNotifier: widget.selectedWidgetNotifier,
              currentSysNotifier: widget.currentSysNotifier,
              currentDiaNotifier: widget.currentDiaNotifier,

              // ecgInfoReadingModelValueNotifier:
              // widget.ecgInfoReadingModelValueNotifier,
              isAiModeSelected: widget.isAiModeSelected,
            );
          }



          return
            Container(
              child: CustomPaint(
              painter: MyPainter(
                lineColor: isDarkMode()
                    ? AppColor.darkBackgroundColor
                    : AppColor.backgroundColor,
                completeColor: widget.progressColor ,
                // completePercent:  widget.listOfPercentage[widget.subIndex]! * 100,
                completePercent: 0,
                width: (widget.selectedWidgetNotifier.value == widget.widgetName &&
                    !widget.isFixedSmallCircle)
                    ? 10.h / widget.listOfPercentage.length
                    : 5.h,
              ),
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                duration:
                Duration(milliseconds: Constants.homeScreenAnimationMilliseconds),
                height: widget.selectedWidgetNotifier.value != widget.widgetName
                    ? 68.h
                    : 225.h - (widget.subIndex * 45.h),
              ),
          ),
            );
        },);

  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
}
