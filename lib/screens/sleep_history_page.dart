import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/ui/graph_screen/graph_item_data.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/database_helper.dart';
import 'package:health_gauge/utils/date_picker.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/date_utils.dart' as dateUtils;
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

class SleepHistoryScreen extends StatefulWidget {
  @override
  _SleepHistoryScreenState createState() => _SleepHistoryScreenState();
}

class _SleepHistoryScreenState extends State<SleepHistoryScreen> {
  int currentIndex = 0;

  DateTime selectedDate = DateTime.now();

  DateTime firstDateOfWeek = DateTime.now();
  DateTime lastDateOfWeek = DateTime.now();

  String? userId;

  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  SleepInfoModel? daySleepInfoModel;

  List<SleepInfoModel> weekSleepInfoList = [];

  List<SleepInfoModel> monthSleepInfoList = [];

  bool isStayUpDay = true;
  bool isLightDay = true;
  bool isDeepDay = true;

  List<chart.Series<GraphItemData, num>> lineChartSeriesForMonth = [];

  List<chart.Series<GraphItemData, num>> lineChartSeriesForWeek = [];

  Widget? weekLineChart;
  Widget? monthLineChart;

  @override
  void initState() {
    initDateVariables();
    getPreference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: Constants.staticWidth, height: Constants.staticHeight, allowFontScaling: true);
    screen = Constants.sleep;
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
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              title: Text(
                StringLocalization.of(context)
                    .getText(StringLocalization.sleepHistoryTitle),
                style: TextStyle(
                    fontSize: 18,
                    color: HexColor.fromHex('62CBC9'),
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          )),
      body: layout(),
    );
  }

  Widget layout() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 4.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                tabLayout(),
                dateChooserLayout(),
              ],
            ),
          ),
          SizedBox(height: 10.0.h),
          displayData(),
          SizedBox(height: 10.0.h),
        ],
      ),
    );
  }

  Widget tabLayout() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: currentIndex == 0
                      ? Colors.blueGrey[900]
                      : Colors.grey[400],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                ),
                child: Body1AutoText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.day),
                  color: currentIndex == 0 ? Colors.white : Colors.black,
                  align: TextAlign.center,
                  maxLine: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 16,
                ),
              ),
              onTap: () {
                currentIndex = 0;
                setState(() {});
              },
            ),
          ),
          currentIndex == 2
              ? Container(
                  width: 1.w,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.white,
                )
              : Container(),
          Expanded(
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: currentIndex == 1
                        ? Colors.blueGrey[900]
                        : Colors.grey[400],
                  ),
                  child: Body1AutoText(
                    text: StringLocalization.of(context)
                        .getText(StringLocalization.week),
                    color: currentIndex == 1 ? Colors.white : Colors.black,
                    align: TextAlign.center,
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 16,
                  )),
              onTap: () {
                currentIndex = 1;
                setState(() {});
              },
            ),
          ),
          currentIndex == 0
              ? Container(
                  width: 1.w,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black54
                      : Colors.white,
                )
              : Container(),
          Expanded(
            child: InkWell(
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: currentIndex == 2
                        ? Colors.blueGrey[900]
                        : Colors.grey[400],
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Body1AutoText(
                    text: StringLocalization.of(context)
                        .getText(StringLocalization.month),
                    color: currentIndex == 2 ? Colors.white : Colors.black,
                    align: TextAlign.center,
                    maxLine: 1,
                    minFontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  )),
              onTap: () {
                currentIndex = 2;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget dateChooserLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            onClickBefore();
          },
        ),
        Expanded(
          child: Container(
            // width: currentIndex == 1 ? 200 : 120,
            child: Center(
              // child: AutoSizeText(
              //   selectedValueText(),
              //   style: TextStyle(
              //     fontSize: 16,
              //   ),
              //   minFontSize: 10,
              //   maxLines: 1,
              // ),
              child: Body1AutoText(
                text: selectedValueText(),
                fontSize: 16,
                minFontSize: 10,
                maxLine: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        nextBtn(),
        /*currentIndex == 0
            ?*/
        IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () async {
            selectedDate = await Date().selectDate(context, selectedDate);
            selectWeek(selectedDate);
            getDayData();
            getWeekData();
            getMonthData();
            setState(() {});
          },
        ) /*: Container()*/,
      ],
    );
  }

  Widget displayData() {
    try {
      return Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: currentIndex == 0 ? 150 : 300.0,
              child: charts(),
            ),
          ),
          timeWidgetForDay(),
          SizedBox(height: 30.0.h),
          legendsForAllGraph()
        ],
      );
    } catch (e) {
      print(e);
    }
    return Container();
  }

  Widget timeWidgetForDay() {
    try {
      if (currentIndex != 0 ||
          daySleepInfoModel == null ||
          daySleepInfoModel!.data.isEmpty) {
        return Container();
      }
      List list = hourList() ?? [];
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: List<Widget>.generate(list.length, (index) {
            return Expanded(
              child: Body1Text(
                text: getSleepTime(list[index]),
                align: TextAlign.center,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.white87
                    : AppColor.color384341,
                fontSize: 12.sp,
                maxLine: 2,
              ),
            );
          }),
        ),
      );
    } catch (e) {
      print(e);
    }
    return Container();
  }

  String getSleepTime(DateTime date) {
    var tempDate = date.hour;
    if (tempDate < 24 && tempDate > 12) {
      tempDate -= 12;
      return '$tempDate\npm';
    } else if (tempDate == 12) {
      return '$tempDate\npm';
    } else if (tempDate == 0) {
      return '12\nam';
    } else {
      return '$tempDate\nam';
    }
  }

  List? hourList() {
    try {
      var current = DateTime.now();

      sortSleepData();
      if (daySleepInfoModel != null) {
        SleepDataInfoModel firstModel = daySleepInfoModel!.data.first;
        DateTime now = DateTime.now();
        int firstHour = 0;
        int firstMinute = 0;
        if (firstModel.time != null) {
          firstHour = int.parse(firstModel.time!.split(':')[0]);
          firstMinute = int.parse(firstModel.time!.split(':')[1]);
          now = DateTime(
            current.year,
            current.month,
            firstHour > 12 ? current.day - 1 : current.day,
            firstHour,
            firstMinute != 0 ? 0 : firstMinute,
          );
        }

        SleepDataInfoModel? lastModel = daySleepInfoModel?.data.last;
        int lastHour = int.tryParse(lastModel?.time?.split(':')[0] ?? '') ?? 0;
        int lastMinute =
            int.tryParse(lastModel?.time?.split(':')[1] ?? '') ?? 0;
        DateTime last = lastMinute == 0
            ? DateTime(
                current.year,
                current.month,
                lastHour > 12 ? current.day - 1 : current.day,
                lastHour,
                lastMinute)
            : DateTime(current.year, current.month,
                lastHour > 12 ? current.day - 1 : current.day, lastHour + 1, 0);

        int hours = last.difference(now).inHours;

        List listOfTime = [];

        for (int i = 0; i < hours + 1; i++) {
          if (i == 0) {
            listOfTime.add(now);
          } else {
            firstHour++;
            now = DateTime(current.year, current.month,
                firstHour > 12 ? current.day - 1 : current.day, firstHour, 0);
            listOfTime.add(now);
          }
        }
        return listOfTime;
      }
    } catch (e) {
      print(e);
    }
  }

  void sortSleepData() {
    try {
      daySleepInfoModel?.data.forEach((element) {
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

      daySleepInfoModel?.data.sort(
          (a, b) => (a.dateTime?.compareTo(b.dateTime ?? DateTime.now()) ?? 0));
    } catch (e) {
      print(e);
    }
  }

  List makeListOfTypeByHours() {
    sortSleepData();
    var current = DateTime.now();
    SleepDataInfoModel? firstModel = daySleepInfoModel?.data.first;
    int firstHour = int.tryParse(firstModel?.time?.split(':')[0] ?? '') ?? 0;
    int firstMinute = int.tryParse(firstModel?.time?.split(':')[1] ?? '') ?? 0;
    DateTime now = DateTime(current.year, current.month,
        firstHour > 12 ? current.day - 1 : current.day, firstHour, firstMinute);

    SleepDataInfoModel? lastModel = daySleepInfoModel?.data.last;
    int lastHour = int.tryParse(lastModel?.time?.split(':')[0] ?? '') ?? 0;
    int lastMinute = int.tryParse(lastModel?.time?.split(':')[1] ?? '') ?? 0;
    DateTime last = DateTime(current.year, current.month,
        lastHour > 12 ? current.day - 1 : current.day, lastHour, lastMinute);

    int totalHour = last.difference(now).inHours;
//    var totalHour = (daySleepInfoModel.sleepAllTime / 60).ceil();
    print(totalHour);
    List listWithColorAndPercentage = [];
    if (daySleepInfoModel?.data.length == 1) {
      listWithColorAndPercentage.add({
        'type': daySleepInfoModel?.data[0].type,
        'percentage': 100,
      });
    } else {
      SleepDataInfoModel lastModel = daySleepInfoModel!.data.last;
      int lastMinute = int.parse(lastModel.time!.split(':')[1]);

      SleepDataInfoModel firstModel = daySleepInfoModel!.data.first;
      int firstMinute = int.parse(firstModel.time!.split(':')[1]);

      if (firstMinute != 0) {
        listWithColorAndPercentage.add({
          'type': -1,
          'percentage': (firstMinute * 100) ~/
              (daySleepInfoModel?.sleepAllTime == 0
                  ? 1
                  : daySleepInfoModel?.sleepAllTime ?? 0),
        });
      }

      for (int i = 0; i < (daySleepInfoModel?.data.length ?? 0) - 1; i++) {
        SleepDataInfoModel? model = daySleepInfoModel?.data[i];
        SleepDataInfoModel? nextModel = daySleepInfoModel?.data[i + 1];

        int nowHour = int.tryParse(model?.time?.split(':')[0] ?? '') ?? 0;
        int nowMinute = int.tryParse(model?.time?.split(':')[1] ?? '') ?? 0;

        int nextHour = int.tryParse(nextModel?.time?.split(':')[0] ?? '') ?? 0;
        int nextMinute =
            int.tryParse(nextModel?.time?.split(':')[1] ?? '') ?? 0;

        DateTime current = DateTime.now();

        DateTime nowDateTime = DateTime(current.year, current.month,
            nowHour > 12 ? current.day - 1 : current.day, nowHour, nowMinute);
        DateTime nextDateTime = DateTime(
            current.year,
            current.month,
            nextHour > 12 ? current.day - 1 : current.day,
            nextHour,
            nextMinute);
        listWithColorAndPercentage.add({
          'type': model?.type ?? '',
          'percentage':
              ((nextDateTime.difference(nowDateTime).inMinutes * 100) ~/
                  (daySleepInfoModel?.sleepAllTime == 0
                      ? 1
                      : daySleepInfoModel?.sleepAllTime ?? 0)),
        });
      }

      if (lastMinute != 0) {
        listWithColorAndPercentage.add({
          'type': -1,
          'percentage': ((60 - lastMinute) * 100) ~/
              (daySleepInfoModel?.sleepAllTime == 0
                  ? 1
                  : daySleepInfoModel?.sleepAllTime ?? 0),
        });
      }
    }
    return listWithColorAndPercentage;
  }

  Widget charts() {
    if (currentIndex == 0) {
      return customBarChart();
    } else if (currentIndex == 1) {
      if (weekSleepInfoList.isEmpty) {
        return Center(
          child: Body1AutoText(
            text: StringLocalization.of(context)
                .getText(StringLocalization.noDataFound),
            maxLine: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      } else {
        String stayUpTime = '0';
        String deepTime = '0';
        String light = '0';
        int awake = 0;
        int lightSleep = 0;
        int deepSleep = 0;
        if (weekSleepInfoList.isNotEmpty) {
          for (SleepInfoModel sleepInfoModel in weekSleepInfoList) {
            awake = awake + sleepInfoModel.stayUpTime;
            deepSleep = deepSleep + sleepInfoModel.deepTime;
            lightSleep = lightSleep + sleepInfoModel.lightTime;
          }
          stayUpTime = (awake / weekSleepInfoList.length).round().toString();
          deepTime = (deepSleep / weekSleepInfoList.length).round().toString();
          light = (lightSleep / weekSleepInfoList.length).round().toString();
        }
        if (weekLineChart == null ||
            (stayUpTime == '0' && deepTime == '0' && light == '0')) {
          return Center(
            child: Body1AutoText(
              text: StringLocalization.of(context)
                  .getText(StringLocalization.noDataFound),
              maxLine: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
        return weekLineChart ?? Container();

        // return getLineChart(weekDataGraphController);
      }
    } else if (currentIndex == 2) {
      if (monthSleepInfoList.isEmpty) {
        return Center(
          child: Body1AutoText(
              text: StringLocalization.of(context)
                  .getText(StringLocalization.noDataFound),
              maxLine: 2,
              overflow: TextOverflow.ellipsis),
        );
      } else {
        String stayUpTime = '0';
        String deepTime = '0';
        String light = '0';
        int awake = 0;
        int lightSleep = 0;
        int deepSleep = 0;
        if (monthSleepInfoList.isNotEmpty) {
          for (SleepInfoModel sleepInfoModel in monthSleepInfoList) {
            awake = awake + sleepInfoModel.stayUpTime;
            deepSleep = deepSleep + sleepInfoModel.deepTime;
            lightSleep = lightSleep + sleepInfoModel.lightTime;
          }
          stayUpTime = (awake / monthSleepInfoList.length).round().toString();
          deepTime = (deepSleep / monthSleepInfoList.length).round().toString();
          light = (lightSleep / monthSleepInfoList.length).round().toString();
        }
        if (monthLineChart == null ||
            (stayUpTime == '0' && deepTime == '0' && light == '0')) {
          return Center(
            child: Body1AutoText(
              text: StringLocalization.of(context)
                  .getText(StringLocalization.noDataFound),
              maxLine: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
        return monthLineChart ?? Container();
      }
    }
    return Center(
      child: Body1AutoText(
          text: StringLocalization.of(context)
              .getText(StringLocalization.noDataFound),
          maxLine: 2,
          overflow: TextOverflow.ellipsis),
    );
  }

  getDayNameFromWeekDay(val) {
    switch (val) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thus';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
    }
    return '';
  }

  Widget customBarChart() {
    if (daySleepInfoModel?.data.isNotEmpty ?? false) {
      List list = makeListOfTypeByHours();
      print('list ${jsonEncode(list)}');
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width - 40.w,
              height: Size.infinite.height),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List<Widget>.generate(list.length, (index) {
              return Expanded(
                  flex: list[index]['percentage'],
                  child: Container(
                    decoration: BoxDecoration(
                      color: getColorByType(list[index]['type'].toString()),
                    ),
                  ));
            }),
          ),
        ),
      );
      /*return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width-40,height: Size.infinite.height),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List<Widget>.generate(list.length, (index) {
              return Expanded(child: list[index]);
            }),
          ),
        ),
      );*/
    }

    return Center(
      child: Body1AutoText(
          text: StringLocalization.of(context)
              .getText(StringLocalization.noDataFound),
          maxLine: 2,
          overflow: TextOverflow.ellipsis),
    );
  }

  Widget legendsForAllGraph() {
    String stayUpTime = '0';
    String deepTime = '0';
    String light = '0';
    int awake = 0;
    int lightSleep = 0;
    int deepSleep = 0;
    try {
      if (currentIndex == 0 && daySleepInfoModel != null) {
        stayUpTime = daySleepInfoModel?.stayUpTime.toString() ?? '0';
        deepTime = daySleepInfoModel?.deepTime.toString() ?? '0';
        light = daySleepInfoModel?.lightTime.toString() ?? '0';
      } else if (currentIndex == 1) {
        if (weekSleepInfoList.isNotEmpty) {
          for (SleepInfoModel sleepInfoModel in weekSleepInfoList) {
            awake = awake + sleepInfoModel.stayUpTime;
            deepSleep = deepSleep + sleepInfoModel.deepTime;
            lightSleep = lightSleep + sleepInfoModel.lightTime;
          }
          stayUpTime = (awake / weekSleepInfoList.length).round().toString();
          deepTime = (deepSleep / weekSleepInfoList.length).round().toString();
          light = (lightSleep / weekSleepInfoList.length).round().toString();
        }
      } else if (currentIndex == 2) {
        if (monthSleepInfoList.isNotEmpty) {
          for (SleepInfoModel sleepInfoModel in monthSleepInfoList) {
            awake = awake + sleepInfoModel.stayUpTime;
            deepSleep = deepSleep + sleepInfoModel.deepTime;
            lightSleep = lightSleep + sleepInfoModel.lightTime;
          }
          stayUpTime = (awake / monthSleepInfoList.length).round().toString();
          deepTime = (deepSleep / monthSleepInfoList.length).round().toString();
          light = (lightSleep / monthSleepInfoList.length).round().toString();
        }
      }
    } catch (e) {
      print(e);
    }
    if (stayUpTime == '0' && deepTime == '0' && light == '0') {
      return Container();
    } else
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 20.0.h,
                    width: 20.0.w,
                    color: AppColor.purpleColor,
                  ),
                  SizedBox(width: 5.0.h),
                  Container(
                    width: 80.w,
                    child: Center(
                        // child: FittedBox(
                        //   fit: BoxFit.scaleDown,
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     StringLocalization.of(context)
                        //             .getText(StringLocalization.stayUp) +
                        //         '\n($stayUpTime ${StringLocalization.of(context).getText(StringLocalization.min)})',
                        //     maxLines: 3,
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                        child: Column(
                      children: [
                        Body1AutoText(
                          text: StringLocalization.of(context)
                              .getText(StringLocalization.stayUp),
                          maxLine: 1,
                          minFontSize: 16,
                          align: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Body1AutoText(
                          text:
                              '($stayUpTime ${StringLocalization.of(context).getText(StringLocalization.min)})',
                          maxLine: 1,
                          align: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 20.0.h,
                    width: 20.0.w,
                    color: AppColor.lightSleepColor,
                  ),
                  SizedBox(width: 5.0.w),
                  Container(
                    width: 80.w,
                    child: Center(
                      // child: FittedBox(
                      //   fit: BoxFit.scaleDown,
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     StringLocalization.of(context)
                      //             .getText(StringLocalization.light) +
                      //         '\n($light ${StringLocalization.of(context).getText(StringLocalization.min)})',
                      //     maxLines: 2,
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      child: Column(
                        children: [
                          Body1AutoText(
                              text: StringLocalization.of(context)
                                  .getText(StringLocalization.light),
                              maxLine: 1,
                              minFontSize: 16,
                              overflow: TextOverflow.ellipsis,
                              align: TextAlign.center),
                          Body1AutoText(
                              text:
                                  '($light ${StringLocalization.of(context).getText(StringLocalization.min)})',
                              maxLine: 1,
                              overflow: TextOverflow.ellipsis,
                              align: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  //Body1AutoText(text: StringLocalization.of(context).getText(StringLocalization.light) + '\n($light ${StringLocalization.of(context).getText(StringLocalization.min)})',maxLine: 4,align: TextAlign.center,),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    height: 20.0.h,
                    width: 20.0.w,
                    color: AppColor.deepSleepColor,
                  ),
                  SizedBox(width: 5.0.w),
                  Container(
                    width: 80.w,
                    child: Center(
                      // child: FittedBox(
                      //   fit: BoxFit.scaleDown,
                      //   alignment: Alignment.centerLeft,
                      //   child: Text(
                      //     StringLocalization.of(context)
                      //             .getText(StringLocalization.deep) +
                      //         '\n($deepTime ${StringLocalization.of(context).getText(StringLocalization.min)})',
                      //     maxLines: 2,
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      child: Column(
                        children: [
                          Body1AutoText(
                            text: StringLocalization.of(context)
                                .getText(StringLocalization.deep),
                            maxLine: 1,
                            minFontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            align: TextAlign.center,
                          ),
                          Body1AutoText(
                            text:
                                '($deepTime ${StringLocalization.of(context).getText(StringLocalization.min)})',
                            maxLine: 1,
                            overflow: TextOverflow.ellipsis,
                            align: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Body1AutoText(text: StringLocalization.of(context).getText(StringLocalization.deep) + '\n($deepTime ${StringLocalization.of(context).getText(StringLocalization.min)})',maxLine: 4,align: TextAlign.center,),
                ],
              ),
            ),
          ],
        ),
      );
  }

  IconButton nextBtn() {
    bool isEnable = true;
    if (currentIndex == 0 &&
        selectedDate.difference(DateTime.now()).inDays == 0) {
      isEnable = false;
    }
    if (currentIndex == 1 &&
        selectedDate.difference(DateTime.now()).inDays == 0) {
      isEnable = false;
    }
    if (currentIndex == 2 &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.year == DateTime.now().year) {
      isEnable = false;
    }
    return IconButton(
      icon: Icon(Icons.navigate_next),
      onPressed: isEnable
          ? () {
              onClickNext();
            }
          : null,
    );
  }

  onClickNext() async {
    switch (currentIndex) {
      case 0:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day + 1);
        break;
      case 1:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day + 7);

        break;
      case 2:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month + 1, selectedDate.day);
        break;
    }

    selectWeek(selectedDate);
    getDayData();
    getWeekData();
    getMonthData();

    setState(() {});
  }

  onClickBefore() async {
    switch (currentIndex) {
      case 0:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day - 1);

        break;
      case 1:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day - 7);

        await getWeekData();
        break;
      case 2:
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month - 1, selectedDate.day);
        await getMonthData();
        break;
    }

    selectWeek(selectedDate);
    getDayData();
    getWeekData();
    getMonthData();

    setState(() {});
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
    final selected =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    if (selected == today) {
      title = StringLocalization.of(context).getText(StringLocalization.today);
    } else if (selected == yesterday) {
      title =
          StringLocalization.of(context).getText(StringLocalization.yesterday);
    } else if (selected == tomorrow) {
      title =
          StringLocalization.of(context).getText(StringLocalization.tomorrow);
    }
    return '$title';
  }

  void initDateVariables() async {
    if (userId == null) {
      await getPreference();
    }
    selectedDate = DateTime.now();
    selectWeek(selectedDate);
    Future.delayed(Duration(milliseconds: 500)).then((_) async {
      await getDayData();
      await getWeekData();
      await getMonthData();
      setState(() {});
    });
  }

  selectWeek(DateTime selectedDate) {
/*
    var dayNr = (selectedDate.weekday + 7) % 7;
    firstDateOfWeek = selectedDate.subtract(new Duration(days: (dayNr)));
    lastDateOfWeek = firstDateOfWeek.add(new Duration(days: 6));
*/

    print('Date: $date');
    print(
        'Start of week: ${getDate(selectedDate.subtract(Duration(days: selectedDate.weekday - 1)))}');
    print(
        'End of week: ${getDate(selectedDate.add(Duration(days: DateTime.daysPerWeek - selectedDate.weekday)))}');

    firstDateOfWeek = getDate(
        selectedDate.subtract(Duration(days: selectedDate.weekday - 1)));
    lastDateOfWeek = getDate(selectedDate
        .add(Duration(days: DateTime.daysPerWeek - selectedDate.weekday)));
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future getPreference() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
  }

  SleepInfoModel trimSleep(SleepInfoModel mSleepInfo) {
    List<SleepDataInfoModel> listOfRemoveItems = [];
    if (mSleepInfo != null && mSleepInfo.data != null) {
      List<String> strList =
          mSleepInfo.data.map((e) => jsonEncode(e.toMap())).toSet().toList();
      mSleepInfo.data = strList
          .map((e) => SleepDataInfoModel.fromMap(jsonDecode(e)))
          .toList();

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

        mSleepInfo.data.sort((a, b) =>
            (a.dateTime?.compareTo(b.dateTime ?? DateTime.now()) ?? 0));
      } catch (e) {
        print(e);
      }

      for (int i = 0; i < mSleepInfo.data.length; i++) {
        SleepDataInfoModel sleepDataInfoModel = mSleepInfo.data[i];
        if (sleepDataInfoModel != null &&
            (sleepDataInfoModel.type == '2' ||
                sleepDataInfoModel.type == '3')) {
          break;
        }
        listOfRemoveItems.add(sleepDataInfoModel);
      }
      try {
        for (int i = mSleepInfo.data.length - 1; i >= 0; i--) {
          SleepDataInfoModel sleepDataInfoModel = mSleepInfo.data[i];
          if (sleepDataInfoModel != null &&
              (sleepDataInfoModel.type == '2' ||
                  sleepDataInfoModel.type == '3')) {
            break;
          }
          listOfRemoveItems.add(sleepDataInfoModel);
        }
      } catch (e) {
        print(e);
      }
      listOfRemoveItems.forEach((element) {
        mSleepInfo.data.remove(element);
      });
    }

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

    if (sleepInfoModel.data.length == 1) {
      SleepDataInfoModel model = sleepInfoModel.data[0];
      if (model.dateTime != null) {
        switch (model.type) {
          case '2': //light sleep
            light += sleepInfoModel.lightTime;
            break;
          case '3': //deep sleep
            deep += sleepInfoModel.deepTime;
            break;
          default:
            awake += sleepInfoModel.stayUpTime;
            break;
        }
      }
    }

    for (int i = 0; i < sleepInfoModel.data.length - 1; i++) {
      SleepDataInfoModel model = sleepInfoModel.data[i];
      SleepDataInfoModel nextModel = sleepInfoModel.data[i + 1];
      if (model.dateTime != null) {
        switch (model.type) {
          case '2': //light sleep
            light += nextModel.dateTime
                    ?.difference(model.dateTime ?? DateTime.now())
                    .inMinutes ??
                0;
            break;
          case '3': //deep sleep
            deep += nextModel.dateTime
                    ?.difference(model.dateTime ?? DateTime.now())
                    .inMinutes ??
                0;
            break;
          default:
            awake += nextModel.dateTime
                    ?.difference(model.dateTime ?? DateTime.now())
                    .inMinutes ??
                0;
            break;
        }
      }
    }
    sleepInfoModel.stayUpTime = awake;
    sleepInfoModel.lightTime = light;
    sleepInfoModel.deepTime = deep;
    return sleepInfoModel;
  }

  getDayData() async {
    DateTime nextDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
    String last = DateFormat(DateUtil.yyyyMMdd).format(nextDay);
    String first = DateFormat(DateUtil.yyyyMMdd).format(selectedDate);
    List<SleepInfoModel> list =
        await databaseHelper.getSleepDataDateWise(first, last, userId ?? '');
    var distinctList = <SleepInfoModel>[];

    list.forEach((element) {
      try {
        if (element.data.length > 0) {
          distinctList.add(element);
        }
      } catch (e) {
        print('Exception in getDayData $e');
        distinctList.add(element);
      }
    });

    list = distinctList;
    if (list.length > 0) {
      daySleepInfoModel = list[0];
      daySleepInfoModel = trimSleep(daySleepInfoModel!);
    } else {
      daySleepInfoModel = null;
    }
    setState(() {});
  }

  getWeekData() async {
    DateTime first = DateTime(
        firstDateOfWeek.year, firstDateOfWeek.month, firstDateOfWeek.day);
    DateTime last = DateTime(
        lastDateOfWeek.year, lastDateOfWeek.month, lastDateOfWeek.day + 1);
    String strFirst = DateFormat(DateUtil.yyyyMMdd).format(first);
    String strLast = DateFormat(DateUtil.yyyyMMdd).format(last);
    List<SleepInfoModel> list = await databaseHelper.getSleepDataDateWise(
        strFirst, strLast, userId ?? '');

    list = list.map((e) => trimSleep(e)).toList();

    var distinctList = <SleepInfoModel>[];

    list.forEach((element) {
      try {
        if (element.data.length > 0) {
          int day = DateTime.parse(element.date ?? '').day;
          bool exist =
              distinctList.any((e) => DateTime.parse(e.date ?? '').day == day);
          if (!exist) {
            distinctList.add(element);
          }
        }
      } catch (e) {
        print('Exception in getMonthData $e');
        distinctList.add(element);
      }
    });

    list = distinctList;
    weekSleepInfoList = list;
    List<GraphItemData> lightDataList = [];
    List<GraphItemData> deepDataList = [];
    List<GraphItemData> awakeDataList = [];

    double lightLastYValue = 0;
    double deepLastYValue = 0;
    double awakeLastYValue = 0;
    SleepInfoModel model;

    try {
      list.sort((a, b) =>
          DateTime.parse(a.date ?? '').compareTo(DateTime.parse(b.date ?? '')));

      int index = list.indexWhere((element) => element != null);
      if (index > -1) {
        model = list[index];
      }
    } catch (e) {
      print('Exception in week data $e');
    }

    for (int i = 1; i < 8; i++) {
      var item = GraphItemData(
        yValue: 0,
        xValue: i.toDouble(),
        xValueStr: i.toString(),
        colorCode: '#99D9D9',
        label: i.toString(),
      );
      int index = list.indexWhere(
          (element) => DateTime.parse(element.date ?? '').weekday == i);

      if (index > -1) {
        SleepInfoModel model = list[index];
        item.yValue = model.lightTime.toDouble();
        lightLastYValue = item.yValue;
      }
      lightDataList.add(item);
    }

    for (int i = 1; i < 8; i++) {
      var item = GraphItemData(
        yValue: 0,
        xValue: i.toDouble(),
        xValueStr: i.toString(),
        colorCode: '#99D9D9',
        label: i.toString(),
      );
      int index = list.indexWhere(
          (element) => DateTime.parse(element.date ?? '').weekday == i);
      if (index > -1) {
        SleepInfoModel model = list[index];
        item.yValue = model.deepTime.toDouble();
        deepLastYValue = model.deepTime.toDouble();
      }
      deepDataList.add(item);
    }
    for (int i = 1; i < 8; i++) {
      var item = GraphItemData(
        yValue: 0,
        xValue: i.toDouble(),
        xValueStr: i.toString(),
        colorCode: '#99D9D9',
        label: i.toString(),
      );
      int index = list.indexWhere(
          (element) => DateTime.parse(element.date ?? '').weekday == i);
      if (index > -1) {
        SleepInfoModel model = list[index];
        item.yValue = model.stayUpTime.toDouble();
        awakeLastYValue = model.stayUpTime.toDouble();
      }
      awakeDataList.add(item);
    }

    lineChartSeriesForWeek = [
      new chart.Series<GraphItemData, num>(
        id: 'lightSleep',
        colorFn: (_, __) => chart.Color(
          a: AppColor.lightSleep.alpha,
          r: AppColor.lightSleep.red,
          g: AppColor.lightSleep.green,
          b: AppColor.lightSleep.blue,
        ),
        // domainFn: (GraphItemData sales, _) => DateTime.parse(sales.label).day,
        domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
        measureFn: (GraphItemData sales, _) => sales.yValue,
        data: lightDataList,
      )..setAttribute(chart.rendererIdKey, 'light'),
      new chart.Series<GraphItemData, num>(
        id: 'deepSleep',
        colorFn: (_, __) => chart.Color(
          a: AppColor.deepSleep.alpha,
          r: AppColor.deepSleep.red,
          g: AppColor.deepSleep.green,
          b: AppColor.deepSleep.blue,
        ),
        // domainFn: (GraphItemData sales, _) => DateTime.parse(sales.label).day,
        domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
        measureFn: (GraphItemData sales, _) => sales.yValue,
        data: deepDataList,
      )..setAttribute(chart.rendererIdKey, 'deep'),
      new chart.Series<GraphItemData, num>(
        id: 'awakeSleep',
        colorFn: (_, __) => chart.Color(
          a: AppColor.purpleColor.alpha,
          r: AppColor.purpleColor.red,
          g: AppColor.purpleColor.green,
          b: AppColor.purpleColor.blue,
        ),
        // domainFn: (GraphItemData sales, _) => DateTime.parse(sales.label).day,
        domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
        measureFn: (GraphItemData sales, _) => sales.yValue,
        data: awakeDataList,
      )..setAttribute(chart.rendererIdKey, 'awake'),
    ];

    weekLineChart = chart.LineChart(lineChartSeriesForWeek,
        animate: true,
        customSeriesRenderers: [
          chart.LineRendererConfig(
            customRendererId: 'light',
            includeArea: true,
            stacked: true,
            includePoints: false,
            includeLine: true,
            roundEndCaps: false,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          ),
          chart.LineRendererConfig(
            customRendererId: 'deep',
            includeArea: true,
            stacked: true,
            includePoints: false,
            includeLine: true,
            roundEndCaps: false,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          ),
          chart.LineRendererConfig(
            customRendererId: 'awake',
            includeArea: true,
            stacked: true,
            includePoints: false,
            includeLine: true,
            roundEndCaps: false,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          ),
        ],
        primaryMeasureAxis: new chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
              fontSize: 10,
              color: Theme.of(context).brightness == Brightness.dark
                  ? chart.MaterialPalette.white
                  : chart.MaterialPalette.black,
            ),
          ),
          tickProviderSpec: new chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
        ),
        domainAxis: chart.NumericAxisSpec(
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            zeroBound: false,
            desiredMinTickCount: 7,
            desiredMaxTickCount: 7,
            dataIsInWholeNumbers: true,
            desiredTickCount: 7,
          ),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 12,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec((val) {
            try {
              return getDayNameFromWeekDay(val?.toInt());
            } catch (e) {
              print(e);
            }
            return '${val?.toInt()}';
          }),
        ));

/*

    //region
    int loopDay = first.day;
    for (int i = 0; i < 7; i++) {
      var date = DateTime(first.year, first.month, loopDay);
      if (i > 0) {
        date =
        date = DateTime(first.year, first.month, loopDay + 1);
        loopDay = DateTime(first.year, first.month, loopDay + 1).day;
      }

      labelsForWeek?.add(date);

      SleepInfoModel model;

      try {
        int index = list.indexWhere((SleepInfoModel mModel) {
          if (mModel != null &&
              mModel.date != null &&
              mModel.date.isNotEmpty &&
              loopDay != null) {
            DateTime dateTime = DateFormat(DateUtil.yyyyMMdd).parse(mModel.date);
            print('${dateTime.day} == $loopDay :${dateTime.day == loopDay}');
            return dateTime.day == loopDay;
          }
          return false;
        });
        if(index>-1){
          model = list[index];
        }
      } catch (e) {
        print(e);
      }

      Entry stayUp = new Entry(x: i + 0.0, y: 0.0);
      Entry lightSleep = new Entry(x: i + 0.0, y: 0.0);
      Entry deepSleep = new Entry(x: i + 0.0, y: 0.0);

      if (model != null) {
        stayUp = new Entry(x: i + 0.0, y: model.stayUpTime + 0.0);
        lightSleep = new Entry(x: i + 0.0, y: model.lightTime + 0.0);
        deepSleep = new Entry(x: i + 0.0, y: model.deepTime + 0.0);
      }

      // if(stayUp.y > 0){
          stayUpValues.add(stayUp);
        // }
      // if(lightSleep.y > 0) {
        lightSleepValues.add(lightSleep);
      // }
      // if(deepSleep.y > 0) {
        deepSlipValues.add(deepSleep);
      // }
    }
    //endregion

    //region sets
    LineDataSet stayUpDataSet = LineDataSet(stayUpValues,
        StringLocalization.of(context).getText(StringLocalization.stayUp));
    stayUpDataSet.setLineWidth(1);
    stayUpDataSet.setCircleRadius(2);
    stayUpDataSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
    stayUpDataSet.setColor1(AppColor.purpleColor);
    stayUpDataSet.setCircleColor(AppColor.purpleColor);
    stayUpDataSet.setDrawValues(false);

    LineDataSet lightSleepSet = LineDataSet(lightSleepValues,
        StringLocalization.of(context).getText(StringLocalization.light));
    lightSleepSet.setLineWidth(1);
    lightSleepSet.setCircleRadius(2);
    lightSleepSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
    lightSleepSet.setColor1(AppColor.lightSleep);
    lightSleepSet.setCircleColor(AppColor.lightSleep);
    lightSleepSet.setDrawValues(false);

    LineDataSet deepSleepSet = LineDataSet(deepSlipValues,
        StringLocalization.of(context).getText(StringLocalization.deep));
    deepSleepSet.setLineWidth(1);
    deepSleepSet.setCircleRadius(2);
    deepSleepSet.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
    deepSleepSet.setColor1(AppColor.deepSleep);
    deepSleepSet.setCircleColor(AppColor.deepSleep);
    deepSleepSet.setDrawValues(false);

    List<ILineDataSet> sets = [];
    sets.add(stayUpDataSet);
    sets.add(lightSleepSet);
    sets.add(deepSleepSet);

    weekDataGraphController.data = LineData.fromList(sets);
    weekDataGraphController.infoBgColor = Theme.of(context).cardColor;
    //endregion
*/
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getMonthData() async {
    try {
      var lightDataListMonth = <GraphItemData>[];
      var deepDataListMonth = <GraphItemData>[];
      var awakeDataListMonth = <GraphItemData>[];

      var first = DateTime(selectedDate.year, selectedDate.month, 1);
      var last = DateTime(selectedDate.year, selectedDate.month + 1, 0);
      var strFirst = DateFormat(DateUtil.yyyyMMdd).format(first);
      var strLast = DateFormat(DateUtil.yyyyMMdd).format(last);
      var list = await databaseHelper.getSleepDataDateWise(
          strFirst, strLast, userId ?? '');
      list = list.map((e) => trimSleep(e)).toList();

      var distinctList = <SleepInfoModel>[];

      list.forEach((element) {
        try {
          if (element.data.isNotEmpty) {
            var day = DateTime.parse(element.date ?? '').day;
            var exist = distinctList
                .any((e) => DateTime.parse(e.date ?? '').day == day);
            if (!exist) {
              distinctList.add(element);
            }
          }
        } catch (e) {
          print('Exception in getMonthData $e');
          distinctList.add(element);
        }
      });

      list = distinctList;

      monthSleepInfoList = list;

      SleepInfoModel model;

      try {
        list.sort((a, b) => DateTime.parse(a.date ?? '')
            .compareTo(DateTime.parse(b.date ?? '')));

        var index = list.indexWhere((element) => element != null);
        if (index > -1) {
          model = list[index];
        }
      } catch (e) {
        print('Exception in week data $e');
      }

      var totalDays = dateUtils.DateUtil()
          .daysInMonth(selectedDate.month, selectedDate.year);

      //region light
      for (int i = 1; i <= totalDays; i++) {
        var item = GraphItemData(
          yValue: 0,
          xValue: i.toDouble(),
          xValueStr: i.toString(),
          colorCode: '#99D9D9',
          label: i.toString(),
        );
        var index = list.indexWhere(
            (element) => DateTime.parse(element.date ?? '').day == i);

        if (index > -1) {
          var model = list[index];
          item.yValue = model.lightTime.toDouble();
        }
        lightDataListMonth.add(item);
      }

      //endregion

      //region deep
      for (var i = 1; i <= totalDays; i++) {
        var item = GraphItemData(
          yValue: 0,
          xValue: i.toDouble(),
          xValueStr: i.toString(),
          colorCode: '#99D9D9',
          label: i.toString(),
        );
        var index = list.indexWhere(
            (element) => DateTime.parse(element.date ?? '').day == i);

        if (index > -1) {
          var model = list[index];
          item.yValue = model.deepTime.toDouble();
        }
        deepDataListMonth.add(item);
      }
      //endregion

      //region awake
      for (var i = 1; i <= totalDays; i++) {
        var item = GraphItemData(
          yValue: 0,
          xValue: i.toDouble(),
          xValueStr: i.toString(),
          colorCode: '#99D9D9',
          label: i.toString(),
        );
        var index = list.indexWhere(
            (element) => DateTime.parse(element.date ?? '').day == i);

        if (index > -1) {
          SleepInfoModel model = list[index];
          item.yValue = model.stayUpTime.toDouble();
        }
        awakeDataListMonth.add(item);
      }
      //endregion

      lineChartSeriesForMonth = [
        chart.Series<GraphItemData, num>(
          id: 'lightSleep',
          colorFn: (_, __) => chart.Color(
            a: AppColor.lightSleep.alpha,
            r: AppColor.lightSleep.red,
            g: AppColor.lightSleep.green,
            b: AppColor.lightSleep.blue,
          ),
          // domainFn: (GraphItemData sales, _) => DateTime.parse(sales.label).day,
          domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
          measureFn: (GraphItemData sales, _) => sales.yValue,
          data: lightDataListMonth,
        )..setAttribute(chart.rendererIdKey, 'light'),
        chart.Series<GraphItemData, num>(
          id: 'deepSleep',
          colorFn: (_, __) => chart.Color(
            a: AppColor.deepSleep.alpha,
            r: AppColor.deepSleep.red,
            g: AppColor.deepSleep.green,
            b: AppColor.deepSleep.blue,
          ),
          // domainFn: (GraphItemData sales, _) => DateTime.parse(sales.label).day,
          domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
          measureFn: (GraphItemData sales, _) => sales.yValue,
          data: deepDataListMonth,
        )..setAttribute(chart.rendererIdKey, 'deep'),
        chart.Series<GraphItemData, num>(
          id: 'awakeSleep',
          colorFn: (_, __) => chart.Color(
            a: AppColor.purpleColor.alpha,
            r: AppColor.purpleColor.red,
            g: AppColor.purpleColor.green,
            b: AppColor.purpleColor.blue,
          ),
          // domainFn: (GraphItemData sales, _) => DateTime.parse(sales.label).day,
          domainFn: (GraphItemData sales, _) => sales.xValue.toInt(),
          measureFn: (GraphItemData sales, _) => sales.yValue,
          data: awakeDataListMonth,
        )..setAttribute(chart.rendererIdKey, 'awake'),
      ];

      monthLineChart = chart.LineChart(
        lineChartSeriesForMonth,
        animate: true,
        customSeriesRenderers: [
          chart.LineRendererConfig(
            customRendererId: 'light',
            includeArea: true,
            stacked: true,
            includePoints: false,
            includeLine: true,
            roundEndCaps: false,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          ),
          chart.LineRendererConfig(
            customRendererId: 'deep',
            includeArea: true,
            stacked: true,
            includePoints: false,
            includeLine: true,
            roundEndCaps: false,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          ),
          chart.LineRendererConfig(
            customRendererId: 'awake',
            includeArea: true,
            stacked: true,
            includePoints: false,
            includeLine: true,
            roundEndCaps: false,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          ),
        ],
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
              fontSize: 10,
              color: Theme.of(context).brightness == Brightness.dark
                  ? chart.MaterialPalette.white
                  : chart.MaterialPalette.black,
            ),
          ),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
        ),
        domainAxis: chart.NumericAxisSpec(
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            zeroBound: false,
            desiredMinTickCount: totalDays,
            desiredMaxTickCount: totalDays,
            dataIsInWholeNumbers: true,
            desiredTickCount: totalDays,
          ),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 12,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec((val) {
            if (val?.toInt() == 1 || ((val?.toInt() ?? -1) % 5 == 0)) {
              return '${val?.toInt()}';
            }
            return '';
          }),
        ),
      );
    } catch (e) {
      print('Exception at Get month data $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  getColorByType(String type) {
    switch (type) {
      case '0': //stay up all night
        return AppColor.purpleColor;
      case '1': //sleep
        return AppColor.deepSleepColor;
      case '2': //light sleep
        return AppColor.lightSleepColor;
      case '3': //deep sleep
        return AppColor.deepSleepColor;
      case '4': //wake up half
        return AppColor.purpleColor;
      case '5': //wake up
        return AppColor.purpleColor;
      case '-1': // only to fill starting and end bar
        return Colors.transparent;
    }
  }
}
