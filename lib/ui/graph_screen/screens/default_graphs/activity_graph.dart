import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as chart;
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/graph_utils/line_graph_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_item_enum.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_manager.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/ui/graph_screen/providers/graph_provider.dart';
import 'package:health_gauge/ui/graph_screen/providers/graph_provider_list.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../graph_item_data.dart';


class ActivityGraph extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime startDate;
  final DateTime endDate;
  final GraphTab graphTab;
  final List<GraphTypeModel> graphTypeList;
  final int index;
  final List<GraphTypeModel> selectedGraphTypeList;
  final GraphProviderList prov;

  ActivityGraph({
    required this.selectedDate,
    required this.graphTab,
    required this.graphTypeList,
    required this.startDate,
    required this.endDate,
    required this.index,
    required this.selectedGraphTypeList,
    required this.prov
  });

  @override
  _ActivityGraphState createState() => _ActivityGraphState();
}

class _ActivityGraphState extends State<ActivityGraph> {
  Widget hrLineChartWidget = Container();
  Widget stepLineChartWidget = Container();
  List<GraphItemData> hrList = [];
  List<GraphItemData> stepList = [];
  List<chart.Series<GraphItemData, num>> hrLineChartSeries = [];
  List<chart.Series<GraphItemData, num>> stepLineChartSeries = [];


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200.h,
                child: hrLineChartWidget,
              ),
              SizedBox(
                height: 15.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 20.h,
                  child: AutoSizeText(
                    'STEPS',
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
                child: stepLineChartWidget,
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getActivityData(),
    );
  }

  Future<bool> getActivityData() async {
    hrList = await GraphDataManager().graphManager(
        userId: globalUser?.userId ?? '',
        startDate: widget.startDate,
        endDate: widget.endDate,
        selectedGraphTypes: [
          widget.graphTypeList.firstWhere(
                  (element) =>
              element.fieldName == DefaultGraphItem.hr.fieldName)
        ],
        isEnableNormalize: false,
        unitType: 1);
    stepList = await GraphDataManager().graphManager(
        userId: globalUser?.userId ?? '',
        startDate: widget.startDate,
        endDate: widget.endDate,
        selectedGraphTypes: [
          widget.graphTypeList.firstWhere(
                  (element) =>
              element.fieldName == DefaultGraphItem.step.fieldName)
        ],
        isEnableNormalize: false,
        unitType: 1);
    stepList = makeDefaultValueForXAxisToBarChart(stepList, 1);

    await makeOrRefreshActivityGraph();
    return true;
  }

  List<GraphItemData> makeDefaultValueForXAxisToBarChart(List<GraphItemData> selectedGraphList, int index) {
    var loopLength = 0;
    if (widget.graphTab == GraphTab.day) {
      loopLength = 25;
    } else if (widget.graphTab == GraphTab.week) {
      loopLength = 7;
    } else if (widget.graphTab == GraphTab.month) {
      loopLength =
          DateTime(widget.startDate.day, widget.startDate.month + 1, 0).day;
    }

    var unAvailableXValues = <GraphItemData>[];
    for (var i = 1; i <= loopLength; i++) {
      var valueIsAlreadyExistForThisAxis = selectedGraphList.any((e) =>
      e.label == widget.selectedGraphTypeList[index].fieldName &&
          e.xValue.toInt() == i);
      if (!valueIsAlreadyExistForThisAxis) {
        var emptyGraphItem = GraphItemData(
            label: widget.selectedGraphTypeList[index].fieldName,
            yValue: 0,
            xValue: i.toDouble(),
            xValueStr: i.toInt().toString());
        unAvailableXValues.add(emptyGraphItem);
      }
    }
    selectedGraphList.addAll(unAvailableXValues);
    return selectedGraphList;
  }

  Future<void> makeOrRefreshActivityGraph() async {
    var newGraphTypeList = <GraphTypeModel>[];
    try {
      newGraphTypeList = [
        widget.graphTypeList.firstWhere((element) => element.fieldName == DefaultGraphItem.hr.fieldName)
      ];
      hrLineChartSeries = LineGraphData(graphList: newGraphTypeList, graphItemList: hrList).getLineGraphData();

      var tempHrLineChartSeries = hrLineChartSeries;
      if(widget.graphTab == GraphTab.week || widget.graphTab == GraphTab.month) {
        if(tempHrLineChartSeries.isNotEmpty && tempHrLineChartSeries[0].data.isNotEmpty && tempHrLineChartSeries[0].data.first.xValue != 0) {
          for (var element in tempHrLineChartSeries) {
            for (var data in element.data) {
              data.xValue = data.xValue - 1;
            }
          }
        }
      }
      hrLineChartWidget = chart.LineChart(
        tempHrLineChartSeries,
        animate: true,
        customSeriesRenderers:
        List.generate(newGraphTypeList.length, (index) {
          return chart.LineRendererConfig(
            customRendererId: newGraphTypeList[index].fieldName,
            includeArea: true,
            stacked: true,
            includePoints: true,
            includeLine: true,
            roundEndCaps: true,
            radiusPx: 1.0,
            strokeWidthPx: 1.0,
          );
        }),
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
              desiredTickCount: 5, zeroBound: true),
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
          message: e.toString(), tag: 'activity graph : hr');
    }

    try {
      newGraphTypeList = [
        widget.graphTypeList.firstWhere((element) => element.fieldName == DefaultGraphItem.step.fieldName)
      ];
      stepLineChartSeries = LineGraphData(graphList: newGraphTypeList, graphItemList: stepList).getLineGraphData();
      var tempStepLineChartSeries = stepLineChartSeries;
      // if(tempStepLineChartSeries.isNotEmpty && tempStepLineChartSeries[0].data.isNotEmpty && tempStepLineChartSeries[0].data.first.xValue == 1) {
        for (var element in tempStepLineChartSeries) {
          for (var data in element.data) {
            data.xValue = data.xValue - 1;
          }
        }
      // }
      stepLineChartWidget = chart.LineChart(
        tempStepLineChartSeries,
        animate: true,
        customSeriesRenderers:
        List.generate(newGraphTypeList.length, (index) {
          return chart.LineRendererConfig(
            customRendererId: newGraphTypeList[index].fieldName,
            includeArea: true,
            stacked: true,
            includePoints: true,
            includeLine: true,
            roundEndCaps: true,
            radiusPx: 2.0,
            strokeWidthPx: 1.0,
          );
        }),
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
              desiredTickCount: 5, zeroBound: true),
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
          message: e.toString(), tag: 'activity graph : step');
    }
    widget.prov.graphProviderList[widget.index].isShowLoadingScreen = false;
  }

  String _formatterXAxis(num? year) {
    if (widget.graphTab == GraphTab.week) {
      var date = DateTime.now();
      var lastMonday =
      date.subtract(Duration(days: date.weekday - (year!.toInt() + 1)));
      return DateFormat(DateUtil.EEE).format(lastMonday); // prints Tuesday
    }
    var value =  year!.toInt();
    if(widget.graphTab == GraphTab.month){
      value = value + 1;
    }
    if (value % 2 == 0) {
      return '';
    }
    return '$value';
  }

  int xAxisCount() {
    if ( widget.graphTab == GraphTab.day) {
      return 25;
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

}
