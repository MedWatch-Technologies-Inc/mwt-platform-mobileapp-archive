import 'package:flutter/material.dart';
import 'package:health_gauge/resources/theme/app_theme.dart';
import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:health_gauge/screens/measurement_screen/cards/progress_card.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OTGraphWidget extends StatelessWidget {
  const OTGraphWidget({
    required this.list,
    required this.type,
    this.isGraphPage = true,
    super.key,
  });

  final String type;
  final List<OTHistoryModel> list;
  final bool isGraphPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isGraphPage ? 220 : 300,
      child: SfCartesianChart(
        series: [
          LineSeries<OTHistoryModel, double>(
            dataSource: list,
            xValueMapper: (OTHistoryModel data, _) => data.getX,
            yValueMapper: (OTHistoryModel data, _) => data.oxygen.toDouble(),
            color: AppThemeColor.appBarTitleColor,
            width: isDarkMode(context)
                ? isGraphPage
                    ? 0.25
                    : 0.5
                : isGraphPage
                    ? 1
                    : 2,
            legendItemText: 'SPO2',
          ),
        ],
        primaryXAxis: NumericAxis(
          title: AxisTitle(
            text: 'HOUR',
            textStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 10),
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
            text: 'SPO2',
            textStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 10),
          ),
          minimum: 80,
          axisLine: AxisLine(
            width: isGraphPage ? 1.0 : 2.0,
          ),
          majorGridLines: MajorGridLines(width: 0),
          minorGridLines: MinorGridLines(width: 0),
          interval: 5,
          maximum: 100,
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
    );
  }
}
