import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/repository/measurement/measurement_repository.dart';
import 'package:health_gauge/repository/measurement/model/get_ecg_ppg_detail_list_result.dart';
import 'package:health_gauge/repository/measurement/request/get_ecg_ppg_detail_list_request.dart';
import 'package:health_gauge/screens/history/week_and_month_history_data.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable.dart';
import 'package:health_gauge/utils/slider/src/widgets/slidable_action_pane.dart';
import 'package:health_gauge/utils/slider/src/widgets/slide_action.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/day_week_month_tab.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class MeasurementHistory extends StatefulWidget {
  @override
  _MeasurementHistoryState createState() => _MeasurementHistoryState();
}

class _MeasurementHistoryState extends State<MeasurementHistory> {
  int currentIndex = 0;
  int currentListIndex = 0;
  bool isAISelected = false;
  int? measurementType;

  List<MeasurementDetail> detailsList = [];
  List<MeasurementHistoryModel> weekMesurementList = [];
  List<MeasurementHistoryModel> monthMesurementList = [];
  bool showDetails = false;

  DateTime selectedDate = DateTime.now();

  bool showListDetails = false;

  int currentOuterListIndex = 0;

//  DateTime selectedDateForWeek = DateTime.now();
//  DateTime selectedDateForMonth = DateTime.now();

  DateTime firstDateOfWeek = DateTime.now();
  DateTime lastDateOfWeek = DateTime.now();

  List<MeasurementHistoryModel> dayHistoryModelList = [];

  List<WeekHistoryListItemData> weekHistoryModelList = [];

  List<MonthHistoryListItemData> monthHistoryModelList = [];

  String userId = '';

  bool showLoadingScreen = true;

  List idListForDay = [];
  List idListForWeek = [];
  List idListForMonth = [];

  ValueNotifier<int> dayDCount = ValueNotifier(0);
  ValueNotifier<int> dayWCount = ValueNotifier(0);
  ValueNotifier<int> dayMCount = ValueNotifier(0);

