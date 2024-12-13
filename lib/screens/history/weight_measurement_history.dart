import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/screens/history/week_and_month_history_data.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/day_week_month_tab.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

import '../weight_measurement/weight_scale_result.dart';

class WeightMeasurementHistory extends StatefulWidget {
  final UserModel user; // to get details of user
  WeightMeasurementHistory({required this.user});

  @override
  _WeightMeasurementHistoryState createState() => _WeightMeasurementHistoryState();
}

class _WeightMeasurementHistoryState extends State<WeightMeasurementHistory> {
  int selectedCard = 0;

  int currentIndex = 0; // it keeps check on day, week or month
  DateTime selectedDate = DateTime.now(); // date selected by user to see history
  DateTime firstDateOfWeek = DateTime.now(); // first date of the week
  DateTime lastDateOfWeek = DateTime.now(); // last date of the week

  late String userId; // stores user ID
  List<WeightMeasurementModel> weightDataList = []; // to store list of measurements taken
  WeightScaleResult weightScaleResult = WeightScaleResult();
  List<WeightMeasurementModel> dayWeightList = []; // contains list of a day
  List<List<WeightMeasurementModel>> weightList = [];
  List<List<dynamic>> measurementDetailList = [];
  bool showLoadingScreen = true;
  bool showDetails = false;
  int currentListIndex = 0;

  bool showListDetails = false;

  int currentOuterListIndex = 0;

  //region day data

