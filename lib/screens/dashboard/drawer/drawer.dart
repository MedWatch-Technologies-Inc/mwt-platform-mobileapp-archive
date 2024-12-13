// ignore_for_file: type_annotate_public_apis, deprecated_export_use, unrelated_type_equality_checks

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/screens/dashboard/drawer/user_image.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../widgets/custom_switch.dart';

class DrawerForDashboard extends StatefulWidget {
  final ValueNotifier<UserModel?> userNotifier;
  final String userEmail;
  final GestureTapCallback onClickProfile;
  final GestureTapCallback onClickSettingScreen;
  final GestureTapCallback onClickTermsAndCondition;
  final GestureTapCallback onClickSignOut;
  final GestureTapCallback onClickHistory;
  final GestureTapCallback onClickMeasurementHistory;
  final GestureTapCallback onClickHeartRateHistory;
  final GestureTapCallback onClickBloodPressureHistory;
  final GestureTapCallback onClickSPO2History;
  final GestureTapCallback onClickWeightScreen;

  final Function(bool isEnable) onUOFAClick;

  final bool showHistory;

  @override
  _DrawerForDashboardState createState() => _DrawerForDashboardState();

  const DrawerForDashboard({
    required this.userNotifier,
    required this.userEmail,
    required this.onClickProfile,
    required this.onClickSettingScreen,
    required this.onClickTermsAndCondition,
    required this.onClickSignOut,
    required this.onClickHistory,
    required this.onClickMeasurementHistory,
    required this.showHistory,
    required this.onClickHeartRateHistory,
    required this.onClickWeightScreen,
    required this.onClickBloodPressureHistory,
    required this.onClickSPO2History,
    required this.onUOFAClick,
    Key? key,
  }) : super(key: key);
}

class _DrawerForDashboardState extends State<DrawerForDashboard> {
  ///Wifi-Connect
  Socket? socket;
  var _incomingMessage;
  File? HFile;
  String? wifiIP;

