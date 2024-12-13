import 'package:charts_flutter/flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/history/history_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';

import '../../ui/graph_screen/graph_item_data.dart';
import '../../utils/database_helper.dart';
import '../../utils/date_utils.dart';
import '../../value/app_color.dart';
import '../../value/string_localization_support/string_localization.dart';

class HistoryItemDetails extends StatefulWidget {
  const HistoryItemDetails({
    required this.chartData,
    required this.historyItemType,
    required this.graphWidget,
    required this.avgRate,
    this.lowestRestingHeartRate,
    this.pageHeading,
    this.notification,
    Key? key,
    required this.chartDatas,
  }) : super(key: key);

  final HistoryItemType historyItemType;
  final Widget? graphWidget;
  final int? avgRate;
  final int? lowestRestingHeartRate;
  final String? pageHeading;
  final List<String>? notification;
  final List<Series<GraphItemData, num>> chartData;
  final List<GraphItemData> chartDatas;

  String notificationHeaderTxt() {
    switch (historyItemType) {
      case HistoryItemType.HeartRate:
        return 'Heart Rate Notifications';
      case HistoryItemType.Oxygen:
        return 'Oxygen Notifications';
      case HistoryItemType.Temperature:
        return 'Temperature Notifications';
      case HistoryItemType.BloodPressure:
        return 'Blood Pressure Notifications';
    }
  }

  String emptyNotificationTodayTxt() {
    switch (historyItemType) {
      case HistoryItemType.HeartRate:
        return 'No heart rate notifications today';
      case HistoryItemType.Oxygen:
        return 'No oxygen notifications today';
      case HistoryItemType.Temperature:
        return 'No temperature notifications today';
      case HistoryItemType.BloodPressure:
        return 'No blood pressure notifications today';
    }
  }

  String restingHeaderTxt() {
    switch (historyItemType) {
      case HistoryItemType.HeartRate:
        return 'Resting Heart Rate';
      case HistoryItemType.Oxygen:
        return 'Resting Oxygen';
      case HistoryItemType.Temperature:
        return 'Resting Temperature';
      case HistoryItemType.BloodPressure:
        return 'Resting Blood Pressure';
    }
  }

  Widget historyTypeIcon() {
    switch (historyItemType) {
      case HistoryItemType.HeartRate:
        return Icon(
          Icons.favorite,
          color: Colors.red,
        );
      case HistoryItemType.Oxygen:
        return ImageIcon(
          AssetImage('asset/oxygen.png'),
          color: Colors.red,
        );
      case HistoryItemType.Temperature:
        return ImageIcon(
          AssetImage('asset/tempurature.png'),
          color: Colors.red,
        );
      case HistoryItemType.BloodPressure:
        return ImageIcon(
          AssetImage('asset/blood_ pressure.png'),
          color: Colors.red,
        );
    }
  }

  String avgValue() {
    if (avgRate == 0) {
      return '0';
    } else {
      if (historyItemType == HistoryItemType.Temperature) {
        try {
          if (tempUnit == 1) {
            var temp = (avgRate! * 9 / 5) + 32;
            return temp.toStringAsFixed(2);
          } else {
            return avgRate.toString();
          }
        } catch (e) {
          print('Exception at temperatureNotifier $e');
        }
        return '';
      }
      return avgRate.toString();
    }
  }

  @override
  _HistoryItemDetailsState createState() => _HistoryItemDetailsState();
}

