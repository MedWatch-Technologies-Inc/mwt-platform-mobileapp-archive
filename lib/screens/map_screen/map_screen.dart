import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/extensions/distance_extension.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/button_layout.dart';
import 'package:health_gauge/screens/map_screen/map_screen_tracker_settings.dart';
import 'package:health_gauge/screens/map_screen/model/hr_monitor_model.dart';
import 'package:health_gauge/screens/map_screen/providers/location_track_provider.dart';
import 'package:health_gauge/screens/map_screen/providers/save_activity_screen_model.dart';
import 'package:health_gauge/screens/map_screen/save_activity_screen.dart';
import 'package:health_gauge/screens/map_screen/select_activity.dart';
import 'package:health_gauge/screens/map_screen/workout_feed_page.dart';
import 'package:health_gauge/services/location/location_service_manager.dart';
import 'package:health_gauge/services/location/model/location_model.dart';
import 'package:health_gauge/utils/calculate_activity_items.dart';
import 'package:health_gauge/utils/connections.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/location_utils.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_container_box.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> implements HeartRateFromRunModeListener {
  double initLat = 45.41534475925838;
  double initLng = -75.70018300974971;
  Location? location = Location();
  AppImages images = AppImages();

  // List<String> selectActivityType = ['Walk', 'Run', 'Ride'];

