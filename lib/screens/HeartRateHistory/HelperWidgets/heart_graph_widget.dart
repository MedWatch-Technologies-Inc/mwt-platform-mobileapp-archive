// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/screens/measurement_screen/cards/progress_card.dart';
import 'package:health_gauge/utils/Synchronisation/Models/hr_monitoring_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HeartGraphWidget extends StatelessWidget {
  const HeartGraphWidget({
    required this.list,
    required this.zoneLines,
    this.isGraphPage = true,
    super.key,
  });

  final List<SyncHRModel> list;
  final List<List<CAnnotation>> zoneLines;
  final bool isGraphPage;

  List<ChartSeries> get getZoneLines => zoneLines
      .map(
        (e) => LineSeries<dynamic, dynamic>(
            dataSource: e,
            xValueMapper: (dynamic data, _) => data.x,
            yValueMapper: (dynamic data, _) => data.y,
            color: e.first.color.withOpacity(0.75),
            legendItemText: 'Zone ${zoneLines.indexOf(e) + 1}'),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isGraphPage ? 220 : 300,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SfCartesianChart(
              series: getZoneLines
                ..add(
                  LineSeries<dynamic, dynamic>(
                    dataSource: list,
                    xValueMapper: (dynamic data, _) => data.getX,
                    yValueMapper: (dynamic data, _) => data.approxHR,
                    color: HexColor.fromHex('#FF9E99'),
                    width: isDarkMode(context)
                        ? isGraphPage
                            ? 0.25
                            : 0.5
                        : isGraphPage
                            ? 1
                            : 2,
                    legendItemText: 'Heart Rate',
                  ),
                ),
              primaryXAxis: NumericAxis(
                title: AxisTitle(
                  text: 'HOUR',
                  textStyle: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: 10),
                ),
                decimalPlaces: 0,
                minimum: 0,
                maximum: 24,
                interval: 4,
                majorGridLines: MajorGridLines(width: 0),
                minorGridLines: MinorGridLines(width: 0),
                majorTickLines: MajorTickLines(size: 0),
                labelStyle: TextStyle(
                  fontSize: isGraphPage ? 8.0 : 10.0,
                  fontWeight: FontWeight.bold,
                ),
                axisLine: AxisLine(
                  width: isGraphPage ? 0.5 : 2.0,
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                    text: 'HEART RATE',
                    textStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge!.color,
                        fontSize: 10)),
                minimum: 0,
                axisLine: AxisLine(
                  width: isGraphPage ? 1.0 : 2.0,
                ),
                majorGridLines: MajorGridLines(width: 0),
                minorGridLines: MinorGridLines(width: 0),
                interval: 50,
                maximum: 200,
                majorTickLines: MajorTickLines(size: 0),
                labelStyle: TextStyle(
                  fontSize: isGraphPage ? 8.0 : 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              plotAreaBorderWidth: 0,
              plotAreaBorderColor: Colors.transparent,
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                zoomMode: ZoomMode.x,
                maximumZoomLevel: 0.2,
              ),
              legend: isGraphPage
                  ? Legend(
                      isVisible: true,
                      iconHeight: 8.0,
                      iconWidth: 8.0,
                      shouldAlwaysShowScrollbar: false,
                      position: LegendPosition.bottom,
                      overflowMode: LegendItemOverflowMode.wrap,
                      textStyle: TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                      overflowMode: LegendItemOverflowMode.wrap,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class CAnnotation {
  double x;
  double y;
  Color color;

  CAnnotation({
    required this.x,
    required this.y,
    required this.color,
  });
}
