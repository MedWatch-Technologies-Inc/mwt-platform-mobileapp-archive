import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/date_utils.dart';
import 'package:health_gauge/screens/calendar/add_alert.dart';
import 'package:health_gauge/screens/calendar/add_invitees.dart';
import 'package:health_gauge/screens/calendar/calendar_screen.dart';
import 'package:health_gauge/screens/calendar/edit_calendar.dart';
import 'package:health_gauge/screens/calendar/add_repeat.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_bloc.dart';
import 'package:health_gauge/screens/calendar/calendar_bloc/bloc/calendar_event.dart';
import 'package:health_gauge/screens/calendar/select_color.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/time_picker.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'custom_calendar_tile.dart';
import 'custom_container_box.dart';
import 'custom_simple_gesture_detector.dart';
import 'event_search_screen.dart';

typedef DayBuilder(BuildContext context, DateTime day);

class Range {
  final DateTime from;
  final DateTime to;
  Range(this.from, this.to);
}

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime>? onDateSelected;
  final ValueChanged<DateTime>? onMonthChanged;
  final ValueChanged? onRangeSelected;
  final bool isExpandable;
  final DayBuilder? dayBuilder;
  final bool hideArrows;
  final bool hideTodayIcon;
  final Map<DateTime, List>? events;
  final Color? selectedColor;
  final Color? todayColor;
  final Color? eventColor;
  final Color? eventDoneColor;
  final DateTime? initialDate;
  final bool isExpanded;
  final List<String> weekDays;
  final String locale;
  final bool startOnMonday;
  final bool hideBottomBar;
  final TextStyle? dayOfWeekStyle;
  final TextStyle? bottomBarTextStyle;
  final Color? bottomBarArrowColor;
  final Color? bottomBarColor;

  Calendar({
    this.onMonthChanged,
    this.onDateSelected,
    this.onRangeSelected,
    this.hideBottomBar = false,
    this.isExpandable = false,
    this.events,
    this.dayBuilder,
    this.hideTodayIcon = false,
    this.hideArrows = false,
    this.selectedColor,
    this.todayColor,
    this.eventColor,
    this.eventDoneColor,
    this.initialDate,
    this.isExpanded = false,
    this.weekDays = const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    this.locale = 'en_US',
    this.startOnMonday = false,
    this.dayOfWeekStyle,
    this.bottomBarTextStyle,
    this.bottomBarArrowColor,
    this.bottomBarColor,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  TextEditingController newEventController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  String startDate = '';
  String endDate = '';
  bool isRepeat = false;
  final calendarUtils = Utils();
  late List<DateTime> selectedMonthsDays;
  late Iterable<DateTime> selectedWeekDays;
  late DateTime _selectedDate;
  String? currentMonth;
  bool isExpanded = true;
  String displayMonth = '';
  String newDisplayMonth = '';
  String newDisplayYear = '';
  late CalendarBloc calendarBloc;

  int alertId = 1;
  int repeatId = 1;

  String alertText = 'None';
  String repeatText = 'None';
  Color selectedColor =  AppColor.colorFF6259;
  String colorName = 'Default';
  DateTime get selectedDate => _selectedDate;
  List inviteeNameList = [];
  List inviteeIdList = [];
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  // DateTime numericStartDate;

  @override
  void initState() {
    // ' ${_selectedDate.day}' +
    // ', ${_selectedDate.year}';
    calendarBloc = BlocProvider.of<CalendarBloc>(context);
    super.initState();
    print(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).toString());
    _selectedDate = widget.initialDate ?? DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

    isExpanded = true;
    selectedMonthsDays = _daysInMonth(_selectedDate);
    selectedWeekDays = [];
    // Utils.daysInRange(
    //         _firstDayOfWeek(_selectedDate), _lastDayOfWeek(_selectedDate))
    //     .toList();
    initializeDateFormatting(null).then((_) => setState(() {
          // var monthFormat =
      //     DateFormat(DateUtil.MMMMyyyy, ).format(_selectedDate);
      // displayMonth =
          //     '${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}';
      var newMonthFormat =
      DateFormat('MMMM', ).format(_selectedDate);
      var newYearFormat =
      DateFormat('yyyy', ).format(_selectedDate);

      newDisplayMonth =
      '${newMonthFormat[0].toUpperCase()}${newMonthFormat.substring(1)}';
      newDisplayYear = '$newYearFormat';
    }));
    startDate =
    '${DateFormat(DateUtil.MMMddyyyy, ).format(_selectedDate)}';
    // ' ${_selectedDate.day}' +
    // ', ${_selectedDate.year}';
    endDate =
    '${DateFormat(DateUtil.MMMddyyyy, ).format(_selectedDate)}';
    // calendarBloc.add(GetCalendarEvent(int.parse(globalUser.userId)));
  }

  Widget get nameAndIconRow {
    var todayIcon;
    var leftArrow;
    var rightArrow;

    if (!widget.hideArrows) {
      leftArrow = IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: Icon(Icons.chevron_left),
      );
      rightArrow = IconButton(
        onPressed: nextMonth,
        icon: Icon(Icons.chevron_right),
      );
    } else {
      leftArrow = Container();
      rightArrow = Container();
    }

    if (!widget.hideTodayIcon) {
      todayIcon = InkWell(
        child: Text('Today'),
        onTap: resetToToday,
      );
    } else {
      todayIcon = Container();
    }
    print(_selectedDate.year);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 32.w),
        Text(
          newDisplayMonth,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                  : HexColor.fromHex('#384341')),
        ),
        SizedBox(
          width: 5.w,
        ),
        Text(
          newDisplayYear,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                  : HexColor.fromHex('#384341')),
        ),
        SizedBox(
          width: 14.w,
        ),
        expansionButtonRow,
        Spacer(),
        IconButton(
            icon: Image.asset(
              'asset/search_icon.png',
              height: 33.h,
              width: 33.h,
            ),
            onPressed: () {
              Constants.navigatePush(
                  EventSearchScreen(events: widget.events), context);
            }),
        SizedBox(width: 25.w),
        Padding(
          padding: EdgeInsets.only(right: 33.w),
          child: GestureDetector(
            onTap: resetToToday,
            child: _selectedDate.day == DateTime.now().day &&
                    _selectedDate.month == DateTime.now().month &&
                    _selectedDate.year == DateTime.now().year
                ? Container(
                    height: 23,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#00AFAA').withOpacity(0.9)
                          : HexColor.fromHex('#00AFAA').withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#FF9E99').withOpacity(0.8)
                              : HexColor.fromHex('#9F2DBC').withOpacity(0.8),
                          spreadRadius: 0.5,
                          blurRadius: 3,
                          offset: Offset(0, 0),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#000000').withOpacity(0.25)
                              : HexColor.fromHex('#00AFAA').withOpacity(0.05),
                          spreadRadius: 5,
                          blurRadius: 6,
                          offset: Offset(10, 10),
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: ConcaveDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                          depression: 8,
                          colors: [
                            Colors.white,
                            HexColor.fromHex('#D1D9E6'),
                          ]),
                      alignment: Alignment.center,
                      padding:  EdgeInsets.symmetric(
                          horizontal: 10.w),
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? HexColor.fromHex('#9F2DBC')
                              : HexColor.fromHex('#9F2DBC'),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 23,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#00AFAA').withOpacity(0.9)
                            : HexColor.fromHex('#00AFAA').withOpacity(0.7),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                : Colors.white,
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(-5.w, -5.h),
                          ),
                          BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black.withOpacity(0.75)
                                    : HexColor.fromHex('#D1D9E6'),
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(5.w, 5.h),
                          ),
                        ]),
                    child: Container(
                      decoration: ConcaveDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                          depression: 8,
                          colors: [
                            Colors.white,
                            HexColor.fromHex('#D1D9E6'),
                          ]),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 3.5.h),
                          child: Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#111B1A')
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget get calendarGridView {
    return isExpanded
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
            child: CustomContainerBox(
              // height: 351.h,
              // width: 349.w,
              padding: EdgeInsets.zero,
              // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              child: SimpleGestureDetector(
                onSwipeLeft: _onSwipeLeft,
                onSwipeRight: _onSwipeRight,
                swipeConfig: SimpleSwipeConfig(
                  verticalThreshold: 10.0,
                  horizontalThreshold: 40.0,
                  swipeDetectionMoment: SwipeDetectionMoment.onUpdate,
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GridView.count(
                        childAspectRatio: MediaQuery.of(context).size.height /
                            MediaQuery.of(context).size.width *
                            0.7,
                        primary: false,
                        shrinkWrap: true,
                        crossAxisCount: 7,
                        padding: EdgeInsets.all(0),
                        children: calendarBuilder(),
                      ),
                    ]),
              ),
            ),
          )
        : Container();
  }

  List timeStamps = [
    'Midnight',
    '1 AM',
    '2 AM',
    '3 AM',
    '4 AM',
    '5 AM',
    '6 AM',
    '7 AM',
    '8 AM',
    '9 AM',
    '10 AM',
    '11 AM',
    'Noon',
    '1 PM',
    '2 PM',
    '3 PM',
    '4 PM',
    '5 PM',
    '6 PM',
    '7 PM',
    '8 PM',
    '9 PM',
    '10 PM',
    '11 PM',
  ];

  Widget get calendarEventView {
    DateTime now = DateTime.now();
    String currentHour = DateFormat(DateUtil.H).format(now);
    String currentMin = DateFormat(DateUtil.m).format(now);
    startDate =
    '${DateFormat(DateUtil.MMMddyyyy, ).format(_selectedDate)}';
    endDate =
    '${DateFormat(DateUtil.MMMddyyyy, ).format(_selectedDate)}';

    print(currentHour);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.h),
      child: CustomContainerBox(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 21.w, vertical: 8.h),
                    child: Text(
                      '${DateFormat('EEEE', ).format(selectedDate)} ${_selectedDate.day}',
                      style: TextStyle(
                          color: Theme.of(context).brightness ==
                                  Brightness.dark
                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                              : HexColor.fromHex('#384341'),
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 24,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          startTime = getTime(index);
                          endTime = getTime(index + 1);
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, StateSetter setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 50.0.h),
                                    child: SingleChildScrollView(
                                      child: Container(
                                        // height: 500.h,
                                        // height: 348.h,
                                        // height: heightOfBottomSheet(),
                                        padding: EdgeInsets.only(top: 10.h),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex('#111B1A')
                                                : AppColor.backgroundColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft:
                                                    Radius.circular(20.h),
                                                topRight:
                                                    Radius.circular(20.h))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 15.h),
                                              child: Align(
                                                alignment:
                                                    Alignment.topCenter,
                                                child: Container(
                                                  height: 11.h,
                                                  width: 46.w,
                                                  child: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Image.asset(
                                                          'asset/DownArrowDark.png')
                                                      : Image.asset(
                                                          'asset/downArrow.png'),
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   height: 4,
                                            //   width: 41,
                                            //   decoration: BoxDecoration(
                                            //       color: Theme.of(context)
                                            //                   .brightness ==
                                            //               Brightness.dark
                                            //           ? AppColor
                                            //               .darkBackgroundColor
                                            //           : HexColor.fromHex(
                                            //               '#D9E0E0'),
                                            //       borderRadius:
                                            //           BorderRadius.all(
                                            //               Radius.circular(
                                            //                   2.h)),
                                            //       boxShadow: [
                                            //         BoxShadow(
                                            //             color: Theme.of(context)
                                            //                         .brightness ==
                                            //                     Brightness
                                            //                         .dark
                                            //                 ? HexColor.fromHex(
                                            //                         '#000000')
                                            //                     .withOpacity(
                                            //                         0.5)
                                            //                 : Colors.black87
                                            //                     .withOpacity(
                                            //                         0.5),
                                            //             offset:
                                            //                 Offset(-1, -1))
                                            //       ]),
                                            // ),
                                            SizedBox(
                                              height: 13.h,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 21.49),
                                              child: TextFormField(
                                                controller:
                                                    newEventController,
                                                style: TextStyle(
                                                    fontSize: 20,
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
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: 'New Event',
                                                    hintStyle: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness
                                                                    .dark
                                                            ? HexColor.fromHex(
                                                                    '#FFFFFF')
                                                                .withOpacity(
                                                                    0.38)
                                                            : HexColor.fromHex(
                                                                '#7F8D8C'))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 21.49),
                                              child: TextFormField(
                                                controller:
                                                    locationController,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                                '#FFFFFF')
                                                            .withOpacity(0.87)
                                                        : HexColor.fromHex(
                                                            '#384341')),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: 'Add Location',
                                                    hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness
                                                                    .dark
                                                            ? HexColor.fromHex(
                                                                    '#FFFFFF')
                                                                .withOpacity(
                                                                    0.38)
                                                            : HexColor.fromHex(
                                                                '#7F8D8C'))),
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex(
                                                          '#FFFFFF')
                                                      .withOpacity(0.15)
                                                  : HexColor.fromHex(
                                                      '#D9E0E0'),
                                              thickness: 1,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 21.49, right: 26.88),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'All-day',
                                                    style: TextStyle(
                                                        fontSize: 14,
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
                                                  Spacer(),
                                                  CustomSwitch(
                                                    activeColor:
                                                        HexColor.fromHex(
                                                            '#00AFAA'),
                                                    inactiveTrackColor: Theme
                                                                    .of(
                                                                        context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? AppColor
                                                            .darkBackgroundColor
                                                        : HexColor.fromHex(
                                                            '#E7EBF2'),
                                                    inactiveThumbColor: Theme
                                                                    .of(
                                                                        context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                            .withOpacity(0.6)
                                                        : HexColor.fromHex(
                                                            '#D1D9E6'),
                                                    activeTrackColor: Theme.of(
                                                                    context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? AppColor
                                                            .darkBackgroundColor
                                                        : HexColor.fromHex(
                                                            '#E7EBF2'),
                                                    onChanged: (val) {
                                                      isRepeat = val;
                                                      setState(() {});
                                                    },
                                                    value: isRepeat,
                                                  )
                                                ],
                                              ),
                                            ),
                                            isRepeat
                                                ? Container()
                                                : Padding(
                                                    padding: EdgeInsets.only(left: 21.49.w, right: 26.88.w),
                                                    child: Container(
                                                      height: 160.h,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Text('Start :',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: Theme.of(context).brightness == Brightness.dark
                                                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                                                        : HexColor.fromHex('#5D6A68')),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text('Ends :',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: Theme.of(context).brightness == Brightness.dark
                                                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                                                        : HexColor.fromHex('#5D6A68')),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                'Repeat :',
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w700,
                                                                    color: Theme.of(context).brightness == Brightness.dark
                                                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                                                        : HexColor.fromHex('#5D6A68')),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                'Alert :',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Theme.of(context).brightness ==
                                                                            Brightness
                                                                                .dark
                                                                        ? HexColor.fromHex('#FFFFFF').withOpacity(
                                                                            0.6)
                                                                        : HexColor.fromHex(
                                                                            '#5D6A68')),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Material(
                                                                color : Colors.transparent,
                                                                child: InkWell(
                                                                  child: Text(
                                                                    // {DateFormat('EEEE', ).format(selectedDate)}'+ '${_selectedDate.day}
                                                                    // '${DateFormat(DateUtil.MMMddyyyy, ).format(_selectedDate)}',
                                                                    startDate,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Theme.of(context).brightness ==
                                                                                Brightness
                                                                                    .dark
                                                                            ? HexColor.fromHex('#FFFFFF').withOpacity(
                                                                                0.87)
                                                                            : HexColor.fromHex(
                                                                                '#384341')),
                                                                  ),
                                                                  onTap: () async {
                                                                    DateTime date = await Date().selectDate(context, _selectedDate);
                                                                    if (date != null) {
                                                                      startDate =
                                                                      '${DateFormat(
                                                                          DateUtil
                                                                              .MMMddyyyy,
                                                                          widget
                                                                              .locale)
                                                                          .format(
                                                                          date)}';
                                                                    }
                                                                    setState(() {});
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              InkWell(
                                                                onTap: () async{
                                                                  DateTime date = await Date().selectDate(context, _selectedDate);
                                                                  if (date != null) {
                                                                    endDate =
                                                                    '${DateFormat(
                                                                        DateUtil
                                                                            .MMMddyyyy,
                                                                        widget
                                                                            .locale)
                                                                        .format(
                                                                        date)}';
                                                                  }
                                                                  setState(() {});
                                                                  },
                                                                child: Text(
                                                                  // {DateFormat('EEEE', ).format(selectedDate)}'+ '${_selectedDate.day}
                                                                  endDate,
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w700,
                                                                      color: Theme.of(context).brightness == Brightness.dark
                                                                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                                                          : HexColor.fromHex('#384341')),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Material(
                                                                color: Colors.transparent,
                                                                child: InkWell(
                                                                  onTap: (){
                                                                    Navigator.push(context,
                                                                        MaterialPageRoute(builder: (context) => AddRepeatScreen(item: repeatId - 1,))).then(
                                                                            (value) {
                                                                              if(value != null){
                                                                                value.forEach((k,v) {
                                                                                  repeatId = k + 1;
                                                                                  repeatText = v;
                                                                                  setState((){});
                                                                                });
                                                                              }
                                                                            });
                                                                  },
                                                                  child: Text(
                                                                    repeatText,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Theme.of(context).brightness ==
                                                                                Brightness
                                                                                    .dark
                                                                            ? HexColor.fromHex('#FFFFFF').withOpacity(
                                                                                0.87)
                                                                            : HexColor.fromHex(
                                                                                '#384341')),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Material(
                                                                color: Colors.transparent,
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(context,
                                                                        MaterialPageRoute(builder: (context) => AddAlertScreen(
                                                                            time: startTime,
                                                                        item: alertId - 1,
                                                                        ))).then(
                                                                            (value){
                                                                              if(value != null){
                                                                                value.forEach((k,v) {
                                                                                  alertId = k + 1;
                                                                                  alertText = v;
                                                                                  setState((){});
                                                                                });
                                                                              }
                                                                            });
                                                                  },
                                                                  child: Text(
                                                                    alertText,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Theme.of(context).brightness ==
                                                                                Brightness.dark
                                                                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                                                            : HexColor.fromHex('#384341')),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Material(
                                                                color: Colors.transparent,
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    TimeOfDay time = await Time().selectTime(context, TimeOfDay.now());
                                                                    if (time != null) {
                                                                      startTime = DateTime(startTime.year).add(Duration(hours: time.hour, minutes:  time.minute));
                                                                    }
                                                                    setState(() {});
                                                                  },
                                                                  child: Text(
                                                                    DateFormat('h:mm a').format(DateTime.parse(startTime.toString()),),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: Theme.of(context).brightness ==
                                                                                Brightness
                                                                                    .dark
                                                                            ? HexColor.fromHex('#FFFFFF').withOpacity(
                                                                                0.87)
                                                                            : HexColor.fromHex(
                                                                                '#384341')),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Material(
                                                                color: Colors.transparent,
                                                                child: InkWell(
                                                                  onTap: () async {
                                                                    TimeOfDay time = await Time().selectTime(context, TimeOfDay.now());
                                                                    if (time != null) {
                                                                      endTime = DateTime(endTime.year).add(Duration(hours: time.hour, minutes:  time.minute));
                                                                    }
                                                                    setState(() {});
                                                                  },
                                                                  child: Text(
                                                                    DateFormat('h:mm a').format(DateTime.parse(endTime.toString()),),
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w700,
                                                                        color: Theme.of(context).brightness == Brightness.dark
                                                                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                                                            : HexColor.fromHex('#384341')),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                ' ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: HexColor
                                                                        .fromHex(
                                                                            '#384341')),
                                                              ),
                                                              SizedBox(
                                                                height: 5.h,
                                                              ),
                                                              Text(
                                                                ' ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: HexColor
                                                                        .fromHex(
                                                                            '#384341')),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            Divider(
                                              height: 1,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex(
                                                          '#FFFFFF')
                                                      .withOpacity(0.15)
                                                  : HexColor.fromHex(
                                                      '#D9E0E0'),
                                              thickness: 1,
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 21.49.w, top: 8.5.h,
                                                    ),
                                                    child: inviteeNameList.isEmpty ? Container()
                                                    : ListView.builder(
                                                        itemCount: inviteeNameList.length,
                                                        shrinkWrap: true,
                                                        padding: EdgeInsets.symmetric(vertical: 5.h),
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return Container(
                                                            height: 30.h,
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  Theme.of(context).brightness == Brightness.dark ? 'asset/dark_question_mark_icon.png' : 'asset/question_mark_icon.png',
                                                                  width: 15.h,
                                                                  height: 15.h,
                                                                ),
                                                                SizedBox(
                                                                  width: 13.51.w,
                                                                ),
                                                                Text(
                                                                  inviteeNameList[index],
                                                                  style: TextStyle(
                                                                      color: Theme.of(context).brightness == Brightness.dark ?
                                                                      HexColor.fromHex('#FFFFFF').withOpacity(0.87) :
                                                                      HexColor.fromHex('#384341'),
                                                                      fontSize: 16,
                                                                      fontWeight: FontWeight.w700),)
                                                              ],
                                                                ),
                                                          );
                                                        }
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 21.49.w,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? 'asset/dark_plus_icon_k.png'
                                                              : 'asset/plus_icon_k.png',
                                                          width: 15.h,
                                                          height: 15.h,
                                                        ),
                                                        SizedBox(
                                                          width: 13.51.w,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
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
                                                          child: Text(
                                                            'Add Invitees',
                                                            style: TextStyle(
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? HexColor.fromHex(
                                                                            '#FFFFFF')
                                                                        .withOpacity(
                                                                            0.38)
                                                                    : HexColor
                                                                        .fromHex(
                                                                            '#7F8D8C'),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 13.h,),
                                            Divider(
                                              height: 1,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex(
                                                          '#FFFFFF')
                                                      .withOpacity(0.15)
                                                  : HexColor.fromHex(
                                                      '#D9E0E0'),
                                              thickness: 1,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 21.w),
                                              child: TextFormField(
                                                controller: urlController,
                                                maxLines: 2,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                                '#FFFFFF')
                                                            .withOpacity(0.87)
                                                        : HexColor.fromHex(
                                                            '#384341')),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText: 'Add Url',
                                                    hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness
                                                                    .dark
                                                            ? HexColor.fromHex(
                                                                    '#FFFFFF')
                                                                .withOpacity(
                                                                    0.38)
                                                            : HexColor.fromHex(
                                                                '#7F8D8C'))),
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex(
                                                          '#FFFFFF')
                                                      .withOpacity(0.15)
                                                  : HexColor.fromHex(
                                                      '#D9E0E0'),
                                              thickness: 1,
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(left : 5.w),
                                                        height: 16.h,
                                                        width: 16.h,
                                                        decoration: BoxDecoration(
                                                          color: selectedColor,
                                                          shape: BoxShape.circle
                                                        ),
                                                      ),
                                                      SizedBox(width: 23.w,),
                                                      Body1Text(
                                                          text : '$colorName Color',
                                                        color: Theme.of(context).brightness == Brightness.dark ?
                                                               AppColor.white87 : AppColor.color384341,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 16.sp,
                                                      ),
                                                      Spacer(),
                                                      Image.asset('asset/mapScreenActivity/right_icon_small.png',
                                                      height: 33.w,
                                                      width: 33.w,)
                                                    ],
                                                  ),
                                                ),
                                                onTap: (){
                                                  Constants.navigatePush(
                                                      SelectColorScreen(color: selectedColor), context).then((value) {
                                                    if(value != null){
                                                      value.forEach((k,v) {
                                                        selectedColor = k;
                                                        colorName = v;
                                                        setState((){});
                                                      });
                                                    }
                                                  });
                                                },
                                              ),
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Theme.of(context)
                                                  .brightness ==
                                                  Brightness.dark
                                                  ? HexColor.fromHex(
                                                  '#FFFFFF')
                                                  .withOpacity(0.15)
                                                  : HexColor.fromHex(
                                                  '#D9E0E0'),
                                              thickness: 1,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 21.w),
                                              child: TextFormField(
                                                controller: notesController,
                                                maxLines: 5,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                                '#FFFFFF')
                                                            .withOpacity(0.87)
                                                        : HexColor.fromHex(
                                                            '#384341')),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                    hintText:
                                                        'Add Notes or Attachments',
                                                    hintStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness
                                                                    .dark
                                                            ? HexColor.fromHex(
                                                                    '#FFFFFF')
                                                                .withOpacity(
                                                                    0.38)
                                                            : HexColor.fromHex(
                                                                '#7F8D8C'))),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 25.h,
                                                  horizontal: 33.w),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: GestureDetector(
                                                        child: Container(
                                                          height: 40.h,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(30
                                                                          .h),
                                                              color: HexColor
                                                                      .fromHex(
                                                                          '#FF6259')
                                                                  .withOpacity(
                                                                      0.8),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Theme.of(context).brightness ==
                                                                          Brightness
                                                                              .dark
                                                                      ? HexColor.fromHex('#D1D9E6').withOpacity(
                                                                          0.1)
                                                                      : Colors
                                                                          .white,
                                                                  blurRadius:
                                                                      5,
                                                                  spreadRadius:
                                                                      0,
                                                                  offset:
                                                                      Offset(
                                                                          -5,
                                                                          -5),
                                                                ),
                                                                BoxShadow(
                                                                  color: Theme.of(context).brightness ==
                                                                          Brightness
                                                                              .dark
                                                                      ? Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.75)
                                                                      : HexColor.fromHex(
                                                                          '#D1D9E6'),
                                                                  blurRadius:
                                                                      5,
                                                                  spreadRadius:
                                                                      0,
                                                                  offset:
                                                                      Offset(
                                                                          5,
                                                                          5),
                                                                ),
                                                              ]),
                                                          child: Container(
                                                            decoration:
                                                                ConcaveDecoration(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(30.h),
                                                                    ),
                                                                    depression:
                                                                        10,
                                                                    colors: [
                                                                  Colors
                                                                      .white,
                                                                  HexColor.fromHex(
                                                                      '#D1D9E6'),
                                                                ]),
                                                            child: Center(
                                                              child: Text(
                                                                stringLocalization
                                                                    .getText(
                                                                        StringLocalization
                                                                            .cancel)
                                                                    .toUpperCase(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(context).brightness ==
                                                                          Brightness
                                                                              .dark
                                                                      ? HexColor.fromHex(
                                                                          '#111B1A')
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          if (context != null) {
                                                            Navigator.of(context).pop();
                                                          }
                                                        }),
                                                  ),
                                                  SizedBox(width: 17.w),
                                                  Expanded(
                                                    child: GestureDetector(
                                                        child: Container(
                                                          height: 40.h,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(30
                                                                          .h),
                                                              color: HexColor
                                                                  .fromHex(
                                                                      '#00AFAA'),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Theme.of(context).brightness ==
                                                                          Brightness
                                                                              .dark
                                                                      ? HexColor.fromHex('#D1D9E6').withOpacity(
                                                                          0.1)
                                                                      : Colors
                                                                          .white,
                                                                  blurRadius:
                                                                      5,
                                                                  spreadRadius:
                                                                      0,
                                                                  offset:
                                                                      Offset(
                                                                          -5,
                                                                          -5),
                                                                ),
                                                                BoxShadow(
                                                                  color: Theme.of(context).brightness ==
                                                                          Brightness
                                                                              .dark
                                                                      ? Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.75)
                                                                      : HexColor.fromHex(
                                                                          '#D1D9E6'),
                                                                  blurRadius:
                                                                      5,
                                                                  spreadRadius:
                                                                      0,
                                                                  offset:
                                                                      Offset(
                                                                          5,
                                                                          5),
                                                                ),
                                                              ]),
                                                          child: Container(
                                                            decoration:
                                                                ConcaveDecoration(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(30.h),
                                                                    ),
                                                                    depression:
                                                                        10,
                                                                    colors: [
                                                                  Colors
                                                                      .white,
                                                                  HexColor.fromHex(
                                                                      '#D1D9E6'),
                                                                ]),
                                                            child: Center(
                                                              child: Text(
                                                                stringLocalization
                                                                    .getText(
                                                                        StringLocalization
                                                                            .save)
                                                                    .toUpperCase(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(context).brightness ==
                                                                          Brightness
                                                                              .dark
                                                                      ? HexColor.fromHex(
                                                                          '#111B1A')
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          print((_selectedDate
                                                              .millisecondsSinceEpoch + (startTime.hour*1000*60*60)+(startTime.minute*1000*60))
                                                              .toString());
                                                          print(( _selectedDate
                                                              .millisecondsSinceEpoch + (endTime.hour*1000*60*60)+(endTime.minute*1000*60))
                                                              .toString());
                                                          if(newEventController
                                                              .text.isNotEmpty) {
                                                            calendarBloc.add(
                                                                CreateCalendarEvent(
                                                                    information: newEventController
                                                                        .text,
                                                                    startDate: '${DateFormat(
                                                                      DateUtil
                                                                          .MMddyyyy,
                                                                    )
                                                                        .format(
                                                                        _selectedDate)}',
                                                                    endDate: '${DateFormat(
                                                                      DateUtil
                                                                          .MMddyyyy,
                                                                    )
                                                                        .format(
                                                                        _selectedDate)}',
                                                                    startTime: '${DateFormat(
                                                                      'h:mm',
                                                                    )
                                                                        .format(
                                                                        startTime)}',
                                                                    endTime: '${DateFormat(
                                                                      'h:mm',
                                                                    )
                                                                        .format(
                                                                        endTime)}',
                                                                    userId: int
                                                                        .parse(
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
                                                                    alertId: alertId,
                                                                    repeatId: repeatId,
                                                                    invitedIds: inviteeIdList,
                                                                    notes: notesController
                                                                        .text,
                                                                    color: selectedColor
                                                                        .toHex(),
                                                                    startDateTimeStamp: (_selectedDate
                                                                        .millisecondsSinceEpoch +
                                                                        (startTime
                                                                            .hour *
                                                                            1000 *
                                                                            60 *
                                                                            60) +
                                                                        (startTime
                                                                            .minute *
                                                                            1000 *
                                                                            60))
                                                                        .toString(),
                                                                    endDateTimeStamp: (_selectedDate
                                                                        .millisecondsSinceEpoch +
                                                                        (endTime
                                                                            .hour *
                                                                            1000 *
                                                                            60 *
                                                                            60) +
                                                                        (endTime
                                                                            .minute *
                                                                            1000 *
                                                                            60))
                                                                        .toString()
                                                                ));

                                                            Navigator.of(
                                                                context).pop(
                                                                true);
                                                          }
                                                          else{
                                                            CustomSnackBar.buildSnackbar(context, "Please Enter Event Name", 3);
                                                          }
                                                          // Navigator.pushReplacement(
                                                          //     context,MaterialPageRoute(builder: (context)=>CaledarScreen()));
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                              }).then((value) {
                            calendarBloc.add(GetCalendarEvent(
                                int.parse(globalUser?.userId ?? '')));
                            if(value) {
                              CustomSnackBar.buildSnackbar(
                                  context, 'Event added successfully', 3);
                            }
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF')
                                      .withOpacity(0.15)
                                  : HexColor.fromHex('#D9E0E0'),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 19.w),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 18.w),
                                      child: Text(
                                        timeStamps[index],
                                        style: TextStyle(
                                            fontSize: 10,
                                            color:
                                                HexColor.fromHex('#7F8D8C')),
                                      ),
                                    ),
                                    widget.events != null &&
                                            widget.events!.isNotEmpty &&
                                            widget.events!
                                                .containsKey(_selectedDate)
                                        ? Row(children: [
                                            SizedBox(
                                              width: 65.w,
                                            ),
                                            Expanded(
                                                child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemCount: widget.events![_selectedDate]!.length,
                                              itemBuilder:
                                                  (context, innerIndex) {
                                                return index == int.parse(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.events![_selectedDate]![innerIndex]['StartDateTimeStamp'])).hour.toString())
                                                    // int.parse(widget.events![_selectedDate]!
                                                    //             [innerIndex]
                                                    //             ['StartTime']
                                                    //         .split(':')[0])
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditCalendar(eventId : widget.events![_selectedDate]![innerIndex]['EventID'])));
                                                        },
                                                        child: Container(
                                                          height: 20.h,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 7.w),
                                                          color: widget.events![_selectedDate]![innerIndex]['Color'] != null
                                                              ? HexColor.fromHex(
                                                              widget.events![_selectedDate]![innerIndex]['Color'])
                                                                  .withOpacity(
                                                                      0.2)
                                                              : HexColor.fromHex(
                                                                      '#FF6259')
                                                                  .withOpacity(
                                                                      0.2),
                                                          child: Text(
                                                              widget.events![_selectedDate]![innerIndex]['Name'].toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: HexColor
                                                                      .fromHex(
                                                                          '#CC0A00'))),
                                                        ),
                                                      )
                                                    : Container();
                                              },
                                            )),
                                          ])
                                        // Row(
                                        //         children: [
                                        //           SizedBox(
                                        //             width: 78.w,
                                        //           ),
                                        //           Expanded(
                                        //             child: Container(
                                        //               padding: EdgeInsets.only(
                                        //                   right: 15.w),
                                        //               height: 29.h,
                                        //               child: Row(
                                        //                 children: [
                                        //                   Expanded(
                                        //                     child:
                                        //                         GestureDetector(
                                        //                       onTap: () {
                                        //                         Navigator.push(
                                        //                             context,
                                        //                             MaterialPageRoute(
                                        //                                 builder:
                                        //                                     (context) =>
                                        //                                         EditCalendar()));
                                        //                       },
                                        //                       child: Container(
                                        //                         padding: EdgeInsets
                                        //                             .only(
                                        //                                 left: 4.81
                                        //                                     .w),
                                        //                         color: Theme.of(context)
                                        //                                     .brightness ==
                                        //                                 Brightness
                                        //                                     .dark
                                        //                             ? HexColor.fromHex(
                                        //                                     '#FF6259')
                                        //                                 .withOpacity(
                                        //                                     0.2)
                                        //                             : HexColor.fromHex(
                                        //                                     '#FF6259')
                                        //                                 .withOpacity(
                                        //                                     0.2),
                                        //                         child: Text(
                                        //                             widget.events[
                                        //                                     _selectedDate]
                                        //                                     [0]
                                        //                                     [
                                        //                                     'Name']
                                        //                                 .toString(),
                                        //                             style: TextStyle(
                                        //                                 fontSize:
                                        //                                     12,
                                        //                                 fontWeight:
                                        //                                     FontWeight
                                        //                                         .w700,
                                        //                                 color: HexColor
                                        //                                     .fromHex(
                                        //                                         '#FF6259'))),
                                        //                       ),
                                        //                     ),
                                        //                   ),
                                        //                   SizedBox(
                                        //                     width: 7.37.w,
                                        //                   ),
                                        //                   // Expanded(
                                        //                   //   child:
                                        //                   //       GestureDetector(
                                        //                   //     onTap: () {
                                        //                   //       Navigator.push(
                                        //                   //           context,
                                        //                   //           MaterialPageRoute(
                                        //                   //               builder:
                                        //                   //                   (context) =>
                                        //                   //                       EditCalendar()));
                                        //                   //     },
                                        //                   //     child: Container(
                                        //                   //       padding: EdgeInsets
                                        //                   //           .only(
                                        //                   //               left: 4.81
                                        //                   //                   .w),
                                        //                   //       color: Theme.of(context)
                                        //                   //                   .brightness ==
                                        //                   //               Brightness
                                        //                   //                   .dark
                                        //                   //           ? HexColor.fromHex(
                                        //                   //                   '#FF6259')
                                        //                   //               .withOpacity(
                                        //                   //                   0.2)
                                        //                   //           : HexColor.fromHex(
                                        //                   //                   '#FF6259')
                                        //                   //               .withOpacity(
                                        //                   //                   0.2),
                                        //                   //       child: Text(
                                        //                   //         'Webinar',
                                        //                   //         style: TextStyle(
                                        //                   //             fontSize:
                                        //                   //                 12,
                                        //                   //             fontWeight:
                                        //                   //                 FontWeight
                                        //                   //                     .w700,
                                        //                   //             color: HexColor
                                        //                   //                 .fromHex(
                                        //                   //                     '#FF6259')),
                                        //                   //       ),
                                        //                   //     ),
                                        //                   //   ),
                                        //                   // ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       )
                                        : Container(),
                                    timeStamps[index] ==
                                            timeStamps[int.parse(currentHour)]
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              top: 40 /
                                                  60 *
                                                  int.parse(currentMin),
                                            ),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: HexColor.fromHex(
                                                          '#9F2DBC')),
                                                ),
                                                SizedBox(width: 65.w),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(30),
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex(
                                                              '#BD78CE')
                                                          : HexColor.fromHex(
                                                              '#9F2DBC')),
                                                  height: 6.h,
                                                  width: 6.h,
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    height: 2.h,
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                            '#BD78CE')
                                                        : HexColor.fromHex(
                                                            '#9F2DBC'),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                height: 45.h,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    Iterable<DateTime> calendarDays = isExpanded ? selectedMonthsDays : selectedWeekDays;
    widget.weekDays.forEach(
      (day) {
        isExpanded
            ? dayWidgets.add(
                CalendarTile(
                  selectedColor: widget.selectedColor,
                  todayColor: widget.todayColor,
                  eventColor: widget.eventColor,
                  eventDoneColor: widget.eventDoneColor,
                  events: widget.events![day],
                  isDayOfWeek: true,
                  dayOfWeek: day,
                  dayOfWeekStyle: widget.dayOfWeekStyle ??
                      TextStyle(
                        color: widget.selectedColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                ),
              )
            : Container();
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
      (day) {
        if (day.hour > 0) {
          day = day.toLocal();
          day = day.subtract(new Duration(hours: day.hour));
        }

        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            CalendarTile(
              selectedColor: widget.selectedColor,
              todayColor: widget.todayColor,
              eventColor: widget.eventColor,
              eventDoneColor: widget.eventDoneColor,
              events: widget.events![day],
              child: this.widget.dayBuilder!(context, day),
              date: day,
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
            ),
          );
        } else {
          dayWidgets.add(
            CalendarTile(
                selectedColor: widget.selectedColor,
                todayColor: widget.todayColor,
                eventColor: widget.eventColor,
                eventDoneColor: widget.eventDoneColor,
                events: widget.events![day],
                onDateSelected: () => handleSelectedDateAndUserCallback(day),
                date: day,
                dateStyles: configureDateStyle(monthStarted, monthEnded),
                isSelected: Utils.isSameDay(selectedDate, day),
                inMonth: day.month == selectedDate.month),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    final TextStyle? body1Style = Theme.of(context).textTheme.bodyLarge;

    if (isExpanded) {
      final TextStyle body1StyleDisabled = body1Style!.copyWith(
          color: Color.fromARGB(
        100,
        body1Style.color!.red,
        body1Style.color!.green,
        body1Style.color!.blue,
      ));

      dateStyles =
          monthStarted && !monthEnded ? body1Style : body1StyleDisabled;
    } else {
      dateStyles = body1Style!;
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return GestureDetector(
        onTap: toggleExpanded,
        child: Container(
          padding: EdgeInsets.all(0),
          child: GestureDetector(
            onTap: toggleExpanded,
            child: isExpanded
                ? Image.asset('asset/up_off.png', height: 26.h, width: 26.h,)
                : Image.asset('asset/down_off.png', height: 26.h, width: 26.h,),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        nameAndIconRow,
        isExpanded
            ? ExpansionCrossFade(
                collapsed: calendarGridView,
                expanded: calendarGridView,
                isExpanded: isExpanded,
              )
            : Container(),
        SizedBox(
          height: 17.h,
        ),
        Expanded(child: calendarEventView),
        SizedBox(
          height: 17.h,
        ),
      ],
    );
  }

  void resetToToday() {
    _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var firstDayOfCurrentWeek = _firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = _lastDayOfWeek(_selectedDate);

    setState(() {
      selectedWeekDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = _daysInMonth(_selectedDate);
      // var monthFormat =
      //     DateFormat(DateUtil.MMMMyyyy, ).format(_selectedDate);
      // displayMonth =
      //     '${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}';
      var newMonthFormat =
          DateFormat('MMMM', ).format(_selectedDate);
      var newYearFormat =
          DateFormat('yyyy', ).format(_selectedDate);

      newDisplayMonth =
          '${newMonthFormat[0].toUpperCase()}${newMonthFormat.substring(1)}';
      newDisplayYear = '$newYearFormat';
    });

    _launchDateSelectionCallback(_selectedDate);
  }

  void nextMonth() {
    setState(() {
      _selectedDate = Utils.nextMonth(_selectedDate);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(_selectedDate);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = _daysInMonth(_selectedDate);
      // var monthFormat =
      //     DateFormat(DateUtil.MMMMyyyy, ).format(_selectedDate);
      // displayMonth =
      //     '${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}';
      var newMonthFormat =
          DateFormat('MMMM', ).format(_selectedDate);
      var newYearFormat =
          DateFormat('yyyy', ).format(_selectedDate);

      newDisplayMonth =
          '${newMonthFormat[0].toUpperCase()}${newMonthFormat.substring(1)}';
      newDisplayYear = '$newYearFormat';
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  DateTime getTime(int index){
    DateTime temp = DateTime(startTime.year);
    return temp.add(Duration(hours: index));
  }

  void previousMonth() {
    setState(() {
      _selectedDate = Utils.previousMonth(_selectedDate);
      var firstDateOfNewMonth = Utils.firstDayOfMonth(_selectedDate);
      var lastDateOfNewMonth = Utils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfNewMonth, lastDateOfNewMonth);
      selectedMonthsDays = _daysInMonth(_selectedDate);
      var monthFormat =
      DateFormat(DateUtil.MMMMyyyy, ).format(_selectedDate);
      displayMonth =
      '${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}';
      var newMonthFormat =
      DateFormat('MMMM', ).format(_selectedDate);
      var newYearFormat =
      DateFormat('yyyy', ).format(_selectedDate);

      newDisplayMonth =
      '${newMonthFormat[0].toUpperCase()}${newMonthFormat.substring(1)}';
      newDisplayYear = '$newYearFormat';
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  // void nextWeek() {
  //   setState(() {
  //     _selectedDate = Utils.nextWeek(_selectedDate);
  //     var firstDayOfCurrentWeek = _firstDayOfWeek(_selectedDate);
  //     var lastDayOfCurrentWeek = _lastDayOfWeek(_selectedDate);
  //     updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
  //     selectedWeekDays =
  //         Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
  //             .toList();
  //     var monthFormat =
  //         DateFormat(DateUtil.MMMMyyyy, ).format(_selectedDate);
  //     displayMonth =
  //         '${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}';
  //     var newMonthFormat =
  //         DateFormat('MMMM', ).format(_selectedDate);
  //     var newYearFormat =
  //         DateFormat('yyyy', ).format(_selectedDate);
  //     var newDayFormat =
  //         DateFormat('EEEE', ).format(_selectedDate);
  //     var newDateFormat = DateFormat('dd', ).format(_selectedDate);
  //     newDisplayDay = '$newDayFormat';
  //     newDisplayDate = '$newDateFormat';
  //     newDisplayMonth =
  //         '${newMonthFormat[0].toUpperCase()}${newMonthFormat.substring(1)}';
  //     newDisplayYear = '$newYearFormat';
  //   });
  //   _launchDateSelectionCallback(_selectedDate);
  // }

  void previousWeek() {
    var firstDayOfCurrentWeek = _firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = _lastDayOfWeek(_selectedDate);
    setState(() {
      _selectedDate = Utils.previousWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeekDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      var monthFormat =
      DateFormat(DateUtil.MMMMyyyy, ).format(_selectedDate);
      displayMonth =
      '${monthFormat[0].toUpperCase()}${monthFormat.substring(1)}';
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    Range _rangeSelected = Range(start, end);
    if (widget.onRangeSelected != null) {
      widget.onRangeSelected!(_rangeSelected);
    }
  }

  void _onSwipeRight() {
    previousMonth();
  }

  void _onSwipeLeft() {
    nextMonth();
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = _firstDayOfWeek(day);
    var lastDayOfCurrentWeek = _lastDayOfWeek(day);

    setState(() {
      _selectedDate = day;
      selectedWeekDays =
          Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek)
              .toList();
      selectedMonthsDays = _daysInMonth(day);
    });
    if (_selectedDate.month > day.month) {
      previousMonth();
    }
    if (_selectedDate.month < day.month) {
      nextMonth();
    }
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected!(day);
    }
    if (widget.onMonthChanged != null) {
      widget.onMonthChanged!(day);
    }
  }

  _firstDayOfWeek(DateTime date) {
    var day = new DateTime.utc(date.year, date.month, date.day, 12);
    return day.subtract(
        new Duration(days: day.weekday - (widget.startOnMonday ? 1 : 0)));
  }

  _lastDayOfWeek(DateTime date) {
    return _firstDayOfWeek(date).add(new Duration(days: 7));
  }

  List<DateTime> _daysInMonth(DateTime month) {
    var first = Utils.firstDayOfMonth(month);
    var daysBefore = first.weekday;
    var firstToDisplay = first
        .subtract(new Duration(days: daysBefore - 1))
        .subtract(new Duration(days: !widget.startOnMonday ? 1 : 0));
    var last = Utils.lastDayOfMonth(month);

    num daysAfter = 7 - last.weekday;

    // If the last day is sunday (7) the entire week must be rendered
    if (daysAfter == 0) {
      daysAfter = 7;
    }

    var lastToDisplay = last.add(new Duration(days: daysAfter.toInt()));
    return Utils.daysInRange(firstToDisplay, lastToDisplay).toList();
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool? isExpanded;

  ExpansionCrossFade({required this.collapsed, required this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: collapsed,
      secondChild: expanded,
      firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.decelerate,
      crossFadeState:
          isExpanded! ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }
}
