import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/screens/measurement_screen/widgets/background_paint.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:mp_chart/mp/core/data/chart_data.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/gloabals.dart';

class HRVCard extends StatelessWidget {
  HRVCard({
    required this.hrvLength,
    required this.hrvGraphValues,
    required this.zoomLevelHRV,
    this.hrvPointList = const <int>[],
    this.setZoom,
    this.setController,
    super.key,
  }) {
    print('HRVGraph :: ${hrvGraphValues.value}');
    print('HRVGraph :: ${hrvGraphValues.value.length}');
  }

  final ValueNotifier<int> hrvLength;
  final ValueNotifier<List<FlSpot>> hrvGraphValues;
  final ValueNotifier<num> zoomLevelHRV;
  final List<int> hrvPointList;
  final Function? setZoom;
  final Function(ChartSeriesController controller)? setController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.h),
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                  : HexColor.fromHex('#FFFFFF'),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(-4, -4),
            ),
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#000000').withOpacity(0.75)
                  : HexColor.fromHex('#D1D9E6'),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(4, 4),
            ),
          ]),
      height: 171.h,
      child: Column(
        children: <Widget>[
          Container(
            height: 25.h,
            margin: EdgeInsets.only(top: 10.h),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Body1AutoText(
                    text: StringLocalization.of(context).getText(StringLocalization.hrv),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: HexColor.fromHex('#BD78CE'),
                  ),
                ),
              ],
            ),
          ),
          hrvGraphValues.value.isEmpty
              ? Container(
                  height: 125.h,
                  child: Center(
                    child: SizedBox(
                      height: 30.h,
                      child: Body1AutoText(
                        text:
                            stringLocalization.getText(StringLocalization.ppgNoChartDataAvailable),
                        maxLine: 1,
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                  height: 135.h,
                  width: MediaQuery.of(context).size.width - 13.w,
                  padding: EdgeInsets.only(left: 5.0, right: 15.0),
                  child: Stack(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: hrvGraphValues,
                        builder: (BuildContext context, List<FlSpot> value, Widget? child) {
                          return LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                leftTitles: SideTitles(
                                  interval: 100,
                                  showTitles: true,
                                  getTextStyles: (value) {
                                    return TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.black54,
                                    );
                                  },
                                ),
                                bottomTitles: SideTitles(
                                  interval: 25,
                                  showTitles: true,
                                  getTextStyles: (value) {
                                    return TextStyle(
                                      fontSize: 8.0,
                                      color: Colors.black54,
                                    );
                                  },
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(color: Colors.black12, width: 0.5),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                horizontalInterval: 25,
                                verticalInterval: 2.5,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                      color: Colors.black12,
                                      strokeWidth: 0.25); // Set the color of horizontal grid lines
                                },
                                getDrawingVerticalLine: (value) {
                                  return FlLine(
                                      color: Colors.black12,
                                      strokeWidth: 0.25); // Set the color of vertical grid lines
                                },
                              ),
                              maxX: 50,
                              maxY: 200,
                              minY: 0,
                              minX: 0,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: getSeconds.asMap().entries.map((entry) {
                                    final time = entry.key;
                                    final hrv = entry.value;
                                    print('entry :: $time x $hrv');
                                    return FlSpot(time.toDouble(), getHRV[time].toDouble());
                                  }).toList(),
                                  isCurved: true,
                                  colors: [Colors.blue],
                                  dotData: FlDotData(show: false),
                                  isStrokeCapRound: true,
                                ),
                              ],
                              // titlesInEventLine: false,
                              // borderLinesData: FlBorderData(
                              //   show: true,
                              // ),
                            ),
                          );
                        },
                      ),
                      /*SfCartesianChart(
                            primaryXAxis: NumericAxis(
                              maximum: measurementTime.value.toDouble(),
                              interval: 25,
                              minimum: 0,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            primaryYAxis: NumericAxis(
                              maximum: 200,
                              minimum: 0,
                              interval: 100,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            series: [
                              StackedLineSeries<ChartSampleData, int>(
                                dataSource: hrvGraphValues.value,
                                xValueMapper: (ChartSampleData sales, _) => sales.x,
                                yValueMapper: (ChartSampleData sales, _) => sales.y,
                                width: 2.5,
                                animationDuration: 2000,
                                onRendererCreated:(ChartSeriesController controller) {
                                  print('ChartSeriesController controller');
                                  if(setController!=null){
                                    setController!(controller);
                                  }
                                },
                              ),
                            ],
                          ),*/
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

List<int> get getSeconds => List.generate(50, (index) => index + 1);

List<int> get getHRV => List.generate(60, (index) => Random().nextInt(50) + 20);
