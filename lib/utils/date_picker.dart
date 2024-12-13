import 'package:flutter/material.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomCalendar/date_picker_dialog.dart';
import 'package:intl/intl.dart';

import 'gloabals.dart';

DateTime selectedDate = DateTime.now();
int date = 0;

class Date {
  final String? getDatabaseDataFrom;

  Date({this.getDatabaseDataFrom});

  Future<DateTime> selectDate(
      BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showCustomDatePicker(
      context: context,
      initialDate:
          selectedDate.isAfter(DateTime.now()) ? DateTime.now() : selectedDate,
      // firstDate: DateTime.now().subtract(Duration(days: 1)),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime.now(),
      fieldHintText: stringLocalization.getText(StringLocalization.enterDate),
      getDatabaseDataFrom: getDatabaseDataFrom ?? '',
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    return selectedDate;
  }

  Future<DateTime> selectDateForHRZone(
      BuildContext context, DateTime selectedDate) async {
    final picked = await showCustomDatePicker(
      context: context,
      initialDate:
          selectedDate.isAfter(DateTime.now()) ? DateTime.now() : selectedDate,
      firstDate: DateTime(DateTime.now().year - 1, DateTime.now().month,
          DateTime.now().day, 0, 0, 0, 0, 0),
      lastDate: DateTime.now(),
      fieldHintText: stringLocalization.getText(StringLocalization.enterDate),
      getDatabaseDataFrom: getDatabaseDataFrom ?? '',
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
    return selectedDate;
  }

  Future<DateTime> calendarSelectDate(
      BuildContext context, DateTime selectedDate) async {
    DateTime date = await showCustomDatePicker(
          context: context,
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
          // initialDate: selectedDate.isAfter(DateTime.now()) ? DateTime.now() : selectedDate,
          initialDate: selectedDate,
          fieldHintText:
              stringLocalization.getText(StringLocalization.enterDate),
          getDatabaseDataFrom: "",
        ) ??
        DateTime.now();
    print(date);
    return date;
  }

  String dateToString(DateTime date) {
    final dateFormat = new DateFormat(DateUtil.MMddyyyy);
    return dateFormat.format(date);
  }

  TimeOfDay convertDateTimeToTimeOfNow(DateTime date) {
    DateTime t = date.add(Duration(minutes: 30));
    return new TimeOfDay(hour: t.hour, minute: t.minute);
  }

  DateTime convertDateFromString(String date, {bool? temp}) {
    DateTime tempDate;
    if (temp != null && temp) {
      tempDate = DateFormat(DateUtil.yyyyMMddhhmm).parse(date);
    } else if (date.contains('T')) {
      tempDate = DateFormat(DateUtil.yyyyMMddhhtmmss).parse(date);
    } else {
      tempDate = DateFormat(DateUtil.yyyyMMddhhmmss).parse(date);
    }
    return tempDate;
  }

  DateTime convertDateFromStringForGraph(String date) {
    DateTime tempDate;
    if (date.contains('T')) {
      tempDate = DateFormat(DateUtil.yyyyMMddhhtmmss).parse(date);
    } else {
      tempDate = DateFormat(DateUtil.yyyyMMddHHmm).parse(date);
    }
    return tempDate;
  }

  String getSelectedMonthLocalization(String date) {
    if (date.isNotEmpty && date.contains('January')) {
      return stringLocalization.getText(StringLocalization.january);
    }
    if (date.isNotEmpty && date.contains('February')) {
      return stringLocalization.getText(StringLocalization.february);
    }
    if (date.isNotEmpty && date.contains('March')) {
      return stringLocalization.getText(StringLocalization.march);
    }
    if (date.isNotEmpty && date.contains('April')) {
      return stringLocalization.getText(StringLocalization.april);
    }
    if (date.isNotEmpty && date.contains('May')) {
      return stringLocalization.getText(StringLocalization.may);
    }
    if (date.isNotEmpty && date.contains('June')) {
      return stringLocalization.getText(StringLocalization.june);
    }
    if (date.isNotEmpty && date.contains('July')) {
      return stringLocalization.getText(StringLocalization.july);
    }
    if (date.isNotEmpty && date.contains('August')) {
      return stringLocalization.getText(StringLocalization.august);
    }
    if (date.isNotEmpty && date.contains('September')) {
      return stringLocalization.getText(StringLocalization.september);
    }
    if (date.isNotEmpty && date.contains('October')) {
      return stringLocalization.getText(StringLocalization.october);
    }
    if (date.isNotEmpty && date.contains('November')) {
      return stringLocalization.getText(StringLocalization.november);
    }
    if (date.isNotEmpty && date.contains('December')) {
      return stringLocalization.getText(StringLocalization.december);
    }
    return '';
  }

  DateTime convertTimeFromString(String date) {
    DateTime tempDate = new DateFormat(DateUtil.hhmm).parse(date);
    return tempDate;
  }
}
