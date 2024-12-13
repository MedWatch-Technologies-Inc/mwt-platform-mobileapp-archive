import 'dart:math';
import 'dart:typed_data';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/custom_packages/map_elevation.dart';
import 'package:health_gauge/screens/map_screen/model/activity_model.dart';
import 'package:health_gauge/screens/map_screen/widgets/summary_container.dart';
import 'package:health_gauge/services/location/model/location_model.dart';
import 'package:health_gauge/utils/calculate_activity_items.dart';
import 'package:provider/provider.dart';

import 'providers/history_detail_provider.dart';

class FullScreenImage extends StatefulWidget {
  final ActivityModel? model;

  const FullScreenImage({Key? key, this.model}) : super(key: key);

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  ElevationPoint? hoverPoint;
  // LatLng currentPosition;

  List<charts.Series<dynamic, num>> chars = [];
  BitmapDescriptor? customIcon;
  CalculateActivityItems activityItems = CalculateActivityItems();

  @override
  void initState() {
    var provider = Provider.of<HistoryDetailProvider>(context, listen: false);
    provider.locationData = widget.model?.locationList;
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(2, 2)),
            'asset/currentPositionIcon.png')
        .then((d) {
      customIcon = d;
    });
    fillCharList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: 320,
                child: Consumer<HistoryDetailProvider>(
                  builder: (context, model, child) {
                    var provider = Provider.of<HistoryDetailProvider>(context,
                        listen: false);
                    return Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition:
                              CameraPosition(target: target(), zoom: 16),
                          polylines: polyLines(),
                          markers: markers(),
                          mapType: MapType.normal,
                          compassEnabled: false,
                          mapToolbarEnabled: true,
                          zoomGesturesEnabled: true,
                          onMapCreated: (controller) {
                            _setMapFitToTour(
                                widget.model!.locationList!, controller);
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            width: MediaQuery.of(context).size.width * .6,
                            margin: EdgeInsets.only(bottom: 15),
                            height: 50,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Speed(m/s)',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(provider.currentSpeed!
                                          .toStringAsFixed(2))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Elevation(m)',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                          provider.currentElevation!
                                              .toStringAsFixed(2),
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8.w),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.h),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: Icon(
                                    Icons.close_fullscreen_rounded,
                                    size: 30.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    // Padding(
                    //   padding: EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 450,
                    //     color: Colors.white.withOpacity(0.6),
                    //     child: NotificationListener<ElevationHoverNotification>(
                    //       onNotification: (ElevationHoverNotification notifiation) {
                    //         if (notifiation != null && notifiation.position != null) {
                    //           if (notifiation.position.latitude != null &&
                    //               notifiation.position.longitude != null) {
                    //             var provider = Provider.of<HistoryDetailProvider>(context,
                    //                 listen: false);
                    //             if(notifiation.position.altitude > 5){
                    //               provider.currentSpeed = 0;
                    //               provider.currentElevation = notifiation.position.altitude;
                    //             }else{
                    //               provider.currentSpeed = notifiation.position.altitude / 10;
                    //             }
                    //             provider.changeCurrentPosition(
                    //                 notifiation.position.latitude,
                    //                 notifiation.position.longitude);
                    //             // currentPosition = LatLng(notifiation.position.latitude,
                    //             //     notifiation.position.longitude);
                    //           }
                    //         }
                    //         hoverPoint = notifiation.position;
                    //         // if(mounted) setState(() {});
                    //         return true;
                    //       },
                    //       child: Column(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           Container(
                    //             height: 150,
                    //             child: Elevation(
                    //               getPointsSpeed(),
                    //               color: Colors.lightBlue,
                    //               elevationGradientColors: ElevationGradientColors(
                    //                   gt10: Colors.lightBlue,
                    //                   gt20: Colors.lightBlue,
                    //                   gt30: Colors.lightBlue),
                    //             ),
                    //           ),
                    //           Align(
                    //             alignment: Alignment.center,
                    //             child: Container(
                    //               child: Text("Speed m/s"),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: 40,
                    //           ),
                    //           Container(
                    //             height: 150,
                    //             child: Elevation(
                    //               getPoints(),
                    //               color: Colors.lightBlue,
                    //               elevationGradientColors: ElevationGradientColors(
                    //                   gt10: Colors.lightBlue,
                    //                   gt20: Colors.lightBlue,
                    //                   gt30: Colors.lightBlue),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        height: 200,
                        child: SliderLine(chars, widget.model!.locationList!)),
                    Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('SUMMARY'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SummaryContainer(
                                      activityItems.getDistance(
                                          widget.model!.locationList),
                                      'Distance',
                                      'KM'),
                                  SummaryContainer(
                                      widget.model!.totalTime != null
                                          ? activityItems.convertSecToTime(
                                              widget.model!.totalTime!)
                                          : '${activityItems.getTimeTaken(widget.model!.endTime, widget.model!.startTime)}',
                                      'Duration',
                                      ''),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // SummaryContainer(activityItems.getAvgSpeed(widget.model.locationList), 'Avg Speed', 'MPS'),
                                  SummaryContainer(
                                      activityItems.getElevation(
                                          widget.model!.locationList),
                                      'el. gain',
                                      'M'),
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  LatLng target() {
    return LatLng(widget.model!.locationList!.first.latitude!,
        widget.model!.locationList!.first.longitude!);
  }

  void fillCharList() {
    var index = 0.0;
    var datax = <LinearSales>[];
    for (var element in widget.model!.locationList!) {
      datax.add(LinearSales(index, element.altitude!));
      index++;
    }
    chars = [
      charts.Series<LinearSales, double>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: datax,
      )
    ];
  }

  List<ElevationPoint> getPoints() {
    var pointList = <ElevationPoint>[];
    var index = 0.0;
    for (var data in widget.model!.locationList!) {
      if (data.altitude! < 0) {
        pointList.add(
            ElevationPoint(data.latitude!, data.longitude!, data.altitude!));
      } else {
        pointList.add(
            ElevationPoint(data.latitude!, data.longitude!, data.altitude!));
      }
      index++;
    }

    fillCharList();
    return pointList;
    // return widget?.model?.locationList?.map((e) => ElevationPoint(e?.latitude,e?.longitude,e?.altitude))?.toList();
  }

  List<ElevationPoint> getPointsSpeed() {
    var pointList = <ElevationPoint>[];
    for (var data in widget.model!.locationList!) {
      if (data.speed! < 0) {
        pointList.add(
            ElevationPoint(data.latitude!, data.longitude!, data.speed! * 10));
      } else {
        pointList.add(
            ElevationPoint(data.latitude!, data.longitude!, data.speed! * 10));
      }
    }
    return pointList;
    // return widget?.model?.locationList?.map((e) => ElevationPoint(e?.latitude,e?.longitude,e?.altitude))?.toList();
  }

  void _setMapFitToTour(List<LocationAddressModel> p, mapController) {
    try {
      if (p != null && p.isNotEmpty) {
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
              20,
            ),
          );
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Set<Marker> markers() {
    if ((widget.model?.locationList?.length ?? 0) > 1) {
      var provider = Provider.of<HistoryDetailProvider>(context, listen: false);
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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
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
        infoWindow: InfoWindow(
            title:
                'Lat : ${provider.currentPosition!.longitude.toStringAsFixed(2)} \n Long:  ${provider.currentPosition!.longitude.toStringAsFixed(2)}'),
        // icon: BitmapDescriptor.fromBytes(setCurrentMarker())
        icon: customIcon!,
      );
      return {start, current, end};
    }
    return {};
  }

  Future<Marker> setCurrentMarker() async {
    var imageData = await getMarker();
    var provider = Provider.of<HistoryDetailProvider>(context, listen: false);
    var current = Marker(
        markerId: MarkerId('current'),
        position: provider.currentPosition!,
        icon: BitmapDescriptor.fromBytes(imageData));
    return current;
  }

  Future<Uint8List> getMarker() async {
    var byteData =
        await DefaultAssetBundle.of(context).load('assets/activityIcon.png');
    return byteData.buffer.asUint8List();
  }

  Set<Polyline> polyLines() {
    try {
      return {
        Polyline(
          points: widget.model?.locationList
                  ?.map((e) => LatLng(e.latitude!, e.longitude!))
                  .toList() ??
              [],
          width: 5,
          color: Colors.blueAccent,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
          polylineId: PolylineId('polyLine'),
        )
      };
    } catch (e) {
      print('Exception at polyLines');
    }
    return {};
  }
}

