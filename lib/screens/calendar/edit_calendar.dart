import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/date_utils.dart';
import 'package:health_gauge/repository/measurement/request/add_measurement_request.dart';
import 'package:health_gauge/screens/calendar/add_alert.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_event.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/time_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_bloc.dart';
import 'package:intl/intl.dart';

import 'add_invitees.dart';
import 'custom_container_box.dart';
import 'calendar_bloc/bloc/calendar_state.dart';

class EditCalendar extends StatefulWidget {
  final int eventId;
  final String locale;
  EditCalendar({required this.eventId, this.locale='en_US'});

  @override
  _EditCalendarState createState() => _EditCalendarState();
}

class _EditCalendarState extends State<EditCalendar> {
  bool isRepeat = false;




  final calendarUtils = Utils();
  late List<DateTime> selectedMonthsDays;
  late Iterable<DateTime> selectedWeekDays;
  DateTime _selectedDate = DateTime.now();
  String? currentMonth;
  bool isExpanded = true;
  String displayMonth = '';
  String newDisplayMonth = '';
  String newDisplayYear = '';
  late CalendarBloc calendarBloc;

  @override
  void initState() {
    calendarBloc = BlocProvider.of<CalendarBloc>(context,listen: false);
    calendarBloc.isEdit = false;
    calendarBloc.add(GetCalendarEventDetails(
      userId: int.parse(globalUser?.userId ?? ''),
      eventId: widget.eventId,
    ));
    super.initState();

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
            child: BlocBuilder<CalendarBloc, CalendarState>(
              bloc: calendarBloc,
    builder: (context, state) {return AppBar(
              centerTitle: true,
              title: Text('Event',
                  style: TextStyle(
                      color: HexColor.fromHex('#62CBC9'),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold)),
              elevation: 2,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              actions: [
                IconButton(
                  icon: calendarBloc.isEdit
                      ? Theme.of(context).brightness == Brightness.dark
                          ? Image.asset(
                              'asset/dark_edit_icon_pressed.png',
                              width: 33.h,
                              height: 33.h,
                            )
                          : Image.asset(
                              'asset/edit_icon _selected.png',
                              width: 33.h,
                              height: 33.h,
                            )
                      : Theme.of(context).brightness == Brightness.dark
                          ? Image.asset(
                              'asset/dark_edit_icon.png',
                              width: 33.h,
                              height: 33.h,
                            )
                          : Image.asset(
                              'asset/new_edit_icon.png',
                              width: 33.h,
                              height: 33.h,
                            ),
                  onPressed: () {
                    calendarBloc.isEdit = !calendarBloc.isEdit;
                    setState(() {

                    });
                  },
                ),
                IconButton(
                  padding: EdgeInsets.only(right: 11.w),
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/delete_dark.png'
                        : 'asset/delete.png',
                    width: 33.h,
                    height: 33.h,
                  ),
                  onPressed: () {

                    calendarBloc.add(DeleteCalendarEvent(widget.eventId));
                  },
                )
              ],
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
            );}),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 13.w),
          child: BlocBuilder<CalendarBloc, CalendarState>(
            bloc: calendarBloc,
            builder: (context, state) {
              if(state is CalendarLoadingState){
                return Container(
                    child: Center(
                      child: CircularProgressIndicator(),)
                    );
              }

              else if(state is DeleteCalendarEvent){
                return Container(
                    child: Center(
                      child: CircularProgressIndicator(),)
                );
              }

              else if(state is DeleteCalendarSuccessState){
                calendarBloc.add(GetCalendarEvent(int.parse(globalUser?.userId ?? '')));
                Navigator.pop(context);
                return Container();
              }
              else if(state is CalendarDeleteErrorState){
                Navigator.pop(context);
                return Container();
              }

              else if(state is EditCalendarEventSuccessState){
                calendarBloc.add(GetCalendarEvent(int.parse(globalUser?.userId ?? '')));
                Navigator.pop(context);
              //  calendarBloc.add(GetCalendarEventDetails(userId: int.parse(globalUser?.userId ?? ''), eventId: widget.eventId));
                return Container();
              }

              else if (state is GetCalendarEventDetailSuccessState) {

                return Container(
                  padding: EdgeInsets.only(left: 13.w, right: 13.w, top: 22.h),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      calendarBloc.isEdit?  EditForm(state,isRepeat,widget.locale,widget.eventId): CustomContainerBox(
                    padding: EdgeInsets.zero,
                    // height: isEdit ? 524.h : 412.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.w, top: 17.h),
                          child: Container(
                            // height: 8.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  initialValue: state.dataModel.data!.information,
                                  enabled: calendarBloc.isEdit,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? HexColor.fromHex('#FFFFFF')
                                          .withOpacity(0.87)
                                          : HexColor.fromHex('#384341')),
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(0),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'New Event',
                                      hintStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).brightness ==
                                              Brightness.dark
                                              ? HexColor.fromHex('#FFFFFF')
                                              .withOpacity(0.38)
                                              : HexColor.fromHex('#7F8D8C'))),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  initialValue: state.dataModel.data!.location,
                                  enabled: calendarBloc.isEdit,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? HexColor.fromHex('#FFFFFF')
                                          .withOpacity(0.87)
                                          : HexColor.fromHex('#384341')),
                                  decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(0),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      hintText: 'Add Location',
                                      hintStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Theme.of(context).brightness ==
                                              Brightness.dark
                                              ? HexColor.fromHex('#FFFFFF')
                                              .withOpacity(0.38)
                                              : HexColor.fromHex('#7F8D8C'))),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 17.0.h),
                          child: Divider(
                            height: 1.h,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                                : HexColor.fromHex('#D9E0E0'),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 9.h,
                              // left: 20.w,
                            ),
                            child: Container(
                              // margin: EdgeInsets.symmetric(
                              //     horizontal: 5.w, vertical: 5.h),
                              // height: isEdit ? 184.h : 94.h,
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                   Padding(
                                    padding: EdgeInsets.only(
                                        left: 21.49.w, right: 26.88.w),
                                    child: Container(
                                      height: 94.h,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${DateFormat(
                                                DateUtil.EEEEMMMddhmma)
                                                .format( DateTime.fromMillisecondsSinceEpoch(int.parse(state
                                                .dataModel.data!.startDateTimeStamp!))).toString()} to ${DateFormat(
                                                'h:mm')
                                                .format( DateTime.fromMillisecondsSinceEpoch(int.parse(state
                                                .dataModel.data!.endDateTimeStamp!))).toString()}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .brightness ==
                                                    Brightness.dark
                                                    ? HexColor.fromHex(
                                                    '#FFFFFF')
                                                    .withOpacity(0.87)
                                                    : HexColor.fromHex(
                                                    '#384341')),
                                          ),
                                        state.dataModel.data!.allDay!?  Text(
                                            'Repeat Daily',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Theme.of(context)
                                                    .brightness ==
                                                    Brightness.dark
                                                    ? HexColor.fromHex(
                                                    '#FFFFFF')
                                                    .withOpacity(0.87)
                                                    : HexColor.fromHex(
                                                    '#384341')),
                                          ):Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 13.0.h),
                          child: Divider(
                            height: 1.h,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                                : HexColor.fromHex('#D9E0E0'),
                            thickness: 1,
                          ),
                        ),
                        // Container(
                        //   height:  41.h,
                        //   child: Column(
                        //     mainAxisSize: MainAxisSize.min,
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       Padding(
                        //         padding: EdgeInsets.only(
                        //           left: 21.49.w,
                        //         ),
                        //         child: Row(
                        //           children: [
                        //             Image.asset(
                        //               Theme.of(context).brightness ==
                        //                   Brightness.dark
                        //                   ? 'asset/dark_question_mark_icon.png'
                        //                   : 'asset/question_mark_icon.png',
                        //               width: 15.h,
                        //               height: 15.h,
                        //             ),
                        //             SizedBox(
                        //               width: 13.51.w,
                        //             ),
                        //             Text(
                        //               'Randy Duguay @HG',
                        //               style: TextStyle(
                        //                   color: Theme.of(context).brightness ==
                        //                       Brightness.dark
                        //                       ? HexColor.fromHex('#FFFFFF')
                        //                       .withOpacity(0.87)
                        //                       : HexColor.fromHex('#384341'),
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w700),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: 13.0.h),
                          child: Divider(
                            height: 1.h,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                                : HexColor.fromHex('#D9E0E0'),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 21.w,
                            right: 21.w,
                          ),
                          child: Container(
                            height: 153.h,
                            child: TextFormField(
                              initialValue: state.dataModel.data!.notes ?? '',
                              enabled: calendarBloc.isEdit,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).brightness ==
                                      Brightness.dark
                                      ? HexColor.fromHex('#FFFFFF')
                                      .withOpacity(0.87)
                                      : HexColor.fromHex('#384341')),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  hintText: 'Add Notes, URLS, or Attachements',
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
                                          ? HexColor.fromHex('#FFFFFF')
                                          .withOpacity(0.38)
                                          : HexColor.fromHex('#7F8D8C'))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                      ],
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          )
          ),
        ),
      );
  }


}

