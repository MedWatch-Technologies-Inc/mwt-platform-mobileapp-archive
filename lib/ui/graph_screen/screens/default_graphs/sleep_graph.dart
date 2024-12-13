import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/bar_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_manager.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_shared_preference_manager_model.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/ui/graph_screen/providers/graph_provider_list.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:intl/intl.dart';

import '../../graph_item_data.dart';

class SleepGraph extends StatefulWidget {
  final DateTime selectedDate;
  final GraphTab graphTab;
  final List<GraphTypeModel> graphTypeList;
  final int index;
  final List<GraphTypeModel> selectedGraphTypeList;
  final GraphProviderList prov;
  final DateTime startDate;
  final DateTime endDate;
  final ChartType chartType;
  final WindowModel graphWindow;

  SleepGraph(
      {required this.selectedDate,
      required this.graphTab,
      required this.graphTypeList,
      required this.index,
      required this.selectedGraphTypeList,
      required this.prov,
      required this.startDate,
      required this.graphWindow,
      required this.endDate,
      required this.chartType});

  @override
  _SleepGraphState createState() => _SleepGraphState();
}

class _SleepGraphState extends State<SleepGraph> {
  SleepInfoModel? daySleepInfoModel;
  List<GraphItemData> hrList = [];
  List<GraphItemData> oxygenList = [];
  List<GraphItemData> tempList = [];
  List<GraphItemData> sleepItemList = [];
  List<GraphTypeModel> sleepChartTypeList = [];
  List<GraphTypeModel> sleepGraphTypeList = [];
  List<GraphItemData> graphItemList = [];
  List sleepList = [];

  int sleepAxisCount = 0;
  double startSleepTime = 0.0;

  List<chart.Series<GraphItemData, num>> sleepLineChartSeries = [];
  List<chart.Series<SleepGraphData, num>> sleepHrChartSeries = [];
  List<chart.Series<SleepGraphData, num>> sleepOxygenChartSeries = [];
  List<chart.Series<SleepGraphData, num>> sleepTempChartSeries = [];
  Widget sleepLineChartWidget = Container();
  Widget hrLineChartWidget = Container();
  Widget oxygenLineChartWidget = Container();
  Widget tempLineChartWidget = Container();
  List<chart.Series<SleepGraphData, num>> lineChartTemperatureSeries = [];
  List<chart.Series<SleepGraphData, num>> lineChartOxygenSeries = [];

  List<chart.Series<GraphItemData, String>> hrBarChartSeries = [];
  Widget hrBarChartWidget = Container();
  List<chart.Series<GraphItemData, String>> sleepBarChartSeries = [];
  Widget sleepBarChartWidget = Container();
  Widget oxygenBarChartWidget = Container();
  Widget tempBarChartWidget = Container();

  List<chart.Series<GraphItemData, num>> hrLineChartSeries = [];
  List<chart.Series<GraphItemData, num>> tempLineChartSeries = [];
  List<chart.Series<GraphItemData, num>> oxygenLineChartSeries = [];

  List<chart.Series<GraphItemData, String>> tempBarChartSeries = [];
  List<chart.Series<GraphItemData, String>> oxygenBarChartSeries = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.graphTab == GraphTab.day
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        height: 250.h,
                        child: widget.selectedGraphTypeList.first.fieldName ==
                                'approxHr'
                            ? sleepLineChartWidget
                            : widget.selectedGraphTypeList.first.fieldName ==
                                    'Oxygen'
                                ? oxygenLineChartWidget
                                : tempLineChartWidget),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.only(right: 20.w),
                        height: 22.h,
                        child: Text(
                          'SLEEP',
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#FF9E99')
                                  : HexColor.fromHex('#FF6259'),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    sleepLegends()
                  ],
                )
              : widget.selectedGraphTypeList.first.fieldName == 'approxHr'
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 200.h,
                          child: widget.chartType == ChartType.line
                              ? hrLineChartWidget
                              : hrBarChartWidget,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: 20.h,
                            child: AutoSizeText(
                              'SLEEP',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? HexColor.fromHex('#FF9E99')
                                      : HexColor.fromHex('#FF6259'),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          height: 200.h,
                          child: widget.chartType == ChartType.line
                              ? sleepLineChartWidget
                              : sleepBarChartWidget,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        widget.chartType == ChartType.line
                            ? sleepIndicator()
                            : sleepLegends(),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    )
                  : widget.selectedGraphTypeList.first.fieldName == 'Oxygen'
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 200.h,
                              child: widget.chartType == ChartType.line
                                  ? oxygenLineChartWidget
                                  : oxygenBarChartWidget,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 20.h,
                                child: AutoSizeText(
                                  'SLEEP',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#FF9E99')
                                          : HexColor.fromHex('#FF6259'),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              height: 200.h,
                              child: widget.chartType == ChartType.line
                                  ? sleepLineChartWidget
                                  : sleepBarChartWidget,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            widget.chartType == ChartType.line
                                ? sleepIndicator()
                                : sleepLegends(),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 200.h,
                              child: widget.chartType == ChartType.line
                                  ? tempLineChartWidget
                                  : tempBarChartWidget,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                height: 20.h,
                                child: AutoSizeText(
                                  'SLEEP',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? HexColor.fromHex('#FF9E99')
                                          : HexColor.fromHex('#FF6259'),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              height: 200.h,
                              child: widget.chartType == ChartType.line
                                  ? sleepLineChartWidget
                                  : sleepBarChartWidget,
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            widget.chartType == ChartType.line
                                ? sleepIndicator()
                                : sleepLegends(),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      future: getSleepDayData(),
    );
  }

  Widget sleepIndicator() {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 12.h,
            width: 12.h,
            decoration: BoxDecoration(
              color: AppColor.progressColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            '${stringLocalization.getText(StringLocalization.light)}'
                .toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.h,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                    : HexColor.fromHex('#5D6A68'),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 40.w,
          ),
          Container(
            height: 12.h,
            width: 12.h,
            decoration: BoxDecoration(
              color: AppColor.deepSleepColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            '${stringLocalization.getText(StringLocalization.deep)}'
                .toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.h,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                    : HexColor.fromHex('#5D6A68'),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 40.w,
          ),
          Container(
            height: 12.h,
            width: 12.h,
            decoration: BoxDecoration(
              color: AppColor.purpleColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 10.w),
          Text(
            '${stringLocalization.getText(StringLocalization.awake)}'
                .toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.h,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                    : HexColor.fromHex('#5D6A68'),
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget sleepLegends() {
    int awakePercentage = 0;
    int deepSleepPercentage = 0;
    int lightSleepPercentage = 0;
    if (widget.graphTab == GraphTab.day) {
      if (daySleepInfoModel != null) {
        // int totalMinutes = sleepModel.sleepAllTime??1;
        daySleepInfoModel = trimSleep(daySleepInfoModel!);
        int totalMinutes = (daySleepInfoModel!.lightTime) +
            (daySleepInfoModel!.deepTime) +
            (daySleepInfoModel!.stayUpTime);
        if (totalMinutes != 0) {
          lightSleepPercentage =
              ((daySleepInfoModel!.lightTime * 100) / totalMinutes).floor();
          deepSleepPercentage =
              ((daySleepInfoModel!.deepTime * 100) / totalMinutes).ceil();
          // deepSleepPercentage = ((sleepModel.deepTime * 100) / totalMinutes).ceil();
          if (lightSleepPercentage < 0) {
            lightSleepPercentage = 0;
          }
          if (deepSleepPercentage < 0) {
            deepSleepPercentage = 0;
          }
          awakePercentage = 100 - (lightSleepPercentage + deepSleepPercentage);
          if (awakePercentage < 0) {
            awakePercentage = 0;
          }
        }
      }
    } else {
      if (sleepItemList != null) {
        int totalMinutes = 0;
        int lightSleepMinutes = 0;
        int deepSleepMinutes = 0;
        int awakeMinutes = 0;

        sleepItemList.forEach((element) {
          if (element.label == 'lightTime') {
            lightSleepMinutes += (element.yValue * 60).toInt();
            totalMinutes += (element.yValue * 60).toInt();
          } else if (element.label == 'deepTime') {
            deepSleepMinutes += (element.yValue * 60).toInt();
            totalMinutes += (element.yValue * 60).toInt();
          } else if (element.label == 'stayUpTime') {
            awakeMinutes += (element.yValue * 60).toInt();
            totalMinutes += (element.yValue * 60).toInt();
          }
        });
        if (totalMinutes == 0) {
          totalMinutes = 1;
        }
        lightSleepPercentage =
            ((lightSleepMinutes * 100) / totalMinutes).round();
        deepSleepPercentage = ((deepSleepMinutes * 100) / totalMinutes).round();
        awakePercentage = ((awakeMinutes * 100) / totalMinutes).round();
        if ((lightSleepPercentage != 0 &&
                deepSleepPercentage != 0 &&
                awakePercentage != 0) &&
            (lightSleepPercentage + deepSleepPercentage + awakePercentage !=
                100)) {
          awakePercentage += 100 -
              (lightSleepPercentage + deepSleepPercentage + awakePercentage);
        }
      }
    }
    bool noSleepData = ((awakePercentage == 0) &&
        (deepSleepPercentage == 0) &&
        (lightSleepPercentage == 0));
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
          decoration: BoxDecoration(
            //border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(15.h),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.25)
                      : Colors.white,
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(-5, -5)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: lightSleepPercentage > 0.0
                      ? lightSleepPercentage.ceil()
                      : noSleepData
                          ? 1
                          : 0,
                  child: Container(
                    height: 12.h,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppColor.progressColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: deepSleepPercentage > 0.0
                      ? deepSleepPercentage.floor()
                      : noSleepData
                          ? 1
                          : 0,
                  child: Container(
                    height: 12.h,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppColor.deepSleepColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: awakePercentage > 0.0
                      ? awakePercentage.toInt()
                      : noSleepData
                          ? 1
                          : 0,
                  child: Container(
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: AppColor.purpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          //color: Colors.yellow,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 12.h,
                      width: 12.h,
                      decoration: BoxDecoration(
                        color: AppColor.progressColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        '$lightSleepPercentage% ${stringLocalization.getText(StringLocalization.light)}'
                            .toUpperCase(),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                : HexColor.fromHex('#5D6A68'),
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              //SizedBox(width: 20.w),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 12.h,
                        width: 12.h,
                        decoration: BoxDecoration(
                          color: AppColor.deepSleepColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          '$deepSleepPercentage% ${stringLocalization.getText(StringLocalization.deep)}'
                              .toUpperCase(),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                  : HexColor.fromHex('#5D6A68'),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //SizedBox(width: 20.w),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 12.h,
                        width: 12.h,
                        decoration: BoxDecoration(
                          color: AppColor.purpleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          '$awakePercentage% ${stringLocalization.getText(StringLocalization.awake)}'
                              .toUpperCase(),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                  : HexColor.fromHex('#5D6A68'),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<bool> getSleepDayData() async {
    var nextDay = DateTime(widget.selectedDate.year, widget.selectedDate.month,
        widget.selectedDate.day + 1);
    var last = DateFormat('yyyy-MM-dd').format(nextDay);
    var first = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    var list = await dbHelper.getSleepDataDateWise(
        first, last, globalUser?.userId ?? '');
    daySleepInfoModel = null;
    var distinctList = <SleepInfoModel>[];
    for (var element in list) {
      if (element.data.isNotEmpty) {
        distinctList.add(element);
      }
    }
    list = distinctList;
    if (list.isNotEmpty && list[0].data.isNotEmpty) {
      daySleepInfoModel = list[0];
      if (daySleepInfoModel != null) {
        daySleepInfoModel = trimSleep(daySleepInfoModel!);
      }
    }

    // hrList = await dbHelper.getHrData(userId, daySleepInfoModel!.data.first.dateTime.toString(),  daySleepInfoModel!.data.last.dateTime.toString());
    if (widget.graphTab == GraphTab.day) {
      // to get Hr data from start time of sleep to the end time of sleep.
      if (daySleepInfoModel != null) {
        hrList = await GraphDataManager().graphManager(
            userId: globalUser?.userId ?? '',
            startDate: daySleepInfoModel!.data.first.dateTime!,
            endDate: daySleepInfoModel!.data.last.dateTime!,
            selectedGraphTypes: [
              widget.graphTypeList.firstWhere((element) =>
                  element.fieldName == DefaultGraphItem.hr.fieldName)
            ],
            isEnableNormalize: false,
            unitType: 1);

        sleepItemList = await GraphDataManager().graphManager(
            userId: globalUser?.userId ?? '',
            startDate: daySleepInfoModel!.data.first.dateTime!,
            endDate: daySleepInfoModel!.data.last.dateTime!,
            selectedGraphTypes: [
              widget.graphTypeList.firstWhere((element) =>
                  element.fieldName == DefaultGraphItem.deepSleep.fieldName),
              widget.graphTypeList.firstWhere((element) =>
                  element.fieldName == DefaultGraphItem.lightSleep.fieldName),
              widget.graphTypeList.firstWhere((element) =>
                  element.fieldName == DefaultGraphItem.awake.fieldName),
            ],
            isEnableNormalize: false,
            unitType: 1);
        oxygenList = await GraphDataManager().graphManager(
            userId: globalUser?.userId ?? '',
            startDate: daySleepInfoModel!.data.first.dateTime!,
            endDate: daySleepInfoModel!.data.last.dateTime!,
            selectedGraphTypes: [
              widget.graphTypeList.firstWhere((element) =>
                  element.fieldName == DefaultGraphItem.oxygen.fieldName)
            ],
            isEnableNormalize: false,
            unitType: 1);
        tempList = await GraphDataManager().graphManager(
            userId: globalUser?.userId ?? '',
            startDate: daySleepInfoModel!.data.first.dateTime!,
            endDate: daySleepInfoModel!.data.last.dateTime!,
            selectedGraphTypes: [
              widget.graphTypeList.firstWhere((element) =>
                  element.fieldName == DefaultGraphItem.temperature.fieldName)
            ],
            isEnableNormalize: false,
            unitType: 1);
      }
    } else {
      hrList = await GraphDataManager().graphManager(
          userId: globalUser?.userId ?? '',
          startDate: widget.startDate,
          endDate: widget.endDate,
          selectedGraphTypes: [
            widget.graphTypeList.firstWhere(
                (element) => element.fieldName == DefaultGraphItem.hr.fieldName)
          ],
          isEnableNormalize: false,
          unitType: 1);
      sleepItemList = await GraphDataManager().graphManager(
          userId: globalUser?.userId ?? '',
          startDate: widget.startDate,
          endDate: widget.endDate,
          selectedGraphTypes: [
            widget.graphTypeList.firstWhere((element) =>
                element.fieldName == DefaultGraphItem.deepSleep.fieldName),
            widget.graphTypeList.firstWhere((element) =>
                element.fieldName == DefaultGraphItem.awake.fieldName),
            widget.graphTypeList.firstWhere((element) =>
                element.fieldName == DefaultGraphItem.lightSleep.fieldName),
          ],
          isEnableNormalize: false,
          unitType: 1);
      oxygenList = await GraphDataManager().graphManager(
          userId: globalUser?.userId ?? '',
          startDate: widget.startDate,
          endDate: widget.endDate,
          selectedGraphTypes: [
            widget.graphTypeList.firstWhere((element) =>
                element.fieldName == DefaultGraphItem.oxygen.fieldName)
          ],
          isEnableNormalize: false,
          unitType: 1);
      tempList = await GraphDataManager().graphManager(
          userId: globalUser?.userId ?? '',
          startDate: widget.startDate,
          endDate: widget.endDate,
          selectedGraphTypes: [
            widget.graphTypeList.firstWhere((element) =>
                element.fieldName == DefaultGraphItem.temperature.fieldName)
          ],
          isEnableNormalize: false,
          unitType: 1);
    }
    makeOrRefreshSleepGraph();
    return true;
  }

  void makeOrRefreshSleepGraph() {
    if (widget.graphTab == GraphTab.day) {
      try {
        sleepHrChartSeries = generateSleepChartData('hr');
        sleepLineChartWidget = chart.LineChart(
          sleepHrChartSeries,
          animate: false,
          customSeriesRenderers: [
            chart.LineRendererConfig(
              customRendererId: widget.selectedGraphTypeList[0].fieldName,
              includeArea: true,
              stacked: true,
              includePoints: false,
              includeLine: true,
              roundEndCaps: true,
              radiusPx: 2.0,
              strokeWidthPx: 1.0,
              areaOpacity:
                  Theme.of(context).brightness == Brightness.dark ? 0.8 : 0.3,
            )
          ],
          primaryMeasureAxis: chart.NumericAxisSpec(
            renderSpec: chart.GridlineRendererSpec(
                labelStyle: chart.TextStyleSpec(
                    fontSize: 10,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? chart.MaterialPalette.white
                        : chart.MaterialPalette.black)),
            tickProviderSpec: chart.BasicNumericTickProviderSpec(
                desiredTickCount: 6, zeroBound: true),
          ),
          domainAxis: chart.NumericAxisSpec(
            tickProviderSpec: chart.BasicNumericTickProviderSpec(
                zeroBound: false, desiredTickCount: sleepAxisCount),
            tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
              _formattXAxis,
            ),
            renderSpec: chart.GridlineRendererSpec(
              tickLengthPx: 0,
              labelOffsetFromAxisPx: 10,
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black),
            ),
            viewport: chart.NumericExtents(0.0, sleepAxisCount),
          ),
        );
      } catch (e) {
        LoggingService()
            .printLog(message: e.toString(), tag: 'hr vs sleep graph');
      }

      try {
        sleepOxygenChartSeries = generateSleepChartData('Oxygen');
        oxygenLineChartWidget = chart.LineChart(
          sleepOxygenChartSeries,
          animate: false,
          customSeriesRenderers: [
            chart.LineRendererConfig(
              customRendererId: widget.selectedGraphTypeList[0].fieldName,
              includeArea: true,
              stacked: true,
              includePoints: false,
              includeLine: true,
              roundEndCaps: true,
              radiusPx: 2.0,
              strokeWidthPx: 1.0,
              areaOpacity:
                  Theme.of(context).brightness == Brightness.dark ? 0.8 : 0.3,
            )
          ],
          primaryMeasureAxis: chart.NumericAxisSpec(
            renderSpec: chart.GridlineRendererSpec(
                labelStyle: chart.TextStyleSpec(
                    fontSize: 10,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? chart.MaterialPalette.white
                        : chart.MaterialPalette.black)),
            tickProviderSpec: chart.BasicNumericTickProviderSpec(
                desiredTickCount: 6, zeroBound: true),
          ),
          domainAxis: chart.NumericAxisSpec(
            tickProviderSpec: chart.BasicNumericTickProviderSpec(
                zeroBound: false, desiredTickCount: sleepAxisCount),
            tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
              _formattXAxis,
            ),
            renderSpec: chart.GridlineRendererSpec(
              tickLengthPx: 0,
              labelOffsetFromAxisPx: 10,
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black),
            ),
            viewport: chart.NumericExtents(0.0, sleepAxisCount),
          ),
        );
      } catch (e) {
        LoggingService()
            .printLog(message: e.toString(), tag: 'oxygen vs sleep graph');
      }

      try {
        sleepTempChartSeries = generateSleepChartData('Temperature');
        tempLineChartWidget = chart.LineChart(
          sleepTempChartSeries,
          animate: false,
          customSeriesRenderers: [
            chart.LineRendererConfig(
              customRendererId: widget.selectedGraphTypeList[0].fieldName,
              includeArea: true,
              stacked: true,
              includePoints: false,
              includeLine: true,
              roundEndCaps: true,
              radiusPx: 2.0,
              strokeWidthPx: 1.0,
              areaOpacity:
                  Theme.of(context).brightness == Brightness.dark ? 0.8 : 0.3,
            )
          ],
          primaryMeasureAxis: chart.NumericAxisSpec(
            renderSpec: chart.GridlineRendererSpec(
                labelStyle: chart.TextStyleSpec(
                    fontSize: 10,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? chart.MaterialPalette.white
                        : chart.MaterialPalette.black)),
            tickProviderSpec: chart.BasicNumericTickProviderSpec(
                desiredTickCount: 6, zeroBound: true),
          ),
          domainAxis: chart.NumericAxisSpec(
            tickProviderSpec: chart.BasicNumericTickProviderSpec(
                zeroBound: false, desiredTickCount: sleepAxisCount),
            tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
              _formattXAxis,
            ),
            renderSpec: chart.GridlineRendererSpec(
              tickLengthPx: 0,
              labelOffsetFromAxisPx: 10,
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black),
            ),
            viewport: chart.NumericExtents(0.0, sleepAxisCount),
          ),
        );
      } catch (e) {
        LoggingService()
            .printLog(message: e.toString(), tag: 'temp vs sleep graph');
      }
    } else {
      hrWeekMonthGraph();
      sleepWeekMonthGraph();
      temperatureWeekMonthGraph();
      oxygenWeekMonthGraph();
    }
    if (mounted) {
      widget.prov.graphProviderList[widget.index].isShowLoadingScreen = false;
    }
  }

  void hrWeekMonthGraph() {
    var newGraphTypeList = <GraphTypeModel>[];
    hrList = makeDefaultValueForXAxisToBarChart(hrList);
    try {
      newGraphTypeList = [
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.hr.fieldName)
      ];
      hrLineChartSeries =
          LineGraphData(graphList: newGraphTypeList, graphItemList: hrList)
              .getLineGraphData();

      var tempLineChartSeries = hrLineChartSeries;
      for (var element in tempLineChartSeries) {
        for (var data in element.data) {
          data.xValue = data.xValue - 1;
        }
      }
      hrLineChartWidget = chart.LineChart(
        tempLineChartSeries,
        animate: false,
        customSeriesRenderers: List.generate(newGraphTypeList.length, (index) {
          return chart.LineRendererConfig(
              customRendererId: newGraphTypeList[index].fieldName,
              includeArea: true,
              stacked: true,
              includePoints: true,
              includeLine: true,
              roundEndCaps: true,
              radiusPx: 2.0,
              strokeWidthPx: 1.0);
        }),
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
              desiredTickCount: 5, zeroBound: false),
        ),
        domainAxis: chart.NumericAxisSpec(
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            zeroBound: true,
            desiredTickCount: xAxisCount(),
          ),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
            _formatterXAxis,
          ),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
          viewport: chart.NumericExtents(0, xAxisCount() - 1),
        ),
      );
    } catch (e) {
      LoggingService()
          .printLog(message: e.toString(), tag: 'hr week and month line graph');
    }

    try {
      hrBarChartSeries =
          BarGraphData(graphList: newGraphTypeList, graphItemList: hrList)
              .getBarGraphData();
      hrBarChartWidget = chart.BarChart(
        hrBarChartSeries,
        animate: true,
        barGroupingType: chart.BarGroupingType.grouped,
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
//          viewport: NumericExtents(0,100)
        ),
        domainAxis: chart.OrdinalAxisSpec(
          tickProviderSpec: chart.StaticOrdinalTickProviderSpec(hrList.map((e) {
            return chart.TickSpec(e.xValue.toInt().toString(),
                label: _formatterXAxis(e.xValue.toInt()),
                style: chart.TextStyleSpec(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? chart.MaterialPalette.white
                        : chart.MaterialPalette.black));
          }).toList()),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
        ),
      );
    } catch (e) {
      LoggingService()
          .printLog(tag: 'hr week and month bar graph', message: e.toString());
    }
  }

  void sleepWeekMonthGraph() {
    var newGraphTypeList = <GraphTypeModel>[];
    try {
      newGraphTypeList = [
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.lightSleep.fieldName),
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.deepSleep.fieldName),
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.awake.fieldName),
      ];
      sleepItemList =
          makeDefaultValueForSleepChart(sleepItemList, newGraphTypeList);
      sleepLineChartSeries = LineGraphData(
              graphList: newGraphTypeList, graphItemList: sleepItemList)
          .getLineGraphData();

      var tempLineChartSeries = sleepLineChartSeries;
      if (tempLineChartSeries.isNotEmpty &&
          tempLineChartSeries[0].data.isNotEmpty &&
          tempLineChartSeries[0].data.first.xValue == 1) {
        for (var element in tempLineChartSeries) {
          for (var data in element.data) {
            data.xValue = data.xValue - 1;
          }
        }
      }
      sleepLineChartWidget = chart.LineChart(
        tempLineChartSeries,
        animate: false,
        customSeriesRenderers: List.generate(newGraphTypeList.length, (index) {
          return chart.LineRendererConfig(
              customRendererId: newGraphTypeList[index].fieldName,
              includeArea: true,
              stacked: true,
              includePoints: true,
              includeLine: true,
              roundEndCaps: true,
              radiusPx: 2.0,
              strokeWidthPx: 1.0);
        }),
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
              desiredTickCount: 5, zeroBound: false),
        ),
        domainAxis: chart.NumericAxisSpec(
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            zeroBound: true,
            desiredTickCount: xAxisCount(),
          ),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
            _formatterXAxis,
          ),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
          viewport: chart.NumericExtents(0, xAxisCount() - 1),
        ),
      );
    } catch (e) {
      LoggingService().printLog(
          message: e.toString(), tag: 'sleep week and month line graph');
    }

    try {
      newGraphTypeList = [
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.lightSleep.fieldName),
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.deepSleep.fieldName),
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.awake.fieldName),
      ];
      sleepItemList =
          makeDefaultValueForSleepChart(sleepItemList, newGraphTypeList);
      sleepBarChartSeries = BarGraphData(
              graphList: newGraphTypeList, graphItemList: sleepItemList)
          .getBarGraphData();
      sleepBarChartWidget = chart.BarChart(
        sleepBarChartSeries,
        animate: true,
        barGroupingType: chart.BarGroupingType.groupedStacked,
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
//          viewport: NumericExtents(0,100)
        ),
        secondaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
        ),
        domainAxis: chart.OrdinalAxisSpec(
          tickProviderSpec:
              chart.StaticOrdinalTickProviderSpec(sleepItemList.map((e) {
            return chart.TickSpec(e.xValue.toInt().toString(),
                label: _formatterXAxis(e.xValue.toInt()),
                style: chart.TextStyleSpec(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? chart.MaterialPalette.white
                        : chart.MaterialPalette.black));
          }).toList()),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
        ),
      );
    } catch (e) {
      LoggingService().printLog(
          tag: 'sleep week and month bar graph', message: e.toString());
    }
  }

  void temperatureWeekMonthGraph() {
    var newGraphTypeList = <GraphTypeModel>[];
    tempList = makeDefaultValueForXAxisToBarChart(tempList);
    try {
      newGraphTypeList = [
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.temperature.fieldName)
      ];
      tempLineChartSeries =
          LineGraphData(graphList: newGraphTypeList, graphItemList: tempList)
              .getLineGraphData();

      var tempChartSeries = tempLineChartSeries;
      for (var element in tempChartSeries) {
        for (var data in element.data) {
          data.xValue = data.xValue - 1;
        }
      }
      tempLineChartWidget = chart.LineChart(
        tempChartSeries,
        animate: false,
        customSeriesRenderers: List.generate(newGraphTypeList.length, (index) {
          return chart.LineRendererConfig(
              customRendererId: newGraphTypeList[index].fieldName,
              includeArea: true,
              stacked: true,
              includePoints: true,
              includeLine: true,
              roundEndCaps: true,
              radiusPx: 2.0,
              strokeWidthPx: 1.0);
        }),
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
              desiredTickCount: 5, zeroBound: false),
        ),
        domainAxis: chart.NumericAxisSpec(
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            zeroBound: true,
            desiredTickCount: xAxisCount(),
          ),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
            _formatterXAxis,
          ),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
          viewport: chart.NumericExtents(0, xAxisCount() - 1),
        ),
      );
    } catch (e) {
      LoggingService().printLog(
          message: e.toString(), tag: 'temp week and month line graph');
    }

    try {
      tempBarChartSeries =
          BarGraphData(graphList: newGraphTypeList, graphItemList: tempList)
              .getBarGraphData();
      tempBarChartWidget = chart.BarChart(
        tempBarChartSeries,
        animate: true,
        barGroupingType: chart.BarGroupingType.grouped,
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
//          viewport: NumericExtents(0,100)
        ),
        domainAxis: chart.OrdinalAxisSpec(
          tickProviderSpec:
              chart.StaticOrdinalTickProviderSpec(tempList.map((e) {
            return chart.TickSpec(e.xValue.toInt().toString(),
                label: _formatterXAxis(e.xValue.toInt()),
                style: chart.TextStyleSpec(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? chart.MaterialPalette.white
                        : chart.MaterialPalette.black));
          }).toList()),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
        ),
      );
    } catch (e) {
      LoggingService().printLog(
          tag: 'temp week and month bar graph', message: e.toString());
    }
  }

  void oxygenWeekMonthGraph() {
    var newGraphTypeList = <GraphTypeModel>[];
    oxygenList = makeDefaultValueForXAxisToBarChart(oxygenList);
    try {
      newGraphTypeList = [
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.oxygen.fieldName)
      ];
      oxygenLineChartSeries =
          LineGraphData(graphList: newGraphTypeList, graphItemList: oxygenList)
              .getLineGraphData();

      var tempLineChartSeries = oxygenLineChartSeries;
      for (var element in tempLineChartSeries) {
        for (var data in element.data) {
          data.xValue = data.xValue - 1;
        }
      }
      oxygenLineChartWidget = chart.LineChart(
        tempLineChartSeries,
        animate: false,
        customSeriesRenderers: List.generate(newGraphTypeList.length, (index) {
          return chart.LineRendererConfig(
              customRendererId: newGraphTypeList[index].fieldName,
              includeArea: true,
              stacked: true,
              includePoints: true,
              includeLine: true,
              roundEndCaps: true,
              radiusPx: 2.0,
              strokeWidthPx: 1.0);
        }),
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
              desiredTickCount: 5, zeroBound: false),
        ),
        domainAxis: chart.NumericAxisSpec(
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            zeroBound: true,
            desiredTickCount: xAxisCount(),
          ),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
            _formatterXAxis,
          ),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
          viewport: chart.NumericExtents(0, xAxisCount() - 1),
        ),
      );
    } catch (e) {
      LoggingService().printLog(
          message: e.toString(), tag: 'oxygen week and month line graph');
    }

    try {
      oxygenBarChartSeries =
          BarGraphData(graphList: newGraphTypeList, graphItemList: oxygenList)
              .getBarGraphData();
      oxygenBarChartWidget = chart.BarChart(
        oxygenBarChartSeries,
        animate: true,
        barGroupingType: chart.BarGroupingType.grouped,
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            desiredTickCount: 5,
            zeroBound: true,
          ),
//          viewport: NumericExtents(0,100)
        ),
        domainAxis: chart.OrdinalAxisSpec(
          tickProviderSpec:
              chart.StaticOrdinalTickProviderSpec(oxygenList.map((e) {
            return chart.TickSpec(e.xValue.toInt().toString(),
                label: _formatterXAxis(e.xValue.toInt()),
                style: chart.TextStyleSpec(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? chart.MaterialPalette.white
                        : chart.MaterialPalette.black));
          }).toList()),
          renderSpec: chart.GridlineRendererSpec(
            tickLengthPx: 0,
            labelOffsetFromAxisPx: 10,
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? chart.MaterialPalette.white
                    : chart.MaterialPalette.black),
          ),
        ),
      );
    } catch (e) {
      LoggingService().printLog(
          tag: 'oxygen week and month bar graph', message: e.toString());
    }
  }

  List<GraphItemData> makeDefaultValueForSleepChart(
      List<GraphItemData> sleepItemList, List<GraphTypeModel> graphItemList) {
    var loopLength = 0;
    if (widget.graphTab == GraphTab.day) {
      loopLength = 24;
    } else if (widget.graphTab == GraphTab.week) {
      loopLength = 7;
    } else if (widget.graphTab == GraphTab.month) {
      loopLength =
          DateTime(widget.startDate.day, widget.startDate.month + 1, 0).day;
    }
    var unAvailableXValues = <GraphItemData>[];
    for (var element in graphItemList) {
      for (var i = 1; i <= loopLength; i++) {
        var valueIsAlreadyExistForThisAxis = sleepItemList
            .any((e) => e.label == element.fieldName && e.xValue.toInt() == i);
        if (!valueIsAlreadyExistForThisAxis) {
          var emptyGraphItem = GraphItemData(
              label: element.fieldName,
              yValue: 0,
              xValue: i.toDouble(),
              xValueStr: i.toInt().toString());
          unAvailableXValues.add(emptyGraphItem);
        }
      }
    }
    sleepItemList.addAll(unAvailableXValues);
    return sleepItemList;
  }

  List<GraphItemData> makeDefaultValueForXAxisToBarChart(
      List<GraphItemData> selectedGraphList) {
    var loopLength = 0;
    if (widget.graphTab == GraphTab.day) {
      loopLength = 24;
    } else if (widget.graphTab == GraphTab.week) {
      loopLength = 7;
    } else if (widget.graphTab == GraphTab.month) {
      loopLength =
          DateTime(widget.startDate.day, widget.startDate.month + 1, 0).day;
    }

    var unAvailableXValues = <GraphItemData>[];
    for (var i = 1; i <= loopLength; i++) {
      var valueIsAlreadyExistForThisAxis = selectedGraphList.any((e) =>
          e.label == widget.selectedGraphTypeList[0].fieldName &&
          e.xValue.toInt() == i);
      if (!valueIsAlreadyExistForThisAxis) {
        var emptyGraphItem = GraphItemData(
            label: widget.selectedGraphTypeList[0].fieldName,
            yValue: 0,
            xValue: i.toDouble(),
            xValueStr: i.toInt().toString());
        unAvailableXValues.add(emptyGraphItem);
      }
    }
    selectedGraphList.addAll(unAvailableXValues);
    return selectedGraphList;
  }

  int xAxisCount() {
    if (widget.graphTab == GraphTab.day) {
      return 24;
    } else if (widget.graphTab == GraphTab.week) {
      return 7;
    } else if (widget.graphTab == GraphTab.month) {
      return daysInMonth(widget.startDate);
    }
    return widget.startDate.difference(widget.endDate).inDays;
  }

  int daysInMonth(DateTime date) {
    if (date != null) {
      var firstDayNextMonth = DateTime(date.year, date.month + 1, 0);
      return firstDayNextMonth.day;
    }
    return 31;
  }

  String _formatterXAxis(num? year) {
    if (widget.graphTab == GraphTab.week) {
      var date = DateTime.now();
      var lastMonday =
          date.subtract(Duration(days: date.weekday - (year!.toInt() + 1)));
      return DateFormat(DateUtil.EEE).format(lastMonday); // prints Tuesday
    }
    var value = year!.toInt();
    if (widget.graphTab == GraphTab.month) {
      value = value + 1;
    }
    if (value % 2 == 0) {
      return '';
    }
    return '$value';
  }

  String _formattXAxis(num? year) {
    if (widget.graphTab == GraphTab.week) {
      DateTime date = DateTime.now();
      var lastMonday =
          date.subtract(Duration(days: date.weekday - year!.toInt()));
      return DateFormat('EEE').format(lastMonday); // prints Tuesday
    }
    var value = year!.toInt() + startSleepTime.toInt();
    if (value < 24) {
      value -= 12;
      return '$value\npm';
    } else if (value == 24) {
      value -= 12;
      return '$value\nam';
    } else {
      value -= 24;
      return '$value\nam';
    }
  }

  List? makeListOfTypeByHours() {
    var current = DateTime.now();
    if (daySleepInfoModel != null && daySleepInfoModel!.data != null) {
      SleepDataInfoModel firstModel = daySleepInfoModel!.data.first;
      int? firstHour;
      int? firstMinute;
      DateTime? now;
      if (firstModel.time != null) {
        firstHour = int.parse(firstModel.time!.split(':')[0]);
        firstMinute = int.parse(firstModel.time!.split(':')[1]);
        now = DateTime(
            current.year,
            current.month,
            firstHour > 12 ? current.day - 1 : current.day,
            firstHour,
            firstMinute);
      }

      SleepDataInfoModel lastModel = daySleepInfoModel!.data.last;
      int? lastHour;
      int? lastMinute;
      DateTime? last;
      if (lastModel.time != null) {
        lastHour = int.parse(lastModel.time!.split(':')[0]);
        lastMinute = int.parse(lastModel.time!.split(':')[1]);
        last = DateTime(
            current.year,
            current.month,
            lastHour > 12 ? current.day - 1 : current.day,
            lastHour,
            lastMinute);
      }

      List listWithColorAndPercentage = [];
      for (int i = 0; i < daySleepInfoModel!.data.length; i++) {
        if (i == daySleepInfoModel!.data.length - 1) {
          break;
        }
        SleepDataInfoModel model = daySleepInfoModel!.data[i];
        SleepDataInfoModel nextModel = daySleepInfoModel!.data[i + 1];
        int? nowHour;
        int? nowMinute;
        if (model.time != null) {
          nowHour = int.parse(model.time!.split(':')[0]);
          nowMinute = int.parse(model.time!.split(':')[1]);
        }

        int? nextHour;
        int? nextMinute;
        if (model.time != null) {
          nextHour = int.parse(nextModel.time!.split(':')[0]);
          nextMinute = int.parse(nextModel.time!.split(':')[1]);
        }
        DateTime current = DateTime.now();

        if (nowHour != null &&
            nowMinute != null &&
            nextHour != null &&
            nextMinute != null) {
          DateTime nowDateTime = DateTime(current.year, current.month,
              nowHour > 12 ? current.day - 1 : current.day, nowHour, nowMinute);
          DateTime nextDateTime = DateTime(
              current.year,
              current.month,
              nextHour > 12 ? current.day - 1 : current.day,
              nextHour,
              nextMinute);
          listWithColorAndPercentage.add({
            'type': model.type,
            'time': model.time,
            'percentage':
                ((nextDateTime.difference(nowDateTime).inMinutes * 100) ~/
                    (daySleepInfoModel!.sleepAllTime == 0
                        ? 1
                        : daySleepInfoModel!.sleepAllTime)),
          });
        }
      }
      listWithColorAndPercentage.add({
        'type': daySleepInfoModel!.data.last.type,
        'time': daySleepInfoModel!.data.last.time,
        'percentage': 1
      });
      return listWithColorAndPercentage;
    }
    return null;
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
    }
  }

  double stringTimeToDouble(String time) {
    double t = 0;
    t += double.parse(time.split(':')[0]);
    double temp = double.parse(time.split(':')[1]);
    temp = (temp / 60);
    if (t < 12) {
      t += 24;
    }
    t += temp;
    t.toStringAsFixed(1);
    return t;
  }

  SleepInfoModel trimSleep(SleepInfoModel mSleepInfo) {
    List<SleepDataInfoModel> listOfRemoveItems = [];
    if (mSleepInfo.data != null) {
      List strList =
          mSleepInfo.data.map((e) => jsonEncode(e.toMap())).toSet().toList();
      mSleepInfo.data = strList
          .map((e) => SleepDataInfoModel.fromMap(jsonDecode(e)))
          .toList();

      try {
        mSleepInfo.data.forEach((element) {
          if (element.time != null && element.time.toString().isNotEmpty) {
            int firstItemHour = int.parse(element.time!.split(':')[0]);
            int firstItemMinute = int.parse(element.time!.split(':')[1]);
            DateTime current = widget.selectedDate;
            DateTime tempStartDate = DateTime(
                current.year,
                current.month,
                firstItemHour > 12 ? current.day - 1 : current.day,
                firstItemHour,
                firstItemMinute);
            element.dateTime = tempStartDate;
          }
        });

        mSleepInfo.data.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
      } catch (e) {
        print(e);
      }

      for (int i = 0; i < mSleepInfo.data.length; i++) {
        SleepDataInfoModel sleepDataInfoModel = mSleepInfo.data[i];
        if (sleepDataInfoModel.type == '2' || sleepDataInfoModel.type == '3') {
          break;
        }
        listOfRemoveItems.add(sleepDataInfoModel);
      }
      try {
        for (int i = mSleepInfo.data.length - 1; i >= 0; i--) {
          SleepDataInfoModel sleepDataInfoModel = mSleepInfo.data[i];
          if (sleepDataInfoModel.type == '2' ||
              sleepDataInfoModel.type == '3') {
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
    try {
      var sleepInfoModel = SleepInfoModel.clone(mSleepInfo);
      int awake = 0;
      int deep = 0;
      int light = 0;

      for (int i = 0; i < sleepInfoModel.data.length; i++) {
        var element = sleepInfoModel.data[i];
        if (element.time != null && element.time.toString().isNotEmpty) {
          int firstItemHour = int.parse(element.time!.split(':')[0]);
          int firstItemMinute = int.parse(element.time!.split(':')[1]);
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
      sleepInfoModel.data.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

      for (int i = 0; i < sleepInfoModel.data.length; i++) {
        SleepDataInfoModel model = sleepInfoModel.data[i];
        if (i == (sleepInfoModel.data.length - 1)) {
          break;
        }
        SleepDataInfoModel nextModel = sleepInfoModel.data[i + 1];
        if (model.dateTime != null) {
          switch (model.type) {
            case '2': //light sleep
              light +=
                  nextModel.dateTime!.difference(model.dateTime!).inMinutes;
              break;
            case '3': //deep sleep
              deep += nextModel.dateTime!.difference(model.dateTime!).inMinutes;
              break;
            default:
              awake +=
                  nextModel.dateTime!.difference(model.dateTime!).inMinutes;
              break;
          }
        }
      }
      sleepInfoModel.stayUpTime = awake;
      sleepInfoModel.lightTime = light;
      sleepInfoModel.deepTime = deep;
      return sleepInfoModel;
    } catch (e) {
      print('exception in graph window screen $e');
    }
    return mSleepInfo;
  }

  List<chart.Series<SleepGraphData, num>> generateSleepChartData(
      String graphType) {
    if (graphType == 'hr') {
      sleepChartTypeList = [
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.hr.fieldName)
      ];
    } else if (graphType == 'Oxygen') {
      sleepChartTypeList = [
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.oxygen.fieldName)
      ];
    } else if (graphType == 'Temperature') {
      sleepChartTypeList = [
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.temperature.fieldName)
      ];
    }
    return List.generate(sleepChartTypeList.length, (index) {
      GraphTypeModel typeModel = sleepChartTypeList[index];
      String colorCode = '#009C92';
      if (typeModel.color.isNotEmpty) {
        colorCode = typeModel.color;
      }
      if (colorCode.length > 4 && colorCode[3] == 'f' && colorCode[4] == 'f') {
        colorCode = colorCode.replaceRange(3, 5, '');
      }

      sleepList = makeListOfTypeByHours() ?? [];
      if (sleepList.isEmpty) {
        hrList = [];
        oxygenList = [];
        tempList = [];
      }
      List<SleepGraphData> sleepDataList = [];
      if (graphType == 'hr') {
        sleepDataList = getSleepChartList(hrList, colorCode, graphType);
      } else if (graphType == 'Oxygen') {
        sleepDataList = getSleepChartList(oxygenList, colorCode, graphType);
      } else {
        sleepDataList = getSleepChartList(tempList, colorCode, graphType);
      }

      return chart.Series<SleepGraphData, double>(
        id: typeModel.id.toString(),
        colorFn: (SleepGraphData data, __) => chart.Color(
            a: data.color.alpha,
            r: data.color.red,
            g: data.color.green,
            b: data.color.blue),
        domainFn: (SleepGraphData data, _) => data.xValue,
        measureFn: (SleepGraphData data, _) => data.yValue,
        data: sleepDataList,
      )..setAttribute(chart.rendererIdKey, typeModel.fieldName);
    });
  }

  /// Added by Shahzad
  /// Added on 23rd Aug
  /// mapping sleep data to SleepGraphData model
  /// then this model will be assigned to graph
  List<SleepGraphData> getSleepChartList(
      List<GraphItemData> list, String colorCode, String graphType) {
    Color materialColor = HexColor.fromHex(colorCode);
    if (list.isNotEmpty) {
      for (var i = 0; i < list.length; i++) {
        if (list[i].xValue < 12) {
          list[i].xValue += 24;
        }
      }
    }
    var sleepGraphData = <SleepGraphData>[];
    if (sleepList.isNotEmpty) {
      if (sleepList.last['time'].split(':')[1] != '00') {
        if (int.parse(sleepList.last['time'].split(':')[0]) <
            int.parse(sleepList.first['time'].split(':')[0])) {
          sleepAxisCount = int.parse(sleepList.last['time'].split(':')[0]) +
              24 -
              int.parse(sleepList.first['time'].split(':')[0]) +
              1;
        } else {
          sleepAxisCount = int.parse(sleepList.last['time'].split(':')[0]) -
              int.parse(sleepList.first['time'].split(':')[0]) +
              1;
        }
      } else {
        if (int.parse(sleepList.last['time'].split(':')[0]) <
            int.parse(sleepList.first['time'].split(':')[0])) {
          sleepAxisCount = int.parse(sleepList.last['time'].split(':')[0]) +
              24 -
              int.parse(sleepList.first['time'].split(':')[0]);
        } else {
          sleepAxisCount = int.parse(sleepList.last['time'].split(':')[0]) -
              int.parse(sleepList.first['time'].split(':')[0]);
        }
      }

      for (int i = 0; i < sleepList.length; i++) {
        int flag = 0;
        for (int j = 0; j < list.length; j++) {
          if (list[j].xValueStr == sleepList[i]['time'].split(':')[0] &&
              sleepList[i]['time'].split(':')[1] == '00') {
            list[j].type = sleepList[i]['type'];
            list[j].xValue = stringTimeToDouble(sleepList[i]['time']);
            flag = 1;
            break;
          }
        }
        if (flag == 0) {
          GraphItemData temp = GraphItemData(
            xValue: stringTimeToDouble(sleepList[i]['time']),
            yValue: 0,
            type: sleepList[i]['type'],
            xValueStr: '',
            label: '',
            date: '',
          );
          list.add(temp);
        }
      }

      list.sort(
          (GraphItemData a, GraphItemData b) => a.xValue.compareTo(b.xValue));
      startSleepTime = stringTimeToDouble(sleepList.first['time']);
      List<GraphItemData> tempGraphList = [];
      for (var i = 0; i < list.length; i++) {
        if (list[i].xValue >= startSleepTime) {
          tempGraphList.add(list[i]);
        }
      }

      for (var i = 0; i < tempGraphList.length; i++) {
        if (i == 0 && tempGraphList[i].type != null) {
          if (tempGraphList[i].yValue == 0) {
            tempGraphList[i].yValue = graphType == 'hr'
                ? 72
                : graphType == 'Oxygen'
                    ? 95
                    : tempUnit == 0
                        ? 37
                        : 98.6;
          }
        } else if (tempGraphList[i].type == null) {
          if (i == 0) {
            {
              tempGraphList[i].type = '5';
            }
            if (tempGraphList[i].yValue == 0) {
              tempGraphList[i].yValue = graphType == 'hr'
                  ? 72
                  : graphType == 'Oxygen'
                      ? 95
                      : tempUnit == 0
                          ? 37
                          : 98.6;
            }
          } else {
            for (var k = i; k >= 0; k--) {
              if (tempGraphList[k].type != null) {
                tempGraphList[i].type = tempGraphList[k].type;
                break;
              }
            }
          }
        }
      }
      var timeDifference = stringTimeToDouble(sleepList.first['time']).toInt();
      tempGraphList.first.xValue = tempGraphList.first.xValue - timeDifference;
      for (int i = 1; i < tempGraphList.length; i++) {
        tempGraphList[i].xValue = tempGraphList[i].xValue - timeDifference;
        if (tempGraphList[i].yValue == 0) {
          tempGraphList[i].yValue = tempGraphList[i - 1].yValue;
        }
      }
      print(tempGraphList);
      tempGraphList.forEach((element) {
        SleepGraphData data = SleepGraphData(
            xValue: element.xValue,
            yValue: element.yValue,
            color: getColorByType(element.type ?? '0'));
        sleepGraphData.add(data);
      });
    } else {
      list.forEach((element) {
        SleepGraphData data = SleepGraphData(
            xValue: element.xValue,
            yValue: element.yValue,
            color: materialColor);
        sleepGraphData.add(data);
      });
    }
    return sleepGraphData;
  }

  List<chart.Series<GraphItemData, num>> generateWeekAndMonthSleepHrChartData(
      String fieldName) {
    List<GraphTypeModel> graphWeekTypeList = [];
    if (fieldName == 'sleep') {
      sleepGraphTypeList = [
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.lightSleep.fieldName),
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.deepSleep.fieldName)
      ];
      graphWeekTypeList = sleepGraphTypeList;
    } else if (fieldName == 'Oxygen') {
      sleepChartTypeList = [
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.oxygen.fieldName)
      ];
      graphWeekTypeList = sleepChartTypeList;
    } else if (fieldName == 'Temperature') {
      sleepChartTypeList = [
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.temperature.fieldName)
      ];
      graphWeekTypeList = sleepChartTypeList;
    } else {
      sleepChartTypeList = [
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.hr.fieldName)
      ];
      graphWeekTypeList = sleepChartTypeList;
    }
    return List.generate(graphWeekTypeList.length, (index) {
      GraphTypeModel typeModel = graphWeekTypeList[index];
      String colorCode = '#009C92';
      if (typeModel.color != null && typeModel.color.isNotEmpty) {
        colorCode = typeModel.color;
      }
      if (colorCode.length > 4 && colorCode[3] == 'f' && colorCode[4] == 'f') {
        colorCode = colorCode.replaceRange(3, 5, '');
      }
      Color materialColor = HexColor.fromHex(colorCode);

      List<GraphItemData> list = [];
      if (fieldName == 'sleep') {
        list = sleepItemList
            .where((element) => element.label == typeModel.fieldName)
            .toList();
      } else {
        list = graphItemList
            .where((element) => element.label == typeModel.fieldName)
            .toList();
      }
      list.sort(
          (GraphItemData a, GraphItemData b) => a.xValue.compareTo(b.xValue));

      return chart.Series<GraphItemData, int>(
        id: typeModel.id.toString(),
        colorFn: (GraphItemData data, __) => chart.Color(
            a: materialColor.alpha,
            r: materialColor.red,
            g: materialColor.green,
            b: materialColor.blue),
        domainFn: (GraphItemData data, _) => data.xValue.toInt(),
        measureFn: (GraphItemData data, _) => data.yValue,
        data: list,
      )..setAttribute(chart.rendererIdKey, typeModel.fieldName);
    });
  }

  List<chart.Series<GraphItemData, String>>
      generateWeekAndMonthSleepHrBarChartData(String fieldName) {
    List<GraphTypeModel> graphWeekTypeList = [];
    if (fieldName == 'sleep') {
      sleepGraphTypeList = [
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.deepSleep.fieldName),
        widget.graphTypeList.firstWhere((element) =>
            element.fieldName == DefaultGraphItem.lightSleep.fieldName),
      ];
      graphWeekTypeList = sleepGraphTypeList;
    } else {
      sleepChartTypeList = [
        widget.graphTypeList.firstWhere(
            (element) => element.fieldName == DefaultGraphItem.hr.fieldName)
      ];
      graphWeekTypeList = sleepChartTypeList;
    }
    return List.generate(graphWeekTypeList.length, (index) {
      GraphTypeModel typeModel = graphWeekTypeList[index];
      String colorCode = '#009C92';
      if (typeModel.color != null && typeModel.color.isNotEmpty) {
        colorCode = typeModel.color;
      }
      var materialColor = HexColor.fromHex(colorCode);

      List<GraphItemData> list = [];
      if (fieldName == 'sleep') {
        list = sleepItemList
            .where((element) => element.label == typeModel.fieldName)
            .toList();
      } else {
        list = graphItemList
            .where((element) => element.label == typeModel.fieldName)
            .toList();
      }
      list.sort(
          (GraphItemData a, GraphItemData b) => a.xValue.compareTo(b.xValue));
      return chart.Series<GraphItemData, String>(
        id: typeModel.id.toString(),
        colorFn: (GraphItemData data, __) => chart.Color(
            a: materialColor.alpha,
            r: materialColor.red,
            g: materialColor.green,
            b: materialColor.blue),
        domainFn: (GraphItemData data, _) => data.xValue.toInt().toString(),
        measureFn: (GraphItemData data, _) => data.yValue,
        data: list,
      );
    });
  }
}

class SleepGraphData {
  double xValue;
  double yValue;
  Color color;

  SleepGraphData(
      {required this.xValue, required this.yValue, required this.color});
}
