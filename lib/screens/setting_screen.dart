import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/infoModels/device_info_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/repository/user/request/edit_user_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/screens/SavePreferenceScreen/chat_backup_screen.dart';
import 'package:health_gauge/screens/SavePreferenceScreen/set_tts_stt_screen.dart';
import 'package:health_gauge/screens/alarm_list_screen.dart';
import 'package:health_gauge/screens/auto_tagging_screen.dart';
import 'package:health_gauge/screens/change_password.dart';
import 'package:health_gauge/screens/HK_GF/health_kit_or_google_fit_screen.dart';
import 'package:health_gauge/screens/hg_server_screen.dart';
import 'package:health_gauge/screens/history/measurement_history.dart';
import 'package:health_gauge/screens/history/tag_history_screen.dart';
import 'package:health_gauge/screens/localization/localization.dart';
import 'package:health_gauge/screens/map_screen/map_screen.dart';
import 'package:health_gauge/screens/measurement_screen/cards/progress_card.dart';
import 'package:health_gauge/screens/measurement_type.dart';
import 'package:health_gauge/screens/measurement_using_camera_screen.dart';
import 'package:health_gauge/screens/reminders/sleep_reminder.dart';
import 'package:health_gauge/screens/HK_GF/select_health_kit_or_google_fit_data_type_screen.dart';
import 'package:health_gauge/screens/select_server_type_screen.dart';
import 'package:health_gauge/screens/set_unit_screen.dart';
import 'package:health_gauge/speech_to_text/model/speech_text_model.dart';
import 'package:health_gauge/utils/app_utils.dart';
import 'package:health_gauge/utils/connections.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/custom_otp_text_field.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/custom_switch.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ai_screen.dart';
import 'device_management/device_management_helper.dart';
import 'device_management/device_management_screen.dart';
import 'e80_alarm_list_screen.dart';
import 'history/oxygen/oxygen_history.dart';
import 'history/temperature/temperature_history.dart';
import 'home_screen_item_list.dart';
import 'notification_center_screen.dart';
import 'researcher_profile_screen.dart';
import 'weight_measurement/weight_measurement_screen.dart';

/// Added by: chandresh
/// Added at: 26-06-2020
/// this screen used to manage device, app language, set targets and see histories
/// @param deviceInfoModel device information listener registered at home screen
/// and displaying battery in setting screen that why we need to pass that object here
class SettingScreen extends StatefulWidget {
  final DeviceInfoModel? deviceInfoModel;
  UserModel? user;

