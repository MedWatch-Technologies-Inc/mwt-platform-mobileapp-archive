import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:health_gauge/bloc/activity/activity_bloc.dart';
import 'package:health_gauge/bloc/activity/activity_event.dart';
import 'package:health_gauge/bloc/activity/activity_state.dart';
import 'package:health_gauge/extensions/distance_extension.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/map_screen/model/hr_monitor_model.dart';
import 'package:health_gauge/screens/map_screen/model/image_model.dart';
import 'package:health_gauge/screens/map_screen/providers/location_track_provider.dart';
import 'package:health_gauge/screens/map_screen/providers/save_activity_screen_model.dart';
import 'package:health_gauge/screens/map_screen/widgets/custom_map_divider.dart';
import 'package:health_gauge/screens/map_screen/widgets/save_workout_summary.dart';
import 'package:health_gauge/screens/map_screen/workout_feed_page.dart';
import 'package:health_gauge/screens/map_screen/workout_photos.dart';
import 'package:health_gauge/services/bloc/bloc_common_state.dart';
import 'package:health_gauge/services/location/model/location_model.dart';
import 'package:health_gauge/utils/calculate_activity_items.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'model/heart_rate_model.dart';

class SaveActivityScreen extends StatefulWidget {
  final List<LocationAddressModel> locationList;
  final int countTime;
  final LatLng currentLocation;

  @override
  _SaveActivityScreenState createState() => _SaveActivityScreenState();

  SaveActivityScreen(this.locationList, this.countTime, this.currentLocation);
}

class _SaveActivityScreenState extends State<SaveActivityScreen> {
  TextEditingController activityTitleController = TextEditingController(text: 'Untitled');
  TextEditingController activityDescriptionController = TextEditingController();
  CalculateActivityItems activityItems = CalculateActivityItems();
  ActivityBloc activityBloc = ActivityBloc();
  AppImages images = AppImages();

  @override
  void dispose() {
    super.dispose();
    activityBloc.close();
  }

  var unit;

  @override
  void initState() {
    stopMode();
    super.initState();
    unit = preferences?.getInt(Constants.mDistanceUnitKey) ?? 10;
  }

