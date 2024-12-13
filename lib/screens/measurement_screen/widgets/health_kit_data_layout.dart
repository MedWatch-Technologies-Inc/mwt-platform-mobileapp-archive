import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/measurement/ecg_info_reading_model.dart';
import 'package:health_gauge/models/measurement/health_kit_model.dart';
import 'package:health_gauge/screens/measurement_screen/cards/bp_card.dart';
import 'package:health_gauge/screens/measurement_screen/cards/health_kit_measurement_card.dart';
import 'package:health_gauge/utils/app_utils.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../measurement_screen.dart';
class HealthKitDataLayout extends StatelessWidget {
  final List<HealthKitModel> sysList;
  final List<HealthKitModel> diaList;
  final List<HealthKitModel> hrList;
  final List<HealthKitModel> hrvList;
  final EcgInfoReadingModel? ecgInfoModel;
  final Widget lineChartWidgetForHr;
  final Widget lineChartWidgetForBp;
  final Widget lineChartWidgetForHrv;
  final IosDeviceInfo? iosInfo;
  final ecgPointList;
  final ValueNotifier<List<Entry>> valuesForEcgGraph;
  final ValueNotifier<int> ecgLength;
  final ValueNotifier<int> measurementType;
  final ValueNotifier<num> zoomLevelECG;
  final controllerForEcgGraph;
  final Function setZoom;
  const HealthKitDataLayout(
      {Key? key,
      required this.sysList,
      required this.diaList,
      required this.hrList,
      required this.hrvList,
        required this.ecgInfoModel,
      required this.lineChartWidgetForHr,
      required this.lineChartWidgetForBp,
      required this.lineChartWidgetForHrv,
        required this.iosInfo,
        required this.ecgPointList,
      required this.valuesForEcgGraph,
      required this.ecgLength,
      required this.measurementType,
      required this.zoomLevelECG,
        required  this.controllerForEcgGraph,
      required this.setZoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<HealthKitModel> sysList = [];
    // List<HealthKitModel> diaList = [];
    // List<HealthKitModel> hrList = [];
    // List<HealthKitModel> hrvList = [];
    // List<MeasurementValue> sysList1 = [];
    // List<MeasurementValue> diaList1 = [];
    // List<MeasurementValue> hrList1 = [];
    // List<MeasurementValue> hrvList1 = [];
    // generateSampleDataAndGraph() async {
    //   sysList = [];
    //   diaList = [];
    //   hrList = [];
    //   hrvList = [];
    //   sysList1 = [];
    //   diaList1 = [];
    //   hrList1 = [];
    //   hrvList1 = [];
    //   await getDataFromHealthKitForGraph();
    //
    //   lineChartSeriesForHr = generateLineChartData(field: 'HR');
    //   lineChartSeriesForBp = generateLineChartData(field: 'BP');
    //   lineChartSeriesForHrv = generateLineChartData(field: 'Hrv');
    //   lineChartWidgetForHr = generateLineChart(lineChartSeriesForHr, 'HR');
    //   lineChartWidgetForBp = generateLineChart(lineChartSeriesForBp, 'BP');
    //   lineChartWidgetForHrv = generateLineChart(lineChartSeriesForHrv, 'Hrv');
    //
    //   debugPrint('Generated data');
    //
    //   Future.delayed(Duration(milliseconds: 100)).then((value) {
    //     if (mounted) {
    //       setState(() {});
    //     }
    //   });
    // }
    //
    // getDataFromHealthKitForGraph() async {
    //   var endDate = DateTime.now();
    //   var startDate = DateTime(endDate.year, endDate.month - 1, endDate.day);
    //   final formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
    //   List? data1 = await connections
    //       .readDiastolicBloodPressureDataFromHealthKitOrGoogleFit(
    //       formatter.format(startDate), formatter.format(endDate));
    //   List? data2 =
    //   await connections.readSystolicBloodPressureDataFromHealthKitOrGoogleFit(
    //       formatter.format(startDate), formatter.format(endDate));
    //   List? data3 = await connections.readHeartRateDataFromHealthKitOrGoogleFit(
    //       formatter.format(startDate), formatter.format(endDate));
    //   List? data4 = await connections.readHRVDataFromHealthKitOrGoogleFit(
    //       formatter.format(startDate), formatter.format(endDate));
    //   ecgInfoModel = EcgInfoReadingModel();
    //   if (data3.isNotEmpty) {
    //     ecgInfoModel?.approxHr =
    //     ((double.tryParse(data3.last['value']) ?? 0).toInt());
    //   } else {
    //     ecgInfoModel?.approxHr = 0;
    //   }
    //
    //   if (data4.isNotEmpty) {
    //     ecgInfoModel?.hrv = ((double.tryParse(data4.last['value']) ?? 0).toInt());
    //   } else {
    //     ecgInfoModel?.hrv = 0;
    //   }
    //   if (AppUtils().iOSVersionCompare(iosInfo?.systemVersion)) {
    //     Map? ecgData = await connections.readBodyEcgDataFromHealthKitOrGoogleFit(
    //         formatter.format(startDate), formatter.format(endDate));
    //     if (ecgData != null) {
    //       ecgPointList = ecgData['ecgList'];
    //       if (ecgPointList != null && ecgPointList.length > 0) {
    //         valuesForEcgGraph.value.clear();
    //         if (controllerForEcgGraph == null) {
    //           initGraphControllers();
    //         }
    //         for (var i = 0; i < ecgPointList.length; i++) {
    //           ecgValueX = i + 0.0;
    //
    //           var entry = Entry(
    //             x: ecgValueX,
    //             y: ecgPointList[i],
    //           );
    //           valuesForEcgGraph.value.add(entry);
    //         }
    //
    //         ecgInfoModel?.hrv = getHrvFromEcg(valuesForEcgGraph.value);
    //         ecgInfoModel?.approxHr = ecgData['hrValue'];
    //
    //         setDataToEcgGraph();
    //
    //         Future.delayed(Duration(milliseconds: 500)).then((value) {
    //           try {
    //             controllerForEcgGraph?.setVisibleXRangeMaximum(1200);
    //             controllerForEcgGraph?.setVisibleXRangeMinimum(1200);
    //             setState(() {});
    //           } catch (e) {
    //             debugPrint('Exception at measurement screen $e');
    //           }
    //         });
    //         setGraphColors();
    //       }
    //     }
    //   }
    //
    //   if (data2.isNotEmpty) {
    //     sysList = data2.map((e) => HealthKitModel.fromMap(e)).toList();
    //     sysList1 = [];
    //   } else {
    //     sysList = [];
    //     sysList1 = [];
    //   }
    //   if (data1.isNotEmpty) {
    //     diaList = data1.map((e) => HealthKitModel.fromMap(e)).toList();
    //     diaList1 = [];
    //   } else {
    //     diaList = [];
    //     diaList1 = [];
    //   }
    //   if (data3.isNotEmpty) {
    //     hrList = data3.map((e) => HealthKitModel.fromMap(e)).toList();
    //     hrList1 = [];
    //   } else {
    //     hrList = [];
    //     hrList1 = [];
    //   }
    //   if (data4.isNotEmpty) {
    //     hrvList = data4.map((e) => HealthKitModel.fromMap(e)).toList();
    //     hrvList1 = [];
    //   } else {
    //     hrvList = [];
    //     hrvList1 = [];
    //   }
    //
    //   var days = <DateTime>[];
    //   for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
    //     days.add(startDate.add(Duration(days: i)));
    //   }
    //   sysList1 = [];
    //   diaList1 = [];
    //   hrvList1 = [];
    //   hrList1 = [];
    //   var i = 0;
    //   for (var date in days) {
    //     var sysRes = sysList.where((element) {
    //       var sysDate = DateTime.tryParse(element.endTime ?? '');
    //       if (sysDate?.month == date.month && sysDate?.day == date.day) {
    //         return true;
    //       }
    //       return false;
    //     }).toList();
    //     var diaRes = diaList.where((element) {
    //       var sysDate = DateTime.tryParse(element.endTime ?? '');
    //       if (sysDate?.month == date.month && sysDate?.day == date.day) {
    //         return true;
    //       }
    //       return false;
    //     }).toList();
    //     var hrRes = hrList.where((element) {
    //       var sysDate = DateTime.tryParse(element.endTime ?? '');
    //       if (sysDate?.month == date.month && sysDate?.day == date.day) {
    //         return true;
    //       }
    //       return false;
    //     }).toList();
    //     var hrvRes = hrvList.where((element) {
    //       var sysDate = DateTime.tryParse(element.endTime ?? '');
    //       if (sysDate?.month == date.month && sysDate?.day == date.day) {
    //         return true;
    //       }
    //       return false;
    //     }).toList();
    //     num sysSum = 0;
    //     num diaSum = 0;
    //     num hrSum = 0;
    //     num hrvSum = 0;
    //     if (sysRes.isNotEmpty) {
    //       sysRes.forEach((element) {
    //         sysSum += double.tryParse(element.value ?? '') ?? 0;
    //       });
    //       sysSum = sysSum / sysRes.length;
    //     }
    //     if (diaRes.isNotEmpty) {
    //       diaRes.forEach((element) {
    //         diaSum += double.tryParse(element.value ?? '') ?? 0;
    //       });
    //       diaSum = diaSum / diaRes.length;
    //     }
    //     if (hrRes.isNotEmpty) {
    //       hrRes.forEach((element) {
    //         hrSum += double.tryParse(element.value ?? '') ?? 0;
    //       });
    //       hrSum = hrSum / hrRes.length;
    //     }
    //     if (hrvRes.isNotEmpty) {
    //       hrvRes.forEach((element) {
    //         hrvSum += double.tryParse(element.value ?? '') ?? 0;
    //       });
    //       hrvSum = hrvSum / hrvRes.length;
    //     }
    //     sysList1.add(MeasurementValue(
    //       xValue: i.toDouble(),
    //       xAxis: date.day.toString() + '/' + date.month.toString(),
    //       yValue: sysSum.toDouble(),
    //     ));
    //     diaList1.add(MeasurementValue(
    //       xValue: i.toDouble(),
    //       xAxis: date.day.toString() + '/' + date.month.toString(),
    //       yValue: diaSum.toDouble(),
    //     ));
    //     hrList1
    //       ..add(MeasurementValue(
    //         xValue: i.toDouble(),
    //         xAxis: date.day.toString() + '/' + date.month.toString(),
    //         yValue: hrSum.toDouble(),
    //       ));
    //     hrvList1.add(MeasurementValue(
    //       xValue: i.toDouble(),
    //       xAxis: date.day.toString() + '/' + date.month.toString(),
    //       yValue: hrvSum.toDouble(),
    //     ));
    //     i++;
    //   }
    //
    //   setState(() {});
    // }
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      shrinkWrap: true,
      children: <Widget>[
        HealthKitMeasurementCard(
            sysList: sysList,
            diaList: diaList,
            hrList: hrList,
            hrvList: hrvList,
            ecgInfoModel: ecgInfoModel),
        BPCard(
            sysList: sysList,
            diaList: diaList,
            hrList: hrList,
            hrvList: hrvList,
            lineChartWidgetForHr: lineChartWidgetForHr,
            lineChartWidgetForBp: lineChartWidgetForBp,
            lineChartWidgetForHrv: lineChartWidgetForHrv,
            iosInfo: iosInfo,
            ecgPointList: ecgPointList,
            valuesForEcgGraph: valuesForEcgGraph,
            ecgLength: ecgLength,
            measurementType: measurementType,
            zoomLevelECG: zoomLevelECG,
            controllerForEcgGraph: controllerForEcgGraph,
            setZoom: setZoom)
      ],
    );
  }
}
