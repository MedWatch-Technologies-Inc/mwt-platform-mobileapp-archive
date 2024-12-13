import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';

import '../../progress_indicator_painter.dart';

class StepDataIndicator extends StatefulWidget {
  final ValueNotifier<MotionInfoModel?> motionInfoModelNotifier;
  final ValueNotifier<String?> selectedWidget;
  final String widgetName;
  final bool isFromFixedCircle;
  final ValueNotifier<String?> selectedWidgetNotifier;

  const StepDataIndicator({
    Key? key,
    required this.motionInfoModelNotifier,
    required this.selectedWidget,
    required this.widgetName,
    required this.isFromFixedCircle,
    required this.selectedWidgetNotifier,
  }) : super(key: key);

  @override
  _StepDataIndicatorState createState() => _StepDataIndicatorState();
}

class _StepDataIndicatorState extends State<StepDataIndicator> {
  List<Map> listAfter12 = [];
  List<Map> listBefore12 = [];

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ValueListenableBuilder(
      valueListenable: widget.selectedWidgetNotifier,
      builder: (BuildContext context, String? value, Widget? child) {
        return ValueListenableBuilder(
          valueListenable: widget.motionInfoModelNotifier,
          builder: (BuildContext context, MotionInfoModel? motionInfoModel,
              Widget? child) {
            bool isNotSelectedOrFromSmallCircle =
                (widget.selectedWidget.value != 'step' ||
                    widget.isFromFixedCircle);

            listAfter12 = [];
            listBefore12 = [];

            List stepData = [];
            // List stepData =[110,10,222,222,22,100,500,0,5000,500,0,500,500,500500,500,500,500,500,500,500,500,800];
            try {
              stepData = motionInfoModel?.data ?? [];
            } catch (e) {
              print('Exception in  step data indicator $e');
            }

            for (int i = 12; i < 24; i++) {
              if (stepData.length > i) {
                listAfter12.add({
                  'Type': stepData[i],
                  'duration': 53,
                  'start': (i * 60) / 12
                });
              } else {
                listAfter12
                    .add({'Type': 0, 'duration': 53, 'start': (i * 60) / 12});
              }
            }

            for (int i = 0; i < 12; i++) {
              if (stepData.length > i) {
                listBefore12.add({
                  'Type': stepData[i],
                  'duration': 53,
                  'start': (i * 60) / 12
                });
              } else {
                listBefore12
                    .add({'Type': 0, 'duration': 53, 'start': (i * 60) / 12});
              }
            }

            return Stack(
              alignment: Alignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children:
                      List<Widget>.generate(listAfter12.length + 1, (position) {
                    if (position == 0) {
                      return RotationTransition(
                        turns: AlwaysStoppedAnimation(0),
                        child: CustomPaint(
                          foregroundPainter: MyPainter(
                              lineColor: Colors.transparent,
                              completeColor: isDarkMode()
                                  ? AppColor.darkBackgroundColor
                                  : AppColor.backgroundColor,
                              completePercent: 100,
                              width: isNotSelectedOrFromSmallCircle ? 2.h : 5.h,
                              strokeCap: StrokeCap.square),
                          child: AnimatedContainer(
                            duration: Duration(
                                milliseconds:
                                    Constants.homeScreenAnimationMilliseconds),
                            height:
                                isNotSelectedOrFromSmallCircle ? 68.h : 225.h,
                            width:
                                isNotSelectedOrFromSmallCircle ? 68.h : 225.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }
                    Map map = listAfter12[position - 1];

                    double width = getWidthByStep(
                        map['Type'], isNotSelectedOrFromSmallCircle);

                    return RotationTransition(
                      turns: AlwaysStoppedAnimation(angleForSleepProgress(map)),
                      child: CustomPaint(
                        foregroundPainter: MyPainter(
                          lineColor: Colors.transparent,
                          completeColor:
                              AppColor.progressColor.withOpacity(width),
                          completePercent: 7.36,
                          width: isNotSelectedOrFromSmallCircle ? 2.h : 5.h,
                          strokeCap: StrokeCap.square,
                        ),
                        child: AnimatedContainer(
                          duration: Duration(
                              milliseconds:
                                  Constants.homeScreenAnimationMilliseconds),
                          height: isNotSelectedOrFromSmallCircle ? 68.h : 225.h,
                          width: isNotSelectedOrFromSmallCircle ? 68.h : 225.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.amberAccent.withOpacity(0.2)
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: List<Widget>.generate(listBefore12.length + 1,
                      (position) {
                    if (position == 0) {
                      return RotationTransition(
                        turns: AlwaysStoppedAnimation(0),
                        child: CustomPaint(
                          foregroundPainter: MyPainter(
                            lineColor: Colors.transparent,
                            completeColor: isDarkMode()
                                ? AppColor.darkBackgroundColor
                                : AppColor.backgroundColor,
                            completePercent: 100,
                            width: isNotSelectedOrFromSmallCircle ? 2.h : 5.h,
                            strokeCap: StrokeCap.square,
                          ),
                          child: AnimatedContainer(
                            duration: Duration(
                                milliseconds:
                                    Constants.homeScreenAnimationMilliseconds),
                            height:
                                isNotSelectedOrFromSmallCircle ? 58.h : 184.h,
                            width:
                                isNotSelectedOrFromSmallCircle ? 58.h : 184.h,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                          ),
                        ),
                      );
                    }
                    Map map = listBefore12[position - 1];
                    double width = getWidthByStep(
                        map['Type'], isNotSelectedOrFromSmallCircle);
                    return RotationTransition(
                      turns: AlwaysStoppedAnimation(angleForSleepProgress(map)),
                      child: CustomPaint(
                        foregroundPainter: MyPainter(
                          lineColor: Colors.transparent,
                          completeColor:
                              AppColor.purpleColor.withOpacity(width),
                          completePercent: (53 / (720)) * 100,
                          width: isNotSelectedOrFromSmallCircle ? 2.h : 5.h,
                          strokeCap: StrokeCap.square,
                        ),
                        child: AnimatedContainer(
                          duration: Duration(
                              milliseconds:
                                  Constants.homeScreenAnimationMilliseconds),
                          height: isNotSelectedOrFromSmallCircle ? 58.h : 184.h,
                          width: isNotSelectedOrFromSmallCircle ? 58.h : 184.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            );
          },
        );
      },
    );
  }

  double getWidthByStep(int step, bool isSelected) {
    if (isSelected) {
      return 0;
    }
    int max = 2000;
    if (step > max) {
      max = step;
    }
    if (step > max) {
      step = max;
    }
    double val = (step) / max;
    if (val > 0 && val <= 0.33) {
      val = 0.33;
    }
    if (val > 0.33 && val <= 0.66) {
      val = 0.66;
    }
    if (val > 0.66 && val <= 1) {
      val = 1;
    }
    return val;
  }

  angleForSleepProgress(Map map) {
    double minutes = map['start'].toDouble();
    return (minutes * 360 / 60) / 360;
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
}