  @override
  Widget build(BuildContext context) {
    var locationProvider = Provider.of<LocationTrackProvider>(context, listen: false);
    var maxSpeed = (double.parse(activityItems.getMaxSpeed(locationProvider.locationList)) * 3.6)
        .toStringAsFixed(2);

    var avgSpeed = (double.parse(activityItems.getAvgSpeed(locationProvider.locationList)) * 3.6)
        .toStringAsFixed(2);

    var isMile = unit == 1;

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
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return CustomDialog(
                        title: stringLocalization.getText(StringLocalization.discardWorkout),
                        maxLine: 2,
                        subTitle: stringLocalization
                            .getText(StringLocalization.areYouSureYouWantToDiscardTheWorkout),
                        onClickYes: () {
                          Navigator.of(context).pop();
                          // resetConnectionPreferences();
                          onClickDiscard();
                        },
                        onClickNo: () {
                          Navigator.of(context).pop();
                        },
                      );
                    });
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
              stringLocalization.getText(StringLocalization.saveWorkout),
              style: TextStyle(color: HexColor.fromHex('62CBC9')),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Constants.navigatePush(WorkoutFeedPage(), context);
                },
                icon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? images.historyDarkIcon
                      : images.historyIcon,
                  // height: 33,
                  // width: 33,
                ),
              ),
            ],
            centerTitle: true,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocListener<ActivityBloc, ActivityState>(
              bloc: activityBloc,
              listener: (context, state) {
                if (state is SendActivityDataState) {
                  var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
                  if (state.status == Status.completed) {
                    locationProvider.locationList.clear();
                    locationProvider.heartRate = [];
                    locationProvider.updateTimeCount(0);
                    Constants.progressDialog(false, context);
                    resetActivityAndMoveToHistory(locationProvider, provider, context);
                  } else if (state.status == Status.error) {
                    Constants.progressDialog(false, context);
                    resetActivityAndMoveToHistory(locationProvider, provider, context);
                  }
                }
              },
              child: Container(),
            ),
            Container(
              height: 189.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.75)
                        : HexColor.fromHex('#D1D9E6'),
                    blurRadius: 4,
                    spreadRadius: 0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: target(), zoom: 16),
                polylines: polyLines(),
                markers: markers(),
                mapType: MapType.normal,
                compassEnabled: false,
                mapToolbarEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: (controller) {
                  // _setMapFitToTour(
                  //     widget.locationList, controller);
                },
              ),
            ),
            SizedBox(
              height: 21.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 13.w),
              child: Row(
                children: [
                  ShareTabs(),
                  SizedBox(
                    width: 25.w,
                  ),
                  ActivityTabs(),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            CustomMapDivider(),
            Container(
              margin: EdgeInsets.only(top: 12.h, left: 21.w, right: 21.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: SaveWorkoutSummary(images.calorieRed, '0',
                          stringLocalization.getText(StringLocalization.calories))),
                  Expanded(
                      child: SaveWorkoutSummary(
                          images.distanceRed,
                          activityItems.getDistance(widget.locationList),
                          stringLocalization.getText(StringLocalization.distanceKm))),
                  Expanded(
                      child: SaveWorkoutSummary(
                          images.durationRed,
                          activityItems.convertSecToFormattedTime(widget.countTime) ?? '0',
                          stringLocalization.getText(StringLocalization.duration))),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 16.h, bottom: 20.h, left: 13.w, right: 13.w),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColor.darkBackgroundColor
                            : HexColor.fromHex('#E5E5E5'),
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                : Colors.white.withOpacity(0.9),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(-4.w, -4.h),
                          ),
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.8)
                                : HexColor.fromHex('#9F2DBC').withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(4.w, 4.h),
                          ),
                        ],
                      ),
                      // height: 79.h,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.h)),
                            gradient: Theme.of(context).brightness == Brightness.dark
                                ? LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        HexColor.fromHex('#CC0A00').withOpacity(0.15),
                                        HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                      ])
                                : RadialGradient(colors: [
                                    HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                                    HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                                  ], stops: [
                                    0.6,
                                    1
                                  ])),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              double.parse(maxSpeed)
                                  .toDouble()
                                  .convertDistanceToUserUnit(isMile)
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 38.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                              ),
                            ),
                            SizedBox(
                              height: 3.h,
                            ),
                            Text(
                              isMile
                                  ? 'Max Speed (Mile/HR)'.toUpperCase()
                                  : stringLocalization
                                      .getText(StringLocalization.maxSpeed)
                                      .toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.6)
                                    : HexColor.fromHex('#5D6A68'),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 11.w,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColor.darkBackgroundColor
                            : HexColor.fromHex('#E5E5E5'),
                        borderRadius: BorderRadius.all(Radius.circular(10.h)),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                : Colors.white.withOpacity(0.9),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(-4.w, -4.h),
                          ),
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.8)
                                : HexColor.fromHex('#9F2DBC').withOpacity(0.2),
                            blurRadius: 4,
                            spreadRadius: 0,
                            offset: Offset(4.w, 4.h),
                          ),
                        ],
                      ),
                      // height: 79.h,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.h)),
                            gradient: Theme.of(context).brightness == Brightness.dark
                                ? LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                        HexColor.fromHex('#CC0A00').withOpacity(0.15),
                                        HexColor.fromHex('#9F2DBC').withOpacity(0.15),
                                      ])
                                : RadialGradient(colors: [
                                    HexColor.fromHex('#FFDFDE').withOpacity(0.5),
                                    HexColor.fromHex('#FFDFDE').withOpacity(0.0)
                                  ], stops: [
                                    0.6,
                                    1
                                  ])),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              (double.parse(activityItems
                                          .getAvgSpeed(locationProvider.locationList)) *
                                      3.6)
                                  .toDouble()
                                  .convertDistanceToUserUnit(isMile)
                                  .toStringAsFixed(2),
                              style: TextStyle(
                                fontSize: 38.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              isMile
                                  ? stringLocalization
                                      .getText(StringLocalization.avgPace1)
                                      .toUpperCase()
                                  : 'Avg Speed (KM/HR)'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.6)
                                    : HexColor.fromHex('#5D6A68'),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            CustomMapDivider(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 17.h, horizontal: 13.w),
              child: Row(
                children: [
                  Text(
                    stringLocalization.getText(StringLocalization.name).toUpperCase(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.87)
                            : HexColor.fromHex('#384341')),
                  ),
                  SizedBox(
                    width: 42.w,
                  ),
                  Expanded(
                    child: Selector<SaveActivityScreenModel, bool>(
                        selector: (context, model) => model.errorTitle!,
                        builder: (context, model, child) {
                          var provider =
                              Provider.of<SaveActivityScreenModel>(context, listen: false);
                          return TextFormField(
                            controller: activityTitleController,
                            inputFormatters: [
                              FilteringTextInputFormatter(RegExp(r'^\S.*$'), allow: true)
                            ],
                            onChanged: (val) {
                              if (val.trim() == '' && val.length == 1) {
                                val = '';
                                activityTitleController.text = activityTitleController.text.trim();
                                activityTitleController.text = '';
                                setState(() {
                                  activityTitleController.text =
                                      activityTitleController.text.trim();
                                });
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: provider.errorTitle!
                                    ? stringLocalization.getText(StringLocalization.enterTitle)
                                    : stringLocalization
                                        .getText(StringLocalization.morningWalk)
                                        .toUpperCase(),
                                hintStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: provider.errorTitle!
                                        ? HexColor.fromHex('FF6259')
                                        : Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white.withOpacity(0.38)
                                            : HexColor.fromHex('#7F8D8C'))),
                          );
                        }),
                  )
                ],
              ),
            ),
            CustomMapDivider(),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: 15.h, horizontal: 13.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stringLocalization.getText(StringLocalization.howWasYourRun).toUpperCase(),
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.87)
                            : HexColor.fromHex('#384341')),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: stringLocalization
                            .getText(StringLocalization.typeNotesHere)
                            .toUpperCase(),
                        hintStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.38)
                                : HexColor.fromHex('#7F8D8C'))),
                  )
                ],
              ),
            ),
            CustomMapDivider(),
            activitySlider(),
            CustomMapDivider(),
            Consumer<SaveActivityScreenModel>(
              builder: (context, model, child) {
                return Container(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: imagesWidget(),
                );
              },
            ),
            cancelSaveButton(),
          ],
        ),
      ),
    );
  }

  Set<Marker> markers() {
    if ((widget.locationList.length) > 1) {
      var firstPoint =
          LatLng(widget.locationList.first.latitude!, widget.locationList.first.longitude!);
      var lastPoint =
          LatLng(widget.locationList.last.latitude!, widget.locationList.last.longitude!);

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
      return {start, end};
    }
    return {};
  }

  LatLng target() {
    if (widget.locationList.isEmpty) {
      return widget.currentLocation;
    }
    return LatLng(widget.locationList.first.latitude!, widget.locationList.first.longitude!);
  }

  Widget cameraContainer() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(left: 13.w, top: 15.h, right: 13.w, bottom: 8.h),
        width: 109.w,
        height: 79.h,
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColor.darkBackgroundColor
                : AppColor.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
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
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 33.w, vertical: 18.h),
            child: Image.asset(
              images.mapCameraIcon,
              height: 43.w,
              width: 43.w,
            )),
      ),
      onTap: showImagePickerDialog,
    );
  }

  void onClickDiscard() {
    // stopMode();
    var provider1 = Provider.of<LocationTrackProvider>(context, listen: false);
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    provider.activityImageModelOldList!.clear();
    provider.activityImageModelList!.clear();
    provider.activityImagesList!.clear();
    provider1.discardActivity();
    provider1.locationList.clear();
    provider1.activityEventList.clear();
    provider1.locationListForFirebase.clear();
    provider1.isStarted = false;
    provider1.isPause = false;
    provider1.countTime = 0;
    provider1.activityImagesList!.clear();
    provider1.activityImageModelList!.clear();
    provider1.activityImageModelOldList!.clear();
    if (provider1.timer != null && provider1.timer!.isActive) {
      provider1.timer!.cancel();
    }
    Navigator.of(context).pop();
  }

  Widget cancelSaveButton() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColor.darkBackgroundColor
          : AppColor.backgroundColor,
      margin: EdgeInsets.only(left: 33.w, right: 33.w, bottom: 41.h),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.h),
                      color: HexColor.fromHex('#FF6259').withOpacity(0.8),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                              : Colors.white,
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(-5, -5),
                        ),
                        BoxShadow(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.black.withOpacity(0.75)
                              : HexColor.fromHex('#D1D9E6'),
                          blurRadius: 5,
                          spreadRadius: 0,
                          offset: Offset(5, 5),
                        ),
                      ]),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: ConcaveDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.h),
                        ),
                        depression: 11,
                        colors: [
                          Colors.white,
                          HexColor.fromHex('#D1D9E6'),
                        ]),
                    child: Center(
                      child: Body1AutoText(
                        text: stringLocalization.getText(StringLocalization.discard).toUpperCase(),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#111B1A')
                            : Colors.white,
                        minFontSize: 10,
                        // maxLine: 1,
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return CustomDialog(
                          title: stringLocalization.getText(StringLocalization.discardWorkout),
                          maxLine: 2,
                          subTitle: stringLocalization
                              .getText(StringLocalization.areYouSureYouWantToDiscardTheWorkout),
                          onClickYes: () {
                            Navigator.of(context).pop();
                            // resetConnectionPreferences();
                            onClickDiscard();
                          },
                          onClickNo: () {
                            Navigator.of(context).pop();
                          },
                        );
                      });
                }),
          ),
          SizedBox(width: 17.w),
          Expanded(
              child: GestureDetector(
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.h),
                        color: HexColor.fromHex('#00AFAA'),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                                : Colors.white,
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(-5, -5),
                          ),
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withOpacity(0.75)
                                : HexColor.fromHex('#D1D9E6'),
                            blurRadius: 5,
                            spreadRadius: 0,
                            offset: Offset(5, 5),
                          ),
                        ]),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: ConcaveDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.h),
                          ),
                          depression: 11,
                          colors: [
                            Colors.white,
                            HexColor.fromHex('#D1D9E6'),
                          ]),
                      child: Center(
                        child: Body1AutoText(
                          text: stringLocalization.getText(StringLocalization.save).toUpperCase(),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? HexColor.fromHex('#111B1A')
                              : Colors.white,
                          minFontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    //

                    onClickSave(context);
                  })),
        ],
      ),
    );
  }

  Future<void> onClickSave(BuildContext context) async {
    try {
      // await stopMode();
      var isInternetAvailable = await Constants.isInternetAvailable();
      if (isInternetAvailable) {
        var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
        validateTitle();
        var provider1 = Provider.of<LocationTrackProvider>(context, listen: false);
        provider1.endTime = DateTime.now();
        Constants.progressDialog(true, context);

        var imageList = <ImageModel>[];
        if (provider1.mapImage != null) {
          imageList.add(provider1.mapImage!);
        }
        for (var i = 0; i < provider.activityImagesList!.length; i++) {
          var model = ImageModel(
            fileName: '$i-${DateTime.now().toString()}',
            fileContent: base64Encode(provider.activityImagesList![i]),
          );
          imageList.add(model);
        }
        try {
          var isInternet = await Constants.isInternetAvailable();
          if (isInternet) {
            imageList = await provider1.uploadImages(imageList);
          }
        } catch (e) {
          print('Exception at upload image $e');
        }
        var requestModel = provider1.getModelForApiCall(
            activityTitleController.text,
            activityDescriptionController.text,
            provider.selectedActivity,
            imageList,
            provider1.countTime);
        var userId = preferences!.getString(Constants.prefUserIdKeyInt);
        var dateTime = DateFormat(DateUtil.yyyyMMddHHmmss).format(provider1.startTime!);

        activityBloc.add(SendActivityDataEvent(
          request: requestModel,
          userId: userId!,
          date: dateTime,
        ));
      } else {
        var dialog = CustomInfoDialog(
          title: stringLocalization.getText(StringLocalization.pleaseConnectTheInternet),
          maxLine: 2,
          primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
          onClickYes: () {
            Navigator.of(context).pop();
          },
        );
        showDialog(
            context: context,
            useRootNavigator: false,
            builder: (context) => dialog,
            barrierDismissible: false);
      }
    } catch (e) {
      print('Exception at onClickSave $e');
      Constants.progressDialog(false, context);
    }
  }

  Future stopMode() {
    var completer = Completer();
    var provider = Provider.of<LocationTrackProvider>(context, listen: false);
    connections.checkAndConnectDeviceIfNotConnected().then((connectedDevice) async {
      if (connectedDevice?.sdkType == Constants.e66) {
        var saveProvider = Provider.of<SaveActivityScreenModel>(context, listen: false);
        var length = saveProvider.activityOptions.length;
        var current = saveProvider.currentSelectedActivityIndex ?? 0;
        if (length > current) {
          var mode = saveProvider.activityOptions[current].code ?? 0;
          await connections.endMode(mode);
          setDefaultHrMonitor();
          List<HrMonitorModel> list = await collectHeartRateHistory();
          if (list != null && list.isNotEmpty) {
            for (var data in list) {
              try {
                var time = data.dateTime!; // 4 : 5
                var locationPointWithSameHourAndMinute = provider.locationList.where((element) {
                  var dt = DateTime.fromMillisecondsSinceEpoch(element.time!.toInt());
                  if (dt.hour == time.hour && dt.minute == time.minute) {
                    return true;
                  }
                  return false;
                }).toList();
                var avgSpeed = 0.0;
                var count = 0;
                var avgElevation = 0.0;
                if (locationPointWithSameHourAndMinute.isNotEmpty) {
                  for (var element in locationPointWithSameHourAndMinute) {
                    if (element.speed != null &&
                        element.altitude != null &&
                        element.speed! > 0 &&
                        element.altitude! > 0) {
                      avgSpeed += element.speed!;
                      avgElevation += element.altitude!;
                      count++;
                    }
                  }
                  if (count != 0) {
                    avgSpeed = avgSpeed / count;
                    avgElevation = avgElevation / count;
                  }
                  provider.heartRate.add(HeartRateModel(
                      hr: data.heartRate!.toInt(),
                      speed: avgSpeed,
                      elevation: avgElevation,
                      timeStamp: data.dateTime!.millisecondsSinceEpoch,
                      locationData: locationPointWithSameHourAndMinute.last));
                } else {
                  // there is heart data but no location data
                }
              } catch (e) {
                print(e);
              }
            }
          }
          print('list $list');
          completer.complete();
        }
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

  Future collectHeartRateHistory() {
    var listOfHeartRate = <HrMonitorModel>[];
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

  void resetActivityAndMoveToHistory(
      LocationTrackProvider provider1, SaveActivityScreenModel provider, BuildContext context) {
    provider1.locationList.clear();
    provider1.locationListForFirebase.clear();
    provider1.isStarted = false;
    provider1.isPause = false;
    provider1.typeTitle = provider.selectedActivity!;
    provider1.activityIntensity = provider.value!;
    provider1.countTime = 0;
    provider.activityImageModelOldList!.clear();
    provider.activityImageModelList!.clear();
    provider.activityImagesList!.clear();
    Constants.navigatePushReplace(WorkoutFeedPage(), context);
  }

  Set<Polyline> polyLines() {
    try {
      return {
        Polyline(
          points: widget.locationList.map((e) => LatLng(e.latitude!, e.longitude!)).toList(),
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

  Widget activitySlider() {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    return Container(
        margin: EdgeInsets.only(
          top: 15.h,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 13.0.w),
            child: Text(
              stringLocalization.getText(StringLocalization.intensity).toUpperCase(),
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.h),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 21.h, left: 33.w, right: 33.w),
                  height: 16.h,
                  child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 11,
                        crossAxisSpacing: 28.w,
                        childAspectRatio: 0.1,
                      ),
                      itemCount: 11,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 5.w, top: 4.h, right: 5.w),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 8.h,
                          width: 1.w,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.38)
                              : HexColor.fromHex('#A7B2AF'),
                        );
                      })),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                    child: SliderTheme(
                      data: SliderThemeData(
                        thumbColor: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#99D9D9')
                            : HexColor.fromHex('#62CBC9'),
                        activeTrackColor: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#62CBC9')
                            : HexColor.fromHex('#99D9D9'),
                        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : HexColor.fromHex('#D9E0E0'),
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.w),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 24.w),
                        overlayColor: HexColor.fromHex('#99D9D9').withOpacity(0.5),
                        inactiveTickMarkColor: Colors.transparent,
                        activeTickMarkColor: Colors.transparent,
                        valueIndicatorColor: HexColor.fromHex('#FF6259'),
                        valueIndicatorTextStyle: TextStyle(
                            color: HexColor.fromHex('#FFDFDE'),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                        trackShape: RoundedRectSliderTrackShape(),
                        trackHeight: 4.h,
                      ),
                      child: Selector<SaveActivityScreenModel, double>(
                          selector: (context, model) => model.value!,
                          builder: (context, model, child) {
                            return Slider(
                              value: provider.value!,
                              min: provider.min!,
                              max: provider.max!,
                              divisions: provider.precision,
                              label: provider.value!.round().toString(),
                              onChanged: (double selectedValue) {
                                provider.onChange(selectedValue);
                              },
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 33.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleText(
                  text:
                      StringLocalization.of(context).getText(StringLocalization.easy).toUpperCase(),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#5D6A68'),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
                TitleText(
                  text: StringLocalization.of(context)
                      .getText(StringLocalization.moderate)
                      .toUpperCase(),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#5D6A68'),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
                TitleText(
                  text:
                      StringLocalization.of(context).getText(StringLocalization.max).toUpperCase(),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#5D6A68'),
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 22.h),
        ]));
  }

  Widget imagesWidget() {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    return Center(
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.4,
            ),
            itemCount: provider.activityImagesList!.length + 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (index == provider.activityImagesList!.length) {
                return cameraContainer();
              }
              return Stack(alignment: Alignment.topRight, children: [
                Container(
                    margin: EdgeInsets.only(left: 13.w, right: 13.w, top: 15.h, bottom: 4.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
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
                    child: InkWell(
                      onLongPress: () {
                        HapticFeedback.vibrate();
                        provider.imageEditing();
                      },
                      onTap: () {
                        if (provider.isImageEditing!) {
                          provider.imageNotEditing();
                        } else {
                          Constants.navigatePush(WorkoutPhotos(), context);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.w),
                        child: Image.memory(
                          provider.activityImagesList![index],
                          // height: 86.h,
                          width: 109.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )),
                provider.isImageEditing!
                    ? Stack(
                        alignment: Alignment.topRight,
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              provider.removeImage(index);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 11.h),
                              height: 21.h,
                              width: 21.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: HexColor.fromHex('#FF6259'),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: AppColor.backgroundColor,
                                  size: 15.h,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ]);
            }),
      ),
    );
  }

  Widget fullImage(Uint8List image) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? HexColor.fromHex('#111B1A')
                  : AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10.w),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5),
                ),
                BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.75)
                      : HexColor.fromHex('#384341').withOpacity(0.9),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5),
                ),
              ]),
          width: 309.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.w),
            child: Image.memory(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  void showImagePickerDialog() {
    var dialog = Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.h),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? HexColor.fromHex('#111B1A')
            : AppColor.backgroundColor,
        child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#111B1A')
                    : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(-5, -5),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#000000').withOpacity(0.75)
                        : HexColor.fromHex('#384341').withOpacity(0.9),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: Offset(5, 5),
                  ),
                ]),
            width: 309.w,
            height: 150.h,
            child: ListView(
              children: ListTile.divideTiles(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.15)
                    : HexColor.fromHex('#D9E0E0'),
                context: context,
                tiles: [
                  photoLibrary(),
                  takePhoto(),
                ],
              ).toList(),
              physics: NeverScrollableScrollPhysics(),
            )));
    showDialog(context: context, useRootNavigator: true, builder: (context) => dialog);
  }

  Widget photoLibrary() {
    return Container(
      height: 69.h,
      child: Center(
        child: ListTile(
            onTap: () {
              if (context != null) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              chooseFromGallery();
            },
            trailing: Image.asset(images.galleryIcon,
                height: 33.h,
                width: 33.h,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#62CBC9')
                    : null),
            title: Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.photoLibrary),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            )),
      ),
    );
  }

  Widget takePhoto() {
    return Container(
      height: 64.h,
      child: Center(
        child: ListTile(
            onTap: () {
              if (context != null) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              takePicture();
            },
            trailing: Image.asset(images.cameraIcon,
                height: 33.h,
                width: 33.h,
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#62CBC9')
                    : null),
            title: Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.takePhoto),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            )),
      ),
    );
  }

  void chooseFromGallery() async {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    provider.imageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.height,
    );
    if (provider.imageFile != null) {
      await _cropSelectedImage(File(provider.imageFile!.path));
    }
  }

  void takePicture() async {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    provider.imageFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
        imageQuality: 100);
    if (provider.imageFile != null) {
      await _cropSelectedImage(File(provider.imageFile!.path));
    }
  }

  Future<void> _cropSelectedImage(File imageFile) async {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
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

  void validateTitle() {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    if (activityTitleController.text.trim().isEmpty) {
      provider.isTitleError(false);
      activityTitleController.text = 'Untitled';
    } else {
      provider.isTitleError(false);
    }
  }
}

