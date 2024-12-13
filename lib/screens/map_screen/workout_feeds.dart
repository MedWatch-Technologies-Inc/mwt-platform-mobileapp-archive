import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/extensions/distance_extension.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/activity_analysis.dart';
import 'package:health_gauge/screens/map_screen/model/workout_model.dart';
import 'package:health_gauge/screens/map_screen/widgets/custom_map_divider.dart';
import 'package:health_gauge/services/location/model/location_model.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:intl/intl.dart';

// class WorkoutFeeds extends StatefulWidget {
//   const WorkoutFeeds({Key? key}) : super(key: key);
//
//   @override
//   _WorkoutFeedsState createState() => _WorkoutFeedsState();
// }
//
// class _WorkoutFeedsState extends State<WorkoutFeeds> {
//   CalculateActivityItems activityItems = CalculateActivityItems();
//   HistoryListProvider historyListProvider = HistoryListProvider();
//
//   @override
//   void initState() {
//     Future.delayed(Duration(milliseconds: 300)).then((value) {
//       var provider = Provider.of<HistoryListProvider>(context, listen: false);
//       provider.isScreenLoad = true;
//       provider.getHistoryData();
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).brightness == Brightness.dark
//           ? AppColor.darkBackgroundColor
//           : AppColor.backgroundColor,
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight),
//         child: Container(
//           decoration: BoxDecoration(boxShadow: [
//             BoxShadow(
//               color: Theme.of(context).brightness == Brightness.dark
//                   ? Colors.black.withOpacity(0.5)
//                   : HexColor.fromHex("#384341").withOpacity(0.2),
//               offset: Offset(0, 2.0),
//               blurRadius: 4.0,
//             )
//           ]),
//           child: AppBar(
//             elevation: 0,
//             backgroundColor: Theme.of(context).brightness == Brightness.dark
//                 ? HexColor.fromHex('#111B1A')
//                 : AppColor.backgroundColor,
//             leading: IconButton(
//               padding: EdgeInsets.only(left: 10),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               icon: Theme.of(context).brightness == Brightness.dark
//                   ? Image.asset(
//                 "asset/dark_close.png",
//                 height: 33,
//                 width: 33,
//               )
//                   : Image.asset(
//                 "asset/close.png",
//                 height: 33,
//                       width: 33,
//                     ),
//             ),
//             title: Text(
//               "Workout Feeds",
//               style: TextStyle(color: HexColor.fromHex("62CBC9")),
//               // .toUpperCase(),
//             ),
//             centerTitle: true,
//             actions: [
//               // IconButton(
//               //   onPressed: () {
//               //     Constants.navigatePush(NotificationScreen(), context);
//               //   },
//               //   icon: Stack(
//               //     children: [
//               //       Image.asset(
//               //         Theme.of(context).brightness == Brightness.dark
//               //             ? "asset/mapScreenActivity/notification_icon_dark.png"
//               //             : "asset/mapScreenActivity/notification_icon_light.png",
//               //         height: 33.w,
//               //         width: 33.w,
//               //       ),
//               //       Positioned(
//               //         right: 0,
//               //         top: 2,
//               //         child: Container(
//               //           height: 18.w,
//               //           width: 18.w,
//               //           decoration: BoxDecoration(
//               //             color: HexColor.fromHex('#FF6259'),
//               //             shape: BoxShape.circle,
//               //           ),
//               //           child: Center(
//               //             child: Text(
//               //               '1',
//               //               style: TextStyle(
//               //                 color: Colors.white,
//               //                 fontSize: 10,
//               //               ),
//               //             ),
//               //           ),
//               //         ),
//               //       )
//               //     ],
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//       body: Consumer<HistoryListProvider>(
//         builder:
//             (BuildContext? context, HistoryListProvider? value, Widget? child) {
//           if (value!.isScreenLoad) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             if (value.historyList.length == 0) {
//               return Container(
//                 child: Center(
//                   child: Text(stringLocalization
//                       .getText(StringLocalization.noDataFound)),
//                 ),
//               );
//             } else {
//               return SingleChildScrollView(
//                 child: Container(
//                   color: Theme.of(context!).brightness == Brightness.dark
//                       ? AppColor.darkBackgroundColor
//                       : AppColor.backgroundColor,
//                   margin: EdgeInsets.only(left: 13.w, right: 13.w),
//                   child: Column(
//                       children: List.generate(
//                     value.historyList.length,
//                     (index) {
//                       ActivityModel model = value.historyList[index];
//                       String startTime = '';
//                       String endTime = '';
//                       try {
//                         startTime = DateTime.fromMillisecondsSinceEpoch(
//                                 model.startTime!)
//                             .toUtc()
//                             .toLocal()
//                             .toString();
//                       } catch (e) {
//                         print('Exception at parsing startTime $e');
//                       }
//                       try {
//                         if (model.endTime == null) {
//                           endTime = DateTime.fromMillisecondsSinceEpoch(
//                                   model.locationList!.last.time.toInt())
//                               .toUtc()
//                               .toLocal()
//                               .toString();
//                         } else {
//                           endTime = DateTime.fromMillisecondsSinceEpoch(
//                                   model.endTime!)
//                               .toUtc()
//                               .toLocal()
//                               .toString();
//                         }
//                       } catch (e) {
//                         print('Exception at parsing endTime $e');
//                       }
//                       // return HistoryItemCard(activityModel: model);
//                       return WorkOutFeedData(WorkoutModel(
//                         name:
//                             '${globalUser!.firstName!} ${globalUser!.lastName!}',
//                         image: 'asset/running_icon.png',
//                         userImage: 'asset/m_profile_icon.png',
//                         date: DateTime.now(),
//                         place: '',
//                         title: model.title ?? 'Untitled',
//                         pace: activityItems.getSpeed(model.locationList ?? []),
//                         avgPace:
//                             activityItems.getAvgSpeed(model.locationList ?? []),
//                         calorie: '0',
//                         duration: activityItems
//                             .convertSecToFormattedTime(model.totalTime ?? 0),
//                         distance:
//                             activityItems.getDistance(model.locationList ?? []),
//                         likes: 0,
//                         commentLength: 0,
//                         activityModel: model,
//                       ));
//                     },
//                   ).reversed.toList()),
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }
// }

