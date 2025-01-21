import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';

import '../../../utils/gloabals.dart';

class BPAreaGraph extends StatefulWidget {
  BPAreaGraph({
    required this.list,
    required this.startDate,
    required this.endDate,
    required this.isDay,
    required this.isWeek,
    super.key,
  }) {
    if (list.isNotEmpty) {
      selectedModel = list.first;
      selectedIndex.add(0);
    }
  }

  final List<MHistoryModel> list;
  final DateTime startDate;
  final DateTime endDate;
  final bool isDay;
  final bool isWeek;

  MHistoryModel? selectedModel;
  List<int> selectedIndex = [];

  @override
  State<BPAreaGraph> createState() => _BPAreaGraphState();
}

class _BPAreaGraphState extends State<BPAreaGraph> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMyTablet ? 420 : 342.5,
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
          Body1AutoText(
            text: 'AI PrecisionPulse Blood Pressure',
            minFontSize: 8,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            align: TextAlign.center,
          ),
          Container(
            height: isMyTablet ? 315 : 265,
            padding: EdgeInsets.only(
              left: 5.0,
              right: 10.0,
              top: 2.5,
            ),
            child: Center(
              child: SfCartesianChart(
                primaryXAxis: NumericAxis(
                  title: AxisTitle(
                      text: 'DIASTOLIC READING',
                      textStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10)),
                  decimalPlaces: 0,
                  minimum: 40,
                  maximum: 120,
                  interval: 10,
                  majorGridLines: MajorGridLines(width: 0),
                  minorGridLines: MinorGridLines(width: 0),
                  majorTickLines: MajorTickLines(size: 0),
                  axisLine: AxisLine(
                    width: 2.0,
                  ),
                  axisLabelFormatter: (value) {
                    if (value.value == 60 ||
                        value.value == 80 ||
                        value.value == 90 ||
                        value.value == 100 ||
                        value.value == 120) {
                      return ChartAxisLabel(
                        value.value.toStringAsFixed(0),
                        TextStyle(
                          fontSize: 8.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return ChartAxisLabel(
                      '',
                      TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                      text: 'SYSTOLIC READING',
                      textStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10)),
                  minimum: 40,
                  maximum: 180,
                  decimalPlaces: 0,
                  interval: 10,
                  majorGridLines: MajorGridLines(width: 0),
                  minorGridLines: MinorGridLines(width: 0),
                  majorTickLines: MajorTickLines(size: 0),
                  axisLine: AxisLine(
                    width: 1.0,
                  ),
                  axisLabelFormatter: (value) {
                    if (value.value == 40 ||
                        value.value == 90 ||
                        value.value == 120 ||
                        value.value == 140 ||
                        value.value == 160 ||
                        value.value == 180) {
                      return ChartAxisLabel(
                        value.value.toStringAsFixed(0),
                        TextStyle(
                          fontSize: 8.0,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return ChartAxisLabel(
                      '',
                      TextStyle(
                        fontSize: 8.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                series: <ChartSeries>[
                  AreaSeries<BloodPressureData, num>(
                    dataSource: [
                      BloodPressureData(40, 180),
                      BloodPressureData(120, 180),
                    ],
                    xValueMapper: (BloodPressureData data, _) => data.systolic,
                    yValueMapper: (BloodPressureData data, _) => data.diastolic,
                    color: HexColor.fromHex('#9F2DBC'),
                    legendItemText: 'Hyper (Stage 2)',
                  ),
                  AreaSeries<BloodPressureData, num>(
                    dataSource: [
                      BloodPressureData(40, 160),
                      BloodPressureData(100, 160),
                    ],
                    xValueMapper: (BloodPressureData data, _) => data.systolic,
                    yValueMapper: (BloodPressureData data, _) => data.diastolic,
                    color: HexColor.fromHex('#BD78CE'),
                    legendItemText: 'Hyper (Stage 1)',
                  ),
                  AreaSeries<BloodPressureData, num>(
                    dataSource: [
                      BloodPressureData(40, 140),
                      BloodPressureData(90, 140),
                    ],
                    xValueMapper: (BloodPressureData data, _) => data.systolic,
                    yValueMapper: (BloodPressureData data, _) => data.diastolic,
                    color: HexColor.fromHex('#D3A5DF'),
                    legendItemText: 'Hyper',
                  ),
                  AreaSeries<BloodPressureData, num>(
                    dataSource: [
                      BloodPressureData(40, 120),
                      BloodPressureData(80, 120),
                    ],
                    xValueMapper: (BloodPressureData data, _) => data.systolic,
                    yValueMapper: (BloodPressureData data, _) => data.diastolic,
                    color: HexColor.fromHex('#00AFAA'),
                    legendItemText: 'Ideal',
                  ),
                  AreaSeries<BloodPressureData, num>(
                    dataSource: [
                      BloodPressureData(40, 90),
                      BloodPressureData(60, 90),
                    ],
                    xValueMapper: (BloodPressureData data, _) => data.systolic,
                    yValueMapper: (BloodPressureData data, _) => data.diastolic,
                    color: HexColor.fromHex('#99D9D9'),
                    legendItemText: 'Low',
                  ),
                  ScatterSeries<MHistoryModel, num>(
                    dataSource: widget.list,
                    xValueMapper: (MHistoryModel data, _) => data.getAIDias,
                    yValueMapper: (MHistoryModel data, _) => data.getAISys,
                    pointColorMapper: (MHistoryModel data, _) =>
                        data.getX == widget.selectedModel?.getX ? Colors.yellow : Colors.red,
                    color: Colors.red,
                    markerSettings: MarkerSettings(
                      isVisible: true,
                      height: 6.0,
                      width: 6.0,
                    ),
                    selectionBehavior: SelectionBehavior(
                      enable: true,
                      selectedOpacity: 1,
                      unselectedOpacity: 1,
                      selectionController: RangeController(
                        start: 0,
                        end: widget.list,
                      ),
                    ),
                    initialSelectedDataIndexes: widget.selectedIndex,
                    isVisibleInLegend: true,
                    legendItemText: 'Systolic - Diastolic',
                  ),
                ],
                legend: Legend(
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
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                splashColor: Colors.transparent,
                icon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/dark_left.png'
                      : 'asset/left.png',
                  height: 12,
                  width: 12,
                ),
                onPressed: () {
                  var index = widget.selectedIndex.first;
                  widget.selectedIndex.clear();
                  if (index == 0) {
                    index = widget.list.length;
                  }
                  index -= 1;
                  widget.selectedModel = widget.list.elementAt(index);
                  widget.selectedIndex.add(index);
                  setState(() {});
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow,
                      ),
                      height: 7,
                      width: 7,
                    ),
                    SizedBox(
                      width: 7.5,
                    ),
                    Body1AutoText(
                      text:
                          '${widget.selectedModel?.getAISys.toStringAsFixed(0) ?? 'NA'} / ${widget.selectedModel?.getAIDias.toStringAsFixed(0) ?? 'NA'}',
                      minFontSize: 8,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      align: TextAlign.center,
                    ),
                    Body1AutoText(
                      text: ' mmHg',
                      minFontSize: 8,
                      fontSize: 10.sp,
                      align: TextAlign.center,
                    ),
                  ],
                ),
              ),
              IconButton(
                splashColor: Colors.transparent,
                icon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/dark_right.png'
                      : 'asset/right.png',
                  height: 12,
                  width: 12,
                ),
                onPressed: () {
                  var index = widget.selectedIndex.first;
                  widget.selectedIndex.clear();
                  if (index == widget.list.length - 1) {
                    index = -1;
                  }
                  index += 1;
                  widget.selectedModel = widget.list.elementAt(index);
                  widget.selectedIndex.add(index);
                  setState(() {});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BloodPressureData {
  final num systolic;
  final num diastolic;

  BloodPressureData(this.systolic, this.diastolic);
}