class ActivityTabs extends StatefulWidget {
  const ActivityTabs({Key? key}) : super(key: key);

  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTabs> {
  void selectActivityBottomSheet() {
    showModalBottomSheet(
        isDismissible: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  height: 4,
                  width: 50,
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
                Container(
                  height: 350.h,
                  padding: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: ListView.builder(
                      itemCount: provider.activityOptions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            provider.updateActivityIndex(index);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 22.h, left: 26.w),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Image.asset(
                                  provider.activityOptions[index].image!,
                                  height: 33.w,
                                  width: 33.w,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text(provider.activityOptions[index].title!),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50.w,
                  height: 42.h,
                  margin: EdgeInsets.only(bottom: 41.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                            : Colors.white,
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(-10, -10),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.25)
                            : HexColor.fromHex('#D1D9E6'),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(10, 10),
                      ),
                    ],
                  ),
                  child: TextButton(
                    child: Body1Text(
                      text: stringLocalization.getText(StringLocalization.close),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68'),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      align: TextAlign.center,
                      maxLine: 1,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    return GestureDetector(
      onTap: selectActivityBottomSheet,
      child: Selector<SaveActivityScreenModel, int>(
        selector: (context, model) => model.currentSelectedActivityIndex!,
        builder: (context, value, _) {
          return Row(
            children: [
              ImageContainer(
                  provider.activityOptions[provider.currentSelectedActivityIndex!].image!),
              SizedBox(
                width: 14.w,
              ),
              Text(
                '${provider.activityOptions[provider.currentSelectedActivityIndex!].title!.toUpperCase()}',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.6)
                        : Color(0xff5D6A68)),
              )
            ],
          );
        },
      ),
    );
  }
}

class ShareTabs extends StatefulWidget {
  const ShareTabs({Key? key}) : super(key: key);

  @override
  _ShareTabState createState() => _ShareTabState();
}

class _ShareTabState extends State<ShareTabs> {
  void selectShareBottomSheet() {
    showModalBottomSheet(
        isDismissible: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : AppColor.backgroundColor,
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  height: 4.h,
                  width: 50.w,
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
                Container(
                  height: 200.h,
                  padding: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#111B1A')
                          : AppColor.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                  child: ListView.builder(
                      itemCount: provider.shareOptions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            provider.updateShareIndex(index);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(bottom: 22.h, left: 26.w),
                            child: Row(
                              children: [
                                Image.asset(
                                  provider.shareOptions[index].image!,
                                  height: 33.w,
                                  width: 33.w,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Text(provider.shareOptions[index].title!),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50.w,
                  height: 42.h,
                  margin: EdgeInsets.only(bottom: 41.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#111B1A')
                        : AppColor.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                            : Colors.white,
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(-10, -10),
                      ),
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.25)
                            : HexColor.fromHex('#D1D9E6'),
                        blurRadius: 20,
                        spreadRadius: 0,
                        offset: Offset(10, 10),
                      ),
                    ],
                  ),
                  child: TextButton(
                    child: Body1Text(
                      text: stringLocalization.getText(StringLocalization.close),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.6)
                          : HexColor.fromHex('#5D6A68'),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      align: TextAlign.center,
                      maxLine: 1,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<SaveActivityScreenModel>(context, listen: false);
    return GestureDetector(
      onTap: selectShareBottomSheet,
      child: Selector<SaveActivityScreenModel, int>(
        selector: (context, model) => model.currentShareOptionIndex!,
        builder: (context, val, _) {
          return Row(
            children: [
              ImageContainer(provider.shareOptions[provider.currentShareOptionIndex!].image!),
              SizedBox(
                width: 14.w,
              ),
              Text(
                '${provider.shareOptions[provider.currentShareOptionIndex!].title!.toUpperCase()}',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.6)
                        : Color(0xff5D6A68)),
              )
            ],
          );
        },
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String image;

  const ImageContainer(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47.w,
      height: 47.w,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
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
      child: Container(
        margin: EdgeInsets.all(7.w),
        child: Image.asset(
          image,
          height: 33.w,
          width: 33.w,
        ),
      ),
    );
  }
}