class WorkOutFeedData extends StatelessWidget {
  final WorkoutModel model;

  WorkOutFeedData(
    this.model, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 14.h, left: 13.w, right: 13.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          UserInfoHeader(model),
          SizedBox(
            height: 7.h,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15.w),
                  child: Text(
                    model.title!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.white87
                          : AppColor.color384341,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  Constants.navigatePush(
                      ActivityAnalysis(model.activityModel), context);
                },
                child: Row(
                  children: [
                    Text(
                      stringLocalization
                          .getText(StringLocalization.viewAnalysis),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.white87
                              : AppColor.color384341),
                    ),
                    Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? images.rightIconSmallDark
                          : images.rightIconSmallLight,
                      width: 26.w,
                      height: 26.w,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 9.h,
          ),
          Container(
            margin: EdgeInsets.only(left: 12.w, right: 9.w),
            height: 227.h,
            /*child: FlutterMap(
              options: MapOptions(
                center: widget.model.activityModel!.locationList == null ||
                        widget.model.activityModel!.locationList!.isEmpty
                    ? LatLng(45.41534475925838, -75.70018300974971)
                    : LatLng(
                        widget
                            .model.activityModel!.locationList!.first.latitude!,
                        widget.model.activityModel!.locationList!.first
                            .longitude!),
                zoom: 18.0,
                maxZoom: 22,
              ),
              mapController: controller,
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/shahzad456/ckotwwxup9oxw17pb55qt2ajq/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2hhaHphZDQ1NiIsImEiOiJja290d3Y2b20wZmdoMm9sbGcyYXU0Z3FmIn0.a9FIy0tjWZcORvbW3w7Exw',
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1Ijoic2hhaHphZDQ1NiIsImEiOiJja290d3Y2b20wZmdoMm9sbGcyYXU0Z3FmIn0.a9FIy0tjWZcORvbW3w7Exw',
                    'id': 'mapbox.mapbox-streets-v8'
                  },
                ),
                PolylineLayerOptions(polylines: [
                  Polyline(
                    // points: model.activityModel!.locationList!
                    //     .map((e) => LatLng(e.latitude!, e.longitude!))
                    //     .toList(),
                    points: widget.model.activityModel!.locationList!
                        .map((e) => LatLng(e.latitude!, e.longitude!))
                        .toList(),
                    strokeWidth: 4,
                    color: Colors.red,
                  )
                ]),
                //                  LocationMarkerLayerOptions(),
              ],
            ),*/
            child: GoogleMap(
              initialCameraPosition: model.activityModel!.locationList ==
                          null ||
                      model.activityModel!.locationList!.isEmpty
                  ? CameraPosition(
                      target: LatLng(45.41534475925838, -75.70018300974971),
                      zoom: 14,
                    )
                  : CameraPosition(
                      target: LatLng(
                          model.activityModel!.locationList!.first.latitude!,
                          model.activityModel!.locationList!.first.longitude!),
                      zoom: 14,
                    ),
              polylines: <Polyline>{
                Polyline(
                  polylineId: PolylineId(model.activityModel!.id!),
                  points: model.activityModel!.locationList!
                      .map((e) => LatLng(e.latitude!, e.longitude!))
                      .toList(),
                  color: Colors.red,
                  width: 4,
                ),
              },
              onMapCreated: (controller) {
                _setMapFitToTour(model.activityModel?.locationList, controller);
              },
            ),
          ),
          WorkoutInfoData(model),
          CustomMapDivider(),
          WorkoutInfoFooter(model),
        ],
      ),
    );
  }

  void _setMapFitToTour(List<LocationAddressModel>? p, mapController) {
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
              14,
            ),
          );
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  LatLng target() {
    if (model.activityModel != null &&
        model.activityModel!.locationList != null &&
        model.activityModel!.locationList!.isNotEmpty) {
      return LatLng(model.activityModel!.locationList!.first.latitude!,
          model.activityModel!.locationList!.first.longitude!);
    } else {
      return LatLng(45.41534475925838, -75.70018300974971);
    }
  }
}

