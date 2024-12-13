import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:intl/intl.dart';

import '../graph_item_data.dart';

class LineAndBarGraph {
  final List<GraphTypeModel> graphList;
  final List<chart.Series<GraphItemData, num>> lineAndBarChartSeries;
  final BuildContext context;
  final GraphTab graphTab;
  final DateTime startDate;
  final DateTime endDate;
  final bool isNormalization;

  LineAndBarGraph({
    required this.graphList,
    required this.lineAndBarChartSeries,
    required this.context,
    required this.startDate,
    required this.endDate,
    required this.graphTab,
    required this.isNormalization,
  });

  Widget getLineAndBarGraph() {
    //region line chart
    try {
      if (graphList.isNotEmpty && graphList.length > 1 && isNormalization) {
        lineAndBarChartSeries[1]
          ..setAttribute(
            chart.measureAxisIdKey,
            chart.Axis.secondaryMeasureAxisId,
          );
      }

      if (lineAndBarChartSeries.isNotEmpty && lineAndBarChartSeries.length > 1) {
        lineAndBarChartSeries[1]
          ..setAttribute(
            chart.rendererIdKey,
            'customLine',
          );
      }

      return chart.LineChart(
        lineAndBarChartSeries,
        animate: true,
        customSeriesRenderers: [
          chart.LineRendererConfig(
            customRendererId: graphList[0].fieldName,
            includeArea: false,
            stacked: true,
            includePoints: true,
            includeLine: true,
            roundEndCaps: true,
            radiusPx: graphList[0].fieldName == 'approxHr' ? 1.0 : 2.0,
            strokeWidthPx: 1.0,
          ),
          chart.BarRendererConfig(
            customRendererId: 'customLine',
          maxBarWidthPx: 3,

          ),
        ],
        primaryMeasureAxis: chart.NumericAxisSpec(
          renderSpec: chart.GridlineRendererSpec(
              labelStyle: chart.TextStyleSpec(
                  fontSize: 10,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? chart.MaterialPalette.white
                      : chart.MaterialPalette.black)),
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
              desiredTickCount: 5,
              dataIsInWholeNumbers: false,
              zeroBound: true),
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
            dataIsInWholeNumbers: false,
            zeroBound: true,
          ),
        ),
        domainAxis: chart.NumericAxisSpec(
          tickProviderSpec: chart.BasicNumericTickProviderSpec(
            zeroBound: false,
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
      LoggingService().printLog(tag: 'line and graph', message: e.toString());
      return Container();
    }
  }

//endregion

  String _formatterXAxis(num? year) {
    if (graphTab == GraphTab.week) {
      var date = DateTime.now();
      var lastMonday =
      date.subtract(Duration(days: date.weekday - (year!.toInt() + 1)));
      return DateFormat('EEE').format(lastMonday); // prints Tuesday
    }
    var value = year!.toInt();
    if(graphTab == GraphTab.month){
      value = value + 1;
    }
    if (value % 2 == 0) {
      return '';
    }
    return '$value';
  }

  int xAxisCount() {
    if (graphTab == GraphTab.day) {
      return 24;
    } else if (graphTab == GraphTab.week) {
      return 7;
    } else if (graphTab == GraphTab.month) {
      return daysInMonth(startDate);
    }
    return startDate.difference(endDate).inDays;
  }

  int daysInMonth(DateTime date) {
    var firstDayNextMonth = DateTime(date.year, date.month + 1, 0);
    return firstDayNextMonth.day;
  }
}