  late IO.Socket socket_;
  int size = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    return Container(
      height: MediaQuery.of(context).size.height,
      color: isDarkMode(context) ? AppColor.darkBackgroundColor : AppColor.backgroundColor,
      width: 309.w,
      child: Column(
        children: <Widget>[
          Container(
              height: 251.h,
              width: 309.w,
              padding: EdgeInsets.only(left: 29.w, top: 58.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 105.h,
                        width: 105.h,
                        child: Image.asset(
                          isDarkMode(context)
                              ? 'asset/imageBackground_dark.png'
                              : 'asset/imageBackground_light.png',
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.all(20.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(36.5.h),
                              child: ValueListenableBuilder(
                                valueListenable: widget.userNotifier,
                                builder: (BuildContext context, UserModel? value, Widget? child) {
                                  return UserImage(user: value);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 17.h),
                  Container(
                    height: 23.h,
                    child: ValueListenableBuilder(
                      valueListenable: widget.userNotifier,
                      builder: (BuildContext context, UserModel? value, Widget? child) {
                        if (value?.userName != null && value!.userName!.trim().isNotEmpty) {
                          return TitleText(
                            text: value.userName!,
                            color: isDarkMode(context)
                                ? Colors.white.withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          );
                        }
                        return child!;
                      },
                      child: Container(),
                    ),
                  ),
                  Container(
                    height: 23.h,
                    child: TitleText(
                      text: (widget.userEmail != null && widget.userEmail.isNotEmpty)
                          ? widget.userEmail
                          : '',
                      color: isDarkMode(context)
                          ? Colors.white.withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      maxLine: 1,
                    ),
                  ),
                ],
              )),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color:
                      isDarkMode(context) ? AppColor.darkBackgroundColor : AppColor.backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode(context) ? Colors.black.withOpacity(0.6) : Colors.white,
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(-5, -5),
                    )
                  ]),
              child: ListView(
                key: Key('drawerItems'),
                padding: EdgeInsets.all(0),
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: Key('profile'),
                      onTap: widget.onClickProfile,
                      child: Container(
                        height: 33.h,
                        width: 309.w,
                        margin: EdgeInsets.only(top: 20.h),
                        padding: EdgeInsets.only(left: 21.w),
                        child: Row(
                          children: [
                            Image.asset(
                              'asset/profile_icon.png',
                            ),
                            SizedBox(width: 16.w),
                            TitleText(
                              text: stringLocalization.getText(StringLocalization.profile),
                              fontSize: 16.sp,
                              color: isDarkMode(context)
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: Key('drawerSettings'),
                      onTap: widget.onClickSettingScreen,
                      child: Container(
                        height: 33.h,
                        width: 309.w,
                        margin: EdgeInsets.only(top: 20.h),
                        padding: EdgeInsets.only(left: 21.w),
                        child: Row(
                          children: [
                            Image.asset(
                              'asset/settings_icon.png',
                            ),
                            SizedBox(width: 16.w),
                            TitleText(
                              text: stringLocalization.getText(StringLocalization.settingScreen),
                              fontSize: 16.sp,
                              color: isDarkMode(context)
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: Key('clickonweightmeasurement'),
                      onTap: widget.onClickWeightScreen,
                      child: Container(
                        height: 33.h,
                        width: 309.w,
                        margin: EdgeInsets.only(top: 20.h),
                        padding: EdgeInsets.only(left: 21.w),
                        child: Row(
                          children: [
                            Image.asset(
                              'asset/weight_setting.png',
                              height: !isMyTablet ? 33.h : 20.h,
                              width: !isMyTablet ? 33.h : 20.h,
                            ),
                            SizedBox(width: 16.w),
                            TitleText(
                              text:
                                  stringLocalization.getText(StringLocalization.weightMeasurement),
                              fontSize: 16.sp,
                              color: isDarkMode(context)
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: Key('openHistory'),
                      onTap: widget.onClickHistory,
                      child: Container(
                        height: 33.h,
                        width: 309.w,
                        margin: EdgeInsets.only(top: 20.h),
                        padding: EdgeInsets.only(left: 21.w),
                        child: Row(
                          children: [
                            Image.asset(
                              'asset/history_icon.png',
                            ),
                            SizedBox(width: 16.w),
                            TitleText(
                                text: stringLocalization.getText(StringLocalization.history),
                                fontSize: 16.sp,
                                color: isDarkMode(context)
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341')),
                            SizedBox(
                              width: 30.w,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: widget.showHistory ? 25.w : 30.w),
                                  child: Image.asset(
                                    !widget.showHistory
                                        ? isDarkMode(context)
                                            ? 'asset/right_setting_dark.png'
                                            : 'asset/right_setting.png'
                                        : isDarkMode(context)
                                            ? 'asset/up_arrow_dark.png'
                                            : 'asset/up_arrow_icon.png',
                                    height: widget.showHistory ? 10 : 14,
                                    width: widget.showHistory ? 20 : 8,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.showHistory,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: Key('openMeasurementHistory'),
                        onTap: widget.onClickMeasurementHistory,
                        child: Container(
                          height: 33.h,
                          width: 309.w,
                          margin: EdgeInsets.only(top: 20.h),
                          padding: EdgeInsets.only(left: 21.w),
                          child: Row(
                            children: [
                              SizedBox(width: 42.w),
                              TitleText(
                                text: stringLocalization
                                    .getText(StringLocalization.measurementHistory),
                                fontSize: 16.sp,
                                color: isDarkMode(context)
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.showHistory,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: Key('clickonHearthistory'),
                        onTap: widget.onClickHeartRateHistory,
                        child: Container(
                          height: 33.h,
                          width: 309.w,
                          margin: EdgeInsets.only(top: 20.h),
                          padding: EdgeInsets.only(left: 21.w),
                          child: Row(
                            children: [
                              SizedBox(width: 42.w),
                              Expanded(
                                child: TitleText(
                                  text: stringLocalization
                                      .getText(StringLocalization.heartRateHistory),
                                  fontSize: 16.sp,
                                  maxLine: 2,
                                  color: isDarkMode(context)
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.showHistory,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: Key('onClickBloodPressureHistory'),
                        onTap: widget.onClickBloodPressureHistory,
                        child: Container(
                          height: 33.h,
                          width: 309.w,
                          margin: EdgeInsets.only(top: 20.h),
                          padding: EdgeInsets.only(left: 21.w),
                          child: Row(
                            children: [
                              SizedBox(width: 42.w),
                              Expanded(
                                child: TitleText(
                                  text: stringLocalization
                                      .getText(StringLocalization.bloodPressureHistory),
                                  fontSize: 16.sp,
                                  maxLine: 2,
                                  color: isDarkMode(context)
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.showHistory,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: Key('onClickSPO2History'),
                        onTap: widget.onClickSPO2History,
                        child: Container(
                          height: 33.h,
                          width: 309.w,
                          margin: EdgeInsets.only(top: 20.h),
                          padding: EdgeInsets.only(left: 21.w),
                          child: Row(
                            children: [
                              SizedBox(width: 42.w),
                              Expanded(
                                child: TitleText(
                                  text: stringLocalization.getText(StringLocalization.spO2),
                                  fontSize: 16.sp,
                                  maxLine: 2,
                                  color: isDarkMode(context)
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: Key('clickonTermsAndConditions'),
                      onTap: widget.onClickTermsAndCondition,
                      child: Container(
                        height: 33.h,
                        width: 309.w,
                        margin: EdgeInsets.only(top: 20.h),
                        padding: EdgeInsets.only(left: 21.w, right: 10.w),
                        child: Row(
                          children: [
                            Image.asset(
                              'asset/terms_icon.png',
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Body1AutoText(
                                text: StringLocalization.of(context)
                                    .getText(StringLocalization.termsAndConditions),
                                fontSize: 16.sp,
                                color: isDarkMode(context)
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: Key('logOutButton'),
                      onTap: widget.onClickSignOut,
                      child: Container(
                        height: 33.h,
                        width: 309.w,
                        margin: EdgeInsets.only(top: 20.h),
                        padding: EdgeInsets.only(left: 21.w),
                        child: Row(
                          children: [
                            Image.asset(
                              'asset/signout_icon.png',
                            ),
                            SizedBox(width: 16.w),
                            TitleText(
                                text: stringLocalization.getText(StringLocalization.btnLogout),
                                fontSize: 16.sp,
                                color: isDarkMode(context)
                                    ? Colors.white.withOpacity(0.87)
                                    : HexColor.fromHex('#384341')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
          Container(
            height: 30.h,
            width: 309.w,
            padding: EdgeInsets.only(left: 28.w, top: 5.h),
            child: FutureBuilder(
              future: getVersion(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Body2Text(
                  text:
                      '${StringLocalization.of(context).getText(StringLocalization.version)} : ${snapshot.data}',
                  align: TextAlign.left,
                  color: isDarkMode(context)
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#5D6A68'),
                  fontSize: 12.sp,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  bool isDarkMode(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  Future getVersion() async {
    try {
      var packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version.toString()} (${packageInfo.buildNumber.toString()})';
    } on Exception catch (e) {
      print('exception in drawer screen $e');
      return '';
    }
  }
}