class UserInfoHeader extends StatelessWidget {
  final WorkoutModel? model;

  const UserInfoHeader(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 14.h),
      child: Row(
        children: [
          Container(
            height: 43.h,
            width: 43.h,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            child: Image.asset(
              model!.userImage!,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model!.name!,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.white87
                          : AppColor.color384341),
                ),
                Row(
                  children: [
                    Image.asset(
                      model!.image!,
                      height: 26.h,
                      width: 26.h,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                      child: Text(
                        DateFormat(DateUtil.MMMMdyhhmmaaa)
                                .format(model!.date ?? DateTime.now()) +
                            (model!.place! == '' ? '' : '| ${model!.place}'),
                        // 'May 6, 2021 at 9:10 pm '
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColor.white60
                                    : AppColor.color5D6A68),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WorkoutInfoData extends StatelessWidget {
  final WorkoutModel model;

  WorkoutInfoData(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMile = model.unit == 1;

    var avgSpeed = (double.parse(model.avgPace ?? '0') * 3.6);

    var speed = (double.parse(model.pace ?? '0') * 3.6);
    var maxSpeed = (double.parse(model.maxPace ?? '0') * 3.6);

    var distance = double.parse(model.distance!);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InfoContainer(
                avgSpeed
                    .toDouble()
                    .convertDistanceToUserUnit(isMile)
                    .toStringAsFixed(2),
                isMile ? 'Avg Speed(Mile/h)' : 'Avg Speed(Km/h)'),
            SizedBox(
              width: 18.w,
            ),
            Container(
              height: 61.h,
              width: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.white15
                  : AppColor.colorD9E0E0,
            ),
            SizedBox(
              width: 18.w,
            ),
            InfoContainer(
                maxSpeed
                    .toDouble()
                    .convertDistanceToUserUnit(isMile)
                    .toStringAsFixed(2),
                isMile ? 'Max Speed(Mile/h)' : 'Max Speed(Km/h)')
          ],
        ),
        CustomMapDivider(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 23.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InfoContainer(model.calorie!, 'Calories'),
              InfoContainer(
                  distance.convertDistanceToUserUnit(isMile).toStringAsFixed(2),
                  isMile ? 'Distance(Mile)' : 'Distance(Km)'),
              InfoContainer(model.duration!, 'Duration'),
            ],
          ),
        )
      ],
    );
  }
}

