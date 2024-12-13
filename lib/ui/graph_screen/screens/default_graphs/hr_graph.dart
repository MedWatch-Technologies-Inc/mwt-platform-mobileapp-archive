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
import 'package:health_gauge/value/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../graph_item_data.dart';



class HrGraph extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime startDate;
  final DateTime endDate;
  final GraphTab graphTab;
  final List<GraphTypeModel> graphTypeList;
  final int index;
  final List<GraphTypeModel> selectedGraphTypeList;
  final GraphProviderList prov;

  HrGraph({
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
  _HrGraphState createState() => _HrGraphState();
}

class _HrGraphState extends State<HrGraph> {
  Widget hrLineChartWidget = Container();
  List<GraphItemData> hrList = [];
  List<chart.Series<GraphItemData, num>> hrLineChartSeries = [];



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Container(
                height: 250.h,
                child: hrLineChartWidget,
              ),
              SizedBox(height: 15.h,),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getHrData(),
    );
  }


  Future<bool> getHrData() async {
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
    await makeOrRefreshHrGraph();
    return true;
  }

  Future<void> makeOrRefreshHrGraph() async {

    try {
      hrLineChartSeries = LineGraphData(graphList: widget.selectedGraphTypeList, graphItemList: hrList).getLineGraphData();
      var tempLineChartSeries = hrLineChartSeries;
      if(widget.graphTab == GraphTab.week || widget.graphTab == GraphTab.month) {
        if(tempLineChartSeries.isNotEmpty && tempLineChartSeries[0].data.isNotEmpty && tempLineChartSeries[0].data.first.xValue != 0) {
          for (var element in tempLineChartSeries) {
            for (var data in element.data) {
              data.xValue = data.xValue - 1;
            }
          }
        }
      }

      hrLineChartWidget = chart.LineChart(
        tempLineChartSeries,
        animate: true,
        customSeriesRenderers:
        List.generate(widget.selectedGraphTypeList.length, (index) {
          return chart.LineRendererConfig(
            customRendererId: widget.selectedGraphTypeList[index].fieldName,
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
          message: e.toString(), tag: 'hr graph');
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