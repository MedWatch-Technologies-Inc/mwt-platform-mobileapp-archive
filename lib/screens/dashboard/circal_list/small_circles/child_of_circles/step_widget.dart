import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/infoModels/motion_info_model.dart';
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class StepWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final ValueNotifier<num?> targetStepNotifier;
  final ValueNotifier<MotionInfoModel?> motionInfoModelNotifier;
  final GestureTapCallback onClickStepWidget;
  final ValueNotifier<TempModel?> temperatureNotifier;

  const StepWidget({
    Key? key,
    required this.isAnimatingNotifier,
    required this.selectedWidgetNotifier,
    required this.targetStepNotifier,
    required this.motionInfoModelNotifier,
    required this.onClickStepWidget,
    required this.temperatureNotifier,
  }) : super(key: key);

  @override
  _StepWidgetState createState() => _StepWidgetState();
}

class _StepWidgetState extends State<StepWidget> {
  int steps = 0;

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ValueListenableBuilder(
      valueListenable: widget.motionInfoModelNotifier,
      builder: (BuildContext context, MotionInfoModel? value, Widget? child) {
        try {
          steps = widget.motionInfoModelNotifier.value?.step ?? 0;
        } catch (e) {
          print('exception in StepWidget $e');
        }

        return InkWell(
          onTap: widget.onClickStepWidget,
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'asset/step_55.png',
                  height: (widget.selectedWidgetNotifier.value ?? '') == 'step'
                      ? 55.h
                      : 50.h,
                  width: (widget.selectedWidgetNotifier.value ?? '') == 'step'
                      ? 55.h
                      : 50.h,
                ),
                SizedBox(height: 9.h),
                Container(
                  width: 120.h,
                  child: Center(
                    child: HeadlineText(
                      text:
                          '${stringLocalization.getText(StringLocalization.goal).toUpperCase()} ${(widget.targetStepNotifier.value?.toInt() ?? '')}',
                      color: isDarkMode()
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontSize: 16.sp,
                      maxLine: 1,
                    ),
                  ),
                ),
                CurrentStep(
                    temperatureNotifier: widget.temperatureNotifier,
                    step: steps),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;
}

class CurrentStep extends StatefulWidget {
  final ValueNotifier<TempModel?> temperatureNotifier;
  final int step;

  const CurrentStep(
      {Key? key, required this.temperatureNotifier, required this.step})
      : super(key: key);

  @override
  _CurrentStepState createState() => _CurrentStepState();
}

class _CurrentStepState extends State<CurrentStep> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkAndGetConnectedDevice(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data == Constants.zhBle) {
          return Container(
            width: 80.w,
            child: Center(
              child: AutoSizeText(
                '${widget.step}',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('FFFFFF').withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                minFontSize: 10,
                maxLines: 1,
              ),
            ),
          );
        } else {
          return ValueListenableBuilder(
            valueListenable: widget.temperatureNotifier,
            builder: (BuildContext context, TempModel? value, Widget? child) {
              int step = widget.step;
              if ((value?.stepValue ?? 0) > (widget.step)) {
                step = value?.stepValue?.toInt() ?? 0;
              }
              return Container(
                width: 80.w,
                child: Center(
                  child: AutoSizeText(
                    '$step',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    minFontSize: 10,
                    maxLines: 1,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  checkAndGetConnectedDevice() async {
    var value =
        preferences!.getString(Constants.connectedDeviceAddressPrefKey) ?? '{}';
    var val = jsonDecode(value);
    if (val is Map) {
      var connectedDevice = DeviceModel.fromMap(val);
      return connectedDevice.sdkType;
    }
    return Constants.e66;
  }
}