  SettingScreen({Key? key, this.deviceInfoModel, this.user}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> implements VibrateListener {
  String? userId;

  int steps = 2000;

  /// Added by: chandresh
  /// Added at: 26-06-2020
  /// isConnected heck that application connected with bracelet or not
  /// if not connected then it will used to hide device management option
  bool isConnected = false;
  bool? isResearcherProfile;
  ValueNotifier<bool> isMTagging = ValueNotifier(false);
  FocusNode passwordFocusNode = new FocusNode();
  bool openKeyboardPassword = false;
  bool canTapDeviceManagement = true;
  bool canTapFindBracelet = true;
  bool showHistory = false;
  TextEditingController researcherProfileTextEditController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var isGoogleSyncEnabled = false;

  bool showResearcherProfileItems = false;

  bool showSync = false;

  bool showWeightConnectionType = false;

  int weightConnectType = preferences?.getInt(Constants.weightConnectionType) ?? 0;

  /// Added by: chandresh
  /// Added at: 26-06-2020
  /// in init method app checking connectionu
  /// getting current version of app
  /// register find device listener
  /// and getting value from shared preference

  @override
  void initState() {
    Future.delayed(Duration.zero, fetchUserDetails);
    super.initState();
    connections.checkAndConnectDeviceIfNotConnected().then((DeviceModel? value) {
      isConnected = value != null;
    });

    getPreferences();
    connections.vibrateListener = this;
  }

  ValueNotifier<bool> isLoading = ValueNotifier(true);

  void fetchUserDetails() async {
    try {
      isLoading.value = true;
      final userDetailResult =
          await UserRepository().getUSerDetailsByUserID(widget.user?.userId ?? '');
      if (userDetailResult.hasData) {
        if (userDetailResult.getData!.result ?? false) {
          var tempUser = UserModel.mapper(userDetailResult.getData!.data!);
          globalUser = tempUser;
          dbHelper.insertUser(globalUser!.toJsonForInsertUsingSignInOrSignUp(), globalUser?.userId ?? '');
          widget.user = tempUser;
          if (preferences != null) {
            preferences?.setInt(
                Constants.measurementType, userDetailResult.getData!.data!.userMeasurementTypeID!);
          }
        }
      }
      configureResearcherProfile();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void configureResearcherProfile() {
    var isResearcher = globalUser?.isResearcherProfile ?? false;
    print('configureResearcherProfile : R : $isResearcher');
    if (isResearcher) {
      var isEST = preferences?.getBool(Constants.isEstimatingEnableKey) ?? false;
      var isOSM = preferences?.getBool(Constants.isOscillometricEnableKey) ?? false;
      if (!isEST && !isOSM) {
        isEST = true;
      }
      var isAI = preferences?.getBool(Constants.isAISelected) ?? false;
      var isHG = preferences?.getBool(Constants.isTFLSelected) ?? false;
      if (!isAI && !isHG) {
        isHG = true;
      }
      preferences?.setBool(Constants.isEstimatingEnableKey, isEST);
      preferences?.setBool(Constants.isOscillometricEnableKey, isOSM);
      preferences?.setBool(Constants.isAISelected, isAI);
      preferences?.setBool(Constants.isTFLSelected, isHG);
    } else {
      preferences?.setBool(Constants.isEstimatingEnableKey, false);
      preferences?.setBool(Constants.isOscillometricEnableKey, false);
    }
    setState(() {
      isResearcherProfile = widget.user != null && widget.user?.isResearcherProfile != null
          ? widget.user?.isResearcherProfile
          : false;
    });
  }

  final TextEditingController _pinController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DeviceManagementHelper _helper = DeviceManagementHelper();

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context,
    //     width: 375.0, height: 812.0, allowFontScaling: true);
    screen = Constants.settings;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: appBar(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : AppColor.backgroundColor,
          child: Stack(
            children: [
              ListView(
                children: [
                  //    excelFeature(),
                  //     startMode(),
                  //     stopMode(),
                  setUnits(),
                  // sleepReminder(),
                  deviceMgmt(),
                  //chatBackup(),
                  // findBracelet(),
                  // alarm(),
                  // FutureBuilder(
                  //     future: connections.checkAndConnectDeviceIfNotConnected(),
                  //     builder: (BuildContext context,
                  //         AsyncSnapshot<DeviceModel?> snapshot) {
                  //       if (snapshot.hasData) {
                  //         return notificationCenter();
                  //       } else {
                  //         return SizedBox.shrink();
                  //       }
                  //     }),
                  // widget.deviceInfoModel != null &&
                  //         widget.deviceInfoModel?.power != null
                  //     ? notificationCenter()
                  //     : Container(),
                  // history(),
                  // tagHistory(),
                  // msrMntHistory(),
                  // tempHistory(),
                  // oxygenHistory(),
                  researcherProfile(),
                  // isResearcherProfile ? Ai() : Container(),
                  // isResearcherProfile && Platform.isIOS
                  //     ? cameraManagement()
                  //     : Container(),
                  // isResearcherProfile ? activityRecognition() : Container(),
                  // isResearcherProfile && Platform.isIOS
                  //     ? measurementType()
                  //     : Container(),
                  // isResearcherProfile ? micOnOff() : Container(),
                  // isResearcherProfile ? preferenceManagement() : Container(),

                  synchronization(),
                  // googleFit(),
                  hgServer(),
                  // weightConnectionType(),
                  // automaticWeightType(), // weight connection type = 0
                  // manualWeightType(), // weight connection type = 1

                  // saveDataInGoogleFit(),
                  // autoTag(),
                  // homeScreenItems(),
                  // weightMeasurement(),
                  localisation(),
                  // serverType(),
                  // changePassword(),
//                        Container(height: kToolbarHeight.h,),
                ],
              ),
//                Align(
//                  alignment: Alignment.bottomCenter,
//                  child: Container(
//                    padding: EdgeInsets.symmetric(vertical: 5.h),
//                    width: Constants.width.w,
//                    color: Theme.of(context).scaffoldBackgroundColor,
//                      child: Body2Text(text: StringLocalization.of(context).getText(StringLocalization.version) + ' : $versionName',align: TextAlign.center,),
//                  ),
//                )
            ],
          ),
        ),
      ),
    );
  }

//  Widget version() {
//    return  Container(
//      margin: EdgeInsets.only(bottom: 10),
//      child: Text(
//        StringLocalization.of(context).getText(StringLocalization.version) + ' : $versionName',
//        style: TextStyle(
//          fontSize: 15.0,
//          fontWeight: FontWeight.w700,
//        ),
//      ),
//
//    );
//  }

  PreferredSize appBar() {
    return PreferredSize(
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
            key: Key('settingScreenBackButton'),
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
            StringLocalization.of(context).getText(StringLocalization.settingScreen),
            style: TextStyle(
                color: HexColor.fromHex('62CBC9'), fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: batteryWidget(),
            ),
            ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (BuildContext context, bool value, Widget? child) {
                if (!value) {
                  return SizedBox();
                }
                return Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 4.0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.only(left: 15.0.w),
      child: Divider(
        color: AppColor.graydark,
        thickness: 1.0,
      ),
    );
  }

  Widget setUnits() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('unitSettingScreen'),
        onTap: () {
          Constants.navigatePush(SetUnitScreen(), context).then((value) {
            if (value != null && value) {
              CustomSnackBar.buildSnackbar(context,
                  StringLocalization.of(context).getText(StringLocalization.unitSetSuccess), 3);
            } else {}
          });
        },
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/settings_icon.png',
                // height: 33,
                // width: 33,
              ),
            ),
            title: Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.setUnit),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/right_setting_dark.png'
                      : 'asset/right_setting.png',
                  height: 14,
                  width: 8,
                ))),
      ),
    );
  }

  Widget sleepReminder() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Constants.navigatePush(SleepReminder(), context);
        },
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
          leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.asset(
              'asset/Wellness/sleepIcon.png',
              height: 33,
              width: 33,
            ),
          ),
          title: Body1AutoText(
            text: StringLocalization.of(context).getText(StringLocalization.sleepReminder),
            fontSize: 16.sp,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex('#384341'),
          ),
          trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/right_setting_dark.png'
                  : 'asset/right_setting.png',
              height: 14,
              width: 8,
            ),
          ),
        ),
      ),
    );
  }

  Widget deviceMgmt() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('opendevicesetting'),
        onTap: canTapDeviceManagement
            ? () async {
                var connectedDevice = await connections.checkAndConnectDeviceIfNotConnected();
                if (connectedDevice != null) {
                  Constants.navigatePush(DeviceManagementScreen(), context)
                      .then((value) => screen = Constants.settings)
                      .then((value) async {
                    _helper.updateDeviceSetting();
                  });
                } else {
                  canTapDeviceManagement = false;
                  setState(() {});
                  CustomSnackBar.buildSnackbar(
                      context,
                      StringLocalization.of(context)
                          .getText(StringLocalization.noConnectionMessage),
                      3);
                  Timer(Duration(seconds: 3), () {
                    canTapDeviceManagement = true;
                    if (this.mounted) {
                      setState(() {});
                    }
                  });
                }
              }
            : null,
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/settings_icon.png',
                height: 33,
                width: 33,
              ),
            ),
            title: Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.deviceManagement),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/right_setting_dark.png'
                      : 'asset/right_setting.png',
                  height: 14,
                  width: 8,
                ))),
      ),
    );
  }

  Widget preferenceManagement() {
    return Visibility(
      visible: showResearcherProfileItems,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Constants.navigatePush(SetTtsAndSttScreen(), context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
                leading: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Image.asset(
                    'asset/voice_icon.png',
                    height: 33,
                    width: 33,
                  ),
                ),
                title: Body1AutoText(
                  text:
                      StringLocalization.of(context).getText(StringLocalization.voiceConfiguration),
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                ),
                trailing: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'asset/right_setting_dark.png'
                          : 'asset/right_setting.png',
                      height: 14,
                      width: 8,
                    ))),
          ),
        ),
      ),
    );

    // return Container();
  }

  Widget weightConnectionType() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showWeightConnectionType = !showWeightConnectionType;
          if (mounted) {
            setState(() {});
          }
        },
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/weight_setting.png',
                height: 33.h,
                width: 33.h,
              ),
            ),
            title: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.weightConnectionType),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: showWeightConnectionType ? 5 : 10),
                child: Image.asset(
                  !showWeightConnectionType
                      ? Theme.of(context).brightness == Brightness.dark
                          ? 'asset/right_setting_dark.png'
                          : 'asset/right_setting.png'
                      : Theme.of(context).brightness == Brightness.dark
                          ? 'asset/up_arrow_dark.png'
                          : 'asset/up_arrow_icon.png',
                  height: showWeightConnectionType ? 10 : 14,
                  width: showWeightConnectionType ? 20 : 8,
                ))),
      ),
    );
  }

  Widget automaticWeightType() {
    return Visibility(
      visible: showWeightConnectionType,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            preferences?.setInt(Constants.weightConnectionType, 0);
            weightConnectType = preferences?.getInt(Constants.weightConnectionType) ?? 0;
            setState(() {});
          },
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              leading: Image.asset(
                'asset/alarm_icon.png',
                color: Colors.transparent,
              ),
              title: Body1AutoText(text: 'Automatic', fontSize: 16.sp),
              trailing: weightConnectType == 0
                  ? Image.asset(
                      'asset/check_icon.png',
                      height: 33.h,
                      width: 33.h,
                    )
                  : SizedBox(
                      width: 2.w,
                    )),
        ),
      ),
    );
  }

  Widget manualWeightType() {
    return Visibility(
      visible: showWeightConnectionType,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            preferences?.setInt(Constants.weightConnectionType, 1);
            weightConnectType = preferences?.getInt(Constants.weightConnectionType) ?? 1;
            postDataToAPI();
            setState(() {});
          },
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
              leading: Image.asset(
                'asset/health_kit_icon.png',
                color: Colors.transparent,
              ),
              title: Body1AutoText(text: 'Manual', fontSize: 16.sp),
              trailing: weightConnectType == 1
                  ? Image.asset(
                      'asset/check_icon.png',
                      height: 33.h,
                      width: 33.h,
                    )
                  : SizedBox(
                      width: 2.w,
                    )),
        ),
      ),
    );
  }

  Widget cameraManagement() {
    return Visibility(
      visible: showResearcherProfileItems,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Constants.navigatePush(MeasurementUsingCamera(), context);
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
                leading: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Image.asset(
                    'asset/camera_measurement_icon.png',
                    height: 33,
                    width: 33,
                  ),
                ),
                title: Body1AutoText(
                  text:
                      StringLocalization.of(context).getText(StringLocalization.cameraMeasurement),
                  fontSize: 16.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                ),
                trailing: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      Theme.of(context).brightness == Brightness.dark
                          ? 'asset/right_setting_dark.png'
                          : 'asset/right_setting.png',
                      height: 14,
                      width: 8,
                    ))),
          ),
        ),
      ),
    );
  }

  Widget chatBackup() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Constants.navigatePush(ChatBackupScreen(), context);
        },
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/settings_icon.png',
                height: 33,
                width: 33,
              ),
            ),
            title: Body1AutoText(
              text: 'Chat Backup',
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/right_setting_dark.png'
                      : 'asset/right_setting.png',
                  height: 14,
                  width: 8,
                ))),
      ),
    );

    // return Container();
  }

  Widget findBracelet() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: canTapFindBracelet
            ? () async {
                await connections.checkAndConnectDeviceIfNotConnected().then((value) {
                  if (value != null) {
                    connections.getVibrationBracelet();
                  }
                });
                if (!isConnected) {
                  canTapFindBracelet = false;
                  setState(() {});
                  CustomSnackBar.buildSnackbar(
                      context,
                      StringLocalization.of(context)
                          .getText(StringLocalization.noConnectionMessage),
                      3);
                  Timer(Duration(seconds: 3), () {
                    canTapFindBracelet = true;
                    if (this.mounted) {
                      setState(() {});
                    }
                  });
                }
              }
            : null,
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            'asset/search_icon.png',
            // height: 33,
            // width: 33,
          ),
        ),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.findBracelet),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/right_setting_dark.png'
                  : 'asset/right_setting.png',
              height: 14,
              width: 8,
            )));
  }

  Widget homeScreenItems() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Constants.navigatePush(HomeScreenItemList(), context);
        },
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/home_icon.png',
                // height: 33,
                // width: 33,
              ),
            ),
            title: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.homeScreenItems),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/right_setting_dark.png'
                      : 'asset/right_setting.png',
                  height: 14,
                  width: 8,
                ))),
      ),
    );
  }

  Widget history() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
          showHistory = !showHistory;
          if (mounted) {
            setState(() {});
          }
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            'asset/history_icon.png',
            // height: 33,
            // width: 33,
          ),
        ),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.history),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: showHistory ? 5 : 10),
            child: Image.asset(
              !showHistory
                  ? Theme.of(context).brightness == Brightness.dark
                      ? 'asset/right_setting_dark.png'
                      : 'asset/right_setting.png'
                  : Theme.of(context).brightness == Brightness.dark
                      ? 'asset/up_arrow_dark.png'
                      : 'asset/up_arrow_icon.png',
              height: showHistory ? 10 : 14,
              width: showHistory ? 20 : 8,
            )));
  }

  Widget synchronization() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          showSync = !showSync;
          if (mounted) {
            setState(() {});
          }
        },
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/sync_icon.png',
                // height: 33,
                // width: 33,
              ),
            ),
            title: Body1AutoText(
              text: StringLocalization.of(context).getText(StringLocalization.synchronization),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: showSync ? 5 : 10),
                child: Image.asset(
                  !showSync
                      ? Theme.of(context).brightness == Brightness.dark
                          ? 'asset/right_setting_dark.png'
                          : 'asset/right_setting.png'
                      : Theme.of(context).brightness == Brightness.dark
                          ? 'asset/up_arrow_dark.png'
                          : 'asset/up_arrow_icon.png',
                  height: showSync ? 10 : 14,
                  width: showSync ? 20 : 8,
                ))),
      ),
    );
  }

  Widget tagHistory() {
    return Visibility(
      visible: showHistory,
      child: ListTile(
        key: Key('tagHistoryScreen'),
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
//        Constants.navigatePush(TagHistory(), context);
          Constants.navigatePush(TagHistoryScreen(), context)
              .then((value) => screen = Constants.settings);
        },
        leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: SizedBox(
              height: 33,
              width: 33,
            )),

        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.tagHistory),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