//  GoogleMapController controller;
  GoogleMapController? controller;

  DateTime? dateTime = DateTime.now();

  bool? stopTimer = false;
  CalculateActivityItems? activityItems = CalculateActivityItems();
  var unit;

  // Timer _timer;
  @override
  void initState() {
    connections.heartRateFromRunModeListener = this;
    LocationUtils().checkPermission(context);
    LocationUtils().requestNotificationPermission();
    unit = preferences?.getInt(Constants.mDistanceUnitKey) ?? 10;
    print('Distance Unit : ${unit.toString()}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    var isMile = unit == 1;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: material.Size.fromHeight(kToolbarHeight),
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
              stringLocalization.getText(StringLocalization.workoutRecord),
              style: TextStyle(color: HexColor.fromHex('62CBC9')),
              // .toUpperCase(),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Constants.navigatePush(WorkoutFeedPage(), context);
                },
                icon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? images.historyDarkIcon
                      : images.historyIcon,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.0.w),
                child: IconButton(
                    onPressed: () {
                      Constants.navigatePush(MapScreenTrackerSettings(), context);
                      // Constants.navigatePush(ActivityAnalysis(), context);
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Colors.grey,
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            builder: (context, snapshot) {
              print('map_error ${snapshot.hasData}');
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 180.0.h),
                  child: Consumer<LocationTrackProvider>(builder:
                      (BuildContext? context, LocationTrackProvider provider, Widget? child) {
                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(initLat, initLng),
                        zoom: 18,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        this.controller = controller;
                      },
                      zoomControlsEnabled: false,
                      markers: <Marker>{
                        Marker(
                          markerId: MarkerId('current_location'),
                          position: provider.locationList.isNotEmpty
                              ? LatLng(
                                  provider.locationList.last.latitude!,
                                  provider.locationList.last.longitude!,
                                )
                              : LatLng(initLat, initLng),
                        ),
                      },
                      polylines: <Polyline>{
                        Polyline(
                          polylineId: PolylineId('route'),
                          points: provider.locationList
                              .map((e) => LatLng(e.latitude!, e.longitude!))
                              .toList(),
                          width: 5,
                          color: Colors.red,
                        ),
                      },
                    );
                    /*return FlutterMap(
                      options: MapOptions(
                        center: LatLng(initLat, initLng),
                        zoom: 18.0,
                        maxZoom: 18,
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
                        MarkerLayerOptions(
                          markers: [
                            Marker(
                              width: 45.0,
                              height: 45.0,
                              point: provider.locationList.isNotEmpty
                                  ? LatLng(
                                      provider.locationList.last.latitude!,
                                      provider.locationList.last.longitude!,
                                    )
                                  : LatLng(initLat, initLng),
                              builder: (ctx) =>
                                  Icon(Icons.location_on, color: Colors.black),
                            ),
                          ],
                        ),
                        PolylineLayerOptions(polylines: [
                          Polyline(
                            points: provider.locationList
                                .map((e) => LatLng(e.latitude!, e.longitude!))
                                .toList(),
                            strokeWidth: 5,
                            color: Colors.red,
                          )
                        ]),
                        //                  LocationMarkerLayerOptions(),
                      ],
                    );*/
                  }),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
            future: getCurrentLocation(),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: Selector<SaveActivityScreenModel, int>(
                selector: (context, model) => model.currentSelectedActivityIndex!,
                builder: (context, value, _) {
                  return Container(
                    padding: EdgeInsets.only(top: 19.h, bottom: 11.h, left: 31.w),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityList(
                              onChangeActivity: (int value) {
                                var provider =
                                    Provider.of<LocationTrackProvider>(context, listen: false);
                                if (provider.isStarted) {
                                  stopMode().then((value) {
                                    startMode();
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            height: 43.h,
                            width: 43.h,
                            child: Image.asset(provider
                                .activityOptions[provider.currentSelectedActivityIndex!].image!),
                          ),
                          SizedBox(
                            width: 14.w,
                          ),
                          Text(
                            '${provider.activityOptions[provider.currentSelectedActivityIndex!].title!.toUpperCase()}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341')),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),

          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 91.h, horizontal: 15.w),
              child: GestureDetector(
                onTap: () {
                  animateToCurrentLocation(controller!);
                },
                child: Container(
                  height: 43.h,
                  width: 43.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
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
                  child: Padding(
                    padding: EdgeInsets.all(6.h),
                    child: Theme.of(context).brightness == Brightness.dark
                        ? Image.asset(
                            images.gpsIconDark,
                            height: 28,
                            width: 28,
                          )
                        : Image.asset(
                            images.gpsIconLight,
                            height: 28,
                            width: 28,
                          ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ButtonLayout(
                  onClickFinishButton: onClickFinishButton,
                  onClickStartButton: () {
                    onClickStartButton(
                        provider.activityOptions[provider.currentSelectedActivityIndex!]);
                  },
                ),
              ),
            ],
          ),

          /// Added by : Shahzad
          /// Added on : 3rd May 2021
          /// this shows the timer, average speed, distance travelled so far.

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 91.h, horizontal: 15.w),
              child: GestureDetector(
                onTap: takePicture,
                child: Container(
                  height: 43.h,
                  width: 43.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
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
                  child: Padding(
                    padding: EdgeInsets.all(6.h),
                    child: Theme.of(context).brightness == Brightness.dark
                        ? Image.asset(
                            images.cameraIconDark,
                            height: 28,
                            width: 28,
                          )
                        : Image.asset(
                            images.cameraIconLight,
                            height: 28,
                            width: 28,
                          ),
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails details) {
                var fractionalDrag = details.primaryDelta! / MediaQuery.of(context).size.height;
                if (fractionalDrag < 5) {
                  showBottomSheet(context, onClickFinishButton, onClickStartButton, unit);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('111B1A')
                      : AppColor.backgroundColor,
                ),
                height: 219.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Container(
                          height: 4,
                          width: 41,
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? AppColor.darkBackgroundColor
                                  : HexColor.fromHex('#D9E0E0'),
                              borderRadius: BorderRadius.all(Radius.circular(2.h)),
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#000000').withOpacity(0.5)
                                        : Colors.black87.withOpacity(0.5),
                                    offset: Offset(-1, -1))
                              ]),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        // padding: EdgeInsets.only(top: 23, left: 23),
                        height: 120.h,
                        child: Container(
                          margin: EdgeInsets.only(left: 30.w, top: 23.h, right: 30.w),
                          child: Selector<LocationTrackProvider, int>(
                            selector: (context, model) => model.countTime,
                            builder: (context, model, child) {
                              var provider =
                                  Provider.of<LocationTrackProvider>(context, listen: false);
                              var speed =
                                  double.parse(activityItems!.getSpeed(provider.locationList)) *
                                      3.6;

                              var avgSpeed =
                                  double.parse(activityItems!.getAvgSpeed(provider.locationList));

                              var distance =
                                  double.parse(activityItems!.getDistance(provider.locationList));

                              return PageView(
                                physics: PageScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: CustomBoxContainer(
                                            height: 79.h,
                                            padding: EdgeInsets.all(0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 40.sp,
                                                  child: Text(
                                                    speed
                                                        .toDouble()
                                                        .convertDistanceToUserUnit(isMile)
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                      fontSize: 38.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#FFFFFF')
                                                              .withOpacity(0.8)
                                                          : HexColor.fromHex('#384341'),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                  child: Text(
                                                    isMile
                                                        ? stringLocalization
                                                            .getText(StringLocalization.pace1)
                                                            .toUpperCase()
                                                        : stringLocalization
                                                            .getText(StringLocalization.pace)
                                                            .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#FFFFFF')
                                                              .withOpacity(0.6)
                                                          : HexColor.fromHex('#5D6A68'),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          child: CustomBoxContainer(
                                            height: 79.h,
                                            padding: EdgeInsets.all(0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 40.sp,
                                                  child: Text(
                                                    distance
                                                        .toDouble()
                                                        .convertDistanceToUserUnit(isMile)
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                      fontSize: 38.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#FFFFFF')
                                                              .withOpacity(0.8)
                                                          : HexColor.fromHex('#384341'),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                  child: Text(
                                                    '${stringLocalization.getText(StringLocalization.distance).toUpperCase()} ${isMile ? '(Mile)'.toUpperCase() : '(KM)'.toUpperCase()}',
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#FFFFFF')
                                                              .withOpacity(0.6)
                                                          : HexColor.fromHex('#5D6A68'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: CustomBoxContainer(
                                            height: 79.h,
                                            padding: EdgeInsets.all(0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 40.sp,
                                                  child: Text(
                                                    activityItems!
                                                        .convertSecToFormattedTime(
                                                            provider.countTime)
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 38.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#FFFFFF')
                                                              .withOpacity(0.8)
                                                          : HexColor.fromHex('#384341'),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                  child: Text(
                                                    stringLocalization
                                                        .getText(StringLocalization.duration)
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#FFFFFF')
                                                              .withOpacity(0.6)
                                                          : HexColor.fromHex('#5D6A68'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          child: CustomBoxContainer(
                                            height: 79.h,
                                            padding: EdgeInsets.all(0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 40.sp,
                                                  child: Text(
                                                    // distance <= 0.02
                                                    //     ? '0.00'
                                                    //     :
                                                    (avgSpeed * 3.6)
                                                        .toDouble()
                                                        .convertDistanceToUserUnit(isMile)
                                                        .toStringAsFixed(2),
                                                    style: TextStyle(
                                                      fontSize: 38.sp,
                                                      fontWeight: FontWeight.w600,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#FFFFFF')
                                                              .withOpacity(0.8)
                                                          : HexColor.fromHex('#384341'),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                  child: Text(
                                                    stringLocalization
                                                        .getText(StringLocalization.avgPace)
                                                        .toUpperCase(),
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w700,
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#FFFFFF')
                                                              .withOpacity(0.6)
                                                          : HexColor.fromHex('#5D6A68'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CustomBoxContainer(
                                          height: 79.h,
                                          width: 145.w,
                                          padding: EdgeInsets.all(0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 40.sp,
                                                child: Text(
                                                  '0',
                                                  style: TextStyle(
                                                    fontSize: 38.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex('#FFFFFF')
                                                            .withOpacity(0.8)
                                                        : HexColor.fromHex('#384341'),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                height: 20.h,
                                                child: Text(
                                                  stringLocalization
                                                      .getText(StringLocalization.calories)
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? HexColor.fromHex('#FFFFFF')
                                                            .withOpacity(0.6)
                                                        : HexColor.fromHex('#5D6A68'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    ButtonLayout(
                      onClickFinishButton: onClickFinishButton,
                      onClickStartButton: () {
                        onClickStartButton(
                            provider.activityOptions[provider.currentSelectedActivityIndex!]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Added by : Shahzad
          /// Added on : 3rd May 2021
          /// this shows the timer, average speed, distance travelled so far.
        ],
      ),
    );
  }

  void takePicture() async {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    provider.imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
        imageQuality: 100);
    if (provider.imageFile != null) {
      await _cropSelectedImage(File(provider.imageFile!.path));
    }
  }

  Future<void> _cropSelectedImage(File imageFile) async {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    var croppedFile = await ImageCropper.platform.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File? imageFile = File(croppedFile.path);
      provider.updateImage(imageFile);
    }
  }

  void onClickStartButton(TabModel? workoutType) {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    provider.startTime = DateTime.now();
    provider.countTime = 0;
    provider.isStarted = true;
    provider.locationList.clear();
    provider.locationListForFirebase.clear();
    provider.activityEventList.clear();
    provider.activityStillCount = false;
    provider.tempLocationList!.clear();
    provider.last5altitudeSum = 0;
    provider.last5LatSum = 0;
    provider.last5LongSum = 0;
    provider.last5speedSum = 0;
    provider.last5altitudeAvg = 0;
    provider.last5LatAvg = 0;
    provider.last5LongAvg = 0;
    provider.last5speedAvg = 0;
    provider.manuallyPause = false;
    provider.workoutType = workoutType;
    provider.trackLocationAndBuild(controller!);

    if (provider.timer != null && provider.timer!.isActive) {
      provider.cancelTimer();
    }
    startMode();
    provider.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      print("timer_tick ${timer.tick}");
      print("timer_tick ${provider.isPause}");
      if (provider.isPause) {
        provider.cancelTimer();
      } else {
        provider.updateTimeCount(1);
      }
    });
    provider.updateStartActivity(true);
  }

  void onClickFinishButton() {
    Location().enableBackgroundMode(enable: false);
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    var saveActivityProvider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    saveActivityProvider.activityImageModelList = provider.activityImageModelList;
    saveActivityProvider.activityImageModelOldList = provider.activityImageModelOldList;
    saveActivityProvider.activityImagesList = provider.activityImagesList;
    if (provider.timer != null) {
      provider.cancelTimer();
    }
    provider.disposeStream();
    Constants.navigatePush(
        SaveActivityScreen(provider.locationList, provider.countTime, LatLng(initLat, initLng)),
        context);

    // stopMode();
  }

  Future startMode() {
    return connections.checkAndConnectDeviceIfNotConnected().then((connectedDevice) {
      if (connectedDevice?.sdkType == Constants.e66) {
        connections.setHourlyHrMonitorOn(true, Constants.hrIntervalForSportModes);

        var saveProvider = Provider.of<SaveActivityScreenModel>(context, listen: false);
        var length = saveProvider.activityOptions.length;
        var current = saveProvider.currentSelectedActivityIndex;
        if (length > current!) {
          var mode = saveProvider.activityOptions[current].code!;
          connections.startMode(mode);
        }
      }
    });
  }

  Future stopMode() {
    var completer = Completer();
    connections.checkAndConnectDeviceIfNotConnected().then((connectedDevice) async {
      if (connectedDevice?.sdkType == Constants.e66) {
        var saveProvider = Provider.of<SaveActivityScreenModel>(context, listen: false);
        var length = saveProvider.activityOptions.length;
        var current = saveProvider.currentSelectedActivityIndex;
        if (length > current!) {
          var mode = saveProvider.activityOptions[current].code!;
          await connections.endMode(mode);
          setDefaultHrMonitor();
          var list = await collectHeartRateHistory();
          print('list $list');
          completer.complete();
        }
      }
    });

    print("Stop_mesurement");
    return completer.future;
  }

  Future collectHeartRateHistory() {
    var listOfHeartRate = [];
    var completer = Completer();
    connections.checkAndConnectDeviceIfNotConnected().then((connectedDevice) async {
      if (connectedDevice?.sdkType == Constants.e66) {
        var provider = Provider.of<LocationTrackProvider>(context, listen: false);
        var startDate = provider.startTime;
        var endDate = provider.endTime;
        final result = await connections.collectHeartRateHistory();
        if (result is List<HrMonitorModel>) {
          for (var element in result) {
            if (startDate != null && element.dateTime is DateTime) {
              var dataDate = element.dateTime;
              var isActivityData = (dataDate == startDate || dataDate == endDate) ||
                  (dataDate!.isAfter(startDate) && dataDate.isBefore(endDate));
              if (isActivityData) {
                listOfHeartRate.add(element);
              }
            }
          }
        }
        completer.complete(listOfHeartRate);
      }
    });
    return completer.future;
  }

  void setDefaultHrMonitor() {
    try {
      var isHourlyHrMonitorOn = preferences?.getBool(Constants.isHourlyHrMonitorOnKey) ?? true;
      var intHrMonitorTime = preferences?.getInt(Constants.heartRateInterval) ?? 10;

      connections.setHourlyHrMonitorOn(isHourlyHrMonitorOn, intHrMonitorTime);
    } catch (e) {
      print('Exception at setDefaultHrMonitor $e');
    }
  }

  void animateToCurrentLocation(GoogleMapController controller) {
    // return;
    try {
      location!
          .changeSettings(
        accuracy: LocationAccuracy.high,
      )
          .then(
        (value) {
          location!.getLocation().then((value) {
            initLat = value.latitude!;
            initLng = value.longitude!;

            /*controller.move(
              LatLng(initLat, initLng),
              18,
            );*/
            controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: LatLng(initLat, initLng), zoom: 18),
            ));
            setState(() {});
          });
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Widget getTitle() {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    return Text(
      provider.title!,
      style:
          TextStyle(color: HexColor.fromHex('62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Future<bool> getCurrentLocation() async {
    try {
      var provider = Provider.of<LocationTrackProvider>(context, listen: false);
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location!.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location!.requestService();
        if (!_serviceEnabled) {
          return false;
        }
      }

      _permissionGranted = await location!.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location!.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return false;
        }
      }
      var value = await location!.changeSettings(
        accuracy: LocationAccuracy.high,
      );
      print('Current_location ${value.toString()}');
      if (value != null) {
        if (Platform.isAndroid) {
          await location!.getLocation().then((value) {
            provider.lastLocation = LocationAddressModel(
              longitude: value.longitude,
              latitude: value.latitude,
              speed: value.speed,
              altitude: value.altitude,
              time: value.time,
            );
            initLat = value.latitude!;
            initLng = value.longitude!;
          });
          LocationServiceManager.getCurrentLocation('currentLocation');
        } else {
          try {
            await LocationServiceManager.getCurrentLocation('sadas').then((value) {
              provider.lastLocation = value;
              if (value != null) {
                initLat = value.latitude!;
                initLng = value.longitude!;
              }
            });
          } catch (e) {
            print('location_Exception ${e.toString()}');
          }
        }
      }
      return true;
    } catch (e) {
      print('Map_Exception ${e.toString()}');
      print(e);
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onGetHeartRateFromRunMode(int hR) {
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    // provider.heartRate.add(HeartRateModel(
    //     hr: hR,
    //     timeStamp: DateTime.now().millisecondsSinceEpoch,
    //     locationData: provider.lastLocation));
    // print('hr ============ ${provider.heartRate.toString()}');
  }

  @override
  void onGetBackgroundLocationData(LocationAddressModel locationModel) {
    print(locationModel);
    // TODO: implement onGetBackgroundLocationData
  }
}

void showBottomSheet(
    BuildContext context, Function onClickFinishButton, Function onClickStartButton, var unit) {
  var activityItems = CalculateActivityItems();
  bool isMile = unit == 1;
  showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Selector<LocationTrackProvider, int>(
            selector: (context, model) => model.countTime,
            builder: (context, model, child) {
              var provider = Provider.of<LocationTrackProvider>(context, listen: false);
              var speed = double.parse(activityItems.getSpeed(provider.locationList)) * 3.6;
              var avgSpeed = double.parse(activityItems.getAvgSpeed(provider.locationList));
              var distance = double.parse(activityItems.getDistance(provider.locationList));

              return Container(
                height: MediaQuery.of(context).size.height - 150.h,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 11.h,
                          width: 46.w,
                          child: Theme.of(context).brightness == Brightness.dark
                              ? Image.asset(images.downArrowDark)
                              : Image.asset(images.downArrowLight),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 125.h,
                    ),
                    CustomBoxContainer(
                      height: 107.h,
                      // width: 192.w,
                      padding: EdgeInsets.only(left: 18, right: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 60.sp,
                            child: Text(
                              activityItems.convertSecToFormattedTime(provider.countTime),
                              style: TextStyle(
                                fontSize: 52.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.8)
                                    : HexColor.fromHex('#384341'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 20.sp,
                            child: Text(
                              stringLocalization.getText(StringLocalization.duration).toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                    : HexColor.fromHex('#5D6A68'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 64.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomBoxContainer(
                          height: 89.h,
                          width: 144.w,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 45.sp,
                                child: Text(
                                  // '0.00',
                                  '${distance.toDouble().convertDistanceToUserUnit(isMile).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.8)
                                        : HexColor.fromHex('#384341'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 20.sp,
                                child: Text(
                                  '${stringLocalization.getText(StringLocalization.distance).toUpperCase()} ${isMile ? ('Mile').toUpperCase() : ('KM')}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                        : HexColor.fromHex('#5D6A68'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomBoxContainer(
                          height: 89.h,
                          width: 144.w,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 45.sp,
                                child: Text(
                                  '0',
                                  // distance <= 0.02
                                  //     ? '0.00'
                                  //     : '$distance',
                                  style: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.8)
                                        : HexColor.fromHex('#384341'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 20.sp,
                                child: Text(
                                  stringLocalization
                                      .getText(StringLocalization.calories)
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                        : HexColor.fromHex('#5D6A68'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 64.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CustomBoxContainer(
                          height: 89.h,
                          width: 144.w,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 45.sp,
                                child: Text(
                                  (speed)
                                      .toDouble()
                                      .convertDistanceToUserUnit(isMile)
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.8)
                                        : HexColor.fromHex('#384341'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 20.sp,
                                child: Text(
                                  isMile
                                      ? stringLocalization
                                          .getText(StringLocalization.pace1)
                                          .toUpperCase()
                                      : stringLocalization
                                          .getText(StringLocalization.pace)
                                          .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                        : HexColor.fromHex('#5D6A68'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomBoxContainer(
                          height: 89.h,
                          width: 144.w,
                          padding: EdgeInsets.zero,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 45.sp,
                                child: Text(
                                  (avgSpeed * 3.6)
                                      .toDouble()
                                      .convertDistanceToUserUnit(isMile)
                                      .toStringAsFixed(2),
                                  // distance <= 0.02
                                  //     ? '0.00'
                                  //     : '$distance',
                                  style: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.8)
                                        : HexColor.fromHex('#384341'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 20.sp,
                                child: Text(
                                  isMile
                                      ? stringLocalization
                                          .getText(StringLocalization.avgPace1)
                                          .toUpperCase()
                                      : 'Avg Speed (KM/HR)'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                                        : HexColor.fromHex('#5D6A68'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    ButtonLayout(
                      onClickFinishButton: () {
                        onClickFinishButton();
                      },
                      onClickStartButton: () {
                        onClickStartButton();
                      },
                    ),
                  ],
                ),
              );
            });
      });
}
