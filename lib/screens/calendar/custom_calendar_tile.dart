import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/date_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:intl/intl.dart';

class CalendarTile extends StatelessWidget {
  final VoidCallback? onDateSelected;
  final DateTime? date;
  final String? dayOfWeek;
  final bool? isDayOfWeek;
  final bool? isSelected;
  final bool? inMonth;
  final List? events;
  final TextStyle? dayOfWeekStyle;
  final TextStyle? dateStyles;
  final Widget? child;
  final Color? selectedColor;
  final Color? todayColor;
  final Color? eventColor;
  final Color? eventDoneColor;

  CalendarTile({
    this.onDateSelected,
    this.date,
    this.child,
    this.dateStyles,
    this.dayOfWeek,
    this.dayOfWeekStyle,
    this.isDayOfWeek = false,
    this.isSelected = false,
    this.inMonth = true,
    this.events,
    this.selectedColor,
    this.todayColor,
    this.eventColor,
    this.eventDoneColor,
  });

  Widget renderDateOrDayOfWeek(BuildContext context) {
    if (isDayOfWeek!) {
      return GestureDetector(
        child: Container(
          alignment: Alignment.center,
          child: Text(
            dayOfWeek!,
            style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                    : HexColor.fromHex('#384341'),
                fontSize: 14,
                fontWeight: FontWeight.w700),
          ),
        ),
      );
    } else {
      int eventCount = 0;
      return inMonth!
          ? GestureDetector(
              onTap: onDateSelected,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: isSelected!
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          color: selectedColor != null
                              ? Utils.isSameDay(this.date!, DateTime.now())
                                  ? HexColor.fromHex('#9F2DBC')
                                  : HexColor.fromHex('#9F2DBC')
                              : Theme.of(context).primaryColor,
                        )
                      : Utils.isSameDay(this.date!, DateTime.now())
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  HexColor.fromHex('#9F2DBC').withOpacity(0.2))
                          : BoxDecoration(),
                  // alignment: Alignment.,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 4.h,
                        height: 4.h,
                      ),
                      Text(
                        DateFormat(DateUtil.d).format(date!),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: isSelected!
                              ? Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#000000')
                                  : Colors.white
                              : Utils.isSameDay(this.date!, DateTime.now())
                                  ? todayColor
                                  : Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#FFFFFF')
                                          .withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                        ),
                      ),
                      events != null && events!.length > 0
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: events!.map((event) {
                                eventCount++;
                                if (eventCount == 3)
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.5.w),
                                    child: Image.asset(
                                      'asset/small_plus.png',
                                      width: 5.h,
                                      height: 5.h,
                                    ),
                                  );
                                else if (eventCount > 3) return Container();
                                return Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 0.5.w),
                                  width: 5.h,
                                  height: 5.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: event['isDone']
                                        ? eventDoneColor ??
                                            Theme.of(context).primaryColor
                                        : eventColor ??
                                            Theme.of(context).colorScheme.secondary,
                                  ),
                                );
                              }).toList())
                          : Container(
                              width: 5.h,
                              height: 5.h,
                            ),
                    ],
                  ),
                ),
              ),
            )
          : Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return new InkWell(
        child: child,
        onTap: onDateSelected,
      );
    }
    return new Container(
      margin: EdgeInsets.all(1.0),
      child: renderDateOrDayOfWeek(context),
    );
  }
}
