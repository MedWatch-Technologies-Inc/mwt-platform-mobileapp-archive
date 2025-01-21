import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/gloabals.dart';

class BPErrorGraph extends StatelessWidget {
  const BPErrorGraph({
    required this.list,
    required this.startDate,
    required this.endDate,
    required this.isDay,
    required this.isWeek,
    super.key,
  });

  final List<MHistoryModel> list;
  final DateTime startDate;
  final DateTime endDate;
  final bool isDay;
  final bool isWeek;

  double get averageSys =>
      list.map((e) => e.getAISys).toList().reduce((value, element) => value + element) /
      list.length;

  double get averageDias =>
      list.map((e) => e.getAIDias).toList().reduce((value, element) => value + element) /
      list.length;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: isMyTablet ? 430  : 340,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10.h),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                    : Colors.white,
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(-4, -4),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#000000').withOpacity(0.6)
                    : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(4, 4),
              ),
            ],
          ),
          margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 12.5,
              ),
              Container(
                height: 270,
                padding: EdgeInsets.only(
                  left: 5.0,
                  right: 10.0,
                  top: 2.5,
                ),
                child: SfCartesianChart(
                  plotAreaBorderWidth: 0,
                  primaryXAxis: NumericAxis(
                    title: AxisTitle(
                      text: 'HOUR',
                      textStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10),
                    ),
                    decimalPlaces: 0,
                    minimum: 0,
                    maximum: 24,
                    interval: 1,
                    majorGridLines: MajorGridLines(width: 0),
                    minorGridLines: MinorGridLines(width: 0),
                    majorTickLines: MajorTickLines(size: 0),
                    axisLine: AxisLine(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    axisLabelFormatter: (value) {
                      if (value.value % 2 == 1) {
                        return ChartAxisLabel(
                          value.value.toStringAsFixed(0),
                          TextStyle(
                            fontSize: 7.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return ChartAxisLabel(
                        '',
                        TextStyle(
                          fontSize: 7.0,
                        ),
                      );
                    },
                  ),
                  primaryYAxis: NumericAxis(
                    title: AxisTitle(
                        text: 'AI PRECISION PULSE READING',
                        textStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10)),
                    minimum: 50,
                    maximum: 200,
                    decimalPlaces: 0,
                    interval: 10,
                    majorGridLines: MajorGridLines(width: 0),
                    minorGridLines: MinorGridLines(width: 0),
                    majorTickLines: MajorTickLines(size: 0),
                    axisLine: AxisLine(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    axisLabelFormatter: (value) {
                      if (value.value % 50 == 0) {
                        return ChartAxisLabel(
                          value.value.toStringAsFixed(0),
                          TextStyle(
                            fontSize: 7.0,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return ChartAxisLabel(
                        '',
                        TextStyle(
                          fontSize: 7.0,
                        ),
                      );
                    },
                  ),
                  series: <CartesianSeries<MHistoryModel, double>>[
                    HiloSeries<MHistoryModel, double>(
                      dataSource: list,
                      showIndicationForSameValues: true,
                      xValueMapper: (MHistoryModel data, _) => data.getX,
                      highValueMapper: (MHistoryModel data, _) => data.getAISys,
                      lowValueMapper: (MHistoryModel data, _) => data.getAIDias,
                      color: HexColor.fromHex('#00AFAA'),
                      borderWidth: 0.75,
                      isVisibleInLegend: true,
                      legendItemText: 'Systolic / Diastolic',
                      markerSettings: MarkerSettings(
                        width: 1.0,
                        height: 1.0,
                        shape: DataMarkerType.circle,
                        isVisible: true,
                      ),
                    ),
                  ],
                  legend: Legend(
                    isVisible: true,
                    iconHeight: 8.0,
                    iconWidth: 8.0,
                    shouldAlwaysShowScrollbar: false,
                    itemPadding: 20.0,
                    position: LegendPosition.bottom,
                    overflowMode: LegendItemOverflowMode.wrap,
                    textStyle: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Body1AutoText(
                        text: list.isEmpty ? 'NA' : averageSys.toInt().toString(),
                        minFontSize: 8,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        align: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Body1AutoText(
                        text: 'Average Systolic',
                        minFontSize: 8,
                        fontSize: 12.sp,
                        align: TextAlign.center,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Body1AutoText(
                        text: list.isEmpty ? 'NA' : averageDias.toInt().toString(),
                        minFontSize: 8,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        align: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Body1AutoText(
                        text: 'Average Diastolic',
                        minFontSize: 8,
                        fontSize: 12.sp,
                        align: TextAlign.center,
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        if (isWeek) ...[
          Container(
            height: 310,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A').withOpacity(0.85)
                  : AppColor.backgroundColor.withOpacity(0.85),
              borderRadius: BorderRadius.circular(10.h),
            ),
            margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          ),
          Body1AutoText(
            text: 'Coming soon ...',
            minFontSize: 8.sp,
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            align: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
