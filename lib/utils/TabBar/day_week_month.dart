import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

import 'app_tab_bar.dart';

class DayWeekMonth extends StatelessWidget {
  DayWeekMonth({
    required this.dateTime,
    required this.onPrevious,
    required this.onNext,
    required this.hTab,
    super.key,
  });

  final DateTime dateTime;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final HTab hTab;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          key: Key('weightGraphDayBackIcon'),
          icon: Image.asset(Theme.of(context).brightness == Brightness.dark
              ? 'asset/dark_left.png'
              : 'asset/left.png'),
          onPressed: onPrevious,
        ),
        Expanded(
          child: Body1AutoText(
            text: title,
            minFontSize: 8,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            align: TextAlign.center,
          ),
        ),
        IconButton(
          key: Key('weightGraphDayNextIcon'),
          icon: Image.asset(Theme.of(context).brightness == Brightness.dark
              ? 'asset/dark_right.png'
              : 'asset/right.png'),
          onPressed: onNext,
        ),
      ],
    );
  }

  String get title {
    switch (hTab) {
      case HTab.day:
        var difference = DateTime(dateTime.year, dateTime.month, dateTime.day).difference(DateTime(now.year, now.month, now.day)).inDays;
        if(difference == -1){
          return 'Yesterday';
        }
        if(difference == 0){
          return 'Today';
        }
        if(difference == 1){
          return 'Tomorrow';
        }
        return dayTitle;
      case HTab.week:
        return '${DateFormat(DateUtil.ddMMyyyy).format(firstDateWeek)} To ${DateFormat(DateUtil.ddMMyyyy).format(lastDateWeek)}';
      case HTab.month:
        return monthTitle;
      default:
        return dayTitle;
    }
  }

  String get dayTitle => DateFormat(DateUtil.ddMMyyyyDashed).format(dateTime);

  DateTime get firstDateWeek => dateTime.subtract(Duration(days: dateTime.weekday - 1));

  DateTime get lastDateWeek => dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));

  String get monthTitle => DateFormat(DateUtil.MMMMyyyy).format(dateTime);

  DateTime get now => DateTime.now();
}