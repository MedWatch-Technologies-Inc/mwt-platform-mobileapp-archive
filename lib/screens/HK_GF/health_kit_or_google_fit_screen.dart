import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/health_kit_or_google_fit_model.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/CustomCalendar/date_picker_dialog.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'select_health_kit_or_google_fit_data_type_screen.dart';

/// Added by: Akhil
/// Added on: Oct/09/2020
/// this screen is for fetching healthKit data for iOS or googleFit data for android
class HealthKitOrGoogleFitScreen extends StatefulWidget {
  @override
  _HealthKitOrGoogleFitScreenState createState() => _HealthKitOrGoogleFitScreenState();
}

/// Added by: Akhil
/// Added on: Oct/09/2020
/// this screen is for fetching healthKit data for iOS or googleFit data for android
class _HealthKitOrGoogleFitScreenState extends State<HealthKitOrGoogleFitScreen> {
  DateTime endDate = DateTime.now();
  DateTime startDate = DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  /// Added by: Chaitanya
  /// Added on: Oct/8/2021
  /// this method is to get local time zone offset
  Duration timeZoneOffset = DateTime.now().timeZoneOffset;
  final DateFormat formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
  String? userId;

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  /// Added by: Akhil
  /// Added on: Oct/09/2020
  /// this wigdet is responsible for making UI for HealthKitOrGoogleFitScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
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
                      'asset/dark_leftArrow.png',
                      width: 13,
                      height: 22,
                    )
                  : Image.asset(
                      'asset/leftArrow.png',
                      width: 13,
                      height: 22,
                    ),
            ),
            title: Text(
              Platform.isIOS
                  ? StringLocalization.of(context).getText(StringLocalization.healthKit)
                  : StringLocalization.of(context).getText(StringLocalization.googleFit),
              style: TextStyle(
                  color: HexColor.fromHex('62CBC9'), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 33.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              stringLocalization.getText(StringLocalization.startDate),
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.white87
                      : AppColor.color384341),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.darkBackgroundColor
                    : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
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
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25.w),
                    child: Body1Text(
                      text: DateFormat(DateUtil.ddMMMMyyyy).format(
                        DateTime.parse(startDate.toString()),
                      ),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.white87
                          : AppColor.color384341,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.only(right: 20.w),
                    icon: Image.asset('asset/calendar_button.png'),
                    onPressed: () async {
                      var selectedDate = await showCustomDatePicker(
                            context: context,
                            initialDate:
                                checkDateIsBetweenOrNot(startDate) ? startDate : DateTime.now(),
                            firstDate: DateTime.now().subtract(Duration(days: 15)),
                            lastDate: DateTime.now(),
                            fieldHintText: stringLocalization.getText(StringLocalization.enterDate),
                            getDatabaseDataFrom: '',
                          ) ??
                          DateTime.now();
                      startDate = selectedDate;
                      setState(() {});
                    },
                  )
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              stringLocalization.getText(StringLocalization.endDate),
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.white87
                      : AppColor.color384341),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColor.darkBackgroundColor
                    : AppColor.backgroundColor,
                borderRadius: BorderRadius.circular(10.h),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                        : Colors.white,
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
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25.w),
                    child: Body1Text(
                      text: DateFormat(DateUtil.ddMMMMyyyy).format(
                        DateTime.parse(endDate.toString()),
                      ),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.white87
                          : AppColor.color384341,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //TODO: Fetch Button
              InkWell(
                onTap: () {
                  if (validateDate()) {
                    var mapData = getMapData..addAll({'isFetch': true});
                    Constants.navigatePush(
                      SelectHealthKitOrGoogleFitDataTypeScreen(mapData: mapData),
                      context,
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 10.h,
                  ),
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
                    ],
                  ),
                  child: Container(
                    decoration: ConcaveDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      depression: 3,
                      colors: [
                        Colors.white,
                        HexColor.fromHex('#D1D9E6'),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          stringLocalization.getText(StringLocalization.fetchAndNext),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#111B1A')
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //TODO: Skip button
              InkWell(
                onTap: () {
                  var mapData = getMapData..addAll({'isFetch': false});
                  Constants.navigatePush(
                    SelectHealthKitOrGoogleFitDataTypeScreen(mapData: mapData),
                    context,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.h),
                    border: Border.all(
                      color: HexColor.fromHex('#00AFAA'),
                      width: 1.5,
                    ),
                  ),
                  child: Container(
                    decoration: ConcaveDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.h),
                      ),
                      depression: 3,
                      colors: [
                        Colors.white,
                        HexColor.fromHex('#D1D9E6'),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Text(
                          stringLocalization.getText(StringLocalization.skipBtn),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: HexColor.fromHex('#00AFAA'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkDateIsBetweenOrNot(endDate1) =>
      endDate1.isBefore(DateTime.now()) &&
      endDate1.isAfter(DateTime.now().subtract(Duration(days: 15)));

  Map<String, dynamic> get getMapData => {
        'startDate': formatter.format(startDate),
        'endDate': formatter.format(DateTime.now()),
      };

  bool validateDate() {
    if (endDate.difference(startDate).inDays < 0) {
      return false;
    }
    return true;
  }

  Future getPreferences() async {
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    setState(() {});
  }
}