class _HistoryItemDetailsState extends State<HistoryItemDetails> {
  // int totalTime = 0;
  final dbHelper = DatabaseHelper.instance;
  // List<GraphItemData> tempchartDatas= [];
  @override
  void initState() {
    // TODO: implement initState

    widget.chartDatas.removeWhere((element) =>
        element.label != "approxHr" || element.label != "HeartRate");
    // widget.chartDatas.sort((a,b)=> a.yValue.toString().compareTo(b.yValue.toString()));
    widget.chartDatas.forEach((element) {
      widget.chartData[0].data.add(element);
    });
    // widget.chartData[0].data.sort((a,b)=> a.yValue.toString().compareTo(b.yValue.toString()));
    // widget.chartData[1].data.sort((a,b)=> a.yValue.toString().compareTo(b.yValue.toString()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.pageHeading != null
          ? AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      'asset/leftArrow.png',
                      width: 13,
                      height: 22,
                    ),
                  );
                },
              ),
              title: Center(
                child: HeadlineText(
                  text: widget.pageHeading!,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.graphWidget != null)
              Container(
                padding: EdgeInsets.all(8.0.w),
                height: 200.h,
                child: widget.graphWidget,
              ),
            if (widget.historyItemType == HistoryItemType.HeartRate)
              if (widget.graphWidget != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    ActionChip(
                        avatar: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex("#ff000000"),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#111B1A')
                                : AppColor.backgroundColor,
                        label: Text(
                          'Sleep',
                          // style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {}),
                    SizedBox(
                      width: 10.w,
                    ),
                    ActionChip(
                        avatar: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex("#ff9e99"),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#111B1A')
                                : AppColor.backgroundColor,
                        label: Text(
                          'Heart Rate',
                          // style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {}),
                    SizedBox(
                      width: 10.w,
                    ),
                    ActionChip(
                        avatar: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 4,
                              height: 12,
                              color: HexColor.fromHex("#008000"),
                            ),
                            Container(
                              width: 4,
                              height: 12,
                              color: HexColor.fromHex("#90EE90"),
                            ),
                            Container(
                              width: 4,
                              height: 12,
                              color: HexColor.fromHex("#FFFF00"),
                            ),
                            Container(
                              width: 4,
                              height: 12,
                              color: HexColor.fromHex("#FFA500"),
                            ),
                            Container(
                              width: 4,
                              height: 12,
                              color: HexColor.fromHex("#FF0000"),
                            ),
                          ],
                        ),
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#111B1A')
                                : AppColor.backgroundColor,
                        label: Text(
                          'HR Zone',
                          // style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {}),
                  ],
                ),
            widget.chartData[0].data.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
                          child: Body1Text(
                            text: widget.notificationHeaderTxt().toUpperCase(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        (widget.notification != null &&
                                widget.notification!.isNotEmpty)
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0.w, top: 8.0.h, bottom: 8.0.h),
                                child: Row(
                                  children: [
                                    for (var item in widget.notification!)
                                      Body1AutoText(text: item),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0.w, top: 8.0.h, bottom: 8.0.h),
                                child: Body1Text(
                                  text: widget.emptyNotificationTodayTxt(),
                                  color: Colors.grey,
                                ),
                              ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0.h),
                              child: Row(
                                children: [
                                  widget.historyTypeIcon(),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Body1Text(
                                    text:
                                        widget.restingHeaderTxt().toUpperCase(),
                                    fontWeight: FontWeight.bold,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8.0.h, bottom: 8.0.h, left: 4.0.w),
                                  child: Rich1Text(
                                    text1: widget.avgValue(),
                                    text2:
                                        ' ${unitFromHistoryType(widget.historyItemType)}',
                                    fontSize1: 30.sp,
                                    fontSize2: 15.sp,
                                    color1: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                    color2: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white.withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                  ),
                                ),

                              ],
                            ),
                            widget.historyItemType == HistoryItemType.HeartRate
                                ? Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0.h),
                                    child: Row(
                                      children: [
                                        widget.historyTypeIcon(),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Body1Text(
                                          text: 'Lowest Resting Heart Rate'
                                              .toUpperCase(),
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white.withOpacity(0.87)
                                              : HexColor.fromHex('#384341'),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            widget.historyItemType == HistoryItemType.HeartRate
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 8.0.h,
                                            bottom: 8.0.h,
                                            left: 4.0.w),
                                        child: Rich1Text(
                                          text1: widget.lowestRestingHeartRate
                                                      .toString() ==
                                                  "0"
                                              ? widget.avgValue()
                                              : widget.lowestRestingHeartRate
                                                  .toString(),
                                          text2:
                                              ' ${unitFromHistoryType(widget.historyItemType)}',
                                          fontSize1: 30.sp,
                                          fontSize2: 15.sp,
                                          color1: Theme.of(context)
                                                      .brightness ==
                                                  Brightness.dark
                                              ? Colors.white.withOpacity(0.87)
                                              : HexColor.fromHex('#384341'),
                                          color2: Theme.of(context)
                                                      .brightness ==
                                                  Brightness.dark
                                              ? Colors.white.withOpacity(0.87)
                                              : HexColor.fromHex('#384341'),
                                        ),
                                      ),

                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: 10.0.h,
                            ),
                          ],
                        ),
                        widget.historyItemType == HistoryItemType.HeartRate
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Divider(),
                                  // widget.chartData[0].data.isNotEmpty ?

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Body1AutoText(
                                        text:
                                            'Heart rate zone data based on time:',
                                        fontSize: 17,
                                        maxLine: 1,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white.withOpacity(0.87)
                                            : HexColor.fromHex('#384341'),
                                      ),

                                      ...List.generate(
                                          widget.chartData[0].data.length,
                                          (index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              left: 13.w,
                                              right: 13.w,
                                              top: 13.h,
                                              bottom: 8.h),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? HexColor.fromHex('#111B1A')
                                                  : AppColor.backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(10.h),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? HexColor.fromHex(
                                                              '#D1D9E6')
                                                          .withOpacity(0.1)
                                                      : Colors.white,
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(-4, -4),
                                                ),
                                                BoxShadow(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.black
                                                          .withOpacity(0.75)
                                                      : HexColor.fromHex(
                                                              '#9F2DBC')
                                                          .withOpacity(0.15),
                                                  blurRadius: 4,
                                                  spreadRadius: 0,
                                                  offset: Offset(4, 4),
                                                ),
                                              ]),
                                          child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 4),
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? HexColor.fromHex(
                                                          '#111B1A')
                                                      : AppColor
                                                          .backgroundColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.h),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex(
                                                                  '#D1D9E6')
                                                              .withOpacity(0.1)
                                                          : Colors.white,
                                                      blurRadius: 5,
                                                      spreadRadius: 0,
                                                      offset: Offset(-5, -5),
                                                    ),
                                                    BoxShadow(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.black
                                                              .withOpacity(0.75)
                                                          : HexColor.fromHex(
                                                                  '#9F2DBC')
                                                              .withOpacity(
                                                                  0.15),
                                                      blurRadius: 5,
                                                      spreadRadius: 0,
                                                      offset: Offset(5, 5),
                                                    ),
                                                  ]),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex(
                                                            '#111B1A')
                                                        : AppColor
                                                            .backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.h),
                                                    gradient: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                                HexColor.fromHex(
                                                                        '#CC0A00')
                                                                    .withOpacity(
                                                                        0.15),
                                                                HexColor.fromHex(
                                                                        '#9F2DBC')
                                                                    .withOpacity(
                                                                        0.15),
                                                              ])
                                                        : LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                                HexColor.fromHex(
                                                                        '#FF9E99')
                                                                    .withOpacity(
                                                                        0.1),
                                                                HexColor.fromHex(
                                                                        '#9F2DBC')
                                                                    .withOpacity(
                                                                        0.023),
                                                              ])),
                                                child: Container(
                                                  // height: MediaQuery.of(context).size.height * 0.5,
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(10),
                                                  height: 60,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Body1AutoText(
                                                        text: DateFormat(
                                                                DateUtil.HHmma)
                                                            .format(DateTime
                                                                .parse(widget
                                                                    .chartData[
                                                                        0]
                                                                    .data[index]
                                                                    .date
                                                                    .toString())),
                                                        fontSize: 14,
                                                        maxLine: 1,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.87)
                                                            : HexColor.fromHex(
                                                                '#384341'),
                                                      ),
                                                      Rich1Text(
                                                        text1: widget
                                                            .chartData[0]
                                                            .data[index]
                                                            .yValue
                                                            .toStringAsFixed(0),
                                                        text2:
                                                            ' ${unitFromHistoryType(widget.historyItemType)}',
                                                        fontSize1: 14.sp,
                                                        fontSize2: 12.sp,
                                                        color1: Theme.of(
                                                                        context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.87)
                                                            : HexColor.fromHex(
                                                                '#384341'),
                                                        color2: Theme.of(
                                                                        context)
                                                                    .brightness ==
                                                                Brightness.dark
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.87)
                                                            : HexColor.fromHex(
                                                                '#384341'),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                              )),
                                        );
                                      }),
                                      widget.chartData[0].data.isEmpty
                                          ? Center(
                                              child: Body1Text(
                                                text: StringLocalization.of(
                                                        context)
                                                    .getText(StringLocalization
                                                        .noDataFound),
                                                fontWeight: FontWeight.normal,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                        .withOpacity(0.87)
                                                    : HexColor.fromHex(
                                                        '#384341'),
                                              ),
                                            )
                                          : Container(),
                                      // ...List.generate(widget.chartDatas.length,
                                      //         (index) {
                                      //
                                      //       // .removeWhere((element) =>
                                      //       // element.label != "approxHr" || element.label != "HeartRate")
                                      //
                                      //       return widget
                                      //           .chartDatas[index].label != "approxHr" || widget
                                      //           .chartDatas[index].label != "HeartRate" ? Container():
                                      //
                                      //       Container(
                                      //         margin: EdgeInsets.only(
                                      //             left: 13.w,
                                      //             right: 13.w,
                                      //             top: 13.h,
                                      //             bottom: 8.h),
                                      //         decoration: BoxDecoration(
                                      //             color: Theme.of(context).brightness ==
                                      //                 Brightness.dark
                                      //                 ? HexColor.fromHex('#111B1A')
                                      //                 : AppColor.backgroundColor,
                                      //             borderRadius: BorderRadius.circular(10.h),
                                      //             boxShadow: [
                                      //               BoxShadow(
                                      //                 color: Theme.of(context).brightness ==
                                      //                     Brightness.dark
                                      //                     ? HexColor.fromHex('#D1D9E6')
                                      //                     .withOpacity(0.1)
                                      //                     : Colors.white,
                                      //                 blurRadius: 4,
                                      //                 spreadRadius: 0,
                                      //                 offset: Offset(-4, -4),
                                      //               ),
                                      //               BoxShadow(
                                      //                 color: Theme.of(context).brightness ==
                                      //                     Brightness.dark
                                      //                     ? Colors.black.withOpacity(0.75)
                                      //                     : HexColor.fromHex('#9F2DBC')
                                      //                     .withOpacity(0.15),
                                      //                 blurRadius: 4,
                                      //                 spreadRadius: 0,
                                      //                 offset: Offset(4, 4),
                                      //               ),
                                      //             ]),
                                      //         child: Container(
                                      //             padding: EdgeInsets.only(bottom: 4),
                                      //             decoration: BoxDecoration(
                                      //                 color: Theme.of(context).brightness ==
                                      //                     Brightness.dark
                                      //                     ? HexColor.fromHex('#111B1A')
                                      //                     : AppColor.backgroundColor,
                                      //                 borderRadius:
                                      //                 BorderRadius.circular(10.h),
                                      //                 boxShadow: [
                                      //                   BoxShadow(
                                      //                     color: Theme.of(context)
                                      //                         .brightness ==
                                      //                         Brightness.dark
                                      //                         ? HexColor.fromHex('#D1D9E6')
                                      //                         .withOpacity(0.1)
                                      //                         : Colors.white,
                                      //                     blurRadius: 5,
                                      //                     spreadRadius: 0,
                                      //                     offset: Offset(-5, -5),
                                      //                   ),
                                      //                   BoxShadow(
                                      //                     color: Theme.of(context)
                                      //                         .brightness ==
                                      //                         Brightness.dark
                                      //                         ? Colors.black.withOpacity(0.75)
                                      //                         : HexColor.fromHex('#9F2DBC')
                                      //                         .withOpacity(0.15),
                                      //                     blurRadius: 5,
                                      //                     spreadRadius: 0,
                                      //                     offset: Offset(5, 5),
                                      //                   ),
                                      //                 ]),
                                      //             child: Container(
                                      //               decoration: BoxDecoration(
                                      //                   color: Theme.of(context).brightness ==
                                      //                       Brightness.dark
                                      //                       ? HexColor.fromHex('#111B1A')
                                      //                       : AppColor.backgroundColor,
                                      //                   borderRadius:
                                      //                   BorderRadius.circular(10.h),
                                      //                   gradient: Theme.of(context)
                                      //                       .brightness ==
                                      //                       Brightness.dark
                                      //                       ? LinearGradient(
                                      //                       begin: Alignment.topCenter,
                                      //                       end: Alignment.bottomCenter,
                                      //                       colors: [
                                      //                         HexColor.fromHex(
                                      //                             '#CC0A00')
                                      //                             .withOpacity(0.15),
                                      //                         HexColor.fromHex(
                                      //                             '#9F2DBC')
                                      //                             .withOpacity(0.15),
                                      //                       ])
                                      //                       : LinearGradient(
                                      //                       begin: Alignment.topCenter,
                                      //                       end: Alignment.bottomCenter,
                                      //                       colors: [
                                      //                         HexColor.fromHex(
                                      //                             '#FF9E99')
                                      //                             .withOpacity(0.1),
                                      //                         HexColor.fromHex(
                                      //                             '#9F2DBC')
                                      //                             .withOpacity(0.023),
                                      //                       ])),
                                      //               child: Container(
                                      //                 // height: MediaQuery.of(context).size.height * 0.5,
                                      //                 width: double.infinity,
                                      //                 padding: EdgeInsets.all(10),
                                      //                 height: 60,
                                      //                 child: Row(
                                      //                   crossAxisAlignment:
                                      //                   CrossAxisAlignment.center,
                                      //                   mainAxisSize: MainAxisSize.min,
                                      //                   mainAxisAlignment:
                                      //                   MainAxisAlignment.spaceBetween,
                                      //                   children: [
                                      //                     Body1AutoText(
                                      //                       text: DateFormat(DateUtil.HHmma)
                                      //                           .format(DateTime.parse(widget
                                      //                           .chartDatas[index]
                                      //                           .date
                                      //                           .toString())),
                                      //                       fontSize: 14,
                                      //                       maxLine: 1,
                                      //                       fontWeight: FontWeight.bold,
                                      //                       color: Theme.of(context)
                                      //                           .brightness ==
                                      //                           Brightness.dark
                                      //                           ? Colors.white
                                      //                           .withOpacity(0.87)
                                      //                           : HexColor.fromHex('#384341'),
                                      //                     ),
                                      //                     Rich1Text(
                                      //                       text1:  widget.chartDatas[index].yValue
                                      //                           .toStringAsFixed(0),
                                      //                       text2: ' ${unitFromHistoryType(widget.historyItemType)}',
                                      //                       fontSize1: 14.sp,
                                      //                       fontSize2: 12.sp,
                                      //                       color1: Colors.black,
                                      //                       color2: Colors.black,
                                      //                     ),
                                      //
                                      //                     FutureBuilder<String>(
                                      //                       initialData: "-",
                                      //                       future: dbHelper
                                      //                           .getZoneFromHRZoneName(widget
                                      //                           .chartDatas[index]
                                      //                           .yValue),
                                      //                       builder: (BuildContext context,
                                      //                           AsyncSnapshot<String>
                                      //                           snapshot) {
                                      //                         return Body1AutoText(
                                      //                           text:
                                      //                           snapshot.data.toString(),
                                      //                           fontSize: 14,
                                      //                           maxLine: 1,
                                      //                           fontWeight: FontWeight.bold,
                                      //                           color: Theme.of(context)
                                      //                               .brightness ==
                                      //                               Brightness.dark
                                      //                               ? Colors.white
                                      //                               .withOpacity(0.87)
                                      //                               : HexColor.fromHex(
                                      //                               '#384341'),
                                      //                         );
                                      //                       },
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //             )),
                                      //       );
                                      //     })
                                    ],
                                  )
                                  // Container()
                                ],
                              )
                            : Container()
                        /*
                 Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bar_chart,
                        ),
                        SizedBox(width: 4.0.w),
                        Body1Text(
                          text: Strings().exerciseZone,
                          fontWeight: FontWeight.bold,
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            if (getTime(widget.exerciseTime)[0] != 0)
                              Rich1Text(
                                text1:
                                    getTime(widget.exerciseTime)[0].toString(),
                                text2: ' ${Strings().hourShort}',
                                color1: Colors.black,
                                color2: Colors.black,
                                fontSize1: 30.sp,
                                fontSize2: 15.sp,
                              ),
                            SizedBox(width: 4.0.w,),
                            Rich1Text(
                              text1: getTime(widget.exerciseTime)[1].toString(),
                              text2: ' ${Strings().minShort}',
                              color1: Colors.black,
                              color2: Colors.black,
                              fontSize1: 30.sp,
                              fontSize2: 15.sp,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Rich1Text(
                          text1: widget.calories.toString(),
                          text2: ' ${Strings().calories.toLowerCase()}',
                          color1: Colors.black,
                          color2: Colors.black,
                          fontSize1: 30.sp,
                          fontSize2: 15.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0.h,
                  ),
                  for (var item in widget.exerciseData.keys)
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40.0.h,
                            width: (MediaQuery.of(context).size.width * 0.6 * (widget.exerciseData[item]!/totalTime))+1,
                            decoration: BoxDecoration(
                              color: getBarColor(item)
                            ),
                          ),
                          SizedBox(width: 4.0.w,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (getTime(widget.exerciseData[item])[0] != 0)
                                    Rich1Text(
                                      text1: getTime(widget.exerciseData[item])[0]
                                          .toString(),
                                      text2: ' ${Strings().hourShort}',
                                      color1: Colors.black,
                                      color2: Colors.black,
                                      fontSize1: 16.sp,
                                      fontSize2: 15.sp,
                                    ),
                                  if (getTime(widget.exerciseData[item])[0] != 0)
                                    SizedBox(width: 4.0.w,),
                                  Rich1Text(
                                    text1: getTime(widget.exerciseData[item])[1]
                                        .toString(),
                                    text2: ' ${Strings().minShort}',
                                    color1: Colors.black,
                                    color2: Colors.black,
                                    fontSize1: 16.sp,
                                    fontSize2: 15.sp,
                                  ),
                                ],
                              ),
                              Body1Text(
                                text: item,
                                align: TextAlign.center,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    */
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Center(
                      child: Body1Text(
                        text: 'No Heart Rate Data Found.',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

/*
  List<int> getTime(int? t) {
    return t != null ? [t ~/ 60, t % 60] : [0, 0];
  }

  void setHighestTimeValue(Map<String, int> data) {
    for (var val in data.values) {
      totalTime += val;
    }
  }

  Color getBarColor(String item) {
    switch (item) {
      case 'peak':
        return Colors.red;
      case 'cardio':
        return Colors.orange;
      case 'fat burn':
        return Colors.yellow;
      default:
        return Colors.blue;
    }
  }
   */
}