//        trailing: Padding(
//            padding: EdgeInsets.only(right: 10),
//            child: Image.asset(
//              Theme.of(context).brightness == Brightness.dark
//                  ? 'asset/right_setting_dark.png'
//                  : 'asset/right_setting.png',
//              height: 14,
//              width: 8,
//            ))
      ),
    );
  }

  Widget msrMntHistory() {
    return Visibility(
      visible: showHistory,
      child: ListTile(
        key: Key('measurementHistory'),
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
          Constants.navigatePush(MeasurementHistory(), context)
              .then((value) => screen = Constants.settings);
        },
        leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: SizedBox(
              height: 33,
              width: 33,
            )),

        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.measurementHistory),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
//        trailing: Padding(
//            padding: EdgeInsets.only(right: 10),
//            child: Image.asset(
//              Theme.of(context).brightness == Brightness.dark
//                  ? 'asset/right_setting_dark.png'
//                  : 'asset/right_setting.png',
//              height: 14,
//              width: 8,
//            ))
      ),
    );
  }

  Widget tempHistory() {
    return Visibility(
      visible: showHistory,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
          Constants.navigatePush(TemperatureHistory(), context)
              .then((value) => screen = Constants.settings);
        },
        leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: SizedBox(
              height: 33,
              width: 33,
            )),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.temperatureHistory),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
