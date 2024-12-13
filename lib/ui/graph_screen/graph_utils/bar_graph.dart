import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:intl/intl.dart';

import '../graph_item_data.dart';

class BarGraph {
  final List<GraphTypeModel> graphList;
  List<chart.Series<GraphItemData, String>> barChartSeries;
  final BuildContext context;
  final GraphTab graphTab;
  final DateTime startDate;
  final DateTime endDate;
  final bool isNormalization;
  final List<GraphItemData> graphItemList;

  BarGraph({
    required this.graphList,
    required this.barChartSeries,
    required this.context,
    required this.startDate,
    required this.endDate,
    required this.graphTab,
    required this.isNormalization,
    required this.graphItemList,
  });

  Widget getBarGraph() {
    //region line chart
    try {
      for(var element in barChartSeries){
        if(element.data.isNotEmpty && element.data.last.xValue == 24){
          element.data.removeLast();
        }
      }

      if (graphList.isNotEmpty && graphList.length > 1 && isNormalization) {
        barChartSeries[1]
          ..setAttribute(
            chart.measureAxisIdKey,
            chart.Axis.secondaryMeasureAxisId,
          );
      }
         return chart.BarChart(
          barChartSeries,
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
              dataIsInWholeNumbers: false,
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
              dataIsInWholeNumbers: false,
              zeroBound: true,
            ),
          ),
          domainAxis: chart.OrdinalAxisSpec(
            tickProviderSpec:
            chart.StaticOrdinalTickProviderSpec(graphItemList.map((e) {
              return chart.TickSpec(e.xValue.toInt().toString(),
                  label: _formatterXAxis(e.xValue.toInt()),
                  style: chart.TextStyleSpec(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? chart.MaterialPalette.white
                          : chart.MaterialPalette.black
                  ));
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
      LoggingService().printLog(tag: 'bar graph', message: e.toString());
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

}
