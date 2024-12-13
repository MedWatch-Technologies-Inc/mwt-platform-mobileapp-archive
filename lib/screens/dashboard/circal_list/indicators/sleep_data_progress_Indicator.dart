import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/screens/dashboard/progress_indicator_painter.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';

class SleepDataProgressIndicator extends StatefulWidget {
  final ValueNotifier<SleepInfoModel?> sleepDataInfoModelValueNotifier;
  final ValueNotifier<String?> selectedWidget;
  final String widgetName;
  final bool isFromFixedCircle;
  final ValueNotifier<String?> selectedWidgetNotifier;

  const SleepDataProgressIndicator({
    Key? key,
    required this.sleepDataInfoModelValueNotifier,
    required this.selectedWidget,
    required this.widgetName,
    required this.isFromFixedCircle,
    required this.selectedWidgetNotifier,
  }) : super(key: key);

  @override
  _SleepDataProgressIndicatorState createState() =>
      _SleepDataProgressIndicatorState();
}

class _SleepDataProgressIndicatorState
    extends State<SleepDataProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return ValueListenableBuilder(
      valueListenable: widget.selectedWidgetNotifier,
      builder: (BuildContext context, String? value, Widget? child) {
        return ValueListenableBuilder(
          valueListenable: widget.sleepDataInfoModelValueNotifier,
          builder: (BuildContext context, SleepInfoModel? sleepModel,
              Widget? child) {
            bool isSelected =
                ((widget.selectedWidget.value ?? '') != widget.widgetName);

            List<SleepDataInfoModel> sleepData = [];
            if (sleepModel != null) {
              try {
                if (isSelected || widget.isFromFixedCircle) {
                  SleepInfoModel sleepInfoModel =
                      SleepInfoModel.clone(sleepModel);
                  sleepData = trimSleep(sleepInfoModel).data;
                } else {
                  sleepData = sleepModel.data;
                }
              } catch (e) {
                print('Exception in SleepDataProgressIndicator $e');
              }
            }

            if (sleepData.length > 0) {
              if (sleepData.first.time != null &&
                  sleepData.first.time.toString().isNotEmpty &&
                  sleepData.first.time != null &&
                  sleepData.first.time.toString().isNotEmpty) {



              }
              List<Map> list = [];

              for (int i = 0; i < sleepData.length; i++) {
                if (i == sleepData.length - 1) {
                  break;
                }
                SleepDataInfoModel model = sleepData[i];
                SleepDataInfoModel nextModel = sleepData[i + 1];

                int nowHour =
                    int.tryParse(model.time?.split(':')[0] ?? '') ?? 0;
                int nowMinute =
                    int.tryParse(model.time?.split(':')[1] ?? '') ?? 0;

                int nextHour =
                    int.tryParse(nextModel.time?.split(':')[0] ?? '') ?? 0;
                int nextMinute =
                    int.tryParse(nextModel.time?.split(':')[1] ?? '') ?? 0;

                DateTime current = DateTime.now();

                DateTime nowDateTime = DateTime(
                    current.year,
                    current.month,
                    nowHour > 12 ? current.day - 1 : current.day,
                    nowHour,
                    nowMinute);
                if (nowDateTime.day == current.day && nowDateTime.hour == 12) {
                  nowDateTime = DateTime(
                      nowDateTime.year,
                      nowDateTime.month,
                      nowDateTime.day,
                      0,
                      nowDateTime.minute,
                      nowDateTime.second);
                }
                DateTime nextDateTime = DateTime(
                    current.year,
                    current.month,
                    nextHour > 12 ? current.day - 1 : current.day,
                    nextHour,
                    nextMinute);

                int minutes = nextDateTime.difference(nowDateTime).inMinutes;
                int statPoint = 0;
                if (nowHour > 12) {
                  nowHour = nowHour - 12;
                }
                statPoint = (nowHour * 60) + nowMinute;
                list.add({
                  'Type': model.type,
                  'duration': minutes,
                  'start': statPoint / 12,
                  'time': '$nowHour : $nowMinute',
                });
              }

              return Stack(
                children: List<Widget>.generate(list.length, (position) {
                  Map map = list[position];
                  return RotationTransition(
                    turns:
                        new AlwaysStoppedAnimation(angleForSleepProgress(map)),
                    child: CustomPaint(
                      foregroundPainter: new MyPainter(
                          lineColor: position == 0
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? AppColor.darkBackgroundColor
                                  : AppColor.backgroundColor
                              : Colors.transparent,
                          completeColor:
                              (isSelected || widget.isFromFixedCircle)
                                  ? AppColor.progressColor
                                  : getTypeWiseColor(map['Type']),
                          completePercent: (map['duration'] / (720)) * 100,
                          width: (isSelected || widget.isFromFixedCircle)
                              ? 5.h
                              : 10.h,
                          strokeCap: StrokeCap.square),
                      child: AnimatedContainer(
                        duration: Duration(
                            milliseconds:
                                Constants.homeScreenAnimationMilliseconds),
                        height: (isSelected || widget.isFromFixedCircle)
                            ? 68.h
                            : 195.h,
                        width: (isSelected || widget.isFromFixedCircle)
                            ? 68.h
                            : 195.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            }

            double value = 0;
            if (sleepModel != null) {
              int totalMinutes = sleepModel.lightTime + sleepModel.deepTime;
              value = totalMinutes / getSleepTarget();
            }
            if (value > 1) {
              value = 1;
            }
            if (value < 0) {
              value = 0;
            }

            return RotationTransition(
              turns: new AlwaysStoppedAnimation(100),
              child: CustomPaint(
                foregroundPainter: MyPainter(
                  lineColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : AppColor.backgroundColor,
                  completeColor: (!isSelected &&
                          sleepData.length == 0)
                      ? Colors.transparent
                      : AppColor.progressColor,
                  completePercent: value * 100,
                  width:
                      (!isSelected && !widget.isFromFixedCircle) ? 10.h : 5.h,
                  strokeCap: StrokeCap.square,
                ),
                child: AnimatedContainer(
                  duration: Duration(
                      milliseconds: Constants.homeScreenAnimationMilliseconds),
                  height: isSelected ? 68.h : 225.h,
                  width: isSelected ? 68.h : 225.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  SleepInfoModel trimSleep(SleepInfoModel mSleepInfo) {
    List<SleepDataInfoModel> listOfRemoveItems = [];
    List<String> strList = mSleepInfo.data.map((e) => jsonEncode(e.toMap())).toSet().toList();
    mSleepInfo.data = strList.map((e) => SleepDataInfoModel.fromMap(jsonDecode(e))).toList();

    try {
      mSleepInfo.data.forEach((element) {
        if (element.time != null && element.time.toString().isNotEmpty) {
          int firstItemHour =
              int.tryParse(element.time?.split(':')[0] ?? '') ?? 0;
          int firstItemMinute =
              int.tryParse(element.time?.split(':')[1] ?? '') ?? 0;
          DateTime current = DateTime.now();
          DateTime startDate = DateTime(
              current.year,
              current.month,
              firstItemHour > 12 ? current.day - 1 : current.day,
              firstItemHour,
              firstItemMinute);
          element.dateTime = startDate;
        }
      });

      mSleepInfo.data.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    } catch (e) {
      debugPrint('Exception at sleep_data_progress_indicator $e');
    }


    for (int i = 0; i < mSleepInfo.data.length; i++) {
      SleepDataInfoModel sleepDataInfoModel = mSleepInfo.data[i];
      if ((sleepDataInfoModel.type == '2' ||
              sleepDataInfoModel.type == '3')) {
        break;
      }
      listOfRemoveItems.add(sleepDataInfoModel);
    }
    try{
      for (int i = mSleepInfo.data.length - 1; i >= 0; i--) {
        SleepDataInfoModel sleepDataInfoModel = mSleepInfo.data[i];
        if ((sleepDataInfoModel.type == '2' ||
                sleepDataInfoModel.type == '3')) {
          break;
        }
        listOfRemoveItems.add(sleepDataInfoModel);
      }
    }catch(e){
      debugPrint('Exception at sleep_data_progress_indicator $e');
    }
    listOfRemoveItems.forEach((element) {
      mSleepInfo.data.remove(element);
    });

    mSleepInfo.stayUpTime = getTotalsFromSleepData(mSleepInfo).stayUpTime;
    mSleepInfo.lightTime = getTotalsFromSleepData(mSleepInfo).lightTime;
    mSleepInfo.deepTime = getTotalsFromSleepData(mSleepInfo).deepTime;

    return mSleepInfo;
  }

  SleepInfoModel getTotalsFromSleepData(SleepInfoModel mSleepInfo) {
    var sleepInfoModel = SleepInfoModel.clone(mSleepInfo);
    int awake = 0;
    int deep = 0;
    int light = 0;

    for (int i = 0; i < sleepInfoModel.data.length; i++) {
      var element = sleepInfoModel.data[i];
      if (element.time != null && element.time.toString().isNotEmpty) {
        int firstItemHour =
            int.tryParse(element.time?.split(':')[0] ?? '') ?? 0;
        int firstItemMinute =
            int.tryParse(element.time?.split(':')[1] ?? '') ?? 0;
        DateTime current = DateTime.now();
        DateTime startDate = DateTime(
            current.year,
            current.month,
            firstItemHour > 12 ? current.day - 1 : current.day,
            firstItemHour,
            firstItemMinute);
        element.dateTime = startDate;
      }
    }
    sleepInfoModel.data.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

    for (int i = 0; i < sleepInfoModel.data.length; i++) {
      SleepDataInfoModel model = sleepInfoModel.data[i];
      if (i == (sleepInfoModel.data.length - 1)) {
        break;
      }
      SleepDataInfoModel nextModel = sleepInfoModel.data[i + 1];
      if (model.dateTime != null) {
        switch (model.type) {
          case '2': //light sleep
            light += nextModel.dateTime!.difference(model.dateTime!).inMinutes;
            break;
          case '3': //deep sleep
            deep += nextModel.dateTime!.difference(model.dateTime!).inMinutes;
            break;
          default:
            awake += nextModel.dateTime!.difference(model.dateTime!).inMinutes;
            break;
        }
      }
    }
    sleepInfoModel.stayUpTime = awake;
    sleepInfoModel.lightTime = light;
    sleepInfoModel.deepTime = deep;
    return sleepInfoModel;
  }

  int getSleepTarget() {
    try {
      String strJson1 =
          preferences!.getString(Constants.prefSavedSleepTarget) ?? '';
      String userId = preferences!.getString(Constants.prefUserIdKeyInt) ?? '';
      if (strJson1.isNotEmpty) {
        Map map = jsonDecode(strJson1);
        if (map.containsKey('userId')) {
          if (map['userId'] == userId) {
            int hour = 8;
            int minute = 0;
            if (map.containsKey('hour')) {
              hour = map['hour'].toInt();
            }
            if (map.containsKey('minute')) {
              minute = map['minute'].toInt();
            }
            return (hour * 60) + minute;
          }
        }
      }
    } catch (e) {
      print('exception in sleep data progress indicator $e');
    }
    return 1;
  }

  angleForSleepProgress(Map map) {
    double minutes = map['start'].toDouble();
    return (minutes * 360 / 60) / 360;
  }

  getTypeWiseColor(String type) {
    switch (type) {
      case '0': //stay up all night
        break;
      case '1': //sleep
        return AppColor.deepSleepColor;
      case '2': //light sleep
        return Color(0XFF99D9D9);
      case '3': //deep sleep
        return AppColor.deepSleepColor;
      case '4': //wake up half
        break;
      case '5': //wake up
        break;
    }
    return HexColor.fromHex('#9F2DBC');
  }
}
