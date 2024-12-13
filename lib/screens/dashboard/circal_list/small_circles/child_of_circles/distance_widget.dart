import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';

import '../../../../../value/string_localization_support/string_localization.dart';

class DistanceWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final ValueNotifier<num?> targetDistanceNotifier;
  final ValueNotifier<MotionInfoModel?> motionInfoModelNotifier;

  final GestureTapCallback onClickDistanceWidget;

  const DistanceWidget({
    Key? key,
    required this.isAnimatingNotifier,
    required this.selectedWidgetNotifier,
    required this.targetDistanceNotifier,
    required this.motionInfoModelNotifier,
    required this.onClickDistanceWidget,
  }) : super(key: key);

  @override
  _DistanceWidgetState createState() => _DistanceWidgetState();
}

class _DistanceWidgetState extends State<DistanceWidget> {
  String distanceInKmStr = "";
  String strTargetDistance = '0 M';

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ValueListenableBuilder(
      valueListenable: widget.selectedWidgetNotifier,
      builder: (BuildContext context, String? value, Widget? child) {
        return InkWell(
          onTap: widget.onClickDistanceWidget,
          child: ValueListenableBuilder(
            valueListenable: widget.isAnimatingNotifier,
            builder: (BuildContext context, bool? value, Widget? child) {
              return Visibility(
                visible: !(value ?? false),
                child: child ?? Container(),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/route_55.png',
                  height: widget.selectedWidgetNotifier.value == 'distance'
                      ? 55.h
                      : 50.h,
                  width: widget.selectedWidgetNotifier.value == 'distance'
                      ? 55.h
                      : 50.h,
                  // color: Theme.of(context).brightness == Brightness.dark ? HexColor.fromHex('#CC0A00'): getSelectedItemIndex() == 2?AppColor.selectedItemColor:AppColor.unSelectedItemColor,
                ),
                SizedBox(height: 9.h),
                ValueListenableBuilder(
                  valueListenable: widget.targetDistanceNotifier,
                  builder: (BuildContext context, num? value, Widget? child) {
                    value ??= 0;
                    strTargetDistance = '$value';
                    if (distanceUnit == 1) {
                      strTargetDistance =
                          '${(value / 1609).toStringAsFixed(2).padLeft(2, '0')} ${(value / 1609) > 1 ? 'Miles' : 'Mile'}';
                    } else if (value >= 1000) {
                      strTargetDistance =
                          '${(value / 1000).toStringAsFixed(2).padLeft(2, '0')} KM';
                    }
                    return SizedBox(
                      width: 120.w,
                      child: HeadlineText(
                        text:
                            '${stringLocalization.getText(StringLocalization.goal).toUpperCase()} $strTargetDistance',
                        color: isDarkMode()
                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                            : HexColor.fromHex('#384341'),
                        fontSize: 16.sp,
                        maxLine: 1,
                        align: TextAlign.center,
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: widget.motionInfoModelNotifier,
                  builder: (BuildContext context, MotionInfoModel? value,
                      Widget? child) {
                    double distance = 0;
                    double distanceInKm = 0;

                    try {
                      distance = (double.parse(
                              double.parse('${value?.distance ?? 0}')
                                  .toStringAsFixed(2)) *
                          1000);
                    } catch (e) {
                      print('Exception in distanceLegends $e');
                    }

                    try {
                      distanceInKm = double.parse(
                          double.parse('${value?.distance ?? 0}')
                              .toStringAsFixed(2));
                    } catch (e) {
                      print('Exception in distanceLegends $e');
                    }

                    distance =
                        (distance / (widget.targetDistanceNotifier.value ?? 1));
                    if (distance > 1) {
                      distance = 1;
                    }
                    if (distance <= 0) {
                      distance = 0;
                    }

                    distanceInKmStr = '$distanceInKm';
                    if (distanceUnit == 1) {
                      distanceInKmStr =
                          '${(double.parse(double.parse('${value?.distance ?? 0}').toStringAsFixed(2)) / 1.609).toStringAsFixed(2)}';
                    }

                    return SizedBox(
                      width: 80.w,
                      child: Center(
                        child: Body1AutoText(
                          text: '$distanceInKmStr',
                          color: isDarkMode()
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
}
