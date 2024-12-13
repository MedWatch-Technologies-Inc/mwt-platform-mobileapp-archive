import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/dashboard/circal_list/indicators/percent_indicator.dart';
import 'package:health_gauge/screens/dashboard/circal_list/small_circles/child_of_circles/child_of_circle_view.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class SmallCircles extends StatefulWidget {
  final int index;
  final String widgetName;
  final String image;
  final Widget widget;
  final List<double> listOfPercentage;
  final List colorsOfIndicators;
  final double angle;

  // final ValueNotifier<MeasurementHistoryModel?>
  //     ecgInfoReadingModelValueNotifier;


  final ValueNotifier<String?> selectedWidgetNotifier;
  final ValueNotifier<bool?> isAnimatingNotifier;
  final GestureTapCallback onClickSmallCircle;
  final VoidCallback onEndAnimation;
  final bool? isAiModeSelected;
  final ValueNotifier<num?> currentSysNotifier;
  final ValueNotifier<num?> currentDiaNotifier;

  const SmallCircles(
      {Key? key,
      required this.index,
      required this.widgetName,
      required this.image,
      required this.widget,
      required this.listOfPercentage,
      required this.colorsOfIndicators,
      required this.angle,
      required this.selectedWidgetNotifier,
      required this.onClickSmallCircle,
      required this.onEndAnimation,
      required this.isAnimatingNotifier,
      // required this.ecgInfoReadingModelValueNotifier,

      this.isAiModeSelected, required this.currentSysNotifier, required this.currentDiaNotifier})
      : super(key: key);

  @override
  _SmallCirclesState createState() => _SmallCirclesState();
}

class _SmallCirclesState extends State<SmallCircles> {
  late double rad;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    rad = vector.radians(widget.angle);
    return ValueListenableBuilder(
      valueListenable: widget.selectedWidgetNotifier,
      builder: (BuildContext context, String? selectedWidget, Widget? child) {
        return AnimatedContainer(
          margin: EdgeInsets.only(left: 80.w),
          duration:
              Duration(milliseconds: Constants.homeScreenAnimationMilliseconds),
          transform: Matrix4.identity()
            ..translate(
                selectedWidget == widget.widgetName
                    ? cos(160.h)
                    : 160.h * cos(rad),
                // 170 * cos(rad),
                selectedWidget == widget.widgetName
                    ? sin(160.h)
                    : 160.h * sin(rad)
                // 170 * sin(rad)
                ),
          child: Padding(
            padding: EdgeInsets.only(
                left: selectedWidget == widget.widgetName
                    ? MediaQuery.of(context).size.width * 0.10
                    : 0),
            child: AnimatedContainer(
              duration: Duration(
                  milliseconds: Constants.homeScreenAnimationMilliseconds),
              height: selectedWidget != widget.widgetName ? 68.h : 225.h,
              width: selectedWidget != widget.widgetName ? 68.h : 225.h,
              onEnd: widget.onEndAnimation,
              child: GestureDetector(
                onTap: widget.onClickSmallCircle,
                child: AnimatedContainer(
                  duration: Duration(
                    milliseconds: Constants.homeScreenAnimationMilliseconds,
                  ),
                  margin: EdgeInsets.only(
                    right: selectedWidget != widget.widgetName ? 0 : 30.w,
                  ),
                  height: selectedWidget != widget.widgetName ? 68.h : 225.h,
                  width: selectedWidget != widget.widgetName ? 68.h : 225.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height:
                            selectedWidget != widget.widgetName ? 68.h : 225.h,
                        width:
                            selectedWidget != widget.widgetName ? 68.h : 225.h,
                        decoration:
                            BoxDecoration(shape: BoxShape.circle, boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.12)
                                : Colors.white,
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(-8.h, -8.h),
                          ),
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black.withOpacity(0.75)
                                    : HexColor.fromHex('#D1D9E6'),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: Offset(8.h, 8.h),
                          ),
                        ]),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            selectedWidget != widget.widgetName
                                ? Container()
                                : Image.asset(
                                    (widget.widgetName == 'step' ||
                                            widget.widgetName == 'sleep')
                                        ? Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? 'asset/dark_large_clock.png'
                                            : 'asset/lite_large_clock.png'
                                        : Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? 'asset/dark_large_circle.png'
                                            : 'asset/lite_large_circle.png',
                                    height: 201.h,
                                    width: 201.h,
                                  )
                          ],
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: List<Widget>.generate(
                            (widget.listOfPercentage.length) + 1, (i) {
                          if (widget.selectedWidgetNotifier.value !=
                                  widget.widgetName &&
                              i == widget.listOfPercentage.length) {
                            return ChildOfCircleView(
                              image: widget.image,
                              index: widget.index,
                              widgetName: widget.widgetName,
                              widget: widget.widget,
                              selectedWidgetNotifier:
                                  widget.selectedWidgetNotifier,
                              isAnimatingNotifier: widget.isAnimatingNotifier,
                            );
                          }
                          if (i == widget.listOfPercentage.length) {
                            return Container();
                          }
                          var color;
                          try {
                            color = widget.colorsOfIndicators[i];
                          } catch (e) {
                            print('exception in color $e');
                          }
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularPercentIndicator(
                                superIndex: widget.index,
                                listOfPercentage: widget.listOfPercentage,
                                progressColor: color ?? AppColor.progressColor,
                                subIndex: i,
                                widgetName: widget.widgetName,
                                isFixedSmallCircle: false,
                                currentDiaNotifier: widget.currentDiaNotifier,
                                currentSysNotifier: widget.currentSysNotifier,

                                // ecgInfoReadingModelValueNotifier:
                                //     widget.ecgInfoReadingModelValueNotifier,
                                selectedWidgetNotifier:
                                    widget.selectedWidgetNotifier,

                                isAiModeSelected: widget.isAiModeSelected,
                              ),
                              selectedWidget == widget.widgetName
                                  ? widget.widget
                                  : Container(),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
