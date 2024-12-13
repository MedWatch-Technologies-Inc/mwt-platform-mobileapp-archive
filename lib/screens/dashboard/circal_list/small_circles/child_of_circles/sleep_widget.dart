import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';

class SleepWidget extends StatefulWidget {
  final ValueNotifier<bool?> isAnimatingNotifier;
  final ValueNotifier<String?> selectedWidgetNotifier;
  final GestureTapCallback onClickSleepWidget;
  final ValueNotifier<SleepInfoModel?> sleepInfoModelNotifier;
  final ValueNotifier<num?> targetMinuteNotifier;

  const SleepWidget({
    Key? key,
    required this.isAnimatingNotifier,
    required this.selectedWidgetNotifier,
    required this.onClickSleepWidget,
    required this.sleepInfoModelNotifier,
    required this.targetMinuteNotifier,
  }) : super(key: key);

  @override
  _SleepWidgetState createState() => _SleepWidgetState();
}

class _SleepWidgetState extends State<SleepWidget> {
  String time = '0:0 HRS';
  String goal = '0:00 H';
  int targetMinute = 0;
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);

    return ValueListenableBuilder(
      valueListenable: widget.sleepInfoModelNotifier,
      builder: (BuildContext context, SleepInfoModel? sleepModel, Widget? child) {


         try {
           targetMinute = widget.targetMinuteNotifier.value?.toInt() ?? 0;
         } catch (e) {
           print('error in SleepWidget $e');
         }

         try {
           if (sleepModel != null) {
                     if (sleepModel.data.length > 0) {
                       int hour = (sleepModel.deepTime + sleepModel.lightTime) ~/ 60;
                       int minute =
                       ((sleepModel.deepTime + sleepModel.lightTime) % 60).toInt();
                       time = '${hour.toString()}:${minute.toString().padLeft(2, '0')} HRS';
                     }
                   }
         } catch (e) {
           print('error in SleepWidget $e');
         }

         try {
           goal = '${(targetMinute ~/ 60).toString()}:${(targetMinute % 60).toString().padLeft(2, '0')} HRS';
         } catch (e) {
           print('error in SleepWidget $e');
         }


         return InkWell(
          onTap: widget.onClickSleepWidget,
          child: ValueListenableBuilder(
            valueListenable: widget.isAnimatingNotifier,
            builder: (BuildContext context, bool? value, Widget? child) {
              return Visibility(
                visible: !(value ?? false),
                child: child??Container(),
              );
            },
            child: Container(
              width: 100.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: widget.selectedWidgetNotifier.value == 'bloodPressure' ? 55.h : 50.h,
                    width: widget.selectedWidgetNotifier.value == 'bloodPressure' ? 55.h : 50.h,
                    child: Image.asset(
                      'asset/sleep_55.png',
                      height: widget.selectedWidgetNotifier.value == 'sleep' ? 55.h : 50.h,
                      width: widget.selectedWidgetNotifier.value == 'sleep' ? 55.h : 50.h,
                    ),
                  ),
                  SizedBox(height: 9.h),
                  FittedBox(
                    child: HeadlineText(
                      text:
                      '${stringLocalization.getText(StringLocalization.goal).toUpperCase()} $goal',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontSize: 16.sp,
                    ),
                  ),
                  FittedBox(
                    child: Display2Text(
                      text: '$time',
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontWeight: FontWeight.bold,
                      fontSize: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
