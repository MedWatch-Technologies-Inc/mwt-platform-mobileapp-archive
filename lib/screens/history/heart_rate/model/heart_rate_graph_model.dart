import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/ui/graph_screen/graph_item_data.dart';
import 'package:health_gauge/ui/graph_screen/manager/graph_type_model.dart';
import 'package:health_gauge/utils/constants.dart';

class HeartRateGraphModel {
  final List<GraphTypeModel> graphList;
  final List<chart.Series<GraphItemData, num>> lineChartSeries;
  final BuildContext context;
  final GraphTab graphTab;
  final DateTime startDate;
  final DateTime endDate;
  final bool isNormalization;
  final bool showXGridLines;
  final bool showYGridLines;

  HeartRateGraphModel({
    required this.graphList,
    required this.lineChartSeries,
    required this.context,
    required this.startDate,
    required this.endDate,
    required this.graphTab,
    required this.isNormalization,
    this.showXGridLines = true,
    this.showYGridLines = true,
  });
}
