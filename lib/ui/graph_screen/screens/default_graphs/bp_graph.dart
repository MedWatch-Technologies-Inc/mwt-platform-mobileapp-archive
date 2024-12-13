import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_helper.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/ui/graph_screen/providers/graph_provider.dart';
import 'package:health_gauge/ui/graph_screen/providers/graph_provider_list.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BPGraph extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime startDate;
  final DateTime endDate;
  final GraphTab graphTab;
  final List<GraphTypeModel> graphTypeList;
  final int index;
  final int bpGraphType;
  final List<GraphTypeModel> selectedGraphTypeList;
  final GraphProviderList prov;

  BPGraph(
      {required this.selectedDate,
        required this.graphTab,
        required this.graphTypeList,
        required this.startDate,
        required this.endDate,
        required this.index,
        required this.bpGraphType,
        required this.prov,
        required this.selectedGraphTypeList});

  @override
  _BPGraphState createState() => _BPGraphState();
}

class _BPGraphState extends State<BPGraph> {
  List<CandleGraph> bpCandleData = [];
  List<chart.Series<ScatterGraph, double>> bpLineChartSeries = [];
  Widget bpLineChartWidget = Container();
  ScatterGraph bloodPressure =
  ScatterGraph(xValue: 0.0, yValue: 0.0, color: Colors.yellow, date: '');
  List<MHistoryModel> measurementModelList = [];
  int avgSbp = 0; // to store avg sys
  int avgDbp = 0; // to store avg dia
  int bpIndex = 0;
  MHistoryModel? selectedMeasurement;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.bpGraphType == 2
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bpCandleGraph(),
              SizedBox(
                height: 20.h,
              ),
              candleGraphIndicator(),
            ],
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 240.h, child: bpLineChartWidget),
              SizedBox(
                height: 7.h,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.only(right: 21.w),
                  height: 22.h,
                  child: AutoSizeText(
                    'DIA',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#FF9E99')
                            : HexColor.fromHex('#FF6259'),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              bloodPressureIndicator(
                bloodPressure.yValue != 0.0
                    ? bloodPressure.yValue.toInt()
                    : (measurementModelList.isNotEmpty)
                    ? measurementModelList.last.getAISys.toInt()
                    : 0,
                bloodPressure.xValue != 0.0
                    ? bloodPressure.xValue.toInt()
                    : (measurementModelList.isNotEmpty)
                    ? measurementModelList.last.getAIDias.toInt()
                    : 0,
              )
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getMeasurementData(),
    );
  }

  Future<bool> getMeasurementData() async {
    measurementModelList = await MHistoryHelper().getAllMHistory(
      startTimestamp: widget.startDate.millisecondsSinceEpoch,
      endTimestamp: widget.endDate.millisecondsSinceEpoch,
    );
    measurementModelList.removeWhere((element) => element.getAISys <= 0 || element.getAIDias <= 0);
    var totalDbp = 0;
    var totalSbp = 0;
    for (var element in measurementModelList) {
      totalDbp += element.getAIDias.toInt();
      totalSbp += element.getAISys.toInt();
    }
    avgSbp = 0;
    avgDbp = 0;
    if (measurementModelList.isNotEmpty) {
      avgSbp = totalSbp ~/ measurementModelList.length;
      avgDbp = totalDbp ~/ measurementModelList.length;
    }

    widget.bpGraphType == 2
        ? await bpCandleGraphData(measurementModelList)
        : await makeOrRefreshBpGraph(context);
    widget.prov.graphProviderList[widget.index].isShowLoadingScreen = false;
    return true;
  }

  Future<void> makeOrRefreshBpGraph(BuildContext context) async {
    try {
      bpLineChartSeries = generateBPLineChartData();
      for (var i = 0; i < bpLineChartSeries.length; i++) {
        if (i > 4) {
          bpLineChartSeries[i]
            ..setAttribute(
              chart.rendererIdKey,
              'customLine',
            );
        }
      }
      bpLineChartWidget = chart.LineChart(
        bpLineChartSeries,
        animate: false,
        customSeriesRenderers: [
          chart.LineRendererConfig(
            customRendererId: 'demo',
            includeArea: true,
            stacked: false,
            includePoints: false,
            includeLine: false,
            roundEndCaps: true,
            radiusPx: 4.0,
            strokeWidthPx: 1.0,
            areaOpacity: 0.8,
            //layoutPaintOrder: 0,
          ),
          chart.LineRendererConfig(
            customRendererId: 'customLine',
            includeArea: false,
            stacked: false,
            includePoints: true,
            includeLine: false,
            roundEndCaps: true,
            radiusPx: 4.0,
            strokeWidthPx: 1.0,
            areaOpacity: 1,
          )
        ],
        selectionModels: [
          chart.SelectionModelConfig(
            type: chart.SelectionModelType.info,
            changedListener: (chart.SelectionModel model) {
              for (var element in model.selectedDatum) {
                if (model.hasDatumSelection && element.datum.pointID == 'point') {
                  showBPSelectedItemData(element.datum.xValue, element.datum.yValue);
                  break;
                }
              }
            },
          )
        ],
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec:
          chart.BasicNumericTickProviderSpec(desiredTickCount: 15, zeroBound: true),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
            _formatterYAxis,
          ),
        ),
        domainAxis: chart.NumericAxisSpec(
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            zeroBound: true,
            desiredTickCount: 17,
          ),
          tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
            _formatterAxis,
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
          //viewport: chart.NumericExtents(1.0, 17),
        ),
      );
    } catch (e) {
      LoggingService().printLog(message: e.toString(), tag: 'scatter bp graph');
    }
  }

  showBPSelectedItemData(var xValue, var yValue) {
    bloodPressure.xValue = (xValue * 5) + 40;
    bloodPressure.yValue = (yValue * 2) + 40;
    makeOrRefreshBpGraph(context);
  }

  /// added by: Shahzad
  /// added on: 30th dec 2020
  /// this function gives a list of data according to date
  Future<void> bpCandleGraphData(List<MHistoryModel> measurementModelList) async {
    bpCandleData = [];
    var times = 0;
    if (widget.graphTab == GraphTab.day) {
      times = 24;
    } else {
      times = widget.endDate.difference(widget.startDate).inDays;
    }
    for (var i = 0; i < times; i++) {
      var temp = <MHistoryModel>[];
      if (widget.graphTab == GraphTab.day) {
        var day = widget.startDate.add(Duration(hours: i + 1));
        // DateTime day = startDate.add(Duration(days: i));
        temp = measurementModelList
            .where((element) =>
        DateTime.parse(element.date).hour == day.hour &&
            (element.getAIDias.toInt() < 200 && element.getAIDias.toInt() > 50) &&
            (element.getAISys.toInt() < 200 && element.getAISys.toInt() > 50))
            .toList();
      } else {
        var day = widget.startDate.add(Duration(days: i));
        temp = measurementModelList
            .where((element) =>
        DateTime.parse(element.date!).day == day.day &&
            (element.getAIDias.toInt() < 200 && element.getAIDias.toInt() > 50) &&
            (element.getAISys.toInt() < 200 && element.getAISys.toInt() > 50))
            .toList();
      }
      var data = CandleGraph(dbpMax: 0, dbpMin: 0, sbpMax: 0, sbpMin: 0);
      if (temp.isNotEmpty) {
        var minMax = await getMinMax(temp);
        data.sbpMin = minMax['sbpMin'];
        data.sbpMax = minMax['sbpMax'];
        data.dbpMin = minMax['dbpMin'];
        data.dbpMax = minMax['dbpMax'];
        if (data.sbpMin < data.dbpMax) {
          data.dbpMax = data.sbpMin;
        }
        bpCandleData.add(data);
      } else {
        bpCandleData.add(data);
      }
    }
  }

  /// added by: Shahzad
  /// added on: 30th dec 2020
  /// this function returns max and min of sys and dia
  Future<Map> getMinMax(List<MHistoryModel> temp) async {
    int sbpMax = 50;
    int dbpMax = 50;
    int sbpMin = 201;
    int dbpMin = 201;
    temp.forEach((element) {
      if (element.getAIDias.toInt() > dbpMax) {
        dbpMax = element.getAIDias.toInt();
      }
      if (element.getAIDias.toInt() < dbpMin) {
        dbpMin = element.getAIDias.toInt();
      }
      if (element.getAISys.toInt() > sbpMax) {
        sbpMax = element.getAISys.toInt();
      }
      if (element.getAISys.toInt() < sbpMin) {
        sbpMin = element.getAISys.toInt();
      }
    });
    Map tempMap = {
      'sbpMax': sbpMax,
      'sbpMin': sbpMin,
      'dbpMax': dbpMax,
      'dbpMin': dbpMin,
    };
    return tempMap;
  }

  List<chart.Series<ScatterGraph, double>> generateBPLineChartData() {
    List<ScatterGraph> bPList = addBpData();

    return List.generate(bPList.length, (index) {
      var typeModel = bPList[index];
      var bpDataList = <ScatterGraph>[];

      if (index < 5) {
        /// adding static BP list values
        bpDataList.add(typeModel);
        var temp = ScatterGraph(xValue: 0, yValue: typeModel.yValue, color: typeModel.color);
        bpDataList.add(temp);
      } else {
        /// adding BP list values
        bpDataList.add(typeModel);
        var demo = ScatterGraph(xValue: 0, yValue: typeModel.yValue, color: Colors.transparent);
        bpDataList.add(demo);
      }

      /// assigning the final list to the Graph.
      return chart.Series<ScatterGraph, double>(
        id: 'demo',
        colorFn: (ScatterGraph data, __) => chart.Color(
            a: data.color.alpha, r: data.color.red, g: data.color.green, b: data.color.blue),
        domainFn: (ScatterGraph data, _) => data.xValue,
        measureFn: (ScatterGraph data, _) => data.yValue,
        data: bpDataList,
      )..setAttribute(chart.rendererIdKey, 'demo');
    });
  }

  /// Static List for background Color
  List<ScatterGraph> bpStaticList = [
    ScatterGraph(xValue: 16, color: HexColor.fromHex('#9F2DBC'), yValue: 70),
    ScatterGraph(xValue: 12, color: HexColor.fromHex('#BD78CE'), yValue: 60),
    ScatterGraph(xValue: 10, color: HexColor.fromHex('#D3A5DF'), yValue: 50),
    ScatterGraph(xValue: 8, color: HexColor.fromHex('#00AFAA'), yValue: 40),
    ScatterGraph(xValue: 4, yValue: 25, color: HexColor.fromHex('#99D9D9').withOpacity(0.5)),
  ];

  List<ScatterGraph> addBpData() {
    var bpList = <ScatterGraph>[];
    bpList.addAll(bpStaticList);

    if (bloodPressure.xValue == 0.0 &&
        bloodPressure.yValue == 0.0 &&
        measurementModelList.isNotEmpty) {
      bloodPressure.xValue = measurementModelList[0].getAIDias;
      bloodPressure.yValue = measurementModelList[0].getAISys;
      bloodPressure.date = measurementModelList[0].date;
      selectedMeasurement = measurementModelList[0];
    }
    for (var i = 0; i < measurementModelList.length; i++) {
      if (measurementModelList[i].getAISys > 0.0 && measurementModelList[i].getAIDias > 0.0) {
        var bpData = ScatterGraph(
            xValue: (measurementModelList[i].getAIDias.toInt() - 40) / 5,
            // to maintain x axis
            yValue: (measurementModelList[i].getAISys.toInt() - 40) / 2,
            // to maintain y axis
            color: (bloodPressure.xValue == measurementModelList[i].getAIDias &&
                bloodPressure.yValue == measurementModelList[i].getAISys)
                ? bloodPressure.color
                : Colors.red,
            pointID: 'point',
            date: measurementModelList[i].date);
        bpList.add(bpData);
      }
    }
    return bpList;
  }

  String _formatterAxis(num? year) {
    var value = (year!.toInt() + 8) * 5;
    if (value == 60 || value == 80 || value == 90 || value == 100 || value == 120) {
      //value = value + 5;
      return '$value';
    }
    return '';
  }

  String _formatterYAxis(num? year) {
    var value2 = ((year! ~/ 5) + 4) * 10;
    if (value2 == 40 ||
        value2 == 90 ||
        value2 == 120 ||
        value2 == 140 ||
        value2 == 160 ||
        value2 == 180) {
      //value2 = value2 + 10;
      return '$value2';
    }
    return '';
    // return '$year$weightLabel';
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
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 0);
    return firstDayNextMonth.day;
  }

  /// added by: Shahzad
  /// added on: 29th dec 2020
  /// container for candle stick graph
  Widget bpCandleGraph() {
    return Container(
      //color: Colors.blue,
      height: 240.h,
      margin: widget.graphTab == GraphTab.week
          ? EdgeInsets.only(top: 10.h, left: 5.w)
          : EdgeInsets.only(top: 10.h),
      child: Center(
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.only(left: 10),
                      height: 210.h,
//                      color: Colors.green,
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  child: Text(
                                    '200',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                            : HexColor.fromHex('#384341'),
                                        fontSize: 10),
                                  )),
                              Text(
                                '150',
                                style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                    fontSize: 10),
                              ),
                              Text(
                                '100',
                                style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                    fontSize: 10),
                              ),
                              Text(
                                '  50',
                                style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                        : HexColor.fromHex('#384341'),
                                    fontSize: 10),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8.h, bottom: 5.h),
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                                : HexColor.fromHex('#D9E0E0'),
                            height: 200,
                            width: 1.w,
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5.h),
                                height: 1.h,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                                    : HexColor.fromHex('#D9E0E0'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                )),
            Expanded(
              flex: widget.graphTab == GraphTab.day
                  ? 10
                  : widget.graphTab == GraphTab.week
                  ? 8
                  : 11,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bpCandleData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return candleContainer(index + 1);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  /// added by: Shahzad
  /// added on: 29th dec 2020
  /// container for a single candle stick
  Widget candleContainer(int index) {
    return Column(
      children: [
        Container(
          height: 210.h,
          width: widget.graphTab == GraphTab.day
              ? 12.w
              : widget.graphTab == GraphTab.week
              ? 40.w
              : 9.5.w,
          child: Column(
            children: [
              candleSingleGraph(bpCandleData[index - 1]),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5.h),
                    height: 1.h,
                    width: widget.graphTab == GraphTab.day
                        ? 12.w
                        : widget.graphTab == GraphTab.week
                        ? 40.w
                        : 9.5.w,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
                        : HexColor.fromHex('#D9E0E0'),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          height: 20.h,
          width: widget.graphTab == GraphTab.day
              ? 12.w
              : widget.graphTab == GraphTab.week
              ? 40.w
              : 9.5.w,
          child: Body1AutoText(
            text: widget.graphTab == GraphTab.week
                ? weekDays(index)
                : index % 2 != 0
                ? index.toString()
                : '',
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                : HexColor.fromHex('#384341'),
            fontSize: widget.graphTab == GraphTab.day
                ? 8.sp
                : widget.graphTab == GraphTab.week
                ? 12.sp
                : 8.sp,
            align: TextAlign.center,
            maxLine: 1,
            minFontSize: 5,
          ),
        )
      ],
    );
  }

  /// added by: Shahzad
  /// added on: 29th dec 2020
  /// adding properties to a single candle stick
  Widget candleSingleGraph(CandleGraph bpGraph) {
    var color = candleColor(bpGraph.sbpMax, bpGraph.dbpMax);
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      height: 198.h,
      child: Container(
        margin: EdgeInsets.only(top: candleHeight(200, bpGraph.sbpMax)),
        child: Column(
          children: [
            Container(
              height: candleHeight(bpGraph.sbpMax, bpGraph.sbpMin),
              width: widget.graphTab == GraphTab.week ? 6.w : 5.w,
              decoration: candleHeight(bpGraph.sbpMax, bpGraph.sbpMin) < 5
                  ? BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(candleHeight(bpGraph.sbpMax, bpGraph.sbpMin)),
                    bottom: Radius.circular(candleHeight(bpGraph.sbpMax, bpGraph.sbpMin))),
                color: color,
              )
                  : BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(4.h), bottom: Radius.circular(4.h)),
                  border: Border.all(color: color, width: 2.w)),
            ),
            Container(
                height: candleHeight(bpGraph.sbpMin, bpGraph.dbpMax), width: 2.w, color: color),
            Container(
              height: candleHeight(bpGraph.dbpMax, bpGraph.dbpMin),
              width: widget.graphTab == GraphTab.week ? 6.w : 5.w,
              decoration: candleHeight(bpGraph.dbpMax, bpGraph.dbpMin) < 5
                  ? BoxDecoration(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(candleHeight(bpGraph.dbpMax, bpGraph.dbpMin)),
                    bottom: Radius.circular(candleHeight(bpGraph.sbpMax, bpGraph.sbpMin))),
                color: color,
              )
                  : BoxDecoration(
                border: Border.all(color: color, width: 2.w),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4.h), bottom: Radius.circular(4.h)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double candleHeight(int value1, int value2) {
    if (value1 < value2) {
      return 0.0;
    }
    double height = 0;
    height = ((value1 - 50) - (value2 - 50)) / 150 * 198;
    return height.h > 198.h ? 0 : height.h;
  }

  Color candleColor(int sbp, int dbp) {
    if (sbp < 90 && dbp < 60) {
      return HexColor.fromHex('#99D9D9');
    } else if (sbp < 120 && dbp < 80) {
      return HexColor.fromHex('#00AFAA');
    } else if (sbp < 140 && dbp < 90) {
      return HexColor.fromHex('#D3A5DF');
    } else if (sbp < 160 && dbp < 100) {
      return HexColor.fromHex('#BD78CE');
    } else if (sbp <= 180 && dbp <= 120) {
      return HexColor.fromHex('#9F2DBC');
    } else {
      return Colors.transparent;
    }
  }

  /// added by: Shahzad
  /// added on: 29th dec 2020
  /// this function return name of week days
  String weekDays(int index) {
    switch (index) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
    }
    return '';
  }

  /// added by: Shahzad
  /// added on: 29th dec 2020
  /// container of avg sys and dia
  Widget candleGraphIndicator() {
    return Container(
      padding: EdgeInsets.only(top: 10.h),
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  stringLocalization.getText(StringLocalization.sysAvg),
                  // minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68')),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        avgSbp.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341')),
                      ),
                      SizedBox(
                        width: 2.h,
                      ),
                      Text(
                        'mmHg',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                : HexColor.fromHex('#5D6A68')),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30.w,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  stringLocalization.getText(StringLocalization.diaAvg),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68')),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        avgDbp.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341')),
                      ),
                      SizedBox(
                        width: 2.h,
                      ),
                      Text(
                        'mmHg',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                : HexColor.fromHex('#5D6A68')),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget bloodPressureIndicator(var sbp, var dbp) {
    var bpDateTime = '';
    if (selectedMeasurement?.date?.split('.')[0].isNotEmpty ?? false) {
      bpDateTime = selectedMeasurement!.date!.split('.')[0];
    } else {
      bpDateTime = stringLocalization.getText(StringLocalization.noData);
    }
    if (measurementModelList.isEmpty) {
      sbp = 0;
      dbp = 0;
      bpDateTime = stringLocalization.getText(StringLocalization.noData);
    }
    return Container(
      margin: EdgeInsets.only(top: 18.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 12.h,
                width: 12.h,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black)),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 20.h,
                child: Body1AutoText(
                  text: stringLocalization.getText(StringLocalization.yourBp),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                      : HexColor.fromHex('#5D6A68'),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 25.h,
                child: Body1AutoText(
                    text: '$sbp/$dbp',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 20.h,
                child: Body1AutoText(
                    text: 'mmHg',
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                        : HexColor.fromHex('#5D6A68'),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          widget.graphTab == GraphTab.day
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              measurementModelList.isNotEmpty
                  ? Material(
                color: Colors.transparent,
                child: Container(
                  height: 30.h,
                  child: IconButton(
                    padding: EdgeInsets.all(0),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    ),
                    onPressed: () {
                      if (bpIndex == 0) {
                        bpIndex = measurementModelList.length - 1;
                      } else {
                        bpIndex = bpIndex - 1;
                      }
                      bloodPressureArrowButtonClicked();
                    },
                  ),
                ),
              )
                  : Container(),
              !(measurementModelList == null || measurementModelList.isEmpty)
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25.h,
                    child: Body1AutoText(
                      text: 'Time:',
                      maxLine: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68'),
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  SizedBox(
                    height: 25.h,
                    child: Body1AutoText(
                      text: bpDateTime.split(' ')[1],
                      maxLine: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )
                  : SizedBox(
                height: 25.h,
                child: Body1AutoText(
                  text: bpDateTime,
                  maxLine: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16.0,
                  align: TextAlign.center,
                ),
              ),
              measurementModelList.isNotEmpty
                  ? Material(
                color: Colors.transparent,
                child: Container(
                  height: 30.h,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    ),
                    onPressed: () {
                      if (bpIndex == measurementModelList.length - 1) {
                        bpIndex = 0;
                      } else {
                        bpIndex = bpIndex + 1;
                      }
                      bloodPressureArrowButtonClicked();
                    },
                  ),
                ),
              )
                  : Container(),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              measurementModelList.isNotEmpty
                  ? Material(
                color: Colors.transparent,
                child: Container(
                  width: 25.w,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    ),
                    onPressed: () {
                      if (bpIndex == 0) {
                        bpIndex = measurementModelList.length - 1;
                      } else {
                        bpIndex = bpIndex - 1;
                      }
                      bloodPressureArrowButtonClicked();
                    },
                  ),
                ),
              )
                  : Container(),
              measurementModelList.isNotEmpty
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25.h,
                    child: Body1AutoText(
                      text: 'Date:',
                      maxLine: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68'),
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  SizedBox(
                    height: 25.h,
                    child: Body1AutoText(
                      text: bpDateTime.split(' ')[0],
                      maxLine: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  SizedBox(
                    height: 25.h,
                    child: Body1AutoText(
                      text: 'Time:',
                      maxLine: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68'),
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  SizedBox(
                    height: 25.h,
                    child: Body1AutoText(
                      text: bpDateTime.split(' ')[1],
                      maxLine: 1,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )
                  : SizedBox(
                height: 25.h,
                child: Body1AutoText(
                  text: bpDateTime,
                  maxLine: 1,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16.0,
                  align: TextAlign.center,
                ),
              ),
              measurementModelList.isNotEmpty
                  ? Material(
                color: Colors.transparent,
                child: Container(
                  width: 25.w,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                    ),
                    onPressed: () {
                      if (bpIndex == measurementModelList.length - 1) {
                        bpIndex = 0;
                      } else {
                        bpIndex = bpIndex + 1;
                      }
                      bloodPressureArrowButtonClicked();
                    },
                  ),
                ),
              )
                  : Container(),
            ],
          ),
          SizedBox(height: measurementModelList.isEmpty ? 30.h : 10.h),
          Container(
            margin: EdgeInsets.only(left: 15.h, right: 15.h),
            height: 1,
            color: HexColor.fromHex('#BDC7C5'),
          ),
          Container(
            margin: EdgeInsets.only(left: 15.h, right: 15.h, top: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 12.h,
                          width: 12.h,
                          decoration: BoxDecoration(color: HexColor.fromHex('#99D9D9')),
                        ),
                        SizedBox(width: 8.w),
                        SizedBox(
                          height: 18.h,
                          child: Body1AutoText(
                              text: 'Low',
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                  : HexColor.fromHex('#5D6A68'),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 12.h,
                          width: 12.h,
                          decoration: BoxDecoration(color: HexColor.fromHex('#D3A5DF')),
                        ),
                        SizedBox(width: 8.w),
                        SizedBox(
                          height: 18.h,
                          child: Body1AutoText(
                              text: 'Hyper',
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                  : HexColor.fromHex('#5D6A68'),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 12.h,
                          width: 12.h,
                          decoration: BoxDecoration(color: HexColor.fromHex('#00AFAA')),
                        ),
                        SizedBox(width: 8.w),
                        SizedBox(
                          height: 18.h,
                          child: Body1AutoText(
                              text: 'Ideal',
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                  : HexColor.fromHex('#5D6A68'),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 12.h,
                          width: 12.h,
                          decoration: BoxDecoration(color: HexColor.fromHex('#BD78CE')),
                        ),
                        SizedBox(width: 8.w),
                        SizedBox(
                          height: 18.h,
                          child: Body1AutoText(
                              text: 'Hyper (stage 1)',
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                  : HexColor.fromHex('#5D6A68'),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 12.h,
                          width: 12.h,
                          decoration: BoxDecoration(color: Colors.transparent),
                        ),
                        SizedBox(width: 8.w),
                        SizedBox(
                            height: 18.h,
                            child: Body1AutoText(text: 'Ideal', color: Colors.transparent)),
                      ],
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 12.h,
                          width: 12.h,
                          decoration: BoxDecoration(color: HexColor.fromHex('#9F2DBC')),
                        ),
                        SizedBox(width: 8.w),
                        SizedBox(
                          height: 18.h,
                          child: Body1AutoText(
                              text: 'Hyper (stage 2)',
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                  : HexColor.fromHex('#5D6A68'),
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void bloodPressureArrowButtonClicked() {
    bloodPressure.xValue = measurementModelList[bpIndex].getAIDias;
    bloodPressure.yValue = measurementModelList[bpIndex].getAISys;
    bloodPressure.date = measurementModelList[bpIndex].date;
    selectedMeasurement = measurementModelList[bpIndex];
    if (mounted) {
      setState(() {});
    }
  }
}

class ScatterGraph {
  double xValue;
  double yValue;
  Color color;
  String? pointID;
  String? date;

  ScatterGraph(
      {required this.yValue, required this.xValue, required this.color, this.pointID, this.date});
}

/// added by: Shahzad
/// added on: 29th dec 2020
/// contains value for candle stick graph
class CandleGraph {
  int sbpMax;
  int dbpMax;
  int sbpMin;
  int dbpMin;

  CandleGraph(
      {required this.dbpMax, required this.dbpMin, required this.sbpMax, required this.sbpMin});
}


// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:health_gauge/models/measurement/measurement_history_model.dart';
// import 'package:charts_flutter/flutter.dart' as chart;
// import 'package:health_gauge/services/logging/logging_service.dart';
// import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
// import 'package:health_gauge/ui/graph_screen/providers/graph_provider.dart';
// import 'package:health_gauge/ui/graph_screen/providers/graph_provider_list.dart';
// import 'package:health_gauge/utils/constants.dart';
// import 'package:health_gauge/utils/date_utils.dart';
// import 'package:health_gauge/utils/gloabals.dart';
// import 'package:health_gauge/utils/globals.dart';
// import 'package:health_gauge/value/app_color.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:health_gauge/value/string_localization_support/string_localization.dart';
// import 'package:health_gauge/widgets/text_utils.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// class BPGraph extends StatefulWidget {
//   final DateTime selectedDate;
//   final DateTime startDate;
//   final DateTime endDate;
//   final GraphTab graphTab;
//   final List<GraphTypeModel> graphTypeList;
//   final int index;
//   final int bpGraphType;
//   final List<GraphTypeModel> selectedGraphTypeList;
//   final GraphProviderList prov;
//
//   BPGraph(
//       {required this.selectedDate,
//       required this.graphTab,
//       required this.graphTypeList,
//       required this.startDate,
//       required this.endDate,
//       required this.index,
//       required this.bpGraphType,
//       required this.prov,
//       required this.selectedGraphTypeList});
//
//   @override
//   _BPGraphState createState() => _BPGraphState();
// }
//
// class _BPGraphState extends State<BPGraph> {
//   List<CandleGraph> bpCandleData = [];
//   List<chart.Series<ScatterGraph, double>> bpLineChartSeries = [];
//   Widget bpLineChartWidget = Container();
//   ScatterGraph bloodPressure =
//       ScatterGraph(xValue: 0.0, yValue: 0.0, color: Colors.yellow, date: '');
//   List<MeasurementHistoryModel> measurementModelList = [];
//   int avgSbp = 0; // to store avg sys
//   int avgDbp = 0; // to store avg dia
//   int bpIndex = 0;
//   MeasurementHistoryModel? selectedMeasurement;
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return widget.bpGraphType == 2
//               ? Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     bpCandleGraph(),
//                     SizedBox(
//                       height: 20.h,
//                     ),
//                     candleGraphIndicator(),
//                   ],
//                 )
//               : Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Container(height: 240.h, child: bpLineChartWidget),
//                     SizedBox(
//                       height: 7.h,
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Container(
//                         padding: EdgeInsets.only(right: 21.w),
//                         height: 22.h,
//                         child: AutoSizeText(
//                           'DIA',
//                           style: TextStyle(
//                               color: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? HexColor.fromHex('#FF9E99')
//                                   : HexColor.fromHex('#FF6259'),
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15.h,
//                     ),
//                     bloodPressureIndicator(
//                         bloodPressure.yValue != 0.0
//                             ? bloodPressure.yValue.toInt()
//                             : (measurementModelList.isNotEmpty)
//                                 ? measurementModelList.last.sbp
//                                 : 0,
//                         bloodPressure.xValue != 0.0
//                             ? bloodPressure.xValue.toInt()
//                             : (measurementModelList.isNotEmpty)
//                                 ? measurementModelList.last.dbp
//                                 : 0)
//                   ],
//                 );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//       future: getMeasurementData(),
//     );
//   }
//
//   Future<bool> getMeasurementData() async {
//     measurementModelList = await dbHelper.getMeasurementHistoryDataForBpGraph(
//         globalUser?.userId ?? '',
//         widget.startDate.toString(),
//         widget.endDate.toString());
//     var totalDbp = 0;
//     var totalSbp = 0;
//     for (var element in measurementModelList) {
//       totalDbp += element.dbp!;
//       totalSbp += element.sbp!;
//     }
//     avgSbp = 0;
//     avgDbp = 0;
//     if (measurementModelList.isNotEmpty) {
//       avgSbp = totalSbp ~/ measurementModelList.length;
//       avgDbp = totalDbp ~/ measurementModelList.length;
//     }
//
//     widget.bpGraphType == 2
//         ? await bpCandleGraphData(measurementModelList)
//         : await makeOrRefreshBpGraph(context);
//     widget.prov.graphProviderList[widget.index].isShowLoadingScreen = false;
//     return true;
//   }
//
//   Future<void> makeOrRefreshBpGraph(BuildContext context) async {
//     try {
//       bpLineChartSeries = generateBPLineChartData();
//       for (var i = 0; i < bpLineChartSeries.length; i++) {
//         if (i > 4) {
//           bpLineChartSeries[i]
//             ..setAttribute(
//               chart.rendererIdKey,
//               'customLine',
//             );
//         }
//       }
//       bpLineChartWidget = chart.LineChart(
//         bpLineChartSeries,
//         animate: false,
//         customSeriesRenderers: [
//           chart.LineRendererConfig(
//             customRendererId: 'demo',
//             includeArea: true,
//             stacked: false,
//             includePoints: false,
//             includeLine: false,
//             roundEndCaps: true,
//             radiusPx: 4.0,
//             strokeWidthPx: 1.0,
//             areaOpacity: 0.8,
//             //layoutPaintOrder: 0,
//           ),
//           chart.LineRendererConfig(
//             customRendererId: 'customLine',
//             includeArea: false,
//             stacked: false,
//             includePoints: true,
//             includeLine: false,
//             roundEndCaps: true,
//             radiusPx: 4.0,
//             strokeWidthPx: 1.0,
//             areaOpacity: 1,
//           )
//         ],
//         selectionModels: [
//           chart.SelectionModelConfig(
//               type: chart.SelectionModelType.info,
//               changedListener: (chart.SelectionModel model) {
//                 for (var element in model.selectedDatum) {
//                   if (model.hasDatumSelection &&
//                       element.datum.pointID == 'point') {
//                     showBPSelectedItemData(
//                         element.datum.xValue, element.datum.yValue);
//                     break;
//                   }
//                 }
//               })
//         ],
//         primaryMeasureAxis: chart.NumericAxisSpec(
//           renderSpec: chart.GridlineRendererSpec(
//               labelStyle: chart.TextStyleSpec(
//                   fontSize: 10,
//                   color: Theme.of(context).brightness == Brightness.dark
//                       ? chart.MaterialPalette.white
//                       : chart.MaterialPalette.black)),
//           tickProviderSpec: chart.BasicNumericTickProviderSpec(
//               desiredTickCount: 15, zeroBound: true),
//           tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
//             _formatterYAxis,
//           ),
//         ),
//         domainAxis: chart.NumericAxisSpec(
//           tickProviderSpec: chart.BasicNumericTickProviderSpec(
//             zeroBound: true,
//             desiredTickCount: 17,
//           ),
//           tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
//             _formatterAxis,
//           ),
//           renderSpec: chart.GridlineRendererSpec(
//             tickLengthPx: 0,
//             labelOffsetFromAxisPx: 10,
//             labelStyle: chart.TextStyleSpec(
//                 fontSize: 10,
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? chart.MaterialPalette.white
//                     : chart.MaterialPalette.black),
//           ),
//           //viewport: chart.NumericExtents(1.0, 17),
//         ),
//       );
//     } catch (e) {
//       LoggingService().printLog(message: e.toString(), tag: 'scatter bp graph');
//     }
//   }
//
//   showBPSelectedItemData(var xValue, var yValue) {
//     bloodPressure.xValue = (xValue * 5) + 40;
//     bloodPressure.yValue = (yValue * 2) + 40;
//     makeOrRefreshBpGraph(context);
//   }
//
//   /// added by: Shahzad
//   /// added on: 30th dec 2020
//   /// this function gives a list of data according to date
//   Future<void> bpCandleGraphData(
//       List<MeasurementHistoryModel> measurementModelList) async {
//     bpCandleData = [];
//     var times = 0;
//     if (widget.graphTab == GraphTab.day) {
//       times = 24;
//     } else {
//       times = widget.endDate.difference(widget.startDate).inDays;
//     }
//     for (var i = 0; i < times; i++) {
//       var temp = <MeasurementHistoryModel>[];
//       if (widget.graphTab == GraphTab.day) {
//         var day = widget.startDate.add(Duration(hours: i + 1));
//         // DateTime day = startDate.add(Duration(days: i));
//         temp = measurementModelList
//             .where((element) =>
//                 DateTime.parse(element.date!).hour == day.hour &&
//                 (element.dbp! < 200 && element.dbp! > 50) &&
//                 (element.sbp! < 200 && element.sbp! > 50))
//             .toList();
//       } else {
//         var day = widget.startDate.add(Duration(days: i));
//         temp = measurementModelList
//             .where((element) =>
//                 DateTime.parse(element.date!).day == day.day &&
//                 (element.dbp! < 200 && element.dbp! > 50) &&
//                 (element.sbp! < 200 && element.sbp! > 50))
//             .toList();
//       }
//       var data = CandleGraph(dbpMax: 0, dbpMin: 0, sbpMax: 0, sbpMin: 0);
//       if (temp.isNotEmpty) {
//         var minMax = await getMinMax(temp);
//         data.sbpMin = minMax['sbpMin'];
//         data.sbpMax = minMax['sbpMax'];
//         data.dbpMin = minMax['dbpMin'];
//         data.dbpMax = minMax['dbpMax'];
//         if (data.sbpMin < data.dbpMax) {
//           data.dbpMax = data.sbpMin;
//         }
//         bpCandleData.add(data);
//       } else {
//         bpCandleData.add(data);
//       }
//     }
//   }
//
//   /// added by: Shahzad
//   /// added on: 30th dec 2020
//   /// this function returns max and min of sys and dia
//   Future<Map> getMinMax(List<MeasurementHistoryModel> temp) async {
//     int sbpMax = 50;
//     int dbpMax = 50;
//     int sbpMin = 201;
//     int dbpMin = 201;
//     temp.forEach((element) {
//       if (element.dbp! > dbpMax) {
//         dbpMax = element.dbp!;
//       }
//       if (element.dbp! < dbpMin) {
//         dbpMin = element.dbp!;
//       }
//       if (element.sbp! > sbpMax) {
//         sbpMax = element.sbp!;
//       }
//       if (element.sbp! < sbpMin) {
//         sbpMin = element.sbp!;
//       }
//     });
//     Map tempMap = {
//       'sbpMax': sbpMax,
//       'sbpMin': sbpMin,
//       'dbpMax': dbpMax,
//       'dbpMin': dbpMin,
//     };
//     return tempMap;
//   }
//
//
//   List<chart.Series<ScatterGraph, double>> generateBPLineChartData() {
//     List<ScatterGraph> bPList = addBpData();
//
//     return List.generate(bPList.length, (index) {
//       var typeModel = bPList[index];
//       var bpDataList = <ScatterGraph>[];
//
//       if (index < 5) {
//         /// adding static BP list values
//         bpDataList.add(typeModel);
//         var temp = ScatterGraph(
//             xValue: 0, yValue: typeModel.yValue, color: typeModel.color);
//         bpDataList.add(temp);
//       } else {
//         /// adding BP list values
//         bpDataList.add(typeModel);
//         var demo = ScatterGraph(
//             xValue: 0, yValue: typeModel.yValue, color: Colors.transparent);
//         bpDataList.add(demo);
//       }
//
//       /// assigning the final list to the Graph.
//       return chart.Series<ScatterGraph, double>(
//         id: 'demo',
//         colorFn: (ScatterGraph data, __) => chart.Color(
//             a: data.color.alpha,
//             r: data.color.red,
//             g: data.color.green,
//             b: data.color.blue),
//         domainFn: (ScatterGraph data, _) => data.xValue,
//         measureFn: (ScatterGraph data, _) => data.yValue,
//         data: bpDataList,
//       )..setAttribute(chart.rendererIdKey, 'demo');
//     });
//   }
//
//   /// Static List for background Color
//   List<ScatterGraph> bpStaticList = [
//     ScatterGraph(xValue: 16, color: HexColor.fromHex('#9F2DBC'), yValue: 70),
//     ScatterGraph(xValue: 12, color: HexColor.fromHex('#BD78CE'), yValue: 60),
//     ScatterGraph(xValue: 10, color: HexColor.fromHex('#D3A5DF'), yValue: 50),
//     ScatterGraph(xValue: 8, color: HexColor.fromHex('#00AFAA'), yValue: 40),
//     ScatterGraph(
//         xValue: 4,
//         yValue: 25,
//         color: HexColor.fromHex('#99D9D9').withOpacity(0.5)),
//   ];
//
//   List<ScatterGraph> addBpData() {
//     var bpList = <ScatterGraph>[];
//     bpList.addAll(bpStaticList);
//
//     if (bloodPressure.xValue == 0.0 && bloodPressure.yValue == 0.0 && measurementModelList.isNotEmpty) {
//       bloodPressure.xValue = measurementModelList[0].dbp != null
//           ? measurementModelList[0].dbp!.toDouble()
//           : 0.0;
//       bloodPressure.yValue = measurementModelList[0].sbp != null
//           ? measurementModelList[0].sbp!.toDouble()
//           : 0.0;
//       bloodPressure.date = measurementModelList[0].date;
//       selectedMeasurement = measurementModelList[0];
//     }
//
//     for (var i = 0; i < measurementModelList.length; i++) {
//       if (measurementModelList[i].sbp != null &&
//           measurementModelList[i].sbp != 0 &&
//           measurementModelList[i].dbp != null &&
//           measurementModelList[i].dbp != 0) {
//         var bpData = ScatterGraph(
//             xValue: (measurementModelList[i].dbp! - 40) / 5,
//             // to maintain x axis
//             yValue: (measurementModelList[i].sbp! - 40) / 2,
//             // to maintain y axis
//             color: (bloodPressure.xValue == measurementModelList[i].dbp! &&
//                     bloodPressure.yValue == measurementModelList[i].sbp!)
//                 ? bloodPressure.color
//                 : Colors.red,
//             pointID: 'point',
//             date: measurementModelList[i].date);
//         bpList.add(bpData);
//       }
//     }
//     return bpList;
//   }
//
//   String _formatterAxis(num? year) {
//     var value = (year!.toInt() + 8) * 5;
//     if (value == 60 ||
//         value == 80 ||
//         value == 90 ||
//         value == 100 ||
//         value == 120) {
//       //value = value + 5;
//       return '$value';
//     }
//     return '';
//   }
//
//   String _formatterYAxis(num? year) {
//     var value2 = ((year! ~/ 5) + 4) * 10;
//     if (value2 == 40 ||
//         value2 == 90 ||
//         value2 == 120 ||
//         value2 == 140 ||
//         value2 == 160 ||
//         value2 == 180) {
//       //value2 = value2 + 10;
//       return '$value2';
//     }
//     return '';
//     // return '$year$weightLabel';
//   }
//
//   int xAxisCount() {
//     if (widget.graphTab == GraphTab.day) {
//       return 24;
//     } else if (widget.graphTab == GraphTab.week) {
//       return 7;
//     } else if (widget.graphTab == GraphTab.month) {
//       return daysInMonth(widget.startDate);
//     }
//     return widget.startDate.difference(widget.endDate).inDays;
//   }
//
//   int daysInMonth(DateTime date) {
//     var firstDayNextMonth = DateTime(date.year, date.month + 1, 0);
//     return firstDayNextMonth.day;
//   }
//
//   /// added by: Shahzad
//   /// added on: 29th dec 2020
//   /// container for candle stick graph
//   Widget bpCandleGraph() {
//     return Container(
//       //color: Colors.blue,
//       height: 240.h,
//       margin: widget.graphTab == GraphTab.week
//           ? EdgeInsets.only(top: 10.h, left: 5.w)
//           : EdgeInsets.only(top: 10.h),
//       child: Center(
//         child: Row(
//           children: [
//             Expanded(
//                 flex: 1,
//                 child: Column(
//                   children: [
//                     Container(
//                       // padding: EdgeInsets.only(left: 10),
//                       height: 210.h,
// //                      color: Colors.green,
//                       child: Row(
//                         children: [
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                   child: Text(
//                                 '200',
//                                 style: TextStyle(
//                                     color: Theme.of(context).brightness ==
//                                             Brightness.dark
//                                         ? HexColor.fromHex('#FFFFFF')
//                                             .withOpacity(0.87)
//                                         : HexColor.fromHex('#384341'),
//                                     fontSize: 10),
//                               )),
//                               Text(
//                                 '150',
//                                 style: TextStyle(
//                                     color: Theme.of(context).brightness ==
//                                             Brightness.dark
//                                         ? HexColor.fromHex('#FFFFFF')
//                                             .withOpacity(0.87)
//                                         : HexColor.fromHex('#384341'),
//                                     fontSize: 10),
//                               ),
//                               Text(
//                                 '100',
//                                 style: TextStyle(
//                                     color: Theme.of(context).brightness ==
//                                             Brightness.dark
//                                         ? HexColor.fromHex('#FFFFFF')
//                                             .withOpacity(0.87)
//                                         : HexColor.fromHex('#384341'),
//                                     fontSize: 10),
//                               ),
//                               Text(
//                                 '  50',
//                                 style: TextStyle(
//                                     color: Theme.of(context).brightness ==
//                                             Brightness.dark
//                                         ? HexColor.fromHex('#FFFFFF')
//                                             .withOpacity(0.87)
//                                         : HexColor.fromHex('#384341'),
//                                     fontSize: 10),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             width: 5.w,
//                           ),
//                           Container(
//                             margin: EdgeInsets.only(top: 8.h, bottom: 5.h),
//                             color: Theme.of(context).brightness ==
//                                     Brightness.dark
//                                 ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
//                                 : HexColor.fromHex('#D9E0E0'),
//                             height: 200,
//                             width: 1.w,
//                           ),
//                           Expanded(
//                             child: Align(
//                               alignment: Alignment.bottomLeft,
//                               child: Container(
//                                 margin: EdgeInsets.only(bottom: 5.h),
//                                 height: 1.h,
//                                 color: Theme.of(context).brightness ==
//                                         Brightness.dark
//                                     ? HexColor.fromHex('#FFFFFF')
//                                         .withOpacity(0.15)
//                                     : HexColor.fromHex('#D9E0E0'),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20.h,
//                     )
//                   ],
//                 )),
//             Expanded(
//               flex: widget.graphTab == GraphTab.day
//                   ? 10
//                   : widget.graphTab == GraphTab.week
//                       ? 8
//                       : 11,
//               child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: bpCandleData.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return candleContainer(index + 1);
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// added by: Shahzad
//   /// added on: 29th dec 2020
//   /// container for a single candle stick
//   Widget candleContainer(int index) {
//     return Column(
//       children: [
//         Container(
//           height: 210.h,
//           width: widget.graphTab == GraphTab.day
//               ? 12.w
//               : widget.graphTab == GraphTab.week
//                   ? 40.w
//                   : 9.5.w,
//           child: Column(
//             children: [
//               candleSingleGraph(bpCandleData[index - 1]),
//               Expanded(
//                 child: Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Container(
//                     margin: EdgeInsets.only(bottom: 5.h),
//                     height: 1.h,
//                     width: widget.graphTab == GraphTab.day
//                         ? 12.w
//                         : widget.graphTab == GraphTab.week
//                             ? 40.w
//                             : 9.5.w,
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? HexColor.fromHex('#FFFFFF').withOpacity(0.15)
//                         : HexColor.fromHex('#D9E0E0'),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//         Container(
//           height: 20.h,
//           width: widget.graphTab == GraphTab.day
//               ? 12.w
//               : widget.graphTab == GraphTab.week
//                   ? 40.w
//                   : 9.5.w,
//           child: Body1AutoText(
//             text: widget.graphTab == GraphTab.week
//                 ? weekDays(index)
//                 : index % 2 != 0
//                     ? index.toString()
//                     : '',
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
//                 : HexColor.fromHex('#384341'),
//             fontSize: widget.graphTab == GraphTab.day
//                 ? 8.sp
//                 : widget.graphTab == GraphTab.week
//                     ? 12.sp
//                     : 8.sp,
//             align: TextAlign.center,
//             maxLine: 1,
//             minFontSize: 5,
//           ),
//         )
//       ],
//     );
//   }
//
//   /// added by: Shahzad
//   /// added on: 29th dec 2020
//   /// adding properties to a single candle stick
//   Widget candleSingleGraph(CandleGraph bpGraph) {
//     var color = candleColor(bpGraph.sbpMax, bpGraph.dbpMax);
//     return Container(
//       margin: EdgeInsets.only(top: 6.h),
//       height: 198.h,
//       child: Container(
//         margin: EdgeInsets.only(top: candleHeight(200, bpGraph.sbpMax)),
//         child: Column(
//           children: [
//             Container(
//               height: candleHeight(bpGraph.sbpMax, bpGraph.sbpMin),
//               width: widget.graphTab == GraphTab.week ? 6.w : 5.w,
//               decoration: candleHeight(bpGraph.sbpMax, bpGraph.sbpMin) < 5
//                   ? BoxDecoration(
//                       borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(
//                               candleHeight(bpGraph.sbpMax, bpGraph.sbpMin)),
//                           bottom: Radius.circular(
//                               candleHeight(bpGraph.sbpMax, bpGraph.sbpMin))),
//                       color: color,
//                     )
//                   : BoxDecoration(
//                       borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(4.h),
//                           bottom: Radius.circular(4.h)),
//                       border: Border.all(color: color, width: 2.w)),
//             ),
//             Container(
//                 height: candleHeight(bpGraph.sbpMin, bpGraph.dbpMax),
//                 width: 2.w,
//                 color: color),
//             Container(
//               height: candleHeight(bpGraph.dbpMax, bpGraph.dbpMin),
//               width: widget.graphTab == GraphTab.week ? 6.w : 5.w,
//               decoration: candleHeight(bpGraph.dbpMax, bpGraph.dbpMin) < 5
//                   ? BoxDecoration(
//                       borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(
//                               candleHeight(bpGraph.dbpMax, bpGraph.dbpMin)),
//                           bottom: Radius.circular(
//                               candleHeight(bpGraph.sbpMax, bpGraph.sbpMin))),
//                       color: color,
//                     )
//                   : BoxDecoration(
//                       border: Border.all(color: color, width: 2.w),
//                       borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(4.h),
//                           bottom: Radius.circular(4.h)),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   double candleHeight(int value1, int value2) {
//     if (value1 < value2) {
//       return 0.0;
//     }
//     double height = 0;
//     height = ((value1 - 50) - (value2 - 50)) / 150 * 198;
//     return height.h > 198.h ? 0 : height.h;
//   }
//
//   /// added by: Shahzad
//   /// added on: 30th dec 2020
//   /// this function returns color of the candle stick
//   Color candleColor(int sbp, int dbp) {
//     if (sbp < 90 && dbp < 60) {
//       return HexColor.fromHex('#99D9D9');
//     } else if (sbp < 120 && dbp < 80) {
//       return HexColor.fromHex('#00AFAA');
//     } else if (sbp < 140 && dbp < 90) {
//       return HexColor.fromHex('#D3A5DF');
//     } else if (sbp < 160 && dbp < 100) {
//       return HexColor.fromHex('#BD78CE');
//     } else if (sbp <= 180 && dbp <= 120) {
//       return HexColor.fromHex('#9F2DBC');
//     } else {
//       return Colors.transparent;
//     }
//   }
//
//   /// added by: Shahzad
//   /// added on: 29th dec 2020
//   /// this function return name of week days
//   String weekDays(int index) {
//     switch (index) {
//       case 1:
//         return 'Mon';
//       case 2:
//         return 'Tue';
//       case 3:
//         return 'Wed';
//       case 4:
//         return 'Thu';
//       case 5:
//         return 'Fri';
//       case 6:
//         return 'Sat';
//       case 7:
//         return 'Sun';
//     }
//     return '';
//   }
//
//   /// added by: Shahzad
//   /// added on: 29th dec 2020
//   /// container of avg sys and dia
//   Widget candleGraphIndicator() {
//     return Container(
//       padding: EdgeInsets.only(top: 10.h),
//       height: 80.h,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Flexible(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   stringLocalization.getText(StringLocalization.sysAvg),
//                   // minFontSize: 12,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Theme.of(context).brightness == Brightness.dark
//                           ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                           : HexColor.fromHex('#5D6A68')),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         avgSbp.toString(),
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                             color: Theme.of(context).brightness ==
//                                     Brightness.dark
//                                 ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
//                                 : HexColor.fromHex('#384341')),
//                       ),
//                       SizedBox(
//                         width: 2.h,
//                       ),
//                       Text(
//                         'mmHg',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Theme.of(context).brightness ==
//                                     Brightness.dark
//                                 ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                 : HexColor.fromHex('#5D6A68')),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             width: 30.w,
//           ),
//           Flexible(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   stringLocalization.getText(StringLocalization.diaAvg),
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Theme.of(context).brightness == Brightness.dark
//                           ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                           : HexColor.fromHex('#5D6A68')),
//                 ),
//                 SizedBox(
//                   height: 2.h,
//                 ),
//                 Expanded(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         avgDbp.toString(),
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                             color: Theme.of(context).brightness ==
//                                     Brightness.dark
//                                 ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
//                                 : HexColor.fromHex('#384341')),
//                       ),
//                       SizedBox(
//                         width: 2.h,
//                       ),
//                       Text(
//                         'mmHg',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Theme.of(context).brightness ==
//                                     Brightness.dark
//                                 ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                 : HexColor.fromHex('#5D6A68')),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget bloodPressureIndicator(var sbp, var dbp) {
//     var bpDateTime = '';
//     if (selectedMeasurement?.date?.split('.')[0].isNotEmpty ?? false) {
//       bpDateTime = selectedMeasurement!.date!.split('.')[0];
//     } else {
//       bpDateTime = stringLocalization.getText(StringLocalization.noData);
//     }
//     if (measurementModelList.isEmpty) {
//       sbp = 0;
//       dbp = 0;
//       bpDateTime = stringLocalization.getText(StringLocalization.noData);
//     }
//     return Container(
//       margin: EdgeInsets.only(top: 18.h),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: 12.h,
//                 width: 12.h,
//                 decoration: BoxDecoration(
//                     color: Colors.yellow,
//                     shape: BoxShape.circle,
//                     border: Border.all(color: Colors.black)),
//               ),
//               SizedBox(width: 8.w),
//               SizedBox(
//                 height: 20.h,
//                 child: Body1AutoText(
//                   text: stringLocalization.getText(StringLocalization.yourBp),
//                   color: Theme.of(context).brightness == Brightness.dark
//                       ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                       : HexColor.fromHex('#5D6A68'),
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               SizedBox(
//                 height: 25.h,
//                 child: Body1AutoText(
//                     text: '$sbp/$dbp',
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
//                         : HexColor.fromHex('#384341'),
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(width: 8.w),
//               SizedBox(
//                 height: 20.h,
//                 child: Body1AutoText(
//                     text: 'mmHg',
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                         : HexColor.fromHex('#5D6A68'),
//                     fontSize: 16.0,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           widget.graphTab == GraphTab.day
//               ? Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     measurementModelList.isNotEmpty
//                         ? Material(
//                           color: Colors.transparent,
//                           child: Container(
//                             height: 30.h,
//                             child: IconButton(
//                               padding: EdgeInsets.all(0),
//                                 icon: Icon(
//                                   Icons.arrow_back_ios,
//                                   size: 14,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.87)
//                                       : HexColor.fromHex('#384341'),
//                                 ),
//                                 onPressed: () {
//                                   if (bpIndex == 0) {
//                                     bpIndex = measurementModelList.length - 1;
//                                   } else {
//                                     bpIndex = bpIndex - 1;
//                                   }
//                                   bloodPressureArrowButtonClicked();
//                                 },
//                               ),
//                           ),
//                         )
//                         : Container(),
//                     !(measurementModelList == null ||
//                             measurementModelList.isEmpty)
//                         ? Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 height: 25.h,
//                                 child: Body1AutoText(
//                                   text: 'Time:',
//                                   maxLine: 1,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.6)
//                                       : HexColor.fromHex('#5D6A68'),
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5.w,
//                               ),
//                               SizedBox(
//                                 height: 25.h,
//                                 child: Body1AutoText(
//                                   text: bpDateTime.split(' ')[1],
//                                   maxLine: 1,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.87)
//                                       : HexColor.fromHex('#384341'),
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           )
//                         : SizedBox(
//                             height: 25.h,
//                             child: Body1AutoText(
//                               text: bpDateTime,
//                               maxLine: 1,
//                               color: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                   : HexColor.fromHex('#384341'),
//                               fontSize: 16.0,
//                               align: TextAlign.center,
//                             ),
//                           ),
//                     measurementModelList.isNotEmpty
//                         ? Material(
//                       color: Colors.transparent,
//                           child: Container(
//                               height: 30.h,
//                               child: IconButton(
//                                 padding: EdgeInsets.zero,
//                                 icon: Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 14,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.87)
//                                       : HexColor.fromHex('#384341'),
//                                 ),
//                                 onPressed: () {
//                                   if (bpIndex ==
//                                       measurementModelList.length - 1) {
//                                     bpIndex = 0;
//                                   } else {
//                                     bpIndex = bpIndex + 1;
//                                   }
//                                   bloodPressureArrowButtonClicked();
//                                 },
//                               ),
//                             ),
//                         )
//                         : Container(),
//                   ],
//                 )
//               : Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     measurementModelList.isNotEmpty
//                         ? Material(
//                       color: Colors.transparent,
//                           child: Container(
//                               width: 25.w,
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.arrow_back_ios,
//                                   size: 14,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.87)
//                                       : HexColor.fromHex('#384341'),
//                                 ),
//                                 onPressed: () {
//                                   if (bpIndex == 0) {
//                                     bpIndex = measurementModelList.length - 1;
//                                   } else {
//                                     bpIndex = bpIndex - 1;
//                                   }
//                                   bloodPressureArrowButtonClicked();
//                                 },
//                               ),
//                             ),
//                         )
//                         : Container(),
//                     measurementModelList.isNotEmpty
//                         ? Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 height: 25.h,
//                                 child: Body1AutoText(
//                                   text: 'Date:',
//                                   maxLine: 1,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.6)
//                                       : HexColor.fromHex('#5D6A68'),
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5.w,
//                               ),
//                               SizedBox(
//                                 height: 25.h,
//                                 child: Body1AutoText(
//                                   text: bpDateTime.split(' ')[0],
//                                   maxLine: 1,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.87)
//                                       : HexColor.fromHex('#384341'),
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5.w,
//                               ),
//                               SizedBox(
//                                 height: 25.h,
//                                 child: Body1AutoText(
//                                   text: 'Time:',
//                                   maxLine: 1,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.6)
//                                       : HexColor.fromHex('#5D6A68'),
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5.w,
//                               ),
//                               SizedBox(
//                                 height: 25.h,
//                                 child: Body1AutoText(
//                                   text: bpDateTime.split(' ')[1],
//                                   maxLine: 1,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.87)
//                                       : HexColor.fromHex('#384341'),
//                                   fontSize: 16.0,
//                                 ),
//                               ),
//                             ],
//                           )
//                         : SizedBox(
//                             height: 25.h,
//                             child: Body1AutoText(
//                               text: bpDateTime,
//                               maxLine: 1,
//                               color: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                   : HexColor.fromHex('#384341'),
//                               fontSize: 16.0,
//                               align: TextAlign.center,
//                             ),
//                           ),
//                     measurementModelList.isNotEmpty
//                         ? Material(
//                       color: Colors.transparent,
//                           child: Container(
//                               width: 25.w,
//                               child: IconButton(
//                                 icon: Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 14,
//                                   color: Theme.of(context).brightness ==
//                                           Brightness.dark
//                                       ? HexColor.fromHex('#FFFFFF')
//                                           .withOpacity(0.87)
//                                       : HexColor.fromHex('#384341'),
//                                 ),
//                                 onPressed: () {
//                                   if (bpIndex ==
//                                       measurementModelList.length - 1) {
//                                     bpIndex = 0;
//                                   } else {
//                                     bpIndex = bpIndex + 1;
//                                   }
//                                   bloodPressureArrowButtonClicked();
//                                 },
//                               ),
//                             ),
//                         )
//                         : Container(),
//                   ],
//                 ),
//           SizedBox(height: measurementModelList.isEmpty ? 30.h : 10.h),
//           Container(
//             margin: EdgeInsets.only(left: 15.h, right: 15.h),
//             height: 1,
//             color: HexColor.fromHex('#BDC7C5'),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 15.h, right: 15.h, top: 15.h),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           height: 12.h,
//                           width: 12.h,
//                           decoration:
//                               BoxDecoration(color: HexColor.fromHex('#99D9D9')),
//                         ),
//                         SizedBox(width: 8.w),
//                         SizedBox(
//                           height: 18.h,
//                           child: Body1AutoText(
//                               text: 'Low',
//                               color: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                   : HexColor.fromHex('#5D6A68'),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 19.h,
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           height: 12.h,
//                           width: 12.h,
//                           decoration:
//                               BoxDecoration(color: HexColor.fromHex('#D3A5DF')),
//                         ),
//                         SizedBox(width: 8.w),
//                         SizedBox(
//                           height: 18.h,
//                           child: Body1AutoText(
//                               text: 'Hyper',
//                               color: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                   : HexColor.fromHex('#5D6A68'),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           height: 12.h,
//                           width: 12.h,
//                           decoration:
//                               BoxDecoration(color: HexColor.fromHex('#00AFAA')),
//                         ),
//                         SizedBox(width: 8.w),
//                         SizedBox(
//                           height: 18.h,
//                           child: Body1AutoText(
//                               text: 'Ideal',
//                               color: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                   : HexColor.fromHex('#5D6A68'),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 19.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 12.h,
//                           width: 12.h,
//                           decoration:
//                               BoxDecoration(color: HexColor.fromHex('#BD78CE')),
//                         ),
//                         SizedBox(width: 8.w),
//                         SizedBox(
//                           height: 18.h,
//                           child: Body1AutoText(
//                               text: 'Hyper (stage 1)',
//                               color: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                   : HexColor.fromHex('#5D6A68'),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           height: 12.h,
//                           width: 12.h,
//                           decoration: BoxDecoration(color: Colors.transparent),
//                         ),
//                         SizedBox(width: 8.w),
//                         SizedBox(
//                             height: 18.h,
//                             child: Body1AutoText(
//                                 text: 'Ideal', color: Colors.transparent)),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 19.h,
//                     ),
//                     Row(
//                       children: [
//                         Container(
//                           height: 12.h,
//                           width: 12.h,
//                           decoration:
//                               BoxDecoration(color: HexColor.fromHex('#9F2DBC')),
//                         ),
//                         SizedBox(width: 8.w),
//                         SizedBox(
//                           height: 18.h,
//                           child: Body1AutoText(
//                               text: 'Hyper (stage 2)',
//                               color: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
//                                   : HexColor.fromHex('#5D6A68'),
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   void bloodPressureArrowButtonClicked() {
//     bloodPressure.xValue = measurementModelList[bpIndex].dbp!.toDouble();
//     bloodPressure.yValue = measurementModelList[bpIndex].sbp!.toDouble();
//     bloodPressure.date = measurementModelList[bpIndex].date;
//     selectedMeasurement = measurementModelList[bpIndex];
//     if (mounted) {
//       setState(() {});
//     }
//   }
// }
//
// class ScatterGraph {
//   double xValue;
//   double yValue;
//   Color color;
//   String? pointID;
//   String? date;
//
//   ScatterGraph(
//       {required this.yValue,
//       required this.xValue,
//       required this.color,
//       this.pointID,
//       this.date});
// }
//
// /// added by: Shahzad
// /// added on: 29th dec 2020
// /// contains value for candle stick graph
// class CandleGraph {
//   int sbpMax;
//   int dbpMax;
//   int sbpMin;
//   int dbpMin;
//
//   CandleGraph(
//       {required this.dbpMax,
//       required this.dbpMin,
//       required this.sbpMax,
//       required this.sbpMin});
// }
