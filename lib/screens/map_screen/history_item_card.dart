import 'dart:convert';

import 'package:flutter/material.dart';
/*import 'package:flutter_map/flutter_map.dart' as map;
import 'package:latlong/latlong.dart' as map;
import 'package:flutter_map/flutter_map.dart' as map;*/
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/screens/map_screen/activity_analysis.dart';
import 'package:health_gauge/utils/calculate_activity_items.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:location/location.dart';

import 'full_screen_image.dart';
import 'model/activity_model.dart';

class HistoryItemCard extends StatefulWidget {
  final ActivityModel? activityModel;

  const HistoryItemCard({Key? key, this.activityModel}) : super(key: key);

  @override
  _HistoryItemCardState createState() => _HistoryItemCardState();
}

class _HistoryItemCardState extends State<HistoryItemCard> {
  double initLat = 45.41534475925838;
  double initLng = -75.70018300974971;

  String distance = '0 KM';
  String time = '00:00';
  String elevation = '0 Gain';
  CalculateActivityItems getItems = CalculateActivityItems();

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: Constants.staticWidth,
    //     height: Constants.staticHeight,
    //     allowFontScaling: true);
    distance = '${getItems.getDistance(widget.activityModel!.locationList)} km';
    print(widget.activityModel!.totalTime);
    if (widget.activityModel!.totalTime != null) {
      time = getItems.convertSecToTime(widget.activityModel!.totalTime!);
    } else {
      time =
          '${getItems.getTimeTaken(widget.activityModel!.endTime, widget.activityModel!.startTime)}';
    }
    elevation =
        '${getItems.getElevation(widget.activityModel!.locationList)} m';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeadlineText(
                text: widget.activityModel?.title ?? 'Activity',
              ),
              (widget.activityModel?.desc?.isNotEmpty ?? false)
                  ? Body1Text(
                      text: widget.activityModel?.desc ?? '',
                    )
                  : Container(),
              CaptionText(
                  text: DateTime.fromMillisecondsSinceEpoch(
                          widget.activityModel!.startTime!)
                      .toString()),
              SizedBox(height: 8.h),
              Container(
                constraints: BoxConstraints(
                  minHeight: 50,
                  minWidth: Size.infinite.width,
                  maxHeight: Size.infinite.height,
                  maxWidth: Size.infinite.width,
                ),
                child: GestureDetector(
                  onTap: () {
                    // Constants.navigatePush(
                    //     FullScreenImage(
                    //       model: widget.activityModel,
                    //     ),
                    //     context);
                    Constants.navigatePush(
                        ActivityAnalysis(widget.activityModel!), context);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Body2Text(text: 'Distance'),
                            TitleText(text: distance)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Body2Text(text: 'Elevation Gain'),
                            TitleText(text: elevation)
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Body2Text(text: 'Time'),
                            TitleText(text: time)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              image(context),
            ],
          ),
        ),
      ),
    );
  }

  Container image(BuildContext context) {
    if (widget.activityModel?.imageString?.isNotEmpty ?? false) {
      return Container(
        height: 200.h,
        width: Size.infinite.width,
        child: Stack(
          children: [
            Image.memory(
              base64Decode(
                widget.activityModel!.imageString!,
              ),
              height: 200.h,
              width: Size.infinite.width,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () {
                  Constants.navigatePush(
                      ActivityAnalysis(widget.activityModel!), context);
                },
                icon: Icon(
                  Icons.fullscreen,
                  size: 30.h,
                ),
              ),
            )
          ],
        ),
      );
    } else if ((widget.activityModel?.imageModelList?.length ?? 0) > 0) {
      var url = widget.activityModel?.imageModelList?.first.fileContent;
      if (url!.contains('http')) {
        return Container(
          height: 200.h,
          width: Size.infinite.width,
          child: Stack(
            children: [
              Image.network(
                url,
                height: 200.h,
                width: Size.infinite.width,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    Constants.navigatePush(
                        FullScreenImage(
                          model: widget.activityModel,
                        ),
                        context);
                  },
                  icon: Icon(
                    Icons.fullscreen,
                    size: 30.h,
                  ),
                ),
              )
            ],
          ),
        );
      } else {
        return Container(
          height: 200.h,
          width: Size.infinite.width,
          child: Stack(
            children: [
              Image.memory(
                base64Decode(
                  url,
                ),
                height: 200.h,
                width: Size.infinite.width,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    Constants.navigatePush(
                        FullScreenImage(
                          model: widget.activityModel,
                        ),
                        context);
                  },
                  icon: Icon(
                    Icons.fullscreen,
                    size: 30.h,
                  ),
                ),
              )
            ],
          ),
        );
      }
    }
    return (widget.activityModel?.imageString?.isNotEmpty ?? false)
        ? Container(
            height: 200.h,
            width: Size.infinite.width,
            child: Stack(
              children: [
                Image.memory(
                  base64Decode(
                    widget.activityModel!.imageString!,
                  ),
                  height: 200.h,
                  width: Size.infinite.width,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {
                      Constants.navigatePush(
                          FullScreenImage(
                            model: widget.activityModel,
                          ),
                          context);
                    },
                    icon: Icon(
                      Icons.fullscreen,
                      size: 30.h,
                    ),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  LatLng target() {
    if ((widget.activityModel?.locationList?.length ?? -1) > 0) {
      return LatLng(
          widget.activityModel!.locationList!.first.latitude ?? initLat,
          widget.activityModel!.locationList!.first.longitude ?? initLng);
    }
    return LatLng(initLat, initLng);
  }

  void _setMapFitToTour(List<LocationData> p, mapController) {
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
            20,
          ),
        );
      });
    }
  }

  Set<Polyline> polyLines() {
    try {
      return {
        Polyline(
          points: widget.activityModel?.locationList
                  ?.map((e) => LatLng(e.latitude!, e.longitude!))
                  .toList() ??
              [],
          width: 5,
          endCap: Cap.roundCap,
          jointType: JointType.mitered,
          polylineId: PolylineId('polyLine'),
        )
      };
    } catch (e) {
      print('Exception at polyLines');
    }
    return {};
  }
}