class WorkoutInfoFooter extends StatelessWidget {
  final WorkoutModel model;
  final AppImages images = AppImages();

  WorkoutInfoFooter(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 21.w, right: 15.w, top: 9.h, bottom: 9.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              CustomSnackBar.buildSnackbar(
                  context, 'Feature not Implemented.', 2);
            },
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? images.commentIconDark
                  : images.commentIconLight,
              height: 30.h,
              width: 30.h,
            ),
          ),
          SizedBox(
            width: 24.w,
          ),
          Container(
            height: 37.h,
            width: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.white15
                : AppColor.colorD9E0E0,
          ),
          SizedBox(
            width: 24.w,
          ),
          GestureDetector(
            onTap: () {
              CustomSnackBar.buildSnackbar(
                  context, 'Feature Not Implemented.', 2);
            },
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? images.thumbsUpButtonDark
                  : images.thumbsUpButtonLight,
              height: 30.h,
              width: 30.h,
            ),
          ),
          Spacer(),
          Text(
            '${model.likes} Likes    ${model.commentLength} Comment',
            style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.white87
                    : AppColor.color384341),
          )
        ],
      ),
    );
  }
}

class InfoContainer extends StatelessWidget {
  final String unit;
  final String title;

  InfoContainer(this.title, this.unit, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      margin: EdgeInsets.symmetric(vertical: 9.h),
      child: Column(children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.white87
                  : AppColor.color384341),
        ),
        Text(
          unit,
          style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.6)
                  : HexColor.fromHex('#5D6A68')),
        )
      ]),
    );
  }
}

