import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_bloc.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_event.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_state.dart';
import 'package:health_gauge/screens/chat/chat_bloc/chat_bloc.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'custom_table_calendar.dart';

class CalendarScreen extends StatefulWidget {

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDay = DateTime.now();
  late List selectdEvent;
  List eventslist = [];
  final Map<DateTime, List> events = {};
  late CalendarBloc calendarBloc;

  @override
  void initState() {
    selectdEvent = events[selectedDay] ?? [];
    calendarBloc = BlocProvider.of<CalendarBloc>(context);
    if(globalUser != null && globalUser!.userId != null ) {
      calendarBloc.add(GetCalendarEvent(int.parse(globalUser!.userId!)));
    }
    super.initState();
  }



  void _handleData(date) {
    setState(() {
      selectedDay = date;
      selectdEvent = events[selectedDay] ?? [];
    });
    print(selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.5)
                    : HexColor.fromHex('#384341').withOpacity(0.2),
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              centerTitle: true,
              title: Text('Calendar',
                  style: TextStyle(
                      color: HexColor.fromHex('#62CBC9'),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold)),
              elevation: 2,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10.w),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Theme.of(context).brightness == Brightness.dark
                    ? Image.asset(
                        'asset/dark_leftArrow.png',
                        width: 13,
                        height: 22,
                      )
                    : Image.asset(
                        'asset/leftArrow.png',
                        width: 13,
                        height: 22,
                      ),
              ),
            ),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: BlocListener(
            bloc: calendarBloc,
            listener: (context, state) {
              if (state is GetCalendarEventSuccessState) {
                events.clear();
                eventslist = state.dataModel.data!;
                for (var i = 0; i < eventslist.length; i++) {
                  var yearDate =  DateTime.fromMillisecondsSinceEpoch(int.parse(eventslist[i].startDateTimeStamp)).year;
                  var monthDate = DateTime.fromMillisecondsSinceEpoch(int.parse(eventslist[i].startDateTimeStamp)).month;
                  var dayDate =   DateTime.fromMillisecondsSinceEpoch(int.parse(eventslist[i].startDateTimeStamp)).day;
                  var eventsKey = DateTime(yearDate, monthDate, dayDate);
                  events.containsKey(eventsKey)
                      ? events[eventsKey]?.add({
                          'Name': eventslist[i].title,
                          'isDone': true,
                          'StartTime': eventslist[i].startTime,
                          'EndTime': eventslist[i].endTime,
                          'EventID': eventslist[i].setRemindersID,
                          'Color': eventslist[i].color,
                          'StartDateTimeStamp': eventslist[i].startDateTimeStamp
                        })
                      : events[eventsKey] = [
                          {
                            'Name': eventslist[i].title,
                            'isDone': true,
                            'StartTime': eventslist[i].startTime,
                            'EndTime': eventslist[i].endTime,
                            'EventID': eventslist[i].setRemindersID,
                            'Color': eventslist[i].color,
                            'StartDateTimeStamp': eventslist[i].startDateTimeStamp
                          }
                        ];
                }

              }

            },
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                if (state is GetCalendarEventSuccessState) {
                  return Calendar(
                    hideTodayIcon: true,
                    startOnMonday: false,
                    selectedColor: HexColor.fromHex('#9F2DBC'),
                    // todayColor: HexColor.fromHex('#9F2DBC'),
                    eventColor: Colors.red,
                    eventDoneColor: Colors.red,
                    onRangeSelected: (range) {
                      // print('Selected Day'${range.from},$)
                    },
                    onDateSelected: _handleData,
                    events: events,
                    hideArrows: true,
                    hideBottomBar: true,
                    isExpandable: true,
                    weekDays: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
                  );
                } else if (state is CalendarLoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Calendar(
                    hideTodayIcon: true,
                    startOnMonday: false,
                    selectedColor: HexColor.fromHex('#9F2DBC'),
                    // todayColor: HexColor.fromHex('#9F2DBC'),
                    eventColor: Colors.red,
                    eventDoneColor: Colors.red,
                    onRangeSelected: (range) {
                      // print('Selected Day'${range.from},$)
                    },
                    onDateSelected: _handleData,
                    events: events,
                    hideArrows: true,
                    hideBottomBar: true,
                    isExpandable: true,
                    weekDays: ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
