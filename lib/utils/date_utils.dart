import 'dart:core';
import 'dart:io';

import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:intl/intl.dart';

class DateUtil {
  var dayOfWeek = 0;

  static const String yyyyMMdd = 'yyyy-MM-dd';
  static const String MMMMdyhhmmaaa = 'MMMM d, y hh:mm aaa ';
  static const String yyyyMMddHHmmss = 'yyyy-MM-dd HH:mm:ss';
  static const String MMM = 'MMM';
  static const String dd = 'dd';
  static const String ddMMM = 'dd MMM';
  static const String ddMMyyyy = 'dd/MM/yyyy';
  static const String yyyyMMddhhmm = 'yyyy-MM-dd hh:mm';
  static const String yyyyMMddhhmm_a = 'yyyy-MM-dd hh:mm a';
  static const String HHmma = 'HH:mm a';
  static const String dd_MM_yyyy = 'dd MM yyyy';
  static const String yyyyMMddhhmmss = 'yyyy-MM-dd hh:mm:ss';
  static const String hmma = 'h:mm a';
  static const String MMddyyyy = 'MM-dd-yyyy';
  static const String hhmm = 'hh:mm';
  static const String MMMddyyyy = 'MMM dd, yyyy';
  static const String EEEEMMMddhmma = 'EEEE, MMM dd h:mm a';
  static const String ddMMMMyyyy = 'dd MMMM yyyy';
  static const String MMMddhhmma = 'MMM dd - hh:mm a';
  static const String MMMMyyyy = 'MMMM yyyy';
  static const String d = 'd';
  static const String yyyyMMddkkmm = 'yyyy-MM-dd - kk:mm';
  static const String ddMMyyHHmm = 'dd-MM-yy HH:mm';
  static const String H = 'H';
  static const String m = 'm';
  static const String s = 's';
    static const String HH = 'HH';
  static const String mm = 'mm';
  static const String ss = 'ss';
  static const String MMMddyy = 'MMM dd, yy';
  static const String ddMMyyyyDashed = 'dd-MM-yyyy';
  static const String EEE = 'EEE';
  static const String yyyyMMddHHmm = 'yyyy-MM-dd HH:mm';
  static const String yyyyMMddhhtmmss = 'yyyy-MM-dd\'T\'hh:mm:ss';
  static const String calendarDateddMMyyyy = 'dd/MM/yyyy';
  static const String EEEEMMMdd = 'EEEE, MMM dd';


  yearLength(int year) {
    var yearLength = 0;

    for (var counter = 1; counter < year; counter++) {
      if (counter >= 4) {
        if (leapYear(counter) == true) {
          yearLength += 366;
        } else {
          yearLength += 365;
        }
      } else {
        yearLength += 365;
      }
    }
    return yearLength;
  }

  day(int length) {
    var day = <String>[
      'Saturday',
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday'
    ];

    var count = 0;
    String? resultDay;

    for (var counter = 1; counter <= length; counter++) {
      var check = ((counter > 639798) && (counter < 639811));
      if (check == true) {
      } else {
        if (count >= 7) {
          if (count % 7 == 0) count = 0;
        }

        resultDay = day[count];

        count++;
      }
    }

    if (count == 1) {
      dayOfWeek = 7;
    } else {
      dayOfWeek = (count - 1);
    }

    return resultDay;
  }

  month(int monthNum) {
    var month = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return month[monthNum - 1];
  }

  int daysInMonth(int monthNum, int year) {
    List monthLength = <int>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[3] = 30;
    monthLength[4] = 31;
    monthLength[5] = 30;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[8] = 30;
    monthLength[9] = 31;
    monthLength[10] = 30;
    monthLength[11] = 31;

    if (leapYear(year) == true) {
      monthLength[1] = 29;
    } else {
      monthLength[1] = 28;
    }

    return monthLength[monthNum - 1];
  }

  daysPastInYear(int monthNum, int dayNum, int year) {
    var totalMonthLength = 0;

    for (var count = 1; count < monthNum; count++) {
      totalMonthLength += daysInMonth(count, year);
    }

    var monthLengthTotal = totalMonthLength + dayNum;

    return monthLengthTotal;
  }

  totalLengthOfDays(int monthNum, int dayNum, int year) {
    return (daysPastInYear(monthNum, dayNum, year) + yearLength(year));
  }