class SliderLine extends StatefulWidget {
  late final List<charts.Series<dynamic, num>> seriesList;
  final List<LocationAddressModel>? locationData;
  final bool? animate;

  SliderLine(this.seriesList, this.locationData, {this.animate});

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => _SliderCallbackState();
}

class _SliderCallbackState extends State<SliderLine> {
  num? _sliderDomainValue;
  String? _sliderDragState;
  Point<int>? _sliderPosition;

  _onSliderChange2(Point<int> point, dynamic domain, String roleId,
      charts.SliderListenerDragState dragState) {
    // Request a build.
    void rebuild(_) {
      if (mounted) {
        var provider =
            Provider.of<HistoryDetailProvider>(context, listen: false);
        provider.domainValue = domain;
        if (provider.domainValue!.toInt() >= widget.locationData!.length) {
          provider.currentElevation = widget.locationData!.last.altitude;
          provider.currentSpeed =
              widget.locationData!.last.speed!.roundToDouble();
          provider.changeCurrentPosition(widget.locationData!.last.latitude!,
              widget.locationData!.last.longitude!);
        } else {
          provider.currentElevation =
              widget.locationData![provider.domainValue!.toInt()].altitude;
          provider.currentSpeed = widget
              .locationData![provider.domainValue!.toInt()].speed!
              .roundToDouble();
          provider.changeCurrentPosition(
              widget.locationData![provider.domainValue!.toInt()].latitude!,
              widget.locationData![provider.domainValue!.toInt()].longitude!);
        }
      }
    }

    SchedulerBinding.instance.addPostFrameCallback(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      SizedBox(
          height: 150.0,
          child: charts.LineChart(
            widget.seriesList,
            animate: widget.animate,
            primaryMeasureAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(
                      fontSize: 10,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? charts.MaterialPalette.white
                          : charts.MaterialPalette.black)),
              tickProviderSpec: charts.BasicNumericTickProviderSpec(
                  desiredTickCount: 5, zeroBound: false),
            ),
            behaviors: [
              charts.Slider(
                  initialDomainValue: 1.0,
                  onChangeCallback: _onSliderChange2,
                  style: charts.SliderStyle(
                    handleSize: Rectangle<int>(0, 0, 20, 20),
                  )),
              // new charts.ChartTitle('Dimension',
              //     behaviorPosition: charts.BehaviorPosition.bottom,
              //     // titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 11),
              //     titleOutsideJustification:
              //     charts.OutsideJustification.middleDrawArea),
              charts.ChartTitle('Elevation(m)',
                  behaviorPosition: charts.BehaviorPosition.start,
                  // titleStyleSpec: chartsCommon.TextStyleSpec(fontSize: 11),
                  titleOutsideJustification:
                      charts.OutsideJustification.middleDrawArea)
            ],
          )),
    ];

    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}

/// Sample linear data type.
class LinearSales {
  final double year;
  final double sales;

  LinearSales(this.year, this.sales);
}
