import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/dashboard/progress_indicator_painter.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';

class BloodPressureDataIndicator extends StatefulWidget {
  final int superIndex;
  final bool isFromFixedCircle;
  final String widgetName;
  final ValueNotifier<num?> currentSysNotifier;
  final ValueNotifier<num?> currentDiaNotifier;

  // final ValueNotifier<MeasurementHistoryModel?>
  //     ecgInfoReadingModelValueNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final bool? isAiModeSelected;

  const BloodPressureDataIndicator({
    Key? key,
    required this.superIndex,
    required this.isFromFixedCircle,
    required this.widgetName,
    // required this.ecgInfoReadingModelValueNotifier,
    required this.selectedWidgetNotifier,
    this.isAiModeSelected, required this.currentSysNotifier, required this.currentDiaNotifier,
  }) : super(key: key);

  @override
  _BloodPressureDataIndicatorState createState() =>
      _BloodPressureDataIndicatorState();
}

class _BloodPressureDataIndicatorState
    extends State<BloodPressureDataIndicator> {
  int sbp = 0;
  int dbp = 0;
  Color bloodPressureProgressColor = AppColor.purpleColor;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ValueListenableBuilder(
      valueListenable: widget.selectedWidgetNotifier,
      builder: (BuildContext context, String? value, Widget? child) {
        return    ValueListenableBuilder(
          // valueListenable: widget.ecgInfoReadingModelValueNotifier,
            valueListenable: widget.currentDiaNotifier,
            builder: (BuildContext context,
                disValue, Widget? child) {
            return ValueListenableBuilder(
              // valueListenable: widget.ecgInfoReadingModelValueNotifier,
              valueListenable: widget.currentSysNotifier,
              builder: (BuildContext context,
                   sysValue, Widget? child) {
                var isSelected =
                    (widget.selectedWidgetNotifier.value != widget.widgetName ||
                        widget.isFromFixedCircle);

                try {
                  sbp = sysValue?.toInt() ?? 0;
                } catch (e) {
                  print('exception in blood pressure indicator $e');
                }
                try {
                  dbp = disValue?.toInt() ?? 0;
                } catch (e) {
                  print('exception in blood pressure indicator $e');
                }

                try {
                  if (sbp < 90 && dbp < 60) {
                    bloodPressureProgressColor = AppColor.lowBpColor;
                  } else if (sbp <= 120 && dbp <= 80) {
                    bloodPressureProgressColor = AppColor.normalBpColor;
                  } else if (sbp <= 140 && dbp <= 90) {
                    bloodPressureProgressColor = AppColor.preBpColor;
                  } else if (sbp <= 180 && dbp <= 120) {
                    bloodPressureProgressColor = AppColor.hyperBpColor;
                  } else {
                    bloodPressureProgressColor = AppColor.hyperBpColor;
                  }
                } catch (e) {
                  print('exception in blood_pressure_data_indicator $e');
                }

                return Stack(
                  children: [
                    CustomPaint(
                      foregroundPainter: MyPainter(
                          lineColor: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.darkBackgroundColor
                              : AppColor.backgroundColor,
                          completeColor: AppColor.backgroundColor,
                          completePercent: 100,
                          width: isSelected ? 5.h : 10.h,
                          strokeCap: StrokeCap.square),
                      child: AnimatedContainer(
                        duration: Duration(
                            milliseconds:
                                Constants.homeScreenAnimationMilliseconds),
                        height: isSelected ? 68.h : 225.h,
                        width: isSelected ? 68.h : 225.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: AlwaysStoppedAnimation(
                          (dbp / Constants.maximumBloodPressure)),
                      child: CustomPaint(
                        foregroundPainter: MyPainter(
                          lineColor: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.darkBackgroundColor
                              : Colors.transparent,
                          completeColor: bloodPressureProgressColor,
                          completePercent:0,
                          // completePercent:
                          //     ((sbp - dbp) / (Constants.maximumBloodPressure)) *
                          //         100,
                          width: isSelected ? 5.h : 10.h,
                          strokeCap: StrokeCap.square,
                        ),
                        child: AnimatedContainer(
                          duration: Duration(
                              milliseconds:
                                  Constants.homeScreenAnimationMilliseconds),
                          height: isSelected ? 68.h : 225.h,
                          width: isSelected ? 68.h : 225.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        );
      },
    );
  }

  String getSbpRange(double positionOfProgress, ecgInfoReadingModel) {
    String sbpRange = '';
    int sbp = 0;
    if (ecgInfoReadingModel != null) {
      sbp = ecgInfoReadingModel.approxSBP;

      if (sbp <= 90) {
        sbpRange = 'Low';
        positionOfProgress = ((MediaQuery.of(context).size.width -
                    ((MediaQuery.of(context).size.width - 70)) / 4) +
                30) /
            4;
      } else if (sbp > 90 && sbp <= 120) {
        sbpRange = 'Normal';
        positionOfProgress = (((MediaQuery.of(context).size.width -
                        ((MediaQuery.of(context).size.width - 70)) / 4) +
                    30) *
                2) /
            4;
      } else if (sbp > 120 && sbp <= 140) {
        sbpRange = 'Pre-Hyper';
        positionOfProgress = (((MediaQuery.of(context).size.width -
                        ((MediaQuery.of(context).size.width - 70)) / 4) +
                    30) *
                3) /
            4;
      } else if (sbp > 140) {
        sbpRange = 'Hyper';
        positionOfProgress = (((MediaQuery.of(context).size.width -
                        ((MediaQuery.of(context).size.width - 70)) / 4) +
                    30) *
                4) /
            4;
      }
    }
    return sbpRange;
  }

  String getDbpRange(double positionOfProgress, ecgInfoReadingModel) {
    String dbpRange = '';
    int dbp = 0;
    if (ecgInfoReadingModel != null) {
      dbp = ecgInfoReadingModel.approxDBP;
      if (dbp >= 40 && dbp <= 60) {
        dbpRange = 'Low';
        positionOfProgress = ((MediaQuery.of(context).size.width -
                    ((MediaQuery.of(context).size.width - 70)) / 4) +
                30) /
            4;
      } else if (dbp > 60 && dbp <= 80) {
        dbpRange = 'Normal';
        positionOfProgress = (((MediaQuery.of(context).size.width -
                        ((MediaQuery.of(context).size.width - 70)) / 4) +
                    30) *
                2) /
            4;
      } else if (dbp > 80 && dbp <= 90) {
        dbpRange = 'Pre-Hyper';
        positionOfProgress = (((MediaQuery.of(context).size.width -
                        ((MediaQuery.of(context).size.width - 70)) / 4) +
                    30) *
                3) /
            4;
      } else if (dbp > 90) {
        dbpRange = 'Hyper';
        positionOfProgress = (((MediaQuery.of(context).size.width -
                        ((MediaQuery.of(context).size.width - 70)) / 4) +
                    30) *
                4) /
            4;
      }
    }
    return dbpRange;
  }
}
