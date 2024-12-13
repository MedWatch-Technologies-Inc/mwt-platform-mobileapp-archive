import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/screens/dashboard/circal_list/indicators/percent_indicator.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:vector_math/vector_math_64.dart' as vect;

class SmallCircleFixed extends StatefulWidget {
  final int index;
  final String widgetName;
  final String image;
  final List<double> listOfPercentage;
  final List colorsOfIndicators;
  final double angle;

  final ValueNotifier<num?> currentSysNotifier;
  final ValueNotifier<num?> currentDiaNotifier;

  // final ValueNotifier<MeasurementHistoryModel?>
  //     ecgInfoReadingModelValueNotifier;

  final ValueNotifier<String?> selectedWidgetNotifier;
  final GestureTapCallback onClickSmallCircle;
  final VoidCallback onEndAnimation;
  final bool? isAiModeSelected;

  const SmallCircleFixed({
    Key? key,
    required this.index,
    required this.widgetName,
    required this.image,
    required this.listOfPercentage,
    required this.colorsOfIndicators,
    // required this.ecgInfoReadingModelValueNotifier,
    required this.angle,
    required this.selectedWidgetNotifier,
    required this.onClickSmallCircle,
    required this.onEndAnimation,
    this.isAiModeSelected,
    required this.currentSysNotifier,
    required this.currentDiaNotifier,
  }) : super(key: key);

  @override
  _SmallCircleFixedState createState() => _SmallCircleFixedState();
}

class _SmallCircleFixedState extends State<SmallCircleFixed> {
  var homeScreeenItems = [];

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    double rad;
    rad = vect.radians(widget.angle);
    return ValueListenableBuilder(
      valueListenable: widget.selectedWidgetNotifier,
      builder: (BuildContext context, String? value, Widget? child) {
        return AnimatedOpacity(
          duration: Duration(
            milliseconds: Constants.homeScreenAnimationMilliseconds,
          ),
          opacity: value == widget.widgetName ? 1 : 0,
          child: GestureDetector(
//            onTap: widget.onClickSmallCircle,
            child: AnimatedContainer(
              margin: EdgeInsets.only(left: 80.w),
              duration: Duration(
                  milliseconds: Constants.homeScreenAnimationMilliseconds),
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..translate(160.h * cos(rad), 160.h * sin(rad)),
              child: AnimatedContainer(
                duration: Duration(
                    milliseconds: Constants.homeScreenAnimationMilliseconds),
                height: 68.h,
                width: 68.h,
                onEnd: widget.onEndAnimation,
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: 25,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode()
                                  ? HexColor.fromHex('#D1D9E6')
                                      .withOpacity(0.12)
                                  : Colors.white,
                              blurRadius: 6,
                              spreadRadius: 4,
                              offset: Offset(-5, -5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(
                            value != widget.widgetName ? 80 : 1000,
                          ),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: 66,
                      child: Container(
                        key: widget.image == "asset/dark_steps_butt_off.png"
                            ? Key('stepSmallCircle')
                            : Key('anotherRandomKey'),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: isDarkMode()
                                  ? Colors.black.withOpacity(0.85)
                                  : HexColor.fromHex('#D1D9E6'),
                              blurRadius: 15,
                              spreadRadius: 4,
                              offset: Offset(-5, -5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(
                            value != widget.widgetName ? 80 : 1000,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      // color: AppColor.white,
                      borderRadius: BorderRadius.circular(80),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: List<Widget>.generate(
                          (widget.listOfPercentage.length) + 1,
                          (i) {
                            if (i == (widget.listOfPercentage.length)) {
                              if (widget.image.contains('svg')) {
                                return SizedBox(
                                  height: 25.h,
                                  width: 25.h,
                                  child: SvgPicture.asset(
                                    widget.image,
                                    height: 25.h,
                                    width: 25.h,
                                    color: AppColor.selectedItemColor,
                                    //  color: AppColor.darkRed,
                                  ),
                                );
                              }
                              return Padding(
                                padding: EdgeInsets.zero,
                                key: widget.image ==
                                        "asset/temperature_butt_off.png"
                                    ? Key('tempratureSmallIcon')
                                    : Key('randomIcon'),
                                child: Image.asset(
                                  widget.image,
                                  height: 68.h,
                                  width: 68.h,
                                  fit: BoxFit.fill,
                                ),
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

                            return RotationTransition(
                              turns: AlwaysStoppedAnimation(
                                (0 * 360 / 60) / 360,
                              ),
                              child: CircularPercentIndicator(
                                superIndex: widget.index,
                                listOfPercentage: widget.listOfPercentage,
                                progressColor: color ?? AppColor.progressColor,

                                subIndex: i,
                                widgetName: widget.widgetName,
                                isFixedSmallCircle: true,
                                currentSysNotifier: widget.currentSysNotifier,
                                currentDiaNotifier: widget.currentDiaNotifier,

                                // ecgInfoReadingModelValueNotifier:
                                //     widget.ecgInfoReadingModelValueNotifier,
                                selectedWidgetNotifier:
                                    widget.selectedWidgetNotifier,
                                isAiModeSelected: widget.isAiModeSelected,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
}
