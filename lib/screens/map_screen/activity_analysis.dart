import 'dart:math';

import 'package:charts_flutter/flutter.dart' as chart;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/model/activity_model.dart';
import 'package:health_gauge/screens/map_screen/providers/history_detail_provider.dart';
import 'package:health_gauge/services/location/model/location_model.dart';
import 'package:health_gauge/utils/calculate_activity_items.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:provider/provider.dart';

import 'model/pie_data.dart';

class ValueGraph {
  double? xValue;
  double? yValue;
  String? xAxis;

  ValueGraph({this.xValue, this.yValue, this.xAxis});
}

class ActivityAnalysis extends StatefulWidget {
  final ActivityModel? model;

  ActivityAnalysis(this.model, {Key? key}) : super(key: key);

  @override
  _ActivityAnalysisState createState() => _ActivityAnalysisState();
}

class _ActivityAnalysisState extends State<ActivityAnalysis> {
  double posx = 27.w;
  double posy = 27.w;
  LineChartController? controllerForPaceGraph;
  LineChartController? controllerForElevationGraph;
  List<chart.Series<ValueGraph, num>> lineChartSeriesForPace = [];
  List<chart.Series<ValueGraph, num>> lineChartSeriesForElevation = [];
  List<ValueGraph>? hrList = [];
  List<ValueGraph>? speedList = [];
  List<ValueGraph>? elevationList = [];
  Widget lineChartWidgetForPace = Container(
    width: double.infinity,
    child: Center(child: Text('No chart Available')),
  );
  Widget lineChartWidgetForElevation = Container(
    width: double.infinity,
    child: Center(child: Text('No chart Available')),
  );
  CalculateActivityItems activityItems = CalculateActivityItems();
  int lastIndex = 0;
  double hr1 = 0;
  double hr2 = 0;
  double pace = 0;
  double maxHr = 0;
  double avgHr = 0;
  double elevation = 0;
  String distance = '0 km';
  BitmapDescriptor? customIcon;
  List<Data> pieData = [];

  double tempDomain = 0.0;
  AppImages images = AppImages();

  bool isDarkMode() => Theme.of(context).brightness == Brightness.dark;

  String _formatterXAxis(num? year) {
    try {
      var value = year!.toInt();
      if (hrList != null && hrList!.isNotEmpty) {
        var time =
            DateTime.fromMillisecondsSinceEpoch(widget.model!.startTime!);
        return '${time.hour}:${time.minute + value}';
      }
      if (value % 10 == 0) {
        var time = DateTime.fromMillisecondsSinceEpoch(
            widget.model!.locationList![value].time!.toInt());
        return getFormatString(time.hour, time.minute, time.second);
        return '${time.hour}:${time.minute}:${time.second}';
        // return value.toString();
        return '';
      }
      return '';
    } catch (e) {
      return '';
    }
    // return '';
  }

  String getFormatString(int hour, int minute, int second) {
    var res = '$hour:';
    if (minute < 9) {
      res += '0$minute:';
    } else {
      res += '$minute:';
    }
    if (second < 9) {
      res += '0$second';
    } else {
      res += '$second';
    }
    return res;
  }

  void _onSliderChange2(Point<int> point, dynamic domain, String roleId,
      chart.SliderListenerDragState dragState) {
    // Request a build.
    void rebuild(_) {
      if (mounted) {
        if (speedList != null && domain.toInt() < speedList!.length) {
          // pace = (speedList![domain.toInt()].yValue! * 3.6).roundToDouble();
          pace = speedList![domain.toInt()].yValue!;
          hr1 = hrList!.isNotEmpty ? hrList![domain.toInt()].yValue! : 0;
          hr2 = hrList!.isNotEmpty ? hrList![domain.toInt()].yValue! : 0;
          if (hrList != null && hrList!.isNotEmpty) {
            var lD = <LocationAddressModel>[];
            for (var i = 0; i < widget.model!.heartRateModel!.length; i++) {
              lD.add(widget.model!.heartRateModel![i].locationData!);
            }
            distance = activityItems.getDistance(lD.sublist(0, domain.toInt()));
          } else {
            distance = activityItems.getDistance(
                widget.model!.locationList!.sublist(0, domain.toInt()));
          }
          elevation = double.parse(
              elevationList![domain.toInt()].yValue!.toStringAsFixed(2));
          var provider =
              Provider.of<HistoryDetailProvider>(context, listen: false);
          provider.currentPosition = LatLng(
              widget.model!.locationList![domain.toInt()].latitude!,
              widget.model!.locationList![domain.toInt()].longitude!);
          // provider.currentDateTime = DateTime.fromMillisecondsSinceEpoch(widget.model.locationList[domain.toInt()].time.toInt());
          var size = MediaQuery.of(context).size.width;
          if (point.x.toDouble() < size / 2) {
            posx = point.x.toDouble();
            setState(() {});
          } else {
            setState(() {});
          }
        }
      }
    }

    SchedulerBinding.instance!.addPostFrameCallback(rebuild);
  }