//        trailing: Padding(
//            padding: EdgeInsets.only(right: 10),
//            child: Image.asset(
//              Theme.of(context).brightness == Brightness.dark
//                  ? 'asset/right_setting_dark.png'
//                  : 'asset/right_setting.png',
//              height: 14,
//              width: 8,
//            ))
      ),
    );
  }

  Widget oxygenHistory() {
    return Visibility(
      visible: showHistory,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
          Constants.navigatePush(OxygenHistory(), context)
              .then((value) => screen = Constants.settings);
        },
        leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: SizedBox(
              height: 33,
              width: 33,
            )),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.oxygenHistory),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
//        trailing: Padding(
//            padding: EdgeInsets.only(right: 10),
//            child: Image.asset(
//              Theme.of(context).brightness == Brightness.dark
//                  ? 'asset/right_setting_dark.png'
//                  : 'asset/right_setting.png',
//              height: 14,
//              width: 8,
//            ))
      ),
    );
  }

  Widget serverUrl() {
    return ListTile(
      onTap: () {},
      leading: Padding(
        padding: EdgeInsets.only(left: 5),
        child: Image.asset(
          'asset/tag_icon.png',
          // height: 25.0,
          // width: 25.0,
          color: IconTheme.of(context).color,
        ),
      ),
      title: Body1AutoText(text: 'Server URL', fontSize: 16.sp),
      trailing: IconButton(
          icon: Icon(Icons.navigate_next, color: IconTheme.of(context).color), onPressed: null),
    );
  }

  Widget training() {
    bool isTraining = false;
    if (preferences != null && preferences?.getBool(Constants.isTrainingEnableKey1) != null) {
      isTraining = preferences?.getBool(Constants.isTrainingEnableKey1) ?? false;
    }
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      leading: Padding(
        padding: EdgeInsets.only(left: 5),
        child: Image.asset(
          'asset/training_icon.png',
          // height: 33,
          // width: 33,
        ),
      ),
      title: Body1AutoText(
        text: StringLocalization.of(context).getText(StringLocalization.training),
        fontSize: 16.sp,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.87)
            : HexColor.fromHex('#384341'),
      ),
      trailing: CustomSwitch(
        value: isTraining,
        onChanged: (value) {
          preferences?.setBool(Constants.isTrainingEnableKey, value);
          preferences?.setBool(Constants.isTrainingEnableKey1, value);
          if (value) {
            preferences?.setBool(Constants.isEstimatingEnableKey, false);
            preferences?.setBool(Constants.isEstimatingEnableKey1, false);
            preferences?.setBool(Constants.isOscillometricEnableKey, false);
            preferences?.setBool(Constants.isOscillometricEnableKey1, false);
          }
          setState(() {});
        },
        activeColor: HexColor.fromHex('#00AFAA'),
        inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
        inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.6)
            : HexColor.fromHex('#D1D9E6'),
        activeTrackColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkBackgroundColor
            : HexColor.fromHex('#E7EBF2'),
      ),
    );
  }

  Widget weightMeasurement() {
    return ListTile(
        key: Key('weightMeasurementScreen'),
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
          Constants.navigatePush(WeightMeasurementScreen(user: widget.user), context);
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            'asset/weight_setting.png',
            height: 33,
            width: 33,
          ),
        ),
        title: Body1AutoText(
          text: stringLocalization.getText(StringLocalization.weightMeasurement),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/right_setting_dark.png'
                  : 'asset/right_setting.png',
              height: 14,
              width: 8,
            )));
  }

  Widget measurementType() {
    return Visibility(
      visible: showResearcherProfileItems,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            onTap: () {
              Constants.navigatePush(MeasurementType(isResearcherProfile ?? false), context)
                  .then((value) => screen = Constants.settings);
            },
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/ai_icon.png',
                height: 33,
                width: 33,
              ),
            ),
            title: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.measurementType),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/right_setting_dark.png'
                      : 'asset/right_setting.png',
                  height: 14,
                  width: 8,
                ))),
      ),
    );
  }

  Widget Ai() {
    return Visibility(
      visible: showResearcherProfileItems,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            onTap: () {
              Constants.navigatePush(AIScreen(), context)
                  .then((value) => screen = Constants.settings);
            },
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/ai_icon.png',
                height: 33,
                width: 33,
              ),
            ),
            title: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.Ai),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/right_setting_dark.png'
                      : 'asset/right_setting.png',
                  height: 14,
                  width: 8,
                ))),
      ),
    );
  }

  Widget hgServer() {
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month - 1, 1);

    if (preferences != null && preferences?.getString(Constants.synchronizationKey) != null) {
      String storedDate = preferences?.getString(Constants.synchronizationKey) ?? '';
      date = DateTime.parse(storedDate);
    }
    return Visibility(
      visible: showSync,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Constants.navigatePush(HGServerScreen(), context);
          },
          child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
              leading: Padding(
                padding: EdgeInsets.only(left: 5),
                child: Image.asset(
                  'asset/sync_icon.png',
                  // height: 33,
                  // width: 33,
                  color: Colors.transparent,
                ),
              ),
              title: Body1AutoText(
                text: StringLocalization.of(context).getText(StringLocalization.hgServer),
                fontSize: 16.sp,
                maxLine: 1,
              ),
              trailing: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/right_setting_dark.png'
                        : 'asset/right_setting.png',
                    height: 14,
                    width: 8,
                  ))
              // InkWell(
              //   onTap: () async {
              //     DateTime selectedDate = await showCustomDatePicker(
              //       context: context,
              //       initialDate: date,
              //       firstDate: DateTime(2020, 1),
              //       lastDate: DateTime.now(),
              //       fieldHintText:
              //           stringLocalization.getText(StringLocalization.enterDate),
              //       getDatabaseDataFrom: '',
              //     );
              //     if (selectedDate != null) {
              //       preferences?.setString(
              //           Constants.synchronizationKey, selectedDate.toString());
              //       setState(() {});
              //     }
              //   },
              //   child: Padding(
              //     padding: EdgeInsets.only(right: 5),
              //     child: Row(
              //       mainAxisSize: MainAxisSize.min,
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: <Widget>[
              //         Body1AutoText(
              //           text: DateFormat('dd-MM-yyyy').format(date),
              //           fontSize: 14,
              //           color: Theme.of(context).brightness == Brightness.dark
              //               ? Colors.white.withOpacity(0.87)
              //               : HexColor.fromHex('#384341'),
              //         ),
              //         SizedBox(width: 5.w),
              //         Image.asset(
              //           'asset/calendar_button.png',
              //           // height: 33,
              //           // width: 33,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              ),
        ),
      ),
    );
  }

  Widget saveDataInGoogleFit() {
    return Visibility(
      visible: Platform.isAndroid,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            'asset/sync_icon.png',
            // height: 33,
            // width: 33,
          ),
        ),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.saveDataInGoogleFit),
          fontSize: 16.sp,
          maxLine: 2,
        ),
        trailing: CustomSwitch(
          value: preferences?.getBool(Constants.isGoogleSyncEnabled) ?? false,
          onChanged: (value) {
            try {
              if (value) {
                connections.checkAuthForGoogleFit().then((value) {
                  preferences?.setBool(Constants.isGoogleSyncEnabled, value);
                  if (mounted) {
                    setState(() {});
                  }
                });
              } else {
                preferences?.setBool(Constants.isGoogleSyncEnabled, value);
                if (mounted) {
                  setState(() {});
                }
              }
            } catch (e) {
              print('Exception at isGoogleSyncEnabled $e');
            }
          },
          activeColor: HexColor.fromHex('#00AFAA'),
          inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : HexColor.fromHex('#E7EBF2'),
          inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.6)
              : HexColor.fromHex('#D1D9E6'),
          activeTrackColor: Theme.of(context).brightness == Brightness.dark
              ? AppColor.darkBackgroundColor
              : HexColor.fromHex('#E7EBF2'),
        ),
      ),
    );
  }

  Widget localisation() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('settingsLanguage'),
        onTap: () {
          Constants.navigatePush(Localisation(), context)
              .then((value) => screen = Constants.settings);
        },
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
          leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.asset(
              'asset/language_icon.png',
            ),
          ),
          title: Body1AutoText(
            text: StringLocalization.of(context).getText(StringLocalization.selectLanguage),
            fontSize: 16.sp,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex('#384341'),
          ),
          trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/right_setting_dark.png'
                  : 'asset/right_setting.png',
              height: 14,
              width: 8,
            ),
          ),
        ),
      ),
    );
  }

  Widget alarm() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () async {
          var connectedDevice = await connections.checkAndConnectDeviceIfNotConnected();
          var alarmScreen;
          if (connectedDevice?.sdkType == 2) {
            alarmScreen = E80AlarmListScreen();
          } else {
            alarmScreen = AlarmListScreen();
          }
          Constants.navigatePush(alarmScreen, context).then((value) => screen = Constants.settings);
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            'asset/alarm_icon.png',
            // height: 33,
            // width: 33,
          ),
        ),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.alarm),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/right_setting_dark.png'
                  : 'asset/right_setting.png',
              height: 14,
              width: 8,
            )));
  }

  Widget changePassword() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () async {
          Constants.navigatePush(ChangePasswordScreen(), context)
              .then((value) => screen = Constants.settings);
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            'asset/sync_icon.png',
            // height: 33,
            // width: 33,
          ),
        ),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.changePassword),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/right_setting_dark.png'
                  : 'asset/right_setting.png',
              height: 14,
              width: 8,
            )));
  }

  Widget serverType() {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
        onTap: () {
          researcherProfileDialog('serverType', false, onClickOk: () async {
            openKeyboardPassword = false;
            Navigator.of(context, rootNavigator: true).pop();
            bool isValidPswd = validatePassword(password: researcherProfileTextEditController.text);
            if (isValidPswd) {
              Constants.navigatePush(SelectServerTypeScreen(), context)
                  .then((value) => screen = Constants.settings);
            }
            researcherProfileTextEditController.clear();
          });
        },
        leading: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Image.asset(
            'asset/deviceManagement_Icon.png',
            height: 33,
            width: 33,
          ),
        ),
        title: Body1AutoText(
          text: StringLocalization.of(context).getText(StringLocalization.selectServer),
          fontSize: 16.sp,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(0.87)
              : HexColor.fromHex('#384341'),
        ),
        trailing: Padding(
            padding: EdgeInsets.only(right: 10),
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/right_setting_dark.png'
                  : 'asset/right_setting.png',
              height: 14,
              width: 8,
            )));
  }

  ///Added by shahzad
  ///Added on: 09/10/2020
  ///Widget to show researcher profile on settings.
  Widget researcherProfile() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('clickonResearcherProfile'),
        onTap: isResearcherProfile ?? false
            ? () {
                Constants.navigatePush(ResearcherProfileScreen(), context);
              }
            : null,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
          leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.asset(
              'asset/profile_icon.png',
              // height: 33,
              // width: 33,
            ),
          ),
          title: Body1AutoText(
            text: StringLocalization.of(context).getText(StringLocalization.researcherProfileTitle),
            fontSize: 16.sp,
            maxLine: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex('#384341'),
          ),
          trailing: Padding(
            key: Key('toggleSwitch'),
            padding: EdgeInsets.zero,
            child: CustomSwitch(
              value: isResearcherProfile ?? false,
              onChanged: (value) async {
                saveProfileData(progressDialog: false);
                isResearcherProfile = value;
                globalUser?.isResearcherProfile = value;
                if (value) {
                  var isEST = true;
                  var isOSM = false;
                  isTflSelected.value = true;
                  isAISelected.value = false;
                  preferences?.setBool(Constants.isEstimatingEnableKey, isEST);
                  preferences?.setBool(Constants.isOscillometricEnableKey, isOSM);
                } else {
                  preferences?.setBool(Constants.isEstimatingEnableKey, false);
                  preferences?.setBool(Constants.isOscillometricEnableKey, false);
                }
              },
              activeColor: HexColor.fromHex('#00AFAA'),
              inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : HexColor.fromHex('#E7EBF2'),
              inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.6)
                  : HexColor.fromHex('#D1D9E6'),
              activeTrackColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColor.darkBackgroundColor
                  : HexColor.fromHex('#E7EBF2'),
            ),
          ),
        ),
      ),
    );
  }

  ///Added by shahzad
  ///Added on: 09/10/2020
  ///this method let the user to fill password to be a researcher
  researcherProfileDialog(String type, bool callFromResearch,
      {required GestureTapCallback onClickOk}) {
    showDialog(
            context: context,
            useRootNavigator: true,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Dialog(
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
                            ? AppColor.darkBackgroundColor
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
                        ],
                      ),
                      padding: EdgeInsets.only(top: 27.h, left: 22.w, right: 22.w),
                      width: 309.w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(
                            text: StringLocalization.of(context)
                                .getText(StringLocalization.enterPassword),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                : HexColor.fromHex('#384341'),
                            // maxLine: 1,
                          ),
                          SizedBox(
                            height: 23.h,
                          ),
                          Form(
                            key: formKey,
                            child: Pinput(
                              controller: _pinController,
                              length: 6,
                              validator: (value) {
                                print(value);
                                if (value == null) {
                                  return 'Invalid !';
                                }
                                if (value.isEmpty) {
                                  return 'Invalid !';
                                }
                                if (value.length != 6) {
                                  return 'Invalid !';
                                }
                                return null;
                              },
                              errorBuilder: (value1, value2) {
                                return SizedBox();
                              },
                              errorPinTheme: PinTheme(
                                height: 45,
                                width: 50,
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                ),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                        : AppColor.backgroundColor,
                                    border: Border.all(
                                      color: Colors.redAccent,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              defaultPinTheme: PinTheme(
                                height: 45,
                                width: 50,
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white.withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                ),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? HexColor.fromHex('#111B1A')
                                        : AppColor.backgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isDarkMode(context) ? Colors.white : Colors.black)
                                            .withOpacity(0.25),
                                        blurRadius: 3,
                                        spreadRadius: 0.2,
                                      )
                                    ],
                                    border: Border.all(
                                      color: (isDarkMode(context) ? Colors.white : Colors.black)
                                          .withOpacity(0.5),
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                            ),
                          ),
                          /*CustomOTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 32.w,
                            fieldHeight: 39.h,
                            spaceBetweenFields: 11.w,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.87)
                                  : HexColor.fromHex('#384341'),
                            ),
                            obscureText: false,
                            onChanged: (pin) {
                              print(pin);
                              researcherPassword = pin;
                            },
                            onCompleted: (pin) {
                              print(pin);
                              researcherPassword = pin;
                            },
                          ),*/
                          SizedBox(
                            height: 24.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  key: Key('clickOnOKButton'),
                                  child: Container(
                                    height: 25.h,
                                    child: Body1Text(
                                      text: stringLocalization.getText(StringLocalization.ok),
                                      color: AppColor.color00AFAA,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      align: TextAlign.left,
                                    ),
                                  ),
                                  onTap: () {
                                    print('formKey :: ${formKey.currentState!.validate()}');
                                    if (formKey.currentState!.validate()) {
                                      onClickOk();
                                    } else {
                                      isResearcherProfile = false;
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: 25.w),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  child: Container(
                                    height: 25.h,
                                    child: Body1Text(
                                      text: stringLocalization.getText(StringLocalization.cancel),
                                      color: AppColor.color00AFAA,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      align: TextAlign.right,
                                    ),
                                  ),
                                  onTap: () {
                                    isResearcherProfile = false;
                                    _pinController.clear();
                                    Navigator.of(context, rootNavigator: true).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 27.h),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            barrierDismissible: false)
        .then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  bool validatePassword({String? password}) {
    if (password == '112233') {
      return true;
    }
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     StringLocalization.of(context)
    //         .getText(StringLocalization.wrongPassword),
    //     textAlign: TextAlign.center,
    //   ),
    // ));
    CustomSnackBar.buildSnackbar(
        context, stringLocalization.getText(StringLocalization.wrongPassword), 3);
    return false;
  }

  ///Added by shahzad
  ///Added on: 09/10/2020
  ///this method saves the profile data in database and server
  Future<void> saveProfileData({bool progressDialog = true}) async {
    bool isInternet = await Constants.isInternetAvailable();
    await dbHelper.insertUser(
        globalUser!.toJsonForInsertUsingSignInOrSignUp(), globalUser!.userId!);
    if (isInternet) {
      postDataToAPI(progressDialog: progressDialog);
    }
    if (isResearcherProfile ?? false) {
      preferences?.setBool(Constants.isTrainingEnableKey, false);
    } else {
      preferences?.setBool(Constants.isEstimatingEnableKey, false);
      preferences?.setBool(Constants.isOscillometricEnableKey, false);
    }
    setState(() {});
  }

  Future postDataToAPI({bool progressDialog = true}) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }
    // Map<String, dynamic> map = {
    //   "UserID": globalUser?.userId,
    //   "FirstName": globalUser?.firstName.toString(),
    //   "LastName": globalUser?.lastName.toString(),
    //   "Gender": globalUser?.gender,
    //   // "UnitID": globalUser.unit,
    //   "DateOfBirth": DateFormat(DateUtil.yyyyMMdd).format(globalUser!.dateOfBirth!),
    //   "Picture": globalUser?.picture,
    //   "Height": globalUser?.height,
    //   "Weight": globalUser?.weight,
    //   "SkinType": globalUser?.skinType,
    //   "IsUpdate": false,
    //   "InitialWeight": globalUser?.maxWeight,
    //   "IsResearcherProfile": isResearcherProfile,
    //   "UserMeasurementTypeID": preferences?.getInt(Constants.measurementType)
    // };
    var requestData = EditUserRequest(
      userID: globalUser?.userId,
      firstName: globalUser?.firstName.toString(),
      lastName: globalUser?.lastName.toString(),
      gender: globalUser?.gender,
      dateOfBirth: DateFormat(DateUtil.yyyyMMdd).format(globalUser?.dateOfBirth ?? DateTime.now()),
      // unitID: 1,
      picture: globalUser?.picture,
      height: globalUser?.height,
      weight: globalUser?.weight,
      skinType: globalUser?.skinType,
      isUpdate: true,
      initialWeight: globalUser?.maxWeight,
      isResearcherProfile: isResearcherProfile,
      userMeasurementTypeID: preferences?.getInt(Constants.measurementType),
      weightUnit: weightUnit + 1,
      heightUnit: heightUnit + 1,
    );
    if (globalUser?.picture != null) {
      requestData.isUpdate = true;
      requestData.userImage = globalUser?.picture;
      // map["IsUpdate"] = true;
      // map["UserImage"] = globalUser?.picture;
    }

    var response = await UserRepository().editUser(requestData);
    if (response.hasData) {
      if (response.getData!.result!) {
        if (response.getData!.data != null) {
          globalUser = UserModel.mapper(response.getData!.data!);
          globalUser?.isSync = 1;
          preferences?.setInt(Constants.measurementType, globalUser?.userMeasurementTypeId ?? 0);
        }
      }
    }