  @override
  void initState() {
    measurementType = preferences?.getInt(Constants.measurementType);
    if (measurementType == null) {
      preferences?.setInt(Constants.measurementType, 1);
    }
    initDateVariables();
    getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screen = Constants.measurementHistory;
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        appBar: appBar(),
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
                  onTapPreviousDate: onClickBefore,
                  onTapNextDate: () {
                    monthMesurementList.clear();
                    idListForMonth.clear();
                    bool isEnable = true;
                    if (currentIndex == 0 && selectedDate.difference(DateTime.now()).inDays == 0) {
                      isEnable = false;
                    }
                    if (currentIndex == 1 &&
                        (lastDateOfWeek.difference(DateTime.now()).inDays >= 0)) {
                      isEnable = false;
                    }
                    if (currentIndex == 2 &&
                        (selectedDate.difference(DateTime.now()).inDays >= 0 ||
                            (selectedDate.year == DateTime.now().year &&
                                selectedDate.month == DateTime.now().month))) {
                      isEnable = false;
                    }

                    if (isEnable) {
                      showDetails = false;
                      onClickNext();
                    }
                  },
                  onTapDay: () async {
                    showDetails = false;
                    currentIndex = 0;
                    // getWeightDataFromDb(isDay: true);
                    showLoadingScreen = true;
                    getDayData();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onTapWeek: () async {
                    showDetails = false;
                    currentIndex = 1;
                    // selectWeek(selectedDate);
                    // getWeightDataFromDb(isWeek: true);
                    showLoadingScreen = true;
                    getWeekData();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onTapMonth: () async {
                    monthMesurementList.clear();
                    idListForMonth.clear();
                    var currentTime = DateTime.now();
                    if (selectedDate.year == currentTime.year &&
                        selectedDate.month - currentTime.month > 0) {
                      selectedDate = currentTime;
                    }
                    currentIndex = 2;
                    showDetails = false;
                    // getWeightDataFromDb(isMonth: true);
                    showLoadingScreen = true;
                    getMonthData();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  onTapCalendar: () async {
                    showLoadingScreen = true;
                    showDetails = false;
                    selectedDate = await Date(getDatabaseDataFrom: 'Blood Pressure')
                        .selectDate(context, selectedDate);
                    fetchData();
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
                Expanded(child: layout()),
              ],
            )),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
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
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
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
          title: Text(
            StringLocalization.of(context).getText(StringLocalization.cardiacHistory),
            style: TextStyle(
                fontSize: 18, color: HexColor.fromHex('62CBC9'), fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: null,
              icon: dataCount(),
            )
          ],
        ),
      ),
    );
  }

  Widget dataCount() {
    switch (currentIndex) {
      case 0:
        return ValueListenableBuilder(
          valueListenable: dayDCount,
          builder: (BuildContext context, int value, Widget? child) {
            return Text(
              value.toString(),
              style: TextStyle(
                  fontSize: 18, color: HexColor.fromHex('62CBC9'), fontWeight: FontWeight.bold),
            );
          },
        );
      case 1:
        return ValueListenableBuilder(
          valueListenable: dayWCount,
          builder: (BuildContext context, int value, Widget? child) {
            return Text(
              value.toString(),
              style: TextStyle(
                  fontSize: 18, color: HexColor.fromHex('62CBC9'), fontWeight: FontWeight.bold),
            );
          },
        );
      case 2:
        return ValueListenableBuilder(
          valueListenable: dayMCount,
          builder: (BuildContext context, int value, Widget? child) {
            return Text(
              value.toString(),
              style: TextStyle(
                  fontSize: 18, color: HexColor.fromHex('62CBC9'), fontWeight: FontWeight.bold),
            );
          },
        );
      default:
        return SizedBox();
    }
  }

  Widget layout() {
    return SingleChildScrollView(child: displayData());
  }

  Widget displayData() {
    return Stack(
      children: [
        Container(
          height: currentIndex == 0 ? null : 0,
          child: displayDataForDay(),
        ),
        Container(
          height: currentIndex == 1 ? null : 0,
          // child: displayDataForWeek(weekHistoryModelList, false),
          child: displayDataForWeek(),
        ),
        Container(
          height: currentIndex == 2 ? null : 0,
          child: monthView(),
        ),
        Visibility(
          visible: showLoadingScreen,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  Column displayDataForDay() {
    List<MeasurementHistoryModel> list = [];
    list = dayHistoryModelList.where(
      (element) {
        if (element != null && element.date != null) {
          DateTime dateOfData = DateFormat(DateUtil.yyyyMMdd).parse(element.date!);
          DateTime dateOfDay = DateFormat(DateUtil.yyyyMMdd).parse(selectedDate.toString());
          return (dateOfDay == dateOfData);
        }
        return false;
      },
    ).toList();
    dayDCount.value = list.length;
    print('dayDataCount :: D :: $dayDCount');
    if (list.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 300.h,
            child: Center(
              child: Text(StringLocalization.of(context).getText(StringLocalization.noDataFound)),
            ),
          )
        ],
      );
    }
    return Column(
      children: List<Widget>.generate(list.length, (index) {
        // if (index == 0) {
        //   return headingOfTitles();
        // }
        MeasurementHistoryModel model = list[index];

        if (showDetails && currentListIndex == index) {
          return listItem(model, index, list.length);
        } else {
          return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: StringLocalization.of(context).getText(StringLocalization.delete),
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    deleteDialog(onClickYes: () async {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                      bool isInternet = await Constants.isInternetAvailable();
                      if (isInternet) {
                        await deleteMeasurementHistory(model);
                      } else {}
                      dayHistoryModelList.remove(model);
                      try {
                        bool flag = false;
                        int? indexO;
                        int? indexI;
                        for (var i = 0; i < weekHistoryModelList.length; i++) {
                          for (var j = 0;
                              j < weekHistoryModelList[i].listOfHistoryModel!.length;
                              j++) {
                            if (weekHistoryModelList[i].listOfHistoryModel![j].id == model.id) {
                              flag = true;
                              indexO = i;
                              indexI = j;
                              break;
                            }
                          }
                        }
                        if (flag && indexO != null && indexI != null) {
                          weekHistoryModelList[indexO].listOfHistoryModel!.removeAt(indexI);
                        }
                        flag = false;
                        indexO = null;
                        indexI = null;
                        int? indexK;
                        for (var i = 0; i < monthHistoryModelList.length; i++) {
                          for (var j = 0;
                              j < monthHistoryModelList[i].listOfWeekHistory!.length;
                              j++) {
                            var weekList = monthHistoryModelList[i].listOfWeekHistory![j];
                            for (var k = 0; k < weekList.listOfHistoryModel!.length; k++) {
                              if (weekList.listOfHistoryModel![k].id == model.id) {
                                flag = true;
                                indexO = i;
                                indexI = j;
                                indexK = k;
                                break;
                              }
                            }
                          }
                        }
                        if (flag && indexO != null && indexI != null && indexK != null) {
                          monthHistoryModelList[indexO]
                              .listOfWeekHistory![indexI]
                              .listOfHistoryModel!
                              .removeAt(indexK);
                        }
                      } catch (e) {}
                      CustomSnackBar.buildSnackbar(context, 'Deleted Successfully', 3);
                      if (mounted) {
                        setState(() {});
                      }
                    });
                  },
                  height: 50,
                  topMargin: 8,
                  rightMargin: 13,
                  leftMargin: 13,
                ),
              ],
              child: listItem(model, index, list.length));
        }
      }),
    );
  }

  Column monthView() {
    var list = <MeasurementHistoryModel>[];
    list = monthMesurementList.where(
      (element) {
        DateTime dataDate = DateFormat(DateUtil.yyyyMMdd).parse(element.date!);
        return dataDate.month == selectedDate.month;
      },
    ).toList();
    dayMCount.value = list.length;
    if (list.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 300.h,
            child: Center(
              child: Text(StringLocalization.of(context).getText(StringLocalization.noDataFound)),
            ),
          )
        ],
      );
    }

    var measurementList = <List<MeasurementHistoryModel>>[];
    try {
      measurementList = WeekAndMonthHistoryData(distinctList: list).getMeasurementData();
    } catch (e) {
      LoggingService().printLog(tag: 'measurement history screen', message: e.toString());
    }

    return Column(children: [
      ListView.builder(
          itemCount: measurementList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
                margin: EdgeInsets.only(
                    left: 13.w,
                    right: 13.w,
                    top: 16.h,
                    bottom: index == measurementList.length - 1 ? 16.h : 0.0),
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
                child: Column(children: [
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
                      child: Container(
                        height: 56.h,
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
                                        HexColor.fromHex('#9F2DBC').withOpacity(0.023),
                                      ])),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: Body1Text(
                                  text: DateFormat(DateUtil.MMMddyyyy).format(
                                      DateTime.parse(measurementList[index][0].date.toString())),
                                  fontSize: 16.sp,
                                  color: Theme.of(context).brightness == Brightness.dark
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
                    child: Column(
                      children: List<Widget>.generate(measurementList[index].length, (innerIndex) {
                        MeasurementHistoryModel model = measurementList[index][innerIndex];

                        if (showDetails && currentListIndex == index) {
                          return listItem(model, innerIndex, measurementList[index].length);
                        } else {
                          return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: StringLocalization.of(context)
                                      .getText(StringLocalization.delete),
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () async {
                                    deleteDialog(onClickYes: () async {
                                      if (Navigator.canPop(context)) {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      }
                                      bool isInternet = await Constants.isInternetAvailable();
                                      if (isInternet) {
                                        await deleteMeasurementHistory(model);
                                      } else {}
                                      monthMesurementList.remove(model);
                                      CustomSnackBar.buildSnackbar(
                                          context, 'Deleted Successfully', 3);
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    });
                                  },
                                  height: 50,
                                  topMargin: 8,
                                  rightMargin: 13,
                                  leftMargin: 13,
                                ),
                              ],
                              child: listItem(model, innerIndex, measurementList[index].length));
                        }
                      }),
                    ),
                  ),
                ]));
          })
    ]);
  }

  Column displayDataForWeek() {
    var list = <MeasurementHistoryModel>[];
    list = weekMesurementList.where(
      (element) {
        bool isInWeek = false;
        DateTime dataDate = DateFormat(DateUtil.yyyyMMdd).parse(element.date!);
        isInWeek = dataDate.isAfter(firstDateOfWeek) && dataDate.isBefore(lastDateOfWeek);
        if (!isInWeek) {
          var first = DateFormat(DateUtil.ddMMyyyy)
              .parse(DateFormat(DateUtil.ddMMyyyy).format(firstDateOfWeek));
          var last = DateFormat(DateUtil.ddMMyyyy)
              .parse(DateFormat(DateUtil.ddMMyyyy).format(lastDateOfWeek));
          isInWeek = (dataDate == first || dataDate == last);
        }
        return isInWeek;
      },
    ).toList();
    dayWCount.value = list.length;
    if (list.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 300.h,
            child: Center(
              child: Text(StringLocalization.of(context).getText(StringLocalization.noDataFound)),
            ),
          )
        ],
      );
    }
    var measurementList = <List<MeasurementHistoryModel>>[];
    try {
      measurementList = WeekAndMonthHistoryData(distinctList: list).getMeasurementData();
    } catch (e) {
      LoggingService().printLog(tag: 'measurement history screen', message: e.toString());
    }

    return Column(
      children: [
        ListView.builder(
            itemCount: measurementList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(
                    left: 13.w,
                    right: 13.w,
                    top: 16.h,
                    bottom: index == measurementList.length - 1 ? 16.h : 0.0),
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
                child: Column(children: [
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
                      child: Container(
                        height: 56.h,
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
                                        HexColor.fromHex('#9F2DBC').withOpacity(0.023),
                                      ])),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 20.w),
                                child: Body1Text(
                                  text: DateFormat(DateUtil.MMMddyyyy).format(
                                      DateTime.parse(measurementList[index][0].date.toString())),
                                  fontSize: 16.sp,
                                  color: Theme.of(context).brightness == Brightness.dark
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
                    child: Column(
                      children: List<Widget>.generate(measurementList[index].length, (innerIndex) {
                        MeasurementHistoryModel model = measurementList[index][innerIndex];

                        if (showDetails && currentListIndex == index) {
                          return listItem(model, innerIndex, measurementList[index].length);
                        } else {
                          return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[
                                IconSlideAction(
                                  caption: StringLocalization.of(context)
                                      .getText(StringLocalization.delete),
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () async {
                                    deleteDialog(onClickYes: () async {
                                      if (Navigator.canPop(context)) {
                                        Navigator.of(context, rootNavigator: true).pop();
                                      }
                                      bool isInternet = await Constants.isInternetAvailable();
                                      if (isInternet) {
                                        await deleteMeasurementHistory(model);
                                      }
                                      weekMesurementList.remove(model);
                                      try {
                                        bool flag = false;
                                        int? indexO;
                                        int? indexI;
                                        for (var i = 0; i < weekHistoryModelList.length; i++) {
                                          for (var j = 0;
                                              j <
                                                  weekHistoryModelList[i]
                                                      .listOfHistoryModel!
                                                      .length;
                                              j++) {
                                            if (weekHistoryModelList[i].listOfHistoryModel![j].id ==
                                                model.id) {
                                              flag = true;
                                              indexO = i;
                                              indexI = j;
                                              break;
                                            }
                                          }
                                        }
                                        if (flag && indexO != null && indexI != null) {
                                          weekHistoryModelList[indexO]
                                              .listOfHistoryModel!
                                              .removeAt(indexI);
                                        }
                                        flag = false;
                                        indexO = null;
                                        indexI = null;
                                        int? indexK;
                                        for (var i = 0; i < monthHistoryModelList.length; i++) {
                                          for (var j = 0;
                                              j <
                                                  monthHistoryModelList[i]
                                                      .listOfWeekHistory!
                                                      .length;
                                              j++) {
                                            var weekList =
                                                monthHistoryModelList[i].listOfWeekHistory![j];
                                            for (var k = 0;
                                                k < weekList.listOfHistoryModel!.length;
                                                k++) {
                                              if (weekList.listOfHistoryModel![k].id == model.id) {
                                                flag = true;
                                                indexO = i;
                                                indexI = j;
                                                indexK = k;
                                                break;
                                              }
                                            }
                                          }
                                        }
                                        if (flag &&
                                            indexO != null &&
                                            indexI != null &&
                                            indexK != null) {
                                          monthHistoryModelList[indexO]
                                              .listOfWeekHistory![indexI]
                                              .listOfHistoryModel!
                                              .removeAt(indexK);
                                        }
                                      } catch (e) {}
                                      CustomSnackBar.buildSnackbar(
                                          context, 'Deleted Successfully', 3);
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    });
                                  },
                                  height: 50,
                                  topMargin: 8,
                                  rightMargin: 13,
                                  leftMargin: 13,
                                ),
                              ],
                              child: listItem(model, innerIndex, measurementList[index].length));
                        }
                      }),
                    ),
                  ),
                ]),
              );
            }),
      ],
    );
  }

  Future<void> deleteMeasurementHistory(MeasurementHistoryModel model) async {
    var result = await MeasurementRepository().deleteEstimateDetailByID(model.idForApi!);
    if (result.hasData) {
      if (result.getData!.result ?? false) {
        dbHelper.deleteMeasurementHistory(model.id!);
        monthMesurementList.removeWhere((element) => element.id == model.id!);
        weekMesurementList.removeWhere((element) => element.id == model.id!);
      }
    }
  }

  Future<EcgPpgHistoryModel?> getEcgPpgDetailsList(int? id) async {
    EcgPpgHistoryModel? ecgPpgHistoryModel;
    var map = {
      'ID': id!.toString(),
    };
    var result =
        await MeasurementRepository().getEcgPpgDetailList(GetEcgPpgDetailListRequest.fromJson(map));

    if (result.hasData) {
      if (result.getData?.result ?? false) {
        ecgPpgHistoryModel = result.getData!.ecgPpgHistoryModel;
      }
    }
    return ecgPpgHistoryModel;
  }

  void deleteDialog({required GestureTapCallback onClickYes}) {
    var dialog = CustomDialog(
        title: stringLocalization.getText(StringLocalization.delete),
        subTitle: stringLocalization.getText(StringLocalization.measurementDeleteInfo),
        onClickYes: onClickYes,
        maxLine: 2,
        onClickNo: onClickDeleteNo);
    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6)
            : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  void onClickDeleteNo() {
    if (context != null) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Widget headingForWeekDay(WeekHistoryListItemData model) {
    if (model.listOfHistoryModel!.length <= 1) {
      return Container();
    }
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: EdgeInsets.only(
          /*top: 4, right: 15, left: 15,*/
          bottom: !model.isExpanded! ? 4 : 0),
      child: InkWell(
        onTap: () {
          if (model.listOfHistoryModel!.length > 1) {
            model.isExpanded = !model.isExpanded!;
            if (mounted) {
              setState(() {});
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              dateColumn(model.listOfHistoryModel!.first, weekHistoryListItemData: model),
              Expanded(
                child: Body1AutoText(
                  text: (model.avgSbp != null && model.avgDbp != null)
                      ? '${model.avgSbp}/${model.avgDbp}'
                      : '',
                  align: TextAlign.center,
                ),
              ),
              Expanded(
                child: Body1AutoText(
                  text: model.avgHr != null ? model.avgHr.toString() : '',
                  align: TextAlign.center,
                ),
              ),
              Expanded(
                child: Body1AutoText(
                  text: (model.avgHrv != null ? model.avgHrv.toString() : ''),
                  align: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listItem(MeasurementHistoryModel model, int index, int listLength) {
    return Container(
      margin: EdgeInsets.only(
          left: 13.w, right: 13.w, top: 16.h, bottom: index == listLength - 1 ? 16.h : 0.0),
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
            key: Key('clickonArrowIconatMeasurementHistory'),
            child: Container(
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
                                HexColor.fromHex('#9F2DBC').withOpacity(0.023),
                              ])),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Body1Text(
                          text: DateFormat(DateUtil.MMMddhhmma)
                              .format(DateTime.parse(model.date.toString())),
                          fontSize: 16.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.87)
                              : HexColor.fromHex('384341'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      key: Key('clickonArrowiconWeek$index'),
                      padding: EdgeInsets.only(right: 14.w),
                      child: Image.asset(
                        showDetails && currentListIndex == index
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
              setState(() {
                if (currentListIndex != index || (currentListIndex == index && !showDetails)) {
                  showDetails = true;
                  currentListIndex = index;
                  updateData(model);
                } else {
                  showDetails = false;
                }
              });
            },
          ),
          showDetails && currentListIndex == index && detailsList.isNotEmpty
              ? GestureDetector(
                  onTap: () async {
                    print("FromMeasurement_history");
                    if ((model.ecg?.length ?? 0) < 2 && (model.ppg?.length ?? 0) < 2) {
                      var isInternet = await Constants.isInternetAvailable();
                      if (isInternet) {
                        Constants.progressDialog(true, context);

                        int? id = model.idForApi;
                        var map = {
                          'ID': id!.toString(),
                        };
                        var result = await MeasurementRepository()
                            .getEcgPpgDetailList(GetEcgPpgDetailListRequest.fromJson(map));
                        if (result.hasData) {
                          if (result.getData?.result ?? false) {
                            if (result.getData?.ecgPpgHistoryModel != null) {
                              model.ecg = result.getData?.ecgPpgHistoryModel.filteredEcgPoints;
                              model.ppg = result.getData?.ecgPpgHistoryModel.filteredPpgPoints;
                              print('getMeasurementDetailList_Response ${model.ppg}');
                              Constants.navigatePush(
                                MeasurementScreen(
                                  measurementHistoryModel: model,
                                ),
                                context,
                              );
                              Constants.progressDialog(false, context);
                            }
                          }
                        }
                      } else {
                        CustomSnackBar.buildSnackbar(
                            context,
                            StringLocalization.of(context)
                                .getText(StringLocalization.enableInternet),
                            3);
                      }
                    } else {
                      Constants.navigatePush(
                          MeasurementScreen(
                            measurementHistoryModel: model,
                          ),
                          context);
                      Constants.progressDialog(false, context);
                    }
                  },
                  child: ListView.builder(
                      itemCount: detailsList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: index == detailsList.length - 1
                                    ? BorderRadius.only(
                                        bottomLeft: Radius.circular(10.h),
                                        bottomRight: Radius.circular(10.h))
                                    : BorderRadius.circular(0.0),
                              ),
                              height: 52.5.h,
                              child: Row(children: [
                                Expanded(
                                  key: Key('taponMeasurementHistory$index'),
                                  child: Image.asset(
                                    detailsList[index].imagePath!,
                                    height: 33.h,
                                    width: 33.h,
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Body1AutoText(
                                        text: detailsList[index].title!,
                                        color: Theme.of(context).brightness == Brightness.dark
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
                                      text: detailsList[index].value!,
                                      color: Theme.of(context).brightness == Brightness.dark
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
                            index == detailsList.length - 1
                                ? Container()
                                : Container(
                                    height: 1.h,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white.withOpacity(0.15)
                                        : HexColor.fromHex('D9E0E0'),
                                  )
                          ],
                        );
                      }),
                )
              : Container(),
        ],
      ),
    );
  }

  void updateData(MeasurementHistoryModel model) {
    detailsList.clear();
    if (model.sbp != null && model.dbp != null) {
      detailsList.add(MeasurementDetail(
          imagePath: 'asset/Wellness/bloodpressure_icon.png',
          title: 'Blood Pressure',
          value: isAISelected ? '${model.aiSBP}/${model.aiDbp}' : '${model.sbp}/${model.dbp}'));
    }
    if (model.hr != null) {
      detailsList.add(MeasurementDetail(
          imagePath: 'asset/Wellness/hr_icon.png', title: 'Heart Rate', value: '${model.hr}'));
    }
    if (model.hrv != null) {
      detailsList.add(MeasurementDetail(
          imagePath: 'asset/stress_icon.png',
          title: 'Heart Rate Variability',
          value: '${model.hrv}'));
    }
    if (model.BG != null) {
      var unit = model.Unit ?? '';
      detailsList.add(MeasurementDetail(
          imagePath: 'asset/blood_glucose.png',
          title: 'Blood Glucose',
          value: '${model.BG} $unit'));
      print('unit_0000 ${model.Unit1}');
    }
    if (model.Class != null && model.Class!.isNotEmpty) {
      detailsList.add(MeasurementDetail(
          imagePath: 'asset/blood_glucose.png', title: 'Glucose Level', value: '${model.Class}'));
    }
  }

  Widget headingOfTitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          firstHeading(),
          Expanded(
            child: Body2Text(
              text: stringLocalization.getText(StringLocalization.bp),
              align: TextAlign.center,
            ),
          ),
          Expanded(
            child: Body2Text(
              text: stringLocalization.getText(StringLocalization.heartRateShortForm),
              align: TextAlign.center,
            ),
          ),
          Expanded(
            child: Body2Text(
              text: stringLocalization.getText(StringLocalization.hrv),
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Expanded firstHeading() {
    String title = 'Week';
    if (currentIndex == 0) {
      title = 'Time';
    } else if (currentIndex == 1) {
      title = 'Day';
    }
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(),
          ),
          Expanded(
            flex: 5,
            child: Body2Text(
              text: title,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Widget dateColumn(MeasurementHistoryModel model,
      {bool? isSubItemOfWeekDay, WeekHistoryListItemData? weekHistoryListItemData}) {
    String? date = model.date;
    try {
      DateTime dateTime = DateTime.parse(date!);
      if (currentIndex == 0) {
        date = DateFormat(DateUtil.HHmma).format(dateTime);
      } else if (currentIndex == 1 || currentIndex == 2) {
        // date = DateFormat('EEEE').format(dateTime);
        date = DateFormat(DateUtil.ddMMM).format(dateTime);
        if (isSubItemOfWeekDay != null && isSubItemOfWeekDay) {
          date = DateFormat(DateUtil.HHmma).format(dateTime);
        }
      } else {
        date = DateFormat(DateUtil.ddMMyyHHmm).format(dateTime);
      }
    } catch (e) {
      print('exception in Measurement History screen $e');
    }

    if (weekHistoryListItemData != null) {
      return Expanded(
        flex: 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Icon(weekHistoryListItemData.isExpanded!
                    ? Icons.arrow_drop_down
                    : Icons.arrow_right)),
            Expanded(
              flex: 4,
              child: Body1AutoText(
                text: date ?? '',
                align: TextAlign.start,
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      flex: 2,
      child: Row(
        children: <Widget>[
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 4,
            child: Body1AutoText(
              text: date ?? '',
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
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

  initDateVariables() {
    selectedDate = DateTime.now();
    selectWeek(selectedDate);
    Future.delayed(Duration(milliseconds: 500)).then((_) {
      var aiSelected = preferences?.getBool(
            Constants.isAISelected,
          ) ??
          false;
      var tflSelected = preferences?.getBool(
            Constants.isTFLSelected,
          ) ??
          false;
      isAISelected = aiSelected || tflSelected;
      fetchData();
    });
    if (mounted) {
      setState(() {});
    }
  }

  selectWeek(DateTime selectedDate) {
    var dayNr = (selectedDate.weekday + 7) % 7;

    firstDateOfWeek = selectedDate.subtract(Duration(days: (dayNr)));

    lastDateOfWeek = firstDateOfWeek.add(Duration(days: 6));
  }

  onClickNext() async {
    switch (currentIndex) {
      case 0:
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
        await getDayData();
        break;
      case 1:
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 7);
        break;
      case 2:
        selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, selectedDate.day);

        break;
    }
    showLoadingScreen = true;
    fetchData();
    if (mounted) {
      setState(() {});
    }
  }

  onClickBefore() async {
    switch (currentIndex) {
      case 0:
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1);

        break;
      case 1:
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 7);

        break;
      case 2:
        monthMesurementList.clear();
        idListForMonth.clear();
        if (selectedDate.month == 3 && selectedDate.day > 28) {
          selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 28);
        } else {
          selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
        }
        break;
    }
    showLoadingScreen = true;
    fetchData();
    if (mounted) {
      setState(() {});
    }
  }

  void fetchData() {
    selectWeek(selectedDate);
    if (currentIndex == 0) {
      getDayData();
    } else if (currentIndex == 1) {
      getWeekData();
    } else if (currentIndex == 2) {
      monthMesurementList.clear();
      idListForMonth.clear();
      getMonthData();
    }
  }

  getDayData() async {
    dayHistoryModelList.clear();
    DateTime nextDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
    String last = DateFormat(DateUtil.yyyyMMdd).format(nextDay);
    String first = DateFormat(DateUtil.yyyyMMdd).format(selectedDate);
    List<MeasurementHistoryModel> dayHistoryModelList1 =
        await dbHelper.getMeasurementHistoryData(userId, '$first', '$last', limit: 20);
    try {
      idListForDay.addAll(dayHistoryModelList1.map((e) => e.id).toList());
    } catch (e) {
      print('exception in Measurement History screen $e');
    }
    try {
      dayHistoryModelList.addAll(removeHourlyHrData(dayHistoryModelList1, 'day'));
    } catch (e) {
      print('exception in Measurement History screen $e');
    }

    if (currentIndex == 0) {
      showLoadingScreen = false;
    }
    if (mounted) {
      setState(() {});
    }
    try {
      // if (dayHistoryModelList1.isNotEmpty) {
      //   getDayData();
      // }
    } catch (e) {
      print('exception in Measurement History screen $e');
    }
  }

  getWeekData() async {
    DateTime first = DateTime(firstDateOfWeek.year, firstDateOfWeek.month, firstDateOfWeek.day);
    DateTime last = DateTime(lastDateOfWeek.year, lastDateOfWeek.month, lastDateOfWeek.day + 1);
    String strFirst = DateFormat(DateUtil.yyyyMMdd).format(first);
    String strLast = DateFormat(DateUtil.yyyyMMdd).format(last);

    List<MeasurementHistoryModel> weekMesurementList1 = await dbHelper
        .getMeasurementHistoryData(userId, '$strFirst', '$strLast', ids: idListForWeek, limit: 20);
    print('weekData $weekMesurementList');
    try {
      idListForWeek.addAll(weekMesurementList1.map((e) => e.id).toList());
    } catch (e) {
      print('exception in Measurement History screen $e');
    }
    try {
      //region
      weekMesurementList.addAll(removeHourlyHrData(weekMesurementList1, 'week'));

      //endregion
    } catch (e) {
      print('exception in Measurement History screen $e');
    }

    if (currentIndex == 1) {
      showLoadingScreen = false;
    }
    if (mounted) {
      setState(() {});
    }
    try {
      if (weekMesurementList1.isNotEmpty) {
        getWeekData();
      }
    } catch (e) {
      print('exception in Measurement History screen $e');
    }
  }

  getMonthData() async {
    DateTime first = DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime last = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    String strFirst = DateFormat(DateUtil.yyyyMMdd).format(first);
    String strLast = DateFormat(DateUtil.yyyyMMdd).format(last);
    List<MeasurementHistoryModel> monthData = await dbHelper
        .getMeasurementHistoryData(userId, '$strFirst', '$strLast', ids: idListForMonth, limit: 30);

    try {
      idListForMonth.addAll(monthData.map((e) => e.id).toList());
    } catch (e) {
      print('exception in Measurement History screen $e');
    }

    try {
      //region
      monthData = removeHourlyHrData(monthData, 'month');
      monthMesurementList.addAll(monthData);
      List<Map> mapList = [];

      int daysOfMonth = last.difference(first).inDays;
      int totalWeeks = (daysOfMonth / 7).ceil();
      int day = 1;
      for (int i = 1; i <= totalWeeks; i++) {
        int firstDayInWeek = day > 1 ? day + 1 : day;
        int lastDayInWeek = day + (day > 1 ? 7 : 6);

        if (lastDayInWeek > (last.day - 1)) {
          day = last.day;
        } else {
          day = lastDayInWeek;
        }

        mapList.add({
          'first': firstDayInWeek,
          'last': day + 1,
        });
        print('first $firstDayInWeek last $day');
      }

      for (int i = 0; i < mapList.length; i++) {
        int first = mapList[i]['first'];
        int last = mapList[i]['last'];

        DateTime firstD = DateTime(selectedDate.year, selectedDate.month, first);
        DateTime lastD = DateTime(selectedDate.year, selectedDate.month, last);

        List list = monthData.where((MeasurementHistoryModel model) {
          DateTime d = DateTime.parse(model.date!);
          if (/*(d.difference(firstD).inDays == 0) ||*/
              (d.isAfter(firstD) && d.isBefore(lastD))) {
            return true;
          }
          return false;
        }).toList();

        //region week
        List<WeekHistoryListItemData> weeks = mergeDataInWeekWise(list);
        MonthHistoryListItemData monthItem = MonthHistoryListItemData();
        monthItem.avgHr = 0;
        monthItem.avgHrv = 0;
        monthItem.avgSbp = 0;
        monthItem.avgDbp = 0;
        monthItem.firstDate = firstD;
        monthItem.lastDate = lastD;
        monthItem.listOfWeekHistory = weeks;
        for (int j = 0; j < monthItem.listOfWeekHistory!.length; j++) {
          monthItem.avgHr = monthItem.avgHr! + (monthItem.listOfWeekHistory![j].avgHr ?? 0);
          monthItem.avgHrv = monthItem.avgHrv! + (monthItem.listOfWeekHistory![j].avgHrv ?? 0);
          monthItem.avgSbp = monthItem.avgSbp! + (monthItem.listOfWeekHistory![j].avgSbp ?? 0);
          monthItem.avgDbp = monthItem.avgDbp! + (monthItem.listOfWeekHistory![j].avgDbp ?? 0);
        }
        if (weeks.isNotEmpty) {
          monthItem.avgHr = (monthItem.avgHr! / weeks.length).round();
          monthItem.avgHrv = (monthItem.avgHrv! / weeks.length).round();
          monthItem.avgSbp = (monthItem.avgSbp! / weeks.length).round();
          monthItem.avgDbp = (monthItem.avgDbp! / weeks.length).round();
        }

        monthHistoryModelList.add(monthItem);
        //endregion
      } //endregion
    } on Exception catch (e) {
      print('exception in Measurement History screen $e');
    }

    if (currentIndex == 2) {
      showLoadingScreen = false;
    }
    if (mounted) {
      setState(() {});
    }

    try {
      // if (monthData.isNotEmpty) {
      //   getMonthData();
      // }
    } catch (e) {
      print('exception in Measurement History screen $e');
    }
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  List<MeasurementHistoryModel> removeHourlyHrData(
      List<MeasurementHistoryModel> data, String type) {
    //region
    try {
      print('data Type :: $type');
      List jsonString = data.map((e) => jsonEncode(e.toMap())).toList();
      jsonString = jsonString.toSet().toList();
      data = jsonString.map((e) => MeasurementHistoryModel.fromMap(jsonDecode(e))).toList();
    } catch (e) {
      print('exception in Measurement History screen $e');
    }
    /*print('data $data');
    data.removeWhere((element) {
      try {
        return (element == null ||
            // (element.ppg == null && element.ecg == null) ||
            // (element.ppg?.length == 0 && element.ecg?.length == 0) ||
            // (element.ppg?.length == 1 && element.ecg?.length == 1) ||
            // (element.ppg?[0] == null || element.ecg?[0] == null) ||
            // (element.ppg![0].isEmpty && element.ecg![0].isEmpty) ||
            // (element.ppg?[0] == '[]' && element.ecg?[0] == '[]') ||
            (element.sbp == null ||
                element.dbp == null ||
                element.hr == null ||
                element.sbp == 0 ||
                element.dbp == 0 ||
                element.hr == 0));
      } catch (e) {
        print('exception in Measurement History screen $e');
        return false;
      }
    });*/

    List<MeasurementHistoryModel> distinctList = [];

    data.forEach((element) {
      var isExist = distinctList.any((data1) {
        try {
          return element == data1 || element.date == data1.date;
          // element.ppg.toString() == data1.ppg.toString() ||
          // element.ecg.toString() == data1.ecg.toString() ;
        } catch (e) {
          print('exception in Measurement History screen $e');
          return false;
        }
      });
      if (!isExist) {
        distinctList.add(element);
      }
    });

    data = distinctList;

    //endregion
    print('data $data');
    return data;
  }

  List<WeekHistoryListItemData> mergeDataInWeekWise(List list1) {
    List<WeekHistoryListItemData> list = <WeekHistoryListItemData>[];

    for (MeasurementHistoryModel model in list1) {
      WeekHistoryListItemData history = WeekHistoryListItemData();
      history.listOfHistoryModel = <MeasurementHistoryModel>[];
      history.avgDbp = model.dbp!;
      history.avgSbp = model.sbp!;
      history.avgHr = model.hr!;
      history.avgHrv = model.hrv!;
      history.BG = int.tryParse(model.BG!.toString());
      history.BG1 = int.tryParse(model.BG1.toString());
      history.BGUnit = model.Unit;
      history.BGUnit1 = model.Unit1;
      history.GlucoseLevel = model.Class;
      history.date = model.date!;
      history.listOfHistoryModel?.add(model);
      list.add(history);
    }

    for (int j = 0; j < list.length; j++) {
      WeekHistoryListItemData item = list[j];

      List<WeekHistoryListItemData> lst = list.where((WeekHistoryListItemData model) {
        var itemDate = DateTime.parse(item.date!);
        var modelDate = DateTime.parse(model.date!);
        if (itemDate.day == modelDate.day) {
          return true;
        }
        return false;
      }).toList();

      if (lst.length > 1) {
        WeekHistoryListItemData Model = WeekHistoryListItemData();
        String date = '';
        int sbp = 0;
        int dbp = 0;
        int hr = 0;
        int hrv = 0;
        List<MeasurementHistoryModel> listMeasurement = <MeasurementHistoryModel>[];

        for (int i = 0; i < lst.length; i++) {
          if (lst[i].date != null) {
            date = lst[i].date!;
          }
          if (lst[i].avgSbp != null) {
            sbp += lst[i].avgSbp!;
          }
          if (lst[i].avgDbp != null) {
            dbp += lst[i].avgDbp!;
          }
          if (lst[i].avgHr != null) {
            hr += lst[i].avgHr!;
          }
          if (lst[i].avgHrv != null) {
            hrv += lst[i].avgHrv!;
          }
          listMeasurement.addAll(lst[i].listOfHistoryModel!);
          list.remove(lst[i]);
        }

        Model.date = date;
        Model.avgSbp = (sbp / lst.length).round();
        Model.avgDbp = (dbp / lst.length).round();
        Model.avgHr = (hr / lst.length).round();
        Model.avgHrv = (hrv / lst.length).round();
        Model.listOfHistoryModel = listMeasurement;
        list.add(Model);
      }
    }
    return list;
  }

  Future getPreference() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
  }
}

class WeekHistoryListItemData {
  String? date;
  int? avgSbp;
  int? avgDbp;
  int? avgHr;
  int? avgHrv;
  int? BG;
  int? BG1;
  String? BGUnit;
  String? BGUnit1;
  String? GlucoseLevel;
  bool? isExpanded = true;
  List<MeasurementHistoryModel>? listOfHistoryModel = <MeasurementHistoryModel>[];

  WeekHistoryListItemData(
      {this.date,
      this.avgSbp,
      this.avgDbp,
      this.avgHr,
      this.avgHrv,
      this.BG,
      this.BG1,
      this.BGUnit,
      this.BGUnit1,
      this.GlucoseLevel,
      this.listOfHistoryModel});
}

class MonthHistoryListItemData {
  DateTime? firstDate;
  DateTime? lastDate;
  int? avgSbp;
  int? avgDbp;
  int? avgHr;
  int? avgHrv;
  int? BG;
  int? BG1;
  String? BGUnit;
  String? BGUnit1;
  String? GlucoseLevel;
  bool isExpanded = true;

  List<WeekHistoryListItemData>? listOfWeekHistory = <WeekHistoryListItemData>[];

  MonthHistoryListItemData({
    this.firstDate,
    this.lastDate,
    this.avgSbp,
    this.avgDbp,
    this.avgHr,
    this.avgHrv,
    this.BG,
    this.BG1,
    this.BGUnit,
    this.BGUnit1,
    this.GlucoseLevel,
    this.listOfWeekHistory,
  });
}

class MeasurementDetail {
  String? imagePath;
  String? title;
  String? value;

  MeasurementDetail({
    @required this.imagePath,
    @required this.title,
    @required this.value,
  });
}