  @override
  void initState() {
    userId = widget.user.userId ?? '';
    getWeightDataFromDb(isDay: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
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
              elevation: 0,
              leading: IconButton(
                padding: EdgeInsets.only(left: 10),
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
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              title: Body1AutoText(
                text: stringLocalization.getText(StringLocalization.weightHistory),
                fontSize: 18.sp,
                color: HexColor.fromHex('62CBC9'),
                fontWeight: FontWeight.bold,
                align: TextAlign.center,
                minFontSize: 12,
                // maxLine: 1,
              ),
              centerTitle: true,
            ),
          ),
        ),
        body: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : AppColor.backgroundColor,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              DayWeekMonthTab(
                currentIndex: currentIndex,
                date: selectedValueText(),
                onTapPreviousDate: () {
                  onClickBefore();
                },
                onTapNextDate: () {
                  bool isEnable = true;
                  if (currentIndex == 0 && selectedDate.difference(DateTime.now()).inDays == 0) {
                    isEnable = false;
                  }
                  if (currentIndex == 1 && selectedDate.difference(DateTime.now()).inDays == 0) {
                    isEnable = false;
                  }
                  if (currentIndex == 2 &&
                      (selectedDate.difference(DateTime.now()).inDays >= 0 ||
                          (selectedDate.year == DateTime.now().year &&
                              selectedDate.month == DateTime.now().month))) {
                    isEnable = false;
                  }
                  if (isEnable) onClickNext();
                },
                onTapDay: () async {
                  currentIndex = 0;
                  getWeightDataFromDb(isDay: true);
                },
                onTapWeek: () async {
                  currentIndex = 1;
                  selectWeek(selectedDate);
                  getWeightDataFromDb(isWeek: true);
                },
                onTapMonth: () async {
                  var currentTime = DateTime.now();
                  if (selectedDate.year == currentTime.year &&
                      selectedDate.month - currentTime.month > 0) {
                    selectedDate = currentTime;
                  }
                  currentIndex = 2;
                  getWeightDataFromDb(isMonth: true);
                },
                onTapCalendar: () async {
                  selectedDate =
                      await Date(getDatabaseDataFrom: 'Weight').selectDate(context, selectedDate);
                  selectWeek(selectedDate);
                  getWeightDataFromDb(
                    isDay: currentIndex == 0 ? true : false,
                    isWeek: currentIndex == 1 ? true : false,
                    isMonth: currentIndex == 2 ? true : false,
                  );
                },
              ),
              Expanded(
                child: currentIndex == 0
                    ? dayWeightList.isNotEmpty
                        ? ListView.builder(
                            itemCount: dayWeightList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (showDetails && currentListIndex == index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 13.w,
                                      right: 13.w,
                                      top: 16.h,
                                      bottom: index == dayWeightList.length - 1 ? 16.h : 0.0),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? HexColor.fromHex('#111B1A')
                                          : AppColor.backgroundColor,
                                      borderRadius: BorderRadius.circular(10.h),
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
                                              : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                          blurRadius: 5,
                                          spreadRadius: 0,
                                          offset: Offset(5, 5),
                                        ),
                                      ]),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 56.h,
                                          padding: EdgeInsets.symmetric(vertical: 13.h),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? HexColor.fromHex('#111B1A')
                                                  : AppColor.backgroundColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10.h),
                                                  topRight: Radius.circular(10.h)),
                                              gradient:
                                                  Theme.of(context).brightness == Brightness.dark
                                                      ? LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [
                                                              HexColor.fromHex('#CC0A00')
                                                                  .withOpacity(0.15),
                                                              HexColor.fromHex('#9F2DBC')
                                                                  .withOpacity(0.15),
                                                            ])
                                                      : LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [
                                                              HexColor.fromHex('#FF9E99')
                                                                  .withOpacity(0.1),
                                                              HexColor.fromHex('#9F2DBC')
                                                                  .withOpacity(0.023),
                                                            ])),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: 20.w),
                                                child: SizedBox(
                                                  width: 86.w,
                                                  height: 30.h,
                                                  child: Body1Text(
                                                    text: getWeightText(index, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? Colors.white.withOpacity(0.87)
                                                        : HexColor.fromHex('384341'),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(right: 14.w),
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Body1Text(
                                                          text: DateFormat(DateUtil.MMMddhhmma)
                                                              .format(DateTime.parse(
                                                                  dayWeightList[index]
                                                                      .date
                                                                      .toString())),
                                                          fontSize: 14,
                                                          color: Theme.of(context).brightness ==
                                                                  Brightness.dark
                                                              ? Colors.white.withOpacity(0.87)
                                                              : HexColor.fromHex('384341'),
                                                        ),
                                                        SizedBox(
                                                          width: 13.w,
                                                        ),
                                                        Image.asset(
                                                          'asset/up_icon_small.png',
                                                          height: 26.h,
                                                          width: 26.h,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          showDetails = false;
                                          setState(() {});
                                        },
                                      ),
                                      measurementDetailList.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: measurementDetailList.length,
                                              shrinkWrap: true,
                                              physics: NeverScrollableScrollPhysics(),
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: index ==
                                                                measurementDetailList.length - 1
                                                            ? BorderRadius.only(
                                                                bottomLeft: Radius.circular(10.h),
                                                                bottomRight: Radius.circular(10.h))
                                                            : BorderRadius.circular(0.0),
                                                      ),
                                                      height: 52.5.h,
                                                      child: Row(children: [
                                                        Expanded(
                                                          child: Image.asset(
                                                            measurementDetailList[index][0],
                                                            height: 33.h,
                                                            width: 33.h,
                                                          ),
                                                          flex: 2,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(left: 5.w),
                                                            child: Body1AutoText(
                                                                text: measurementDetailList[index]
                                                                    [1],
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness.dark
                                                                    ? Colors.white.withOpacity(0.8)
                                                                    : HexColor.fromHex('#384341'),
                                                                fontSize: 16.sp,
                                                                minFontSize: 10
                                                                // maxLine: 1,
                                                                ),
                                                          ),
                                                          flex: 5,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(right: 25.w),
                                                            child: Body1AutoText(
                                                              text: measurementDetailList[index][2],
                                                              color: Theme.of(context).brightness ==
                                                                      Brightness.dark
                                                                  ? Colors.white.withOpacity(0.8)
                                                                  : HexColor.fromHex('#384341'),
                                                              fontSize: 16.sp,
                                                              fontWeight: FontWeight.bold,
                                                              align: TextAlign.right,
                                                              minFontSize: 6,
                                                            ),
                                                          ),
                                                          flex: 3,
                                                        ),
                                                      ]),
                                                    ),
                                                    index == measurementDetailList.length - 1
                                                        ? Container()
                                                        : Container(
                                                            height: 1.h,
                                                            color: Theme.of(context).brightness ==
                                                                    Brightness.dark
                                                                ? Colors.white.withOpacity(0.15)
                                                                : HexColor.fromHex('D9E0E0'),
                                                          )
                                                  ],
                                                );
                                              })
                                          : Container()
                                    ],
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 13.w,
                                        right: 13.w,
                                        top: 16.h,
                                        bottom: index == dayWeightList.length - 1 ? 16.h : 0.0),
                                    height: 56.h,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? HexColor.fromHex('#111B1A')
                                            : AppColor.backgroundColor,
                                        borderRadius: BorderRadius.circular(10.h),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                                : Colors.white,
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(-4, -4),
                                          ),
                                          BoxShadow(
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.black.withOpacity(0.75)
                                                : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(4, 4),
                                          ),
                                        ]),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 13.h),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? HexColor.fromHex('#111B1A')
                                              : AppColor.backgroundColor,
                                          borderRadius: BorderRadius.circular(10.h),
                                          gradient: Theme.of(context).brightness == Brightness.dark
                                              ? LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                      HexColor.fromHex('#CC0A00').withOpacity(0.15),
                                                      HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                                    ])
                                              : LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                      HexColor.fromHex('#FF9E99').withOpacity(0.1),
                                                      HexColor.fromHex('#9F2DBC')
                                                          .withOpacity(0.023),
                                                    ])),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 20.w),
                                            child: SizedBox(
                                              width: 86.w,
                                              height: 30.h,
                                              child: Body1Text(
                                                text: getWeightText(index, 0),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.white.withOpacity(0.87)
                                                        : HexColor.fromHex('384341'),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(right: 14.w),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Body1Text(
                                                      text: DateFormat(DateUtil.MMMddhhmma).format(
                                                          DateTime.parse(dayWeightList[index]
                                                              .date
                                                              .toString())),
                                                      fontSize: 14,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? Colors.white.withOpacity(0.87)
                                                          : HexColor.fromHex('384341'),
                                                    ),
                                                    SizedBox(
                                                      width: 13.w,
                                                    ),
                                                    Image.asset(
                                                      'asset/down_icon_small.png',
                                                      height: 26.h,
                                                      width: 26.h,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    showDetails = true;
                                    currentListIndex = index;
                                    measurementDetailList = updateDetailList(dayWeightList[index]);
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                );
                              }
                            })
                        : Container(
                            margin: EdgeInsets.only(top: 100.h),
                            child: Body1Text(
                              text: stringLocalization.getText(
                                StringLocalization.noDataFound,
                              ),
                              fontSize: 16,
                            ),
                          )
                    : weightList.isNotEmpty
                        ? ListView.builder(
                            itemCount: weightList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 13.w,
                                    right: 13.w,
                                    top: 16.h,
                                    bottom: index == weightList.length - 1 ? 16.h : 0.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                        : AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(10.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                            : Colors.white,
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: Offset(-4, -4),
                                      ),
                                      BoxShadow(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.black.withOpacity(0.75)
                                            : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                        offset: Offset(4, 4),
                                      ),
                                    ]),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      child: Container(
                                        height: 56.h,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? HexColor.fromHex('#111B1A')
                                                : AppColor.backgroundColor,
                                            borderRadius: BorderRadius.circular(10.h),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                                    : Colors.white,
                                                blurRadius: 5,
                                                spreadRadius: 0,
                                                offset: Offset(-5, -5),
                                              ),
                                              BoxShadow(
                                                color: Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.black.withOpacity(0.75)
                                                    : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                                blurRadius: 5,
                                                spreadRadius: 0,
                                                offset: Offset(5, 5),
                                              ),
                                            ]),
                                        child: Container(
                                          height: 56.h,
                                          padding: EdgeInsets.symmetric(vertical: 13.h),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? HexColor.fromHex('#111B1A')
                                                  : AppColor.backgroundColor,
                                              borderRadius: BorderRadius.circular(10.h),
                                              gradient:
                                                  Theme.of(context).brightness == Brightness.dark
                                                      ? LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [
                                                              HexColor.fromHex('#CC0A00')
                                                                  .withOpacity(0.15),
                                                              HexColor.fromHex('#9F2DBC')
                                                                  .withOpacity(0.15),
                                                            ])
                                                      : LinearGradient(
                                                          begin: Alignment.topCenter,
                                                          end: Alignment.bottomCenter,
                                                          colors: [
                                                              HexColor.fromHex('#FF9E99')
                                                                  .withOpacity(0.1),
                                                              HexColor.fromHex('#9F2DBC')
                                                                  .withOpacity(0.023),
                                                            ])),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(left: 20.w),
                                                  child: Body1Text(
                                                    text: DateFormat(DateUtil.MMMddyyyy).format(
                                                        DateTime.parse(
                                                            weightList[index][0].date.toString())),
                                                    fontSize: 16.sp,
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? Colors.white.withOpacity(0.87)
                                                        : HexColor.fromHex('384341'),
                                                    fontWeight: FontWeight.bold,
                                                    align: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(right: 14.w),
                                                child: Image.asset(
                                                  showListDetails && currentOuterListIndex == index
                                                      ? 'asset/up_icon_small.png'
                                                      : 'asset/down_icon_small.png',
                                                  height: 26.h,
                                                  width: 26.h,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (currentOuterListIndex != index ||
                                            (currentOuterListIndex == index && !showListDetails)) {
                                          showListDetails = true;
                                          currentOuterListIndex = index;
                                          setState(() {});
                                        } else {
                                          showListDetails = false;
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    showListDetails && currentOuterListIndex == index
                                        ? SizedBox(
                                            height: 16.h,
                                          )
                                        : Container(),
                                    Visibility(
                                      visible: showListDetails && currentOuterListIndex == index,
                                      child: ListView.builder(
                                          itemCount: weightList[index].length,
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int innerIndex) {
                                            if (showDetails && currentListIndex == innerIndex) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    left: 13.w,
                                                    right: 13.w,
                                                    top: 16.h,
                                                    bottom:
                                                        innerIndex == weightList[index].length - 1
                                                            ? 16.h
                                                            : 0.0),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex('#111B1A')
                                                        : AppColor.backgroundColor,
                                                    borderRadius: BorderRadius.circular(10.h),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? HexColor.fromHex('#D1D9E6')
                                                                .withOpacity(0.1)
                                                            : Colors.white,
                                                        blurRadius: 5,
                                                        spreadRadius: 0,
                                                        offset: Offset(-5, -5),
                                                      ),
                                                      BoxShadow(
                                                        color: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? Colors.black.withOpacity(0.75)
                                                            : HexColor.fromHex('#9F2DBC')
                                                                .withOpacity(0.15),
                                                        blurRadius: 5,
                                                        spreadRadius: 0,
                                                        offset: Offset(5, 5),
                                                      ),
                                                    ]),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                      child: Container(
                                                        height: 56.h,
                                                        padding:
                                                            EdgeInsets.symmetric(vertical: 13.h),
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(context).brightness ==
                                                                    Brightness.dark
                                                                ? HexColor.fromHex('#111B1A')
                                                                : AppColor.backgroundColor,
                                                            borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(10.h),
                                                                topRight: Radius.circular(10.h)),
                                                            gradient: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness.dark
                                                                ? LinearGradient(
                                                                    begin: Alignment.topCenter,
                                                                    end: Alignment.bottomCenter,
                                                                    colors: [
                                                                        HexColor.fromHex('#CC0A00')
                                                                            .withOpacity(0.15),
                                                                        HexColor.fromHex('#9F2DBC')
                                                                            .withOpacity(0.15),
                                                                      ])
                                                                : LinearGradient(
                                                                    begin: Alignment.topCenter,
                                                                    end: Alignment.bottomCenter,
                                                                    colors: [
                                                                        HexColor.fromHex('#FF9E99')
                                                                            .withOpacity(0.1),
                                                                        HexColor.fromHex('#9F2DBC')
                                                                            .withOpacity(0.023),
                                                                      ])),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(left: 20.w),
                                                              child: SizedBox(
                                                                width: 86.w,
                                                                height: 30.h,
                                                                child: Body1Text(
                                                                  text: getWeightText(
                                                                      index, innerIndex),
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Theme.of(context)
                                                                              .brightness ==
                                                                          Brightness.dark
                                                                      ? Colors.white
                                                                          .withOpacity(0.87)
                                                                      : HexColor.fromHex('384341'),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.only(right: 14.w),
                                                                child: Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment.end,
                                                                    children: [
                                                                      Body1Text(
                                                                        text: DateFormat(
                                                                                DateUtil.MMMddhhmma)
                                                                            .format(DateTime.parse(
                                                                                weightList[index]
                                                                                        [innerIndex]
                                                                                    .date
                                                                                    .toString())),
                                                                        fontSize: 14,
                                                                        color: Theme.of(context)
                                                                                    .brightness ==
                                                                                Brightness.dark
                                                                            ? Colors.white
                                                                                .withOpacity(0.87)
                                                                            : HexColor.fromHex(
                                                                                '384341'),
                                                                      ),
                                                                      SizedBox(
                                                                        width: 13.w,
                                                                      ),
                                                                      Image.asset(
                                                                        'asset/up_icon_small.png',
                                                                        height: 26.h,
                                                                        width: 26.h,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        showDetails = false;
                                                        setState(() {});
                                                      },
                                                    ),
                                                    measurementDetailList.isNotEmpty
                                                        ? ListView.builder(
                                                            itemCount: measurementDetailList.length,
                                                            shrinkWrap: true,
                                                            physics: NeverScrollableScrollPhysics(),
                                                            itemBuilder: (BuildContext context,
                                                                int detailIndex) {
                                                              return Column(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: detailIndex ==
                                                                              measurementDetailList
                                                                                      .length -
                                                                                  1
                                                                          ? BorderRadius.only(
                                                                              bottomLeft:
                                                                                  Radius.circular(
                                                                                      10.h),
                                                                              bottomRight:
                                                                                  Radius.circular(
                                                                                      10.h))
                                                                          : BorderRadius.circular(
                                                                              0.0),
                                                                    ),
                                                                    height: 52.5.h,
                                                                    child: Row(children: [
                                                                      Expanded(
                                                                        child: Image.asset(
                                                                          measurementDetailList[
                                                                              detailIndex][0],
                                                                          height: 33.h,
                                                                          width: 33.h,
                                                                        ),
                                                                        flex: 2,
                                                                      ),
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left: 5.w),
                                                                          child: Body1AutoText(
                                                                              text: measurementDetailList[
                                                                                  detailIndex][1],
                                                                              color: Theme.of(context)
                                                                                          .brightness ==
                                                                                      Brightness
                                                                                          .dark
                                                                                  ? Colors.white
                                                                                      .withOpacity(
                                                                                          0.8)
                                                                                  : HexColor.fromHex(
                                                                                      '#384341'),
                                                                              fontSize: 16.sp,
                                                                              minFontSize: 10
                                                                              // maxLine: 1,
                                                                              ),
                                                                        ),
                                                                        flex: 5,
                                                                      ),
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.only(
                                                                              right: 25.w),
                                                                          child: Body1AutoText(
                                                                            text:
                                                                                measurementDetailList[
                                                                                    detailIndex][2],
                                                                            color: Theme.of(context)
                                                                                        .brightness ==
                                                                                    Brightness.dark
                                                                                ? Colors.white
                                                                                    .withOpacity(
                                                                                        0.8)
                                                                                : HexColor.fromHex(
                                                                                    '#384341'),
                                                                            fontSize: 16.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            align: TextAlign.right,
                                                                            minFontSize: 6,
                                                                          ),
                                                                        ),
                                                                        flex: 3,
                                                                      ),
                                                                    ]),
                                                                  ),
                                                                  detailIndex ==
                                                                          measurementDetailList
                                                                                  .length -
                                                                              1
                                                                      ? Container()
                                                                      : Container(
                                                                          height: 1.h,
                                                                          color: Theme.of(context)
                                                                                      .brightness ==
                                                                                  Brightness.dark
                                                                              ? Colors.white
                                                                                  .withOpacity(0.15)
                                                                              : HexColor.fromHex(
                                                                                  'D9E0E0'),
                                                                        )
                                                                ],
                                                              );
                                                            },
                                                          )
                                                        : Container()
                                                  ],
                                                ),
                                              );
                                            } else {
                                              return GestureDetector(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 13.w,
                                                      right: 13.w,
                                                      top: 16.h,
                                                      bottom:
                                                          innerIndex == weightList[index].length - 1
                                                              ? 16.h
                                                              : 0.0),
                                                  height: 56.h,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#111B1A')
                                                          : AppColor.backgroundColor,
                                                      borderRadius: BorderRadius.circular(10.h),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Theme.of(context).brightness ==
                                                                  Brightness.dark
                                                              ? HexColor.fromHex('#D1D9E6')
                                                                  .withOpacity(0.1)
                                                              : Colors.white,
                                                          blurRadius: 4,
                                                          spreadRadius: 0,
                                                          offset: Offset(-4, -4),
                                                        ),
                                                        BoxShadow(
                                                          color: Theme.of(context).brightness ==
                                                                  Brightness.dark
                                                              ? Colors.black.withOpacity(0.75)
                                                              : HexColor.fromHex('#9F2DBC')
                                                                  .withOpacity(0.15),
                                                          blurRadius: 4,
                                                          spreadRadius: 0,
                                                          offset: Offset(4, 4),
                                                        ),
                                                      ]),
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 13.h),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? HexColor.fromHex('#111B1A')
                                                            : AppColor.backgroundColor,
                                                        borderRadius: BorderRadius.circular(10.h),
                                                        gradient: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? LinearGradient(
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                                colors: [
                                                                    HexColor.fromHex('#CC0A00')
                                                                        .withOpacity(0.15),
                                                                    HexColor.fromHex('#9F2DBC')
                                                                        .withOpacity(0.15),
                                                                  ])
                                                            : LinearGradient(
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                                colors: [
                                                                    HexColor.fromHex('#FF9E99')
                                                                        .withOpacity(0.1),
                                                                    HexColor.fromHex('#9F2DBC')
                                                                        .withOpacity(0.023),
                                                                  ])),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: EdgeInsets.only(left: 20.w),
                                                          child: SizedBox(
                                                            width: 86.w,
                                                            height: 30.h,
                                                            child: Body1Text(
                                                              text:
                                                                  getWeightText(index, innerIndex),
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: Theme.of(context).brightness ==
                                                                      Brightness.dark
                                                                  ? Colors.white.withOpacity(0.87)
                                                                  : HexColor.fromHex('384341'),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding: EdgeInsets.only(right: 14.w),
                                                            child: Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment.end,
                                                                children: [
                                                                  Body1Text(
                                                                    text: DateFormat(
                                                                            DateUtil.MMMddhhmma)
                                                                        .format(DateTime.parse(
                                                                            weightList[index]
                                                                                    [innerIndex]
                                                                                .date
                                                                                .toString())),
                                                                    fontSize: 14,
                                                                    color: Theme.of(context)
                                                                                .brightness ==
                                                                            Brightness.dark
                                                                        ? Colors.white
                                                                            .withOpacity(0.87)
                                                                        : HexColor.fromHex(
                                                                            '384341'),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 13.w,
                                                                  ),
                                                                  Image.asset(
                                                                    'asset/down_icon_small.png',
                                                                    height: 26.h,
                                                                    width: 26.h,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  showDetails = true;
                                                  currentListIndex = innerIndex;
                                                  measurementDetailList = updateDetailList(
                                                      weightList[index][innerIndex]);
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                },
                                              );
                                            }
                                          }),
                                    )
                                  ],
                                ),
                              );
                            })
                        : Container(
                            margin: EdgeInsets.only(top: 100.h),
                            child: Body1Text(
                              text: stringLocalization.getText(
                                StringLocalization.noDataFound,
                              ),
                              fontSize: 16,
                            ),
                          ),
              )
            ],
          ),
        ));
  }

  onClickBefore() async {
    switch (currentIndex) {
      case 0:
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1);
        getWeightDataFromDb(isDay: true);
        break;
      case 1:
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 7);
        selectWeek(selectedDate);
        getWeightDataFromDb(isWeek: true);
        break;
      case 2:
        selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
        getWeightDataFromDb(isMonth: true);
        break;
    }
  }

  onClickNext() async {
    switch (currentIndex) {
      case 0:
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
        getWeightDataFromDb(isDay: true);
        break;
      case 1:
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 7);
        selectWeek(selectedDate);
        getWeightDataFromDb(isWeek: true);
        break;
      case 2:
        selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);
        getWeightDataFromDb(isMonth: true);
        break;
    }
  }

  selectedValueText() {
    if (currentIndex == 0) {
      return txtSelectedDate();
    } else if (currentIndex == 1) {
      String first = DateFormat(DateUtil.ddMMyyyy).format(firstDateOfWeek);
      String last = DateFormat(DateUtil.ddMMyyyy).format(lastDateOfWeek);
      return '$first   to   $last';
    } else if (currentIndex == 2) {
      String date = DateFormat(DateUtil.MMMMyyyy).format(selectedDate);
      String year = date.split(' ')[1];
      date = Date().getSelectedMonthLocalization(date) + ' $year';
      return '$date';
    }
  }

  String txtSelectedDate() {
    String title = DateFormat(DateUtil.ddMMyyyyDashed).format(selectedDate);

    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final selected = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selected == today) {
      title = StringLocalization.of(context).getText(StringLocalization.today);
    } else if (selected == yesterday) {
      title = StringLocalization.of(context).getText(StringLocalization.yesterday);
    } else if (selected == tomorrow) {
      title = StringLocalization.of(context).getText(StringLocalization.tomorrow);
    }
    return '$title';
  }

  selectWeek(DateTime selectedDate) {
    var dayNr = (selectedDate.weekday + 7) % 7;

    firstDateOfWeek = selectedDate.subtract(new Duration(days: (dayNr)));

    lastDateOfWeek = firstDateOfWeek.add(new Duration(days: 6));
  }

  getWeightDataFromDb({bool? isDay, bool? isWeek, bool? isMonth}) async {
    showDetails = false;
    weightList.clear();
    dayWeightList.clear();

    late DateTime startDate;
    late DateTime endDate;
    if (isDay != null && isDay) {
      startDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      endDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
    } else if (isWeek != null && isWeek) {
      startDate = DateTime(firstDateOfWeek.year, firstDateOfWeek.month, firstDateOfWeek.day);
      endDate = DateTime(lastDateOfWeek.year, lastDateOfWeek.month, lastDateOfWeek.day + 1);
    } else if (isMonth != null && isMonth) {
      startDate = DateTime(selectedDate.year, selectedDate.month, 1);
      endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
      endDate = endDate.add(Duration(days: 1));
    }

    String? strFirst = DateFormat(DateUtil.yyyyMMdd).format(startDate);
    String? strLast = DateFormat(DateUtil.yyyyMMdd).format(endDate);
    await dbHelper
        .getWeightData(userId, strFirst, strLast)
        ?.then((List<WeightMeasurementModel> weightMeasurementModelList) {
      if (weightMeasurementModelList.isNotEmpty) {
        dayWeightList = weightMeasurementModelList;
      }
    });

    var list = <List<WeightMeasurementModel>>[];
    try {
      if (dayWeightList.isNotEmpty) {
        list = WeekAndMonthHistoryData(distinctList: dayWeightList).getWeightData();
      }
    } catch (e) {
      LoggingService().printLog(tag: 'weight history screen', message: e.toString());
    }
    weightList = list;

    if (mounted) {
      setState(() {});
    }
  }

  String getWeightText(int index, int innerIndex) {
    var weight = 0.0;
    if (currentIndex == 0) {
      weight = dayWeightList[index].weightSum ?? 0.0;
    } else {
      weight = weightList[index][innerIndex].weightSum ?? 0.0;
    }

    if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
      // weight = weight * 2.205;
      weight = weight * 2.20462;
      return '${weight.toStringAsFixed(1)} ${stringLocalization.getText(StringLocalization.lb).toUpperCase()}';
    }
    return '${weight.toStringAsFixed(1)} ${stringLocalization.getText(StringLocalization.kg).toUpperCase()}';
  }

  List<List<dynamic>> updateDetailList(WeightMeasurementModel data) {
    var tempWeightList = <List<dynamic>>[];
    if (data.bMI != null && data.bMI != 0.0) {
      tempWeightList.add([
        'asset/bmi_icon.png',
        'Body Mass Index',
        data.bMI!.toStringAsFixed(2),
      ]);
    }
    if (data.fatRate != null && data.fatRate != 0.0) {
      tempWeightList.add([
        'asset/bfr_icon.png',
        'Body Fat Ratio',
        '${data.fatRate!.toStringAsFixed(2)}%',
      ]);
    }
    if (data.muscle != null && data.muscle != 0.0) {
      tempWeightList.add([
        'asset/muscleRate.png',
        'Muscle Rate',
        '${data.muscle!.toStringAsFixed(2)}%',
      ]);
    }
    if (data.moisture != null && data.moisture != 0.0) {
      tempWeightList.add([
        'asset/bodyWater.png',
        'Body Water',
        '${data.moisture!.toStringAsFixed(2)}%',
      ]);
    }
    if (data.boneMass != null && data.boneMass != 0.0) {
      tempWeightList.add([
        'asset/boneMass.png',
        'Bone Mass',
        '${data.boneMass!.toStringAsFixed(2)}kg',
      ]);
    }
    if (data.bMR != null && data.bMR != 0.0) {
      tempWeightList.add([
        'asset/bmr.png',
        'Basal Metabolic',
        '${data.bMR!.toStringAsFixed(0)}kcal',
      ]);
    }

    if (data.proteinRate != null && data.proteinRate != 0.0) {
      tempWeightList.add([
        'asset/proteinRate.png',
        'Protein Rate',
        '${data.proteinRate!.toStringAsFixed(2)}%',
      ]);
    }

    if (data.visceralFat != null && data.visceralFat != 0.0) {
      tempWeightList.add([
        'asset/bfr_icon.png',
        'Visceral Fat Index',
        '${data.visceralFat.toString()}',
      ]);
    }
    return tempWeightList;
  }
}