class EditForm extends StatefulWidget{
  final GetCalendarEventDetailSuccessState state;
  final isRepeat;
  final locale;
  final eventId;
  EditForm(this.state,this.isRepeat,this.locale,this.eventId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditForm();
  }
}

class _EditForm extends State<EditForm>{

  TextEditingController locationController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController newEventController = TextEditingController();
  String startDate = '';
  String endDate = '';
  late String startTime;
  late String endTime;
  late bool isRepeat;
  List inviteeNameList = [];
  List inviteeIdList = [];
   DateTime? _startDateTime;
 //  DateTime? _endDateTime;
  late CalendarBloc calendarBloc;
  @override
  void initState(){
    calendarBloc = BlocProvider.of<CalendarBloc>(context,listen: false);
    newEventController.text = widget.state.dataModel.data!.information!;
    locationController.text = widget.state.dataModel.data!.location!;
    urlController.text = widget.state.dataModel.data!.url!;
    notesController.text = widget.state.dataModel.data!.notes!;
   // startDate = widget.state.dataModel.data!.start!;
   // endDate = widget.state.dataModel.data!.end!;
    startTime = DateFormat(
        DateUtil.hhmm)
        .format( DateTime.fromMillisecondsSinceEpoch(int.parse(widget.state
        .dataModel.data!.startDateTimeStamp!))).toString();
    endTime =   DateFormat(
        DateUtil.hhmm)
        .format( DateTime.fromMillisecondsSinceEpoch(int.parse(widget.state
        .dataModel.data!.endDateTimeStamp!))).toString();
    isRepeat = widget.isRepeat;
    inviteeIdList = widget.state.dataModel.data!.invitedIds??[];
    startDate = DateFormat(
        DateUtil.ddMMyyyyDashed)
        .format( DateTime.fromMillisecondsSinceEpoch(int.parse(widget.state
       .dataModel.data!.startDateTimeStamp!)));
    endDate = DateFormat(
        DateUtil.ddMMyyyyDashed)
        .format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.state
        .dataModel.data!.endDateTimeStamp!)));
        // DateTime.parse(widget.state
        //     .dataModel.data!
        //     .start!));
    // endDate = DateFormat(
    //     DateUtil.ddMMyyyyDashed)
    //     .format(
    //     DateTime.parse(widget.state
    //         .dataModel.data!
    //         .end!));
   _startDateTime = DateTime(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.state
       .dataModel.data!.startDateTimeStamp!)).year,DateTime.fromMillisecondsSinceEpoch(int.parse(widget.state
       .dataModel.data!.startDateTimeStamp!)).month,DateTime.fromMillisecondsSinceEpoch(int.parse(widget.state
       .dataModel.data!.startDateTimeStamp!)).day);

       // DateTime.parse(widget.state
       // .dataModel.data!
       // .start!);
    // _endDateTime = DateTime.parse(widget.state
    //     .dataModel.data!
    //     .end!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
        bloc: calendarBloc,
        builder: (context, state) {

          if(state is EditCalendarEventSuccessState){
            calendarBloc.isEdit = false;
            calendarBloc.add(GetCalendarEventDetails(userId: int.parse(globalUser!.userId!), eventId: widget.eventId));
            return Container();
          }


         return CustomContainerBox(
      padding: EdgeInsets.zero,
      // height: isEdit ? 524.h : 412.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 17.h),
            child: Container(
              // height: 8.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: newEventController,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness ==
                            Brightness.dark
                            ? HexColor.fromHex('#FFFFFF')
                            .withOpacity(0.87)
                            : HexColor.fromHex('#384341')),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'New Event',
                        hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).brightness ==
                                Brightness.dark
                                ? HexColor.fromHex('#FFFFFF')
                                .withOpacity(0.38)
                                : HexColor.fromHex('#7F8D8C'))),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: locationController,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).brightness ==
                            Brightness.dark
                            ? HexColor.fromHex('#FFFFFF')
                            .withOpacity(0.87)
                            : HexColor.fromHex('#384341')),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Add Location',
                        hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).brightness ==
                                Brightness.dark
                                ? HexColor.fromHex('#FFFFFF')
                                .withOpacity(0.38)
                                : HexColor.fromHex('#7F8D8C'))),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 17.0.h),
            child: Divider(
              height: 1.h,
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                  : HexColor.fromHex('#D9E0E0'),
              thickness: 1,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                top: 9.h,
                // left: 20.w,
              ),
              child: Container(
                // margin: EdgeInsets.symmetric(
                //     horizontal: 5.w, vertical: 5.h),
                // height: isEdit ? 184.h : 94.h,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 21.49.w, right: 26.88.w),
                      child: Row(
                        children: [
                          Text(
                            'All-day',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context)
                                    .brightness ==
                                    Brightness.dark
                                    ? HexColor.fromHex(
                                    '#FFFFFF')
                                    .withOpacity(0.87)
                                    : HexColor.fromHex(
                                    '#384341')),
                          ),
                          Spacer(),
                          CustomSwitch(
                            activeColor:
                            HexColor.fromHex('#00AFAA'),
                            inactiveTrackColor: Theme.of(
                                context)
                                .brightness ==
                                Brightness.dark
                                ? AppColor.darkBackgroundColor
                                : HexColor.fromHex('#E7EBF2'),
                            inactiveThumbColor: Theme.of(
                                context)
                                .brightness ==
                                Brightness.dark
                                ? Colors.white.withOpacity(0.6)
                                : HexColor.fromHex('#D1D9E6'),
                            activeTrackColor: Theme.of(context)
                                .brightness ==
                                Brightness.dark
                                ? AppColor.darkBackgroundColor
                                : HexColor.fromHex('#E7EBF2'),
                            onChanged: (val) {
                              isRepeat = val;
                              setState(() {});
                            },
                            value: isRepeat,
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(
                          left: 21.49.w, right: 26.88.w),
                      child: Container(
                        // height: 115.h,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                isRepeat
                                    ? Container()
                                    : InkWell(
                                  child: Text(
                                    '${startDate}',
                                    // {DateFormat('EEEE', widget.locale).format(selectedDate)}'+ '${_selectedDate.day},
                                    //  'Mar 12, 2021',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.w700,
                                        color: Theme.of(context)
                                            .brightness ==
                                            Brightness
                                                .dark
                                            ? HexColor.fromHex(
                                            '#FFFFFF')
                                            .withOpacity(
                                            0.87)
                                            : HexColor.fromHex(
                                            '#384341')),
                                  ),
                                  onTap: () async{
                                    DateTime date = await  Date().calendarSelectDate(context, _startDateTime??DateTime.now());
                                    _startDateTime = date;
                                    if (date != null) {
                                      startDate =
                                      '${DateFormat(
                                          DateUtil
                                              .ddMMyyyyDashed,
                                          widget
                                              .locale)
                                          .format(
                                          date)}';
                                      endDate =
                                      '${DateFormat(
                                          DateUtil
                                              .ddMMyyyyDashed,
                                          widget
                                              .locale)
                                          .format(
                                          date)}';
                                    }
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                isRepeat
                                    ? Container()
                                    : InkWell(child:Text(
                                  '${endDate}',
                                  // {DateFormat('EEEE', widget.locale).format(selectedDate)}'+ '${_selectedDate.day}
                                  // 'Mar 12, 2021',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Theme.of(context)
                                          .brightness ==
                                          Brightness
                                              .dark
                                          ? HexColor.fromHex(
                                          '#FFFFFF')
                                          .withOpacity(
                                          0.87)
                                          : HexColor.fromHex(
                                          '#384341')),
                                ),
                                  onTap: ()async{
                                    DateTime date = await  Date().calendarSelectDate(context, _startDateTime??DateTime.now());
                                    if (date != null) {
                                      _startDateTime = date;
                                      endDate =
                                      '${DateFormat(
                                          DateUtil
                                              .ddMMyyyyDashed,
                                          widget
                                              .locale)
                                          .format(
                                          date)}';
                                      startDate =
                                      '${DateFormat(
                                          DateUtil
                                              .ddMMyyyyDashed,
                                          widget
                                              .locale)
                                          .format(
                                          date)}';
                                    }
                                    setState(() {});
                                  },
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  // {DateFormat('EEEE', widget.locale).format(selectedDate)}'+ '${_selectedDate.day}
                                  'Repeat Daily',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Theme.of(context)
                                          .brightness ==
                                          Brightness.dark
                                          ? HexColor.fromHex(
                                          '#FFFFFF')
                                          .withOpacity(0.87)
                                          : HexColor.fromHex(
                                          '#384341')),
                                ),
                              ],
                            ),
                            Spacer(),
                            isRepeat
                                ? Container()
                                : Column(
                              mainAxisSize:
                              MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                InkWell(
                                  child: Text(
                                    // {DateFormat('EEEE', widget.locale).format(selectedDate)}'+ '${_selectedDate.day}
                                    '${startTime}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.w700,
                                        color: Theme.of(context)
                                            .brightness ==
                                            Brightness
                                                .dark
                                            ? HexColor.fromHex(
                                            '#FFFFFF')
                                            .withOpacity(
                                            0.87)
                                            : HexColor.fromHex(
                                            '#384341')),
                                  ),
                                  onTap: () async{

                                    TimeOfDay time = await Time().selectTime(context, timeofday);
                                    if (time != null) {
                                      // startTime = time.hour.toString()+":"+time.minute.toString();
                                      DateTime date = DateTime(2022,1,1,time.hour,time.minute);
                                      startTime = DateFormat('HH:mm').format(date);
                                    }
                                    setState(() {});
                                   },
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                InkWell(child: Text(
                                  // {DateFormat('EEEE', widget.locale).format(selectedDate)}'+ '${_selectedDate.day}
                                  // '5:45 AM',
                                  '${endTime}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                      FontWeight.w700,
                                      color: Theme.of(context)
                                          .brightness ==
                                          Brightness
                                              .dark
                                          ? HexColor.fromHex(
                                          '#FFFFFF')
                                          .withOpacity(
                                          0.87)
                                          : HexColor.fromHex(
                                          '#384341')),
                                )
                                  ,onTap: ()async{
                                    TimeOfDay time = await Time().selectTime(context, timeofday);
                                    if (time != null) {
                                      print(time.period.toString());
                                     DateTime date = DateTime(2022,1,1,time.hour,time.minute);
                                      endTime = DateFormat('HH:mm').format(date);

                                    }
                                    setState(() {});
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: 13.0.h),
            child: Divider(
              height: 1.h,
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                  : HexColor.fromHex('#D9E0E0'),
              thickness: 1,
            ),
          ),
          Container(
            height:  75.h ,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 21.49.w,
                //   ),
                //   child: Row(
                //     children: [
                //       Image.asset(
                //         Theme.of(context).brightness ==
                //             Brightness.dark
                //             ? 'asset/dark_question_mark_icon.png'
                //             : 'asset/question_mark_icon.png',
                //         width: 15.h,
                //         height: 15.h,
                //       ),
                //       SizedBox(
                //         width: 13.51.w,
                //       ),
                //       Text(
                //         'Randy Duguay @HG',
                //         style: TextStyle(
                //             color: Theme.of(context).brightness ==
                //                 Brightness.dark
                //                 ? HexColor.fromHex('#FFFFFF')
                //                 .withOpacity(0.87)
                //                 : HexColor.fromHex('#384341'),
                //             fontSize: 16,
                //             fontWeight: FontWeight.w700),
                //       )
                //     ],
                //   ),
                // ),
              GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddInvitees())).then((value) {
                      if(value != null){
                        inviteeNameList.clear();
                        inviteeIdList.clear();
                        value.forEach((k,v) {
                          inviteeIdList.add(k);
                          inviteeNameList.add(v);
                        });
                        setState(() {});
                      }
                    });
                  },

                  child:  Padding(
                  padding: EdgeInsets.only(
                    left: 21.49.w,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Theme.of(context).brightness ==
                            Brightness.dark
                            ? 'asset/dark_plus_icon_k.png'
                            : 'asset/plus_icon_k.png',
                        width: 15.h,
                        height: 15.h,
                      ),
                      SizedBox(
                        width: 13.51.w,
                      ),
                      Text(
                        'Add Invitees',
                        style: TextStyle(
                            color: Theme.of(context)
                                .brightness ==
                                Brightness.dark
                                ? HexColor.fromHex('#FFFFFF')
                                .withOpacity(0.38)
                                : HexColor.fromHex('#7F8D8C'),
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ))

              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 13.0.h),
            child: Divider(
              height: 1.h,
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                  : HexColor.fromHex('#D9E0E0'),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 21.w,
              right: 21.w,
            ),
            child: Container(
              height: 153.h,
              child: TextFormField(
                controller: notesController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).brightness ==
                        Brightness.dark
                        ? HexColor.fromHex('#FFFFFF')
                        .withOpacity(0.87)
                        : HexColor.fromHex('#384341')),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Add Notes, URLS, or Attachements',
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).brightness ==
                            Brightness.dark
                            ? HexColor.fromHex('#FFFFFF')
                            .withOpacity(0.38)
                            : HexColor.fromHex('#7F8D8C'))),
              ),
            ),
          ),
          buttons()
        ],
      ),
    );},
    );
  }

  Widget buttons() {
    return BlocBuilder<CalendarBloc, CalendarState>(
        bloc: calendarBloc,
        builder: (context, state) {


          return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 33.w),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.h),
                      color: HexColor.fromHex('#FF6259').withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5, -5),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex('#D1D9E6'),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5, 5),
                        ),
                      ]),
                  child: Container(
                    decoration: ConcaveDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.h),
                        ),
                        depression: 10,
                        colors: [
                          Colors.white,
                          HexColor.fromHex('#D1D9E6'),
                        ]),
                    child: Center(
                      child: Text(
                        stringLocalization
                            .getText(StringLocalization.cancel)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {}),
          ),
          SizedBox(width: 17.w),
          Expanded(
            child: GestureDetector(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.h),
                      color: HexColor.fromHex('#00AFAA'),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5, -5),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex('#D1D9E6'),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5, 5),
                        ),
                      ]),
                  child: Container(
                    decoration: ConcaveDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.h),
                        ),
                        depression: 10,
                        colors: [
                          Colors.white,
                          HexColor.fromHex('#D1D9E6'),
                        ]),
                    child: Center(
                      child: Text(
                        stringLocalization
                            .getText(StringLocalization.save)
                            .toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  print("added edit");
                  if( newEventController
                      .text.isNotEmpty){
                  calendarBloc.add(EditCalendarEvent(
                      information: newEventController
                          .text,
                      startDate: '${startDate}',
                      endDate: '${endDate}',
                      startTime: '${
                          startTime}',
                      endTime: '${
                          endTime}',
                      userId: int.parse(
                          globalUser
                              ?.userId ??
                              ''),
                      location: locationController
                          .text,
                      url: urlController
                          .text,
                      allDayCheck: isRepeat
                          ? 1
                          : 0,
                       alertId: widget.state.dataModel.data!.alertId,
                       repeatId: widget.state.dataModel.data!.repeatId,
                       invitedIds: inviteeIdList,
                      notes: notesController
                          .text,
                      color: widget.state.dataModel.data!.color,
                      startDateTimeStamp: (_startDateTime!
                          .millisecondsSinceEpoch+(int.parse(startTime.split(':')[0])*1000*60*60)+(int.parse(startTime.split(':')[1])*1000*60))
                          .toString(),
                      endDateTimeStamp: (_startDateTime!
                          .millisecondsSinceEpoch+(int.parse(endTime.split(':')[0])*1000*60*60)+(int.parse(endTime.split(':')[1])*1000*60))
                          .toString(),
                      reminderId: widget.eventId
                  ));}
                  else{
                    CustomSnackBar.buildSnackbar(context, "Please Add Event Name First", 3);
                  }

                //  Navigator.of(context, rootNavigator: true).pop();
                  // calendarBloc.add(GetCalendarEventDetails(userId: int.parse(
                  //     globalUser
                  //         ?.userId ??
                  //         ''), eventId: widget.eventId));
                  // calendarBloc.add(GetCalendarEvent(int.parse(
                  //     globalUser
                  //         ?.userId ??
                  //         '')));
                }),
          ),
        ],
      ),
    );});
  }

}