  Widget generateLineChartForSpeed(
      List<chart.Series<ValueGraph, num>> lineChartSeries, String field) {
    if (hrList != null && hrList!.isNotEmpty) {
      lineChartSeries[1]
        ..setAttribute(
          chart.measureAxisIdKey,
          chart.Axis.secondaryMeasureAxisId,
        );
    }

    return chart.LineChart(
      lineChartSeries,
      animate: false,
      customSeriesRenderers: List.generate(2, (index) {
        return chart.LineRendererConfig(
          customRendererId: field + '$index',
          includeArea: true,
          stacked: true,
          includePoints: false,
          includeLine: true,
          roundEndCaps: true,
          radiusPx: 2.0,
          strokeWidthPx: 1.0,
        );
      }),
      primaryMeasureAxis: chart.NumericAxisSpec(
        renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: isDarkMode()
                    ? chart.ColorUtil.fromDartColor(AppColor.white38)
                    : chart.ColorUtil.fromDartColor(AppColor.color7F8D8C)),
            lineStyle: chart.LineStyleSpec(
                dashPattern: [2, 2],
                color: isDarkMode()
                    ? chart.ColorUtil.fromDartColor(
                        Colors.white.withOpacity(0.4))
                    : chart.ColorUtil.fromDartColor(Color(0xffA7B2AF)))),
        tickProviderSpec: chart.BasicNumericTickProviderSpec(
            desiredTickCount: 6, zeroBound: false),
      ),
      secondaryMeasureAxis: chart.NumericAxisSpec(
        renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: chart.ColorUtil.fromDartColor(AppColor.colorFF6259)
                // color: isDarkMode()
                //     ? chart.MaterialPalette.white
                //     : chart.MaterialPalette.black
                ),
            lineStyle: chart.LineStyleSpec(
              color: chart.ColorUtil.fromDartColor(Colors.transparent),
            )),
        tickProviderSpec: chart.BasicNumericTickProviderSpec(
          desiredTickCount: 6,
          zeroBound: false,
        ),
      ),
      domainAxis: chart.NumericAxisSpec(
        tickProviderSpec: chart.BasicNumericTickProviderSpec(
          zeroBound: true,
          desiredTickCount:
              hrList != null && hrList!.length < 5 ? hrList!.length : 5,
        ),
        showAxisLine: false,
        tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
          _formatterXAxis,
        ),
        renderSpec: chart.GridlineRendererSpec(
          tickLengthPx: 0,
          labelOffsetFromAxisPx: 10,
          labelStyle: chart.TextStyleSpec(
              fontSize: 10,
              color: isDarkMode()
                  ? chart.ColorUtil.fromDartColor(AppColor.white87)
                  : chart.ColorUtil.fromDartColor(AppColor.color384341)),
          lineStyle: chart.LineStyleSpec(
            thickness: 0,
            color: chart.ColorUtil.fromDartColor(Colors.transparent),
          ),
        ),
        viewport: chart.NumericExtents(
            0,
            hrList != null && hrList!.isNotEmpty
                ? hrList!.length
                : speedList!.length < 10
                    ? 1
                    : 0.2 * speedList!.length),
      ),
      behaviors: [
        // new chart.Slider(
        //     initialDomainValue: 1.0,
        //     onChangeCallback: _onSliderChange2,
        //     style: chart.SliderStyle(
        //       fillColor: chart.ColorUtil.fromDartColor(Color(0xffcc0a00)),
        //       strokeColor: chart.ColorUtil.fromDartColor(Color(0xffcc0a00)),
        //       handleSize: Rectangle<int>(0, 0, 20, 20),
        //     )),
        chartSlider(),
        chart.SlidingViewport(),
        chart.PanAndZoomBehavior(),
      ],
    );
  }

  chart.ChartBehavior<num> chartSlider() {
    return chart.Slider(
      initialDomainValue: 0.0,
      onChangeCallback: _onSliderChange2,
      style: chart.SliderStyle(
        fillColor: chart.ColorUtil.fromDartColor(Color(0xffcc0a00)),
        strokeColor: chart.ColorUtil.fromDartColor(Color(0xffcc0a00)),
        handleSize: Rectangle<int>(0, 0, 20, 20),
      ),
      handleRenderer: chart.CircleSymbolRenderer(),
    );
  }

  chart.LineChart generateLineChartForElevation(
      List<chart.Series<ValueGraph, num>> lineChartSeries, String field) {
    if (hrList != null && hrList!.isNotEmpty) {
      lineChartSeries[1]
        ..setAttribute(
          chart.measureAxisIdKey,
          chart.Axis.secondaryMeasureAxisId,
        );
    }
    return chart.LineChart(
      lineChartSeries,
      animate: false,
      customSeriesRenderers: List.generate(2, (index) {
        return chart.LineRendererConfig(
          customRendererId: '$field$index',
          includeArea: true,
          stacked: true,
          includePoints: false,
          includeLine: true,
          roundEndCaps: true,
          radiusPx: 2.0,
          strokeWidthPx: 1.0,
        );
      }),
      primaryMeasureAxis: chart.NumericAxisSpec(
        renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
                fontWeight: 'bold',
                fontSize: 10,
                color: isDarkMode()
                    ? chart.ColorUtil.fromDartColor(AppColor.colorBD78CE)
                    : chart.ColorUtil.fromDartColor(AppColor.color9F2DBC)),
            lineStyle: chart.LineStyleSpec(
                dashPattern: [2, 2],
                color: isDarkMode()
                    ? chart.ColorUtil.fromDartColor(
                        Colors.white.withOpacity(0.4))
                    : chart.ColorUtil.fromDartColor(Color(0xffA7B2AF)))),
        tickProviderSpec: chart.BasicNumericTickProviderSpec(
            desiredTickCount: 6, zeroBound: false),
      ),
      secondaryMeasureAxis: chart.NumericAxisSpec(
        renderSpec: chart.GridlineRendererSpec(
            labelStyle: chart.TextStyleSpec(
                fontSize: 10,
                color: chart.ColorUtil.fromDartColor(AppColor.colorFF6259)
                // color: isDarkMode()
                //     ? chart.MaterialPalette.white
                //     : chart.MaterialPalette.black
                ),
            lineStyle: chart.LineStyleSpec(
                color: chart.ColorUtil.fromDartColor(Colors.transparent))),
        tickProviderSpec: chart.BasicNumericTickProviderSpec(
          desiredTickCount: 6,
          zeroBound: false,
        ),
      ),
      domainAxis: chart.NumericAxisSpec(
        tickProviderSpec: chart.BasicNumericTickProviderSpec(
          zeroBound: true,
          desiredTickCount: 5,
        ),
        tickFormatterSpec: chart.BasicNumericTickFormatterSpec(
          _formatterXAxis,
        ),
        renderSpec: chart.GridlineRendererSpec(
          tickLengthPx: 0,
          labelOffsetFromAxisPx: 10,
          labelStyle: chart.TextStyleSpec(
              fontSize: 10,
              color: isDarkMode()
                  ? chart.ColorUtil.fromDartColor(AppColor.white87)
                  : chart.ColorUtil.fromDartColor(AppColor.color384341)),
          lineStyle: chart.LineStyleSpec(
            thickness: 0,
            color: chart.ColorUtil.fromDartColor(Colors.transparent),
          ),
        ),
        viewport: chart.NumericExtents(
            0,
            hrList != null && hrList!.isNotEmpty
                ? hrList!.length
                : speedList!.length < 10
                    ? speedList!.length
                    : speedList!.length * 0.2),
      ),
      behaviors: [
        chartSlider(),
        chart.SlidingViewport(),
        chart.PanAndZoomBehavior(),
      ],
    );
  }

  List<chart.Series<ValueGraph, num>> generateLineChartData({String? field}) {
    var graphList = <List<ValueGraph>>[];
    if (field == 'Pace') {
      graphList.add(speedList!);
      graphList.add(hrList!);
    } else {
      graphList.add(elevationList!);
      graphList.add(hrList!);
    }

    return List.generate(graphList.length, (index) {
      var colorCode = '#009C92';
      if (index == 1) {
        colorCode = '#ff6259';
      } else {
        if (field == 'Elevation') {
          colorCode = isDarkMode() ? '#BD78CE' : '#9F2DBC';
        } else if (field == 'Pace') {
          colorCode = isDarkMode() ? '#7F8DBC' : '#7F8D8C';
        }
      }
      if (colorCode.length > 4 && colorCode[3] == 'f' && colorCode[4] == 'f') {
        colorCode = colorCode.replaceRange(3, 5, '');
      }
      var materialColor = HexColor.fromHex(colorCode);

      return chart.Series<ValueGraph, double>(
        id: '${field!}$index',
        colorFn: (ValueGraph data, __) => chart.Color(
            a: materialColor.alpha,
            r: materialColor.red,
            g: materialColor.green,
            b: materialColor.blue),
        // (typeModel.fieldName == "step" && data.xValue > 8) ? chart.Color(a: Colors.green.alpha, r: Colors.green.red, g: Colors.green.green, b: Colors.green.blue)  : chart.Color(a: materialColor.alpha, r: materialColor.red, g: materialColor.green, b: materialColor.blue),
        domainFn: (ValueGraph data, _) => data.xValue!,
        measureFn: (ValueGraph data, _) => data.yValue,
        data: graphList[index],
      )..setAttribute(chart.rendererIdKey, '$field$index');
    });
  }

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(12, 12)), images.ellipseIcon)
        .then((d) {
      customIcon = d;
    });
    Future.delayed(Duration(milliseconds: 500), getSampleDataAndMakeGraph);
    // getSampleDataAndMakeGraph();
  }

  void getSampleDataAndMakeGraph() async {
    var endDate = DateTime.now();
    var rnd = Random();
    var n = 30;
    // for (int i = 0; i <= n; i++) {
    //   speedList.add(ValueGraph(
    //     yValue: (12 + rnd.nextInt(15 - 12)).toDouble(),
    //     xValue: i.toDouble(),
    //   ));
    //   elevationList.add(ValueGraph(
    //     yValue: (600 + rnd.nextInt(630 - 600)).toDouble(),
    //     xValue: i.toDouble(),
    //   ));
    //   hrList.add(ValueGraph(
    //     yValue: (50 + rnd.nextInt(120 - 50)).toDouble(),
    //     xValue: i.toDouble(),
    //   ));
    // }
    var allData = await dbHelper.getMeasurementDataForWorkout(
        globalUser!.userId!,
        widget.model!.startTime.toString(),
        widget.model!.endTime.toString());
    if (widget.model != null &&
        widget.model!.heartRateModel != null &&
        widget.model!.heartRateModel!.isNotEmpty) {
      for (var i = 0; i < widget.model!.heartRateModel!.length; i++) {
        var item = widget.model!.heartRateModel![i];
        speedList!.add(ValueGraph(
            yValue: item.speed == null ? 0 : item.speed, xValue: i.toDouble()));
        elevationList!.add(ValueGraph(
          yValue: double.parse(item.elevation == null
              ? 0.toStringAsFixed(2)
              : item.elevation!.toStringAsFixed(2)),
          xValue: i.toDouble(),
        ));
        hrList!.add(ValueGraph(
          xValue: i.toDouble(),
          yValue: item.hr == null ? 0 : item.hr!.toDouble(),
        ));
      }
    } else {
      // int j = 0;
      // int i=0;
      // while (j < widget.model.locationList.length){
      //   var item = widget.model.locationList[j];
      //   DateTime dt = DateTime.fromMillisecondsSinceEpoch(item.time.toInt());
      //   List<LocationData> ld = [];
      //   ld = widget.model.locationList.where((element){
      //     var it = DateTime.fromMillisecondsSinceEpoch(element.time.toInt());
      //     if(it.minute == dt.minute && it.hour == dt.hour){
      //       return true;
      //     }
      //     return false;
      //   }).toList();
      //   double avgSpeed = 0;
      //   double avgElevation = 0;
      //   int count = 0;
      //   if(ld != null && ld.isNotEmpty){
      //     ld.forEach((element) {
      //       if(element.speed > 0 && element.altitude > 0){
      //         count++;
      //         avgSpeed += element.speed;
      //         avgElevation += element.altitude;
      //       }
      //     });
      //     avgSpeed = avgSpeed == 0 ? 0 : avgSpeed / count;
      //     avgElevation = avgElevation == 0 ? 0 : avgElevation / count;
      //   }
      //   speedList.add(ValueGraph(
      //     yValue: avgSpeed,
      //     xValue: i.toDouble(),
      //   ));
      //   elevationList.add(ValueGraph(
      //     yValue: avgElevation,
      //     xValue: i.toDouble(),
      //   ));
      //   i++;
      //   j = j + ld.length;
      // }
      for (var i = 0; i < widget.model!.locationList!.length; i++) {
        var item = widget.model!.locationList![i];
        speedList!.add(ValueGraph(
          yValue: item.speed! < 0
              ? 0
              : double.parse(item.speed!.toStringAsFixed(2)),
          xValue: i.toDouble(),
        ));
        elevationList!.add(ValueGraph(
          yValue: double.parse(item.altitude!.toStringAsFixed(2)),
          xValue: i.toDouble(),
        ));
        // hrList.add(ValueGraph(
        //   yValue: (72 + rnd.nextInt(185 - 72)).toDouble(),
        //   xValue: i.toDouble(),
        // ));
      }
      hrList = [];
    }

    // hr between 0 - 109
    var val = hrList!
        .where((element) => element.yValue! < 109 && element.yValue! >= 0)
        .toList();
    double zoneOnePercent;
    if (hrList!.isNotEmpty) {
      zoneOnePercent = ((val.length / hrList!.length) * 100);
    } else {
      zoneOnePercent = 0;
    }
    pieData.add(Data(
        name: 'Zone 1', percent: zoneOnePercent, color: AppColor.colorFFDFDE));
    // hr between 109 - 144
    val = hrList!
        .where((element) => element.yValue! < 144 && element.yValue! >= 109)
        .toList();
    double zoneTwoPercent;
    if (hrList!.isNotEmpty) {
      zoneTwoPercent = ((val.length / hrList!.length) * 100);
    } else {
      zoneTwoPercent = 0;
    }
    pieData.add(Data(
        name: 'Zone 2', percent: zoneTwoPercent, color: AppColor.colorFF9E99));
    // hr between 144 - 161
    val = hrList!
        .where((element) => element.yValue! < 161 && element.yValue! >= 144)
        .toList();
    if (val.isNotEmpty) {
      zoneTwoPercent = ((val.length / hrList!.length) * 100);
    } else {
      zoneTwoPercent = 0;
    }
    pieData.add(Data(
        name: 'Zone 3', percent: zoneTwoPercent, color: AppColor.colorFF6259));
    // hr between 161 - 179
    val = hrList!
        .where((element) => element.yValue! < 179 && element.yValue! >= 161)
        .toList();
    if (val.isNotEmpty) {
      zoneTwoPercent = ((val.length / hrList!.length) * 100);
    } else {
      zoneTwoPercent = 0;
    }
    pieData.add(Data(
        name: 'Zone 4', percent: zoneTwoPercent, color: AppColor.colorCC0A00));
    // hr > 179
    val = hrList!.where((element) => element.yValue! >= 179).toList();
    if (val.isNotEmpty) {
      zoneTwoPercent = ((val.length / hrList!.length) * 100);
    } else {
      zoneTwoPercent = 0;
    }
    pieData.add(Data(
        name: 'Zone 5', percent: zoneTwoPercent, color: AppColor.color980C23));

    var startDate = endDate.subtract(Duration(days: 30));
    var days = <DateTime>[];
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }

    try {
      lineChartSeriesForPace = generateLineChartData(field: 'Pace');
      lineChartSeriesForElevation = generateLineChartData(field: 'Elevation');
      lineChartWidgetForPace =
          generateLineChartForSpeed(lineChartSeriesForPace, 'Pace');
      lineChartWidgetForElevation = generateLineChartForElevation(
          lineChartSeriesForElevation, 'Elevation');
    } on Exception catch (e) {
      print(e);
    }

    setState(() {});
  }

  int? touchedIndex = 0;

  LatLng target() {
    if (widget.model != null &&
        widget.model!.locationList != null &&
        widget.model!.locationList!.isNotEmpty) {
      return LatLng(widget.model!.locationList!.first.latitude!,
          widget.model!.locationList!.first.longitude!);
    } else {
      return LatLng(53.5461, 113.4938);
    }
  }

  Set<Polyline> polyLines() {
    try {
      return {
        Polyline(
          points: widget.model?.locationList
                  ?.map((e) => LatLng(e.latitude!, e.longitude!))
                  .toList() ??
              [],
          width: 4,
          color: HexColor.fromHex('#FF6259'),
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          polylineId: PolylineId('polyLine'),
        )
      };
      if (widget.model != null &&
          widget.model!.heartRateModel != null &&
          widget.model!.heartRateModel!.isNotEmpty) {
        return {
          Polyline(
            points: widget.model?.heartRateModel
                    ?.map((e) => LatLng(
                        e.locationData!.latitude!, e.locationData!.longitude!))
                    .toList() ??
                [],
            width: 4,
            color: HexColor.fromHex('#FF6259'),
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
            polylineId: PolylineId('polyLine'),
          )
        };
      } else {
        return {
          Polyline(
            points: widget.model?.locationList
                    ?.map((e) => LatLng(e.latitude!, e.longitude!))
                    .toList() ??
                [],
            width: 4,
            color: HexColor.fromHex('#FF6259'),
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
            polylineId: PolylineId('polyLine'),
          )
        };
      }
    } on Exception catch (e) {
      print('Exception at polyLines');
    }
    return {};
  }

  Set<Marker> markers() {
    if (widget.model != null &&
        widget.model!.heartRateModel != null &&
        widget.model!.heartRateModel!.isNotEmpty) {
      var provider = Provider.of<HistoryDetailProvider>(context, listen: false);
      provider.currentPosition ??= LatLng(
          widget.model!.heartRateModel!.first.locationData!.latitude!,
          widget.model!.heartRateModel!.first.locationData!.longitude!);
      var current = Marker(
        markerId: MarkerId('current'),
        position: provider.currentPosition!,
        infoWindow:
            InfoWindow(title: '${provider.currentDateTime?.toString() ?? 0}'),
        // icon: BitmapDescriptor.fromBytes(setCurrentMarker())
        icon: customIcon != null
            ? customIcon!
            : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      return {current};
    } else {
      if (widget.model != null &&
          (widget.model!.locationList?.length ?? 0) > 1) {
        var provider =
            Provider.of<HistoryDetailProvider>(context, listen: false);
        var firstPoint = LatLng(widget.model!.locationList!.first.latitude!,
            widget.model!.locationList!.first.longitude!);
        var lastPoint = LatLng(widget.model!.locationList!.last.latitude!,
            widget.model!.locationList!.last.longitude!);
        provider.currentPosition ??= LatLng(
            widget.model!.locationList!.first.latitude!,
            widget.model!.locationList!.first.longitude!);
        // currentPosition = LatLng(widget.model.locationList.last.latitude,
        //     widget.model.locationList.last.longitude);
        // provider.changeCurrentPosition(widget.model.locationList.last.latitude,
        //     widget.model.locationList.last.longitude);

        var start = Marker(
          markerId: MarkerId('start'),
          position: firstPoint,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Start'),
        );
        var end = Marker(
          markerId: MarkerId('end'),
          position: lastPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: 'End',
          ),
        );
        var current = Marker(
          markerId: MarkerId('current'),
          position: provider.currentPosition!,
          infoWindow:
              InfoWindow(title: '${provider.currentDateTime?.toString() ?? 0}'),
          // icon: BitmapDescriptor.fromBytes(setCurrentMarker())
          icon: customIcon != null
              ? customIcon!
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
        return {current};
      }
      return {};
    }

    return {};
  }

  void _setMapFitToTour(List<LocationAddressModel> p, mapController) {
    try {
      if (p.isNotEmpty) {
        var minLat = p.first.latitude!;
        var minLong = p.first.longitude!;
        var maxLat = p.first.latitude!;
        var maxLong = p.first.longitude!;
        for (var point in p) {
          if (point.latitude! < minLat) minLat = point.latitude!;
          if (point.latitude! > maxLat) maxLat = point.latitude!;
          if (point.longitude! < minLong) minLong = point.longitude!;
          if (point.longitude! > maxLong) maxLong = point.longitude!;
        }
        Future.delayed(Duration(seconds: 1)).then((value) {
          mapController.moveCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(minLat, minLong),
                northeast: LatLng(maxLat, maxLong),
              ),
              14,
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.5)
                  : HexColor.fromHex('#384341').withOpacity(0.2),
              offset: Offset(0, 2.0),
              blurRadius: 4.0,
            )
          ]),
          child: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            leading: IconButton(
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Theme.of(context).brightness == Brightness.dark
                  ? Image.asset(
                      images.leftArrowDark,
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      images.leftArrowLight,
                      width: 13,
                      height: 22,
                    ),
            ),
            title: Text(
              'Workout Analysis',
              style: TextStyle(color: HexColor.fromHex('62CBC9')),
              // .toUpperCase(),
            ),
            centerTitle: true,
            actions: [
              // IconButton(
              //   onPressed: () {
              //     Constants.navigatePush(NotificationScreen(), context);
              //   },
              //   icon: Stack(
              //     children: [
              //       Image.asset(
              //         Theme.of(context).brightness == Brightness.dark
              //             ? "asset/mapScreenActivity/notification_icon_dark.png"
              //             : "asset/mapScreenActivity/notification_icon_light.png",
              //         height: 33.w,
              //         width: 33.w,
              //       ),
              //       Positioned(
              //         right: 0,
              //         top: 2,
              //         child: Container(
              //           height: 18.w,
              //           width: 18.w,
              //           decoration: BoxDecoration(
              //             color: HexColor.fromHex('#FF6259'),
              //             shape: BoxShape.circle,
              //           ),
              //           child: Center(
              //             child: Text(
              //               '1',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // IconButton(
              //   onPressed: () {
              //     // Constants.navigatePush(ActivityHistory(), context);
              //     Constants.navigatePush(WorkoutFeeds(), context);
              //   },
              //   icon: Image.asset(
              //     Theme.of(context).brightness == Brightness.dark
              //         ? "asset/history_dark.png"
              //         : "asset/history.png",
              //     // height: 33,
              //     // width: 33,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).brightness == Brightness.dark
              ? HexColor.fromHex('#111B1A')
              : AppColor.backgroundColor,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColor.darkBackgroundColor
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                            : Colors.white.withOpacity(0.7),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(-4, -4),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.75)
                            : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: Offset(4, 4),
                      ),
                    ]),
                margin: EdgeInsets.only(left: 13.w, right: 13.w, top: 13.h),
                height: 227.h,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: target(), zoom: 14),
                  polylines: polyLines(),
                  markers: markers(),
                  mapType: MapType.normal,
                  compassEnabled: false,
                  mapToolbarEnabled: true,
                  zoomGesturesEnabled: true,
                  buildingsEnabled: true,
                  onMapCreated: (controller) {
                    _setMapFitToTour(widget.model!.locationList!, controller);
                  },
                ),
              ),
              widget.model != null &&
                      widget.model!.locationList != null &&
                      widget.model!.locationList!.isNotEmpty
                  ? OuterContainer(
                      child: Container(
                        height: 300.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 14.w, right: 10.w, top: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'SPEED (m/s)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColor.white60
                                            : AppColor.color5D6A68),
                                  ),
                                  hrList != null && hrList!.isNotEmpty
                                      ? Text(
                                          'HR (bpm)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.colorFF6259),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 14.w, right: 12.w),
                                    height: 200.h,
                                    child: lineChartWidgetForPace),
                                Positioned(
                                  left: posx,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 8.w,
                                        right: 8.w,
                                        top: 8.h,
                                        bottom: 2.h),
                                    width: 135.w,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColor.darkBackgroundColor
                                            : AppColor.backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex('#D1D9E6')
                                                    .withOpacity(0.1)
                                                : Colors.white.withOpacity(0.7),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(-4, -4),
                                          ),
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.black.withOpacity(0.75)
                                                : HexColor.fromHex('#9F2DBC')
                                                    .withOpacity(0.15),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(4, 4),
                                          ),
                                        ]),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$distance km',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            ),
                                            Text(
                                              '$hr1 bpm',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${pace.toStringAsFixed(2)} m/s',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            ),
                                            Text(
                                              '$elevation m',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                infoContainer(
                                    (double.parse(activityItems.getAvgSpeed(
                                                widget.model!.locationList ??
                                                    [])) *
                                            3.6)
                                        .toStringAsFixed(2),
                                    'Avg Speed(km/h)'.toUpperCase()),
                                SizedBox(
                                  width: 69.w,
                                ),
                                infoContainer(
                                    (double.parse(activityItems.getMaxSpeed(
                                                widget.model!.locationList ??
                                                    [])) *
                                            3.6)
                                        .toStringAsFixed(2),
                                    'Max Speed(km/h)'.toUpperCase()),
                              ],
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              widget.model != null &&
                      widget.model!.locationList != null &&
                      widget.model!.locationList!.isNotEmpty
                  ? OuterContainer(
                      child: Container(
                        height: 300.h,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: 14.w, right: 10.w, top: 10.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ELEVATION (m)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColor.colorBD78CE
                                            : AppColor.color9F2DBC),
                                  ),
                                  hrList != null && hrList!.isNotEmpty
                                      ? Text(
                                          'HR (bpm)',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.colorFF6259),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(
                                        left: 14.w, right: 12.w),
                                    height: 200.h,
                                    child: lineChartWidgetForElevation),
                                Positioned(
                                  left: posx,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 8.w,
                                        right: 8.w,
                                        top: 8.h,
                                        bottom: 2.h),
                                    width: 135.w,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? AppColor.darkBackgroundColor
                                            : AppColor.backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? HexColor.fromHex('#D1D9E6')
                                                    .withOpacity(0.1)
                                                : Colors.white.withOpacity(0.7),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(-4, -4),
                                          ),
                                          BoxShadow(
                                            color: Theme.of(context)
                                                        .brightness ==
                                                    Brightness.dark
                                                ? Colors.black.withOpacity(0.75)
                                                : HexColor.fromHex('#9F2DBC')
                                                    .withOpacity(0.15),
                                            blurRadius: 4,
                                            spreadRadius: 0,
                                            offset: Offset(4, 4),
                                          ),
                                        ]),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '$distance km',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            ),
                                            Text(
                                              '$hr2 bpm',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${pace.toStringAsFixed(2)} m/s',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            ),
                                            Text(
                                              '$elevation m',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                infoContainer('0', 'Avg hr'.toUpperCase()),
                                SizedBox(
                                  width: 69.w,
                                ),
                                infoContainer('0', 'max hr'.toUpperCase()),
                              ],
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
              OuterContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(left: 24.w, right: 14.w, top: 10.h),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Heart Rate Zones',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColor.white87
                                        : AppColor.color384341),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Based on your max heart rate',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColor.white60
                                        : AppColor.color5D6A68),
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                              child: Image.asset(
                                Theme.of(context).brightness == Brightness.dark
                                    ? images.settingButtonDark
                                    : images.settingButtonLight,
                                width: 33.w,
                                height: 33.w,
                              ),
                              onTap: () {}),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    hrList != null && hrList!.isNotEmpty
                        ? Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                touchedIndex != null && touchedIndex != -1
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Zone ${touchedIndex! + 1}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white60
                                                      : AppColor.color5D6A68),
                                            ),
                                            Text(
                                              pieData[touchedIndex!].percent !=
                                                      null
                                                  ? '${pieData[touchedIndex!].percent!.toStringAsFixed(2)} %'
                                                  : '0 %',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? AppColor.white87
                                                      : AppColor.color384341),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 243.h,
                                      width: 243.h,
                                      child: PieChart(
                                        PieChartData(
                                          pieTouchData: PieTouchData(
                                            touchCallback: (pieTouchResponse) {
                                              setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  if (pieTouchResponse
                                                          .touchedSection!
                                                          .touchedSectionIndex ==
                                                      -1) {
                                                    touchedIndex = 0;
                                                  } else {
                                                    touchedIndex =
                                                        pieTouchResponse
                                                            .touchedSection!
                                                            .touchedSectionIndex;
                                                  }
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                              });
                                            },
                                          ),
                                          borderData: FlBorderData(show: false),
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 71.h,
                                          sections:
                                              getSections(touchedIndex ?? 0),
                                          // startDegreeOffset: -90,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : Center(
                            child: Text('No heart rate data found'),
                          ),
                    SizedBox(
                      height: 25.h,
                    ),
                    hrList != null && hrList!.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 19, bottom: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                smallRectangle(
                                    0, AppColor.colorFFDFDE, '0-109'),
                                smallRectangle(
                                    1, AppColor.colorFF9E99, '109-144'),
                                smallRectangle(
                                    2, AppColor.colorFF6259, '144-161'),
                                smallRectangle(
                                    3, AppColor.colorCC0A00, '161-179'),
                                smallRectangle(
                                    4, AppColor.color980C23, '> 179'),
                              ],
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              widget.model != null &&
                      widget.model!.locationList != null &&
                      widget.model!.locationList!.isEmpty
                  ? SizedBox(
                      height: 20.h,
                    )
                  : Container(),
              widget.model != null &&
                      widget.model!.locationList != null &&
                      widget.model!.locationList!.isEmpty
                  ? Container(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      child: Center(
                        child: Text(StringLocalization.of(context)
                            .getText(StringLocalization.noDataFound)),
                      ))
                  : Container(),
              SizedBox(
                height: 25.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget smallRectangle(int index, Color color, String text) {
    return Expanded(
        child: Container(
      height: touchedIndex != null && index == touchedIndex ? 45.h : 41.h,
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: index == 0 ? AppColor.color384341 : Colors.white),
        ),
      ),
    ));
  }

  getSections(int touchedIndex) => pieData
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        final isTouched = index == touchedIndex;
        final fontSize = isTouched ? 20.0 : 14.0;
        final radius = isTouched ? 55.h : 50.h;

        final value = PieChartSectionData(
            color: data.color,
            value: data.percent,
            title: '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
            badgePositionPercentageOffset: 0.5,
            badgeWidget: index == touchedIndex
                ? Container(
                    height: 42.h,
                    width: 80.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                            Theme.of(context).brightness == Brightness.dark
                                ? images.unionDark
                                : images.unionLight),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              index == 0
                                  ? 'Normal'
                                  : index == 1
                                      ? 'High'
                                      : 'Stress',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColor.white87
                                      : AppColor.color384341),
                            ),
                            Text(
                              '',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColor.white87
                                      : AppColor.color384341),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : Text(''));

        return MapEntry(index, value);
      })
      .values
      .toList();

  Widget infoContainer(String title, String cont) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.white87
                : AppColor.color384341,
          ),
        ),
        Text(
          cont,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.white38
                : AppColor.color7F8D8C,
          ),
        )
      ],
    );
  }
}

class OuterContainer extends StatelessWidget {
  Widget? child;

  OuterContainer({this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 17.h, left: 13.w, right: 13.w),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white.withOpacity(0.7),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(-4, -4),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.75)
                    : HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(4, 4),
              ),
            ]),
        child: child);
  }
}