//    Constants.progressDialog(true, context);
//     var result = await UpdateProfileParser()
//         .callApi(Constants.baseUrl + 'EditUser', map);
// //    Constants.progressDialog(false, context);
//     if (!result['isError']) {
//       if (result['value'] is UserModel) {
//         globalUser = result['value'];
//         globalUser?.isSync = 1;
//         preferences?.setInt(Constants.measurementType, globalUser?.userMeasurementTypeId ?? 0);
//       }
//     } else {
//       // scaffoldKey.currentState.showSnackBar(SnackBar(
//       //   content: Text(
//       //     StringLocalization.of(context)
//       //         .getText(StringLocalization.somethingWentWrong),
//       //     textAlign: TextAlign.center,
//       //   ),
//       //   duration: Duration(milliseconds: 700),
//       // ));
//       // CustomSnackBar.CurrentBuildSnackBar(
//       //     context,
//       //     scaffoldKey,
//       //     StringLocalization.of(context)
//       //         .getText(StringLocalization.somethingWentWrong));
//     }
  }

  // ValueNotifier<bool> isMTagging = ValueNotifier(false);

  Widget autoTag() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('clickonMeasurementTagging'),
        onTap: () {
          Constants.navigatePush(AutoTaggingScreen(), context)
              .then((value) => screen = Constants.settings);
        },
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
          leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.asset(
              'asset/tag_icon.png',
              // height: 33,
              // width: 33,
            ),
          ),
          title: Body1AutoText(
            text: StringLocalization.of(context).getText(StringLocalization.autoTagging),
            fontSize: 16.sp,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex('#384341'),
          ),
          trailing: Padding(
            key: Key('toggleSwitch'),
            padding: EdgeInsets.zero,
            child: ValueListenableBuilder(
              valueListenable: isMTagging,
              builder: (BuildContext context, bool taggingValue, Widget? child) {
                return CustomSwitch(
                  value: taggingValue,
                  onChanged: (value) async {
                    isMTagging.value = value;
                    if (value) {
                      preferences!.setBool(Constants.prefMTagging, true);
                    } else {
                      preferences!.setBool(Constants.prefMTagging, false);
                    }
                  },
                  activeColor: HexColor.fromHex('#00AFAA'),
                  inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E7EBF2'),
                  inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#D1D9E6'),
                  activeTrackColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E7EBF2'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget googleFit() {
    return Visibility(
      visible: showSync,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (Platform.isIOS) {
              var result = await connections.isHealthDataAvailable();
              result
                  ? Constants.navigatePush(HealthKitOrGoogleFitScreen(), context)
                      .then((value) => screen = Constants.settings)
                  : healthKitDialog();
            } else {
              Constants.navigatePush(HealthKitOrGoogleFitScreen(), context)
                  .then((value) => screen = Constants.settings);
            }
          },
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/health_kit_icon.png',
                color: Colors.transparent,
              ),
            ),
            title: Body1AutoText(
              text: Platform.isIOS
                  ? StringLocalization.of(context).getText(StringLocalization.healthKit)
                  : StringLocalization.of(context).getText(StringLocalization.googleFit),
              fontSize: 16.sp,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'asset/right_setting_dark.png'
                    : 'asset/right_setting.png',
                height: 14,
                width: 8,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget startMode() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () async {
        connections.startMode(0x0b);
      },
      title: Body1AutoText(
        text: 'Start Mode',
        fontSize: 16.sp,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.87)
            : HexColor.fromHex('#384341'),
      ),
    );
  }

  Widget stopMode() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
      onTap: () async {
        connections.endMode(0x0B);
      },
      title: Body1AutoText(
        text: 'Start Mode',
        fontSize: 16.sp,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(0.87)
            : HexColor.fromHex('#384341'),
      ),
    );
  }

  healthKitDialog() {
    var dialog = CustomInfoDialog(
      title: null,
      subTitle: stringLocalization.getText(StringLocalization.healthKitNotAvailableOnDevice),
      maxLine: 2,
      primaryButton: stringLocalization.getText(StringLocalization.ok).toUpperCase(),
      onClickYes: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => dialog,
        barrierColor: Theme.of(context).brightness == Brightness.dark
            ? AppColor.color7F8D8C.withOpacity(0.6)
            : AppColor.color384341.withOpacity(0.6),
        barrierDismissible: false);
  }

  // AlertDialog(
  //         title: Text(''),
  // content: Text(stringLocalization
  //     .getText(StringLocalization.healthKitNotAvailableOnDevice)),
  //         actions: <Widget>[
  //           FlatBtn(
  //               onPressed: () async {
  //                 if (context != null) {
  //                   Navigator.of(context, rootNavigator: true).pop();
  //                 }
  //                 Navigator.pop(context);
  //               },
  //               text: StringLocalization.of(context)
  //                   .getText(StringLocalization.ok)),
  //         ]);

  /// Added by: chandresh
  /// Added at: 26-06-2020
  /// this callback function used to receive find bracelet call
  @override
  void onGetVibration(bool isVibrate) {
    // TODO: implement onGetVibration
    print('lisneter');
  }

  /// Added by: chandresh
  /// Added at: 26-06-2020
  /// this method return battery widget if device is connected
  Widget batteryWidget() {
    if (widget.deviceInfoModel != null && widget.deviceInfoModel?.power != null) {
      return Padding(
        padding: EdgeInsets.only(right: 10),
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'asset/dark_battery_icon.png'
                    : 'asset/battery_icon.png',
                height: 33,
                width: 33,
              ),
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 18.w,
                    height: 9.h,
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.only(
                        top: 2.5.h,
                        bottom: 1.2.h,
                        left: 1.w,
                        right: (15.w - widget.deviceInfoModel!.power! / 100 * 15.w) + 1.5.w,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? HexColor.fromHex('#5D6A68')
                            : HexColor.fromHex('#BDC7C5'),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#D1D9E6').withOpacity(0.07)
                                : Colors.white,
                            blurRadius: 1,
                            spreadRadius: 0,
                            offset: Offset(0, -0.5.h),
                          ),
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#000000').withOpacity(0.6)
                                : HexColor.fromHex('#9F2DBC').withOpacity(0.9),
                            blurRadius: 1,
                            spreadRadius: 0,
                            offset: Offset(0, 0.5.h),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

//                  Container(
//                    margin: EdgeInsets.only(left: 6.5.w),
//                    child: LinearPercentIndicator(
//                      width: 44.0.w,
//                      lineHeight: 10.0.h,
//                      backgroundColor: Colors.transparent,
//                      percent: (widget.deviceInfoModel.power + 0.0) / 100,
//                      center: RotatedBox(
//                          quarterTurns: 45,
//                          child: new CaptionText(
//                              text: widget.deviceInfoModel.power >= 100
//                                  ? ''
//                                  : '${widget.deviceInfoModel.power}',
//                              color: Theme.of(context).brightness ==
//                                      Brightness.dark
//                                  ? Colors.white
//                                  : Colors.black)),
//                      progressColor: Colors.white,
//                      linearStrokeCap: LinearStrokeCap.butt,
//                    ),
//                  )
            ],
          ),
        ),
      );
    }
    return Container();
  }

  /// Added by: chandresh
  /// Added at: 26-06-2020
  /// this method used to get preferences for target and user ids
  void getPreferences() async {
    isMTagging.value = preferences?.getBool(Constants.prefMTagging) ?? false;
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    var strJsonForStep = preferences?.getString(Constants.prefSavedStepTarget) ?? '';
    if (strJsonForStep.isNotEmpty) {
      Map map = jsonDecode(strJsonForStep);
      if (map.containsKey('userId')) {
        if (map['userId'] == userId) {
          if (map.containsKey('step')) {
            steps = double.parse('${map['step']}').toInt();
            connections.setStepTarget(steps.toInt());
          }
        }
      }
    }
    setState(() {});
  }

  ///Added by shahzad
  ///Added on: 17th June 2021
  ///Widget to show and handle mic turn on/off
  Widget micOnOff() {
    var provider = Provider.of<SpeechTextModel>(context, listen: false);
    return Visibility(
      visible: showResearcherProfileItems,
      child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
          leading: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.asset(
              'asset/voice_icon.png',
              height: 33,
              width: 33,
            ),
          ),
          title: Body1AutoText(
            text: StringLocalization.of(context).getText(StringLocalization.voiceSetting),
            fontSize: 16.sp,
            maxLine: 1,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.87)
                : HexColor.fromHex('#384341'),
          ),
          trailing: Selector<SpeechTextModel, bool>(
              selector: (context, model) => model.showMic,
              builder: (context, value, _) {
                return CustomSwitch(
                  value: provider.showMic,
                  onChanged: (value) {
                    provider.micOnOff(value);
                  },
                  activeColor: HexColor.fromHex('#00AFAA'),
                  inactiveTrackColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E7EBF2'),
                  inactiveThumbColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.6)
                      : HexColor.fromHex('#D1D9E6'),
                  activeTrackColor: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.darkBackgroundColor
                      : HexColor.fromHex('#E7EBF2'),
                );
              })),
    );
  }

  ///Added by shahzad
  ///Added on: 17th June 2021
  ///Widget to show notification center
  Widget notificationCenter() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Constants.navigatePush(NotificationCenterScreen(), context);
        },
        child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
            leading: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Image.asset(
                'asset/deviceManagement_Icon.png',
                height: 33,
                width: 33,
              ),
            ),
            title: Body1AutoText(
              text: stringLocalization.getText(StringLocalization.notificationCenter),
              fontSize: 16.sp,
              maxLine: 1,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.87)
                  : HexColor.fromHex('#384341'),
            ),
            trailing: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/right_setting_dark.png'
                      : 'asset/right_setting.png',
                  height: 14,
                  width: 8,
                ))),
      ),
    );
  }
}