/*class _WorkOutFeedDataState extends State<WorkOutFeedData> {
  //MapController? controller = MapController();
  AppImages images = AppImages();

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);

    return Container(
      margin: EdgeInsets.only(top: 14.h, left: 13.w, right: 13.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          UserInfoHeader(widget.model),
          SizedBox(
            height: 7.h,
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 15.w),
                  child: Text(
                    widget.model.title!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.white87
                          : AppColor.color384341,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  Constants.navigatePush(
                      ActivityAnalysis(widget.model.activityModel), context);
                },
                child: Row(
                  children: [
                    Text(
                      stringLocalization
                          .getText(StringLocalization.viewAnalysis),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColor.white87
                              : AppColor.color384341),
                    ),
                    Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? images.rightIconSmallDark
                          : images.rightIconSmallLight,
                      width: 26.w,
                      height: 26.w,
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 9.h,
          ),
          Container(
            margin: EdgeInsets.only(left: 12.w, right: 9.w),
            height: 227.h,
            */ /*child: FlutterMap(
              options: MapOptions(
                center: widget.model.activityModel!.locationList == null ||
                        widget.model.activityModel!.locationList!.isEmpty
                    ? LatLng(45.41534475925838, -75.70018300974971)
                    : LatLng(
                        widget
                            .model.activityModel!.locationList!.first.latitude!,
                        widget.model.activityModel!.locationList!.first
                            .longitude!),
                zoom: 18.0,
                maxZoom: 22,
              ),
              mapController: controller,
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/shahzad456/ckotwwxup9oxw17pb55qt2ajq/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic2hhaHphZDQ1NiIsImEiOiJja290d3Y2b20wZmdoMm9sbGcyYXU0Z3FmIn0.a9FIy0tjWZcORvbW3w7Exw',
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1Ijoic2hhaHphZDQ1NiIsImEiOiJja290d3Y2b20wZmdoMm9sbGcyYXU0Z3FmIn0.a9FIy0tjWZcORvbW3w7Exw',
                    'id': 'mapbox.mapbox-streets-v8'
                  },
                ),
                PolylineLayerOptions(polylines: [
                  Polyline(
                    // points: model.activityModel!.locationList!
                    //     .map((e) => LatLng(e.latitude!, e.longitude!))
                    //     .toList(),
                    points: widget.model.activityModel!.locationList!
                        .map((e) => LatLng(e.latitude!, e.longitude!))
                        .toList(),
                    strokeWidth: 4,
                    color: Colors.red,
                  )
                ]),
                //                  LocationMarkerLayerOptions(),
              ],
            ),*/ /*
            child: GoogleMap(
              initialCameraPosition:
                  widget.model.activityModel!.locationList == null ||
                          widget.model.activityModel!.locationList!.isEmpty
                      ? CameraPosition(
                          target: LatLng(45.41534475925838, -75.70018300974971),
                          zoom: 14,
                        )
                      : CameraPosition(
                          target: LatLng(
                              widget.model.activityModel!.locationList!.first
                                  .latitude!,
                              widget.model.activityModel!.locationList!.first
                                  .longitude!),
                          zoom: 14,
                        ),
              polylines: <Polyline>{
                Polyline(
                  polylineId: PolylineId(widget.model.activityModel!.id!),
                  points: widget.model.activityModel!.locationList!
                      .map((e) => LatLng(e.latitude!, e.longitude!))
                      .toList(),
                  color: Colors.red,
                  width: 4,
                ),
              },
              onMapCreated: (controller) {
                _setMapFitToTour(widget.model.activityModel?.locationList, controller);
              },
            ),
          ),
          WorkoutInfoData(widget.model),
          CustomMapDivider(),
          WorkoutInfoFooter(widget.model),
        ],
      ),
    );
  }

  void _setMapFitToTour(List<LocationAddressModel>? p, mapController) {
    try {
      if (p!=null && p.isNotEmpty) {
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

  */ /*Set<Polyline> polyLines() {
    // try {
    //   if (model.activityModel != null &&
    //       model.activityModel!.heartRateModel != null &&
    //       model.activityModel!.heartRateModel!.isNotEmpty) {
    //     return {
    //       Polyline(
    //         points: model.activityModel?.heartRateModel
    //                 ?.map((e) => LatLng(
    //                     e.locationData!.latitude!, e.locationData!.longitude!))
    //                 .toList() ??
    //             [],
    //         width: 4,
    //         color: HexColor.fromHex('#FF6259'),
    //         startCap: Cap.roundCap,
    //         endCap: Cap.roundCap,
    //         jointType: JointType.round,
    //         polylineId: PolylineId('polyLine'),
    //       )
    //     };
    //   } else {
    //     return {
    //       Polyline(
    //         points: model.activityModel?.locationList
    //                 ?.map((e) => LatLng(e.latitude!, e.longitude!))
    //                 .toList() ??
    //             [],
    //         width: 4,
    //         color: HexColor.fromHex('#FF6259'),
    //         startCap: Cap.roundCap,
    //         endCap: Cap.roundCap,
    //         jointType: JointType.round,
    //         polylineId: PolylineId('polyLine'),
    //       )
    //     };
    //   }
    // } catch (e) {
    //   print('Exception at polyLines');
    // }
    return {};
  }*/ /*

  LatLng target() {
    if (widget.model.activityModel != null &&
        widget.model.activityModel!.locationList != null &&
        widget.model.activityModel!.locationList!.isNotEmpty) {
      return LatLng(widget.model.activityModel!.locationList!.first.latitude!,
          widget.model.activityModel!.locationList!.first.longitude!);
    } else {
      return LatLng(45.41534475925838, -75.70018300974971);
    }
  }
}*/