  printMonthCalendar(int monthNum, int year) {
    var dayNum = 1;
    var strDay = <String>['Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];
    day(daysPastInYear(monthNum, 1, year) + yearLength(year));
    var dayDays = 1;

    for (var i = 0; i < 7; i++) {
      stdout.write('${strDay[i]}\t');
    }
    stdout.writeln();

    for (var i = 1; i <= 6; i++) {
      for (var j = 1; j <= 7; j++) {
        if (dayNum >= dayOfWeek) {
          if (dayDays <= daysInMonth(monthNum, year)) {
            stdout.write('$dayDays\t');
          }
          ++dayDays;
        } else if (dayNum < dayOfWeek) {
          stdout.write('\t');
        }

        dayNum++;
      }
      stdout.writeln();
    }
  }

  getWeek(int monthNum, int dayNum, int year) {
    double a = (daysPastInYear(monthNum, dayNum, year) / 7) + 1;
    return a.toInt();
  }

  leapYear(int year) {
    var leapYear = false;

    var leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true) {
      leapYear = false;
    } else if (year % 4 == 0) {
      leapYear = true;
    }

    return leapYear;
  }

  String getDateDifferenceMilli({required int milliseconds, bool show24Hours = false}) {
    var days = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - milliseconds).inDays;
    if (days < 1) {
      return stringLocalization.getText(StringLocalization.withinADay);
    } else if (days == 1) {
      return stringLocalization.getText(StringLocalization.aDayAgo);
    } else {
      return '$days ${stringLocalization.getText(StringLocalization.daysAgo)}';
    }
  }

  String getDateDifference(DateTime date, {bool show24Hours = false}) {
    var days = DateTime.now().difference(date).inDays;
    print("days_different ${days}");
    if (days < 1) {
      if(show24Hours){
        var time = DateTime.now().difference(date);
        if(DateTime.now().difference(date).inMinutes < 60) {
          return '${time.inMinutes} Mins ago';
        }
        return '${time.inHours} Hrs ago';
      }
      return stringLocalization.getText(StringLocalization.withinADay);
    } else if (days == 1) {
      return stringLocalization.getText(StringLocalization.aDayAgo);
    } else {
      return '$days ${stringLocalization.getText(StringLocalization.daysAgo)}';
    }
  }

  static DateTime? parse(var date) {
    if (date is String && date.isNotEmpty) {
      return DateTime.tryParse(date)?.toLocal();
    }
    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date).toLocal();
    }
    return null;
  }

  DateTime toLocalFromUTC({String? stringDate}) {
    if (stringDate == null) {
      return DateTime.now();
    }
    if (!stringDate.contains('Z')) {
      stringDate = stringDate + 'Z';
    }
    return DateTime.parse(stringDate).toLocal();
  }

  DateTime toUtcFromLocal({DateTime? date, String? stringDate}) {
    if (date != null) {
      return date.toUtc();
    }
    return DateTime.parse(stringDate!).toUtc();
  }

  DateTime toLocalMillisecondsFromUTC({int? date}) {
    return DateTime.fromMillisecondsSinceEpoch(date!).toLocal();
  }

  DateTime toDateFromTimestamp(String timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  }

  int getCurrentUtc() {
    var dt = DateTime.now();
    return dt.millisecondsSinceEpoch;
  }

  DateTime convertUtcToLocal(String date){
    var utcDate = DateTime.parse(date);
    var localDate =  utcDate.toLocal();
    return localDate;
  }

  String getSleepValue(var totalSleepMinutes){
    // var totalSleepMinutes = DateUtil().convertUtcToLocal(element['endTime']).difference(DateUtil().convertUtcToLocal(element['startTime'])).inMinutes.toDouble();
    // print('totalSleepMinutes ${totalSleepMinutes}');
    var sleepHours = totalSleepMinutes / 60;
    var sleepMinutes = totalSleepMinutes % 60;
    if(sleepMinutes != 0){
      return '${sleepHours.truncate()} Hrs ${sleepMinutes.truncate()} Mins';
    } else {
      return '$sleepHours Hrs';
    }
  }
  String getSleepMinitus(dynamic element){
    var totalSleepMinutes = DateUtil().convertUtcToLocal(element['endTime']).difference(DateUtil().convertUtcToLocal(element['startTime'])).inMinutes.toDouble();
    print('totalSleepMinutes ${totalSleepMinutes}');
    return '$totalSleepMinutes';

  }

  DateFormat getDateFormatter({String formatType=yyyyMMddhhmm_a}){
    return DateFormat(formatType);
  }

  String getFormattedDateTime({required DateFormat formatter,required DateTime dateTime}){
    return formatter.format(dateTime);
  }


}
