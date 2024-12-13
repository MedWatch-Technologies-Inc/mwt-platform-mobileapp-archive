// ignore_for_file: always_declare_return_types, type_annotate_public_apis, avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/utils/reminder_notification.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';

import 'chat_connection_global.dart';

enum TagType {
  exercise,
  health,
  symptoms,
  bloodGlucose,
  smoke,
  stress,
  fatigue,
  running,
  temperature,
  sleep,
  medicine,
  CORONA,
  Alcohol,
  GlucosePatch,
}

extension TagTypeValue on TagType {
  int get value {
    switch (this) {
      case TagType.exercise:
        return 1;
      case TagType.health:
        return 2;
      case TagType.smoke:
        return 3;
      case TagType.bloodGlucose:
        return 4;
      case TagType.stress:
        return 5;
      case TagType.fatigue:
        return 6;
      case TagType.running:
        return 7;
      case TagType.temperature:
        return 8;
      case TagType.sleep:
        return 9;
      case TagType.medicine:
        return 10;
      case TagType.CORONA:
        return 11;
      case TagType.Alcohol:
        return 12;
      case TagType.GlucosePatch:
        return 13;
      default:
        return 2;
    }
  }
}

TagType tagByValue(int? value) {
  if (value != null) {
    switch (value) {
      case 1:
        return TagType.exercise;
      case 2:
        return TagType.health;
      case 3:
        return TagType.smoke;
      case 4:
        return TagType.bloodGlucose;
      case 5:
        return TagType.stress;
      case 6:
        return TagType.fatigue;
      case 7:
        return TagType.running;
      case 8:
        return TagType.temperature;
      case 9:
        return TagType.sleep;
      case 10:
        return TagType.medicine;
      case 11:
        return TagType.CORONA;
      case 12:
        return TagType.Alcohol;
      default:
        return TagType.health;
    }
  }
  return TagType.health;
}

enum GraphTab { day, week, month }

enum WidgetType { dropdown, radioButtons, checkboxList, textFields, label }

extension WidgetTypeValue on WidgetType {
  int get value {
    switch (this) {
      case WidgetType.dropdown:
        return 1;
      case WidgetType.radioButtons:
        return 2;
      case WidgetType.checkboxList:
        return 3;
      case WidgetType.textFields:
        return 4;
      case WidgetType.label:
        return 4;
      default:
        return 5;
    }
  }
}

class Constants {
  static const platform = const MethodChannel('com.helthgauge');
  static const eventChannel = const EventChannel('location');
  static String imageUploadURl = '${baseUrl}GeneralFileUpload/';

  static String sleepReminderModelKey = 'sleepReminderModelKey';

  static String prefActivityTitle = 'activityTitle';
  static String baseHost = 'https://qa.healthgauge.com/';
  static String baseUrl = 'https://qa.healthgauge.com/DeviceServices/';

  static String isOxygenMonitorOnKey = 'isOxygenMonitorOnKey';

  static int hrIntervalForSportModes = 1;
  static int bpIntervalForSportModes = 1;

  static String showMicKey = 'showMicKey';

  static String googleFitEndDate = 'googleFitEndDate';

  static String bloodGlucoseUnitKey = 'bloodGlucoseUnitKey';

  static String weightConnectionType = 'weightConnectionType';

  static String connectedBlePrefKey = 'connected_ble_address';

  static String databasePassword = '010203';

  // static String termAndConditionURL = 'https://www.healthgauge.com/copy-of-privacy-policy';
  static String termAndConditionURL =
      'https://www.healthgauge.com/terms-of-service';
  static String privacyPolicyURL = 'https://www.healthgauge.com/privacy-policy';

  static String estimateApiUrl =
      'http://ec2-100-25-163-229.compute-1.amazonaws.com:80/predict';
  static String nlpApiUrl =
      'http://ec2-3-83-253-148.compute-1.amazonaws.com:5000/predict_GPT3_tagging';
  static String hr = 'hr';
  static String hrv = 'hrv';
  static String light = 'light';
  static String deep = 'deep';
  static String total = 'total';
  static String sBp = 'sBp';
  static String dBp = 'dBp';
  static String step = 'Steps';

  static String authToken = '';

  static Map<String, String> header = {
    'Authorization': 'Bearer $authToken',
    'Content-Type': 'application/json',
  };
  static Map<String, String> headerFormData = {
    'Authorization': '$authToken',
    'Content-Type': 'application/form-data',
  };

  static String prefUserIdKeyInt = 'pref_user_id';
  static String prefUserEmailKey = 'pref_email';
  static String prefUserName = 'pref_user_name';
  static String prefUserPasswordKey = 'password';
  static String prefsLastSyncTimeStamp = 'prefsLastSyncTimeStamp';
  static String toggleSwitch = 'toggleSwitch';

  static String prefLoginResponse = 'loginResponse';

  static String userTableName = 'user';

  static String kUserId = 'UserID';
  static String kPageNumber = 'PageNumber';
  static String kPageIndex = 'PageIndex';
  static String kPageSize = 'PageSize';
  static String kFromDateStamp = 'FromDateStamp';
  static String kToDateStamp = 'ToDateStamp';
  static String kbpReminder = 'BpReminder';

  static int remidertimeInDays = 7;

  static String surveyId = 'SurveyID';

  static String connectedDeviceAddressPrefKey = 'connected_device_address';
  static String connectedBLEDeviceAddressPrefKey =
      'connected_ble_device_address';

  //this is maximum ecg read count
  static var maximumReadCount = 3750;

//  static var maximumReadCount = 13000;

  static String prefTokenKey = 'Token';

  static String prefConsentKey = 'pref_consent_key';
  static String prefMTagging = 'pref_measurement_tagging';
  static String prefMTime = 'pref_measurement_time';

  static String prefSavedSleepTarget = 'SleepTarget';

  static String prefKeyForGraphWindowTemp = 'graphTemplets';

  static String prefKeyForGraphPages = 'prefKeyForGraphPages';

  static String prefSavedStepTarget = 'StepTarget';

  static String prefServerType = 'serverType';

  static String isTrainingEnableKey = 'IsTrainingEnable';
  static String isTrainingEnableKey1 = 'IsTrainingEnable1';

  static String isGoogleSyncEnabled = 'isGoogleSyncEnabled';
  static String isOscillometricEnableKey = 'isOscillometricEnableKey';
  static String isOscillometricEnableKey1 = 'isOscillometricEnableKey1';

  static String isEstimatingEnableKey = 'isEstimatingEnable';
  static String isEstimatingEnableKey1 = 'isEstimatingEnable1';

  static String isGlucoseData = 'isGlucoseData';
  static String isGlucoseData1 = 'isGlucoseData1';

  static String synchronizationKey = 'synchronization';

  static String isLiftTheWristBrightnessOnKey = 'isLiftTheWristBrightnessOn';

  static String isDoNotDisturbKey = 'isDoNotDisturb';

  static String isTimeFormat24hKey = 'isTimeFormat24h';

  static String isHourlyHrMonitorOnKey = 'isHourlyHrMonitorOn';
  static String isBPMonitorOnKey = 'isBPMonitorOn';

  static String isWearOnLeftKey = 'wearOnLeft';

  static String brightnessLevel = 'brightnessLevel';
  static String isTemperatureMonitorOnKey = 'isTemperatureMonitorOn';
  static String temperatureTimeInterval = 'tempTimeInterval';
  static String heartRateInterval = 'hrTimeInterval';
  static String bpRateInterval = 'bpRateInterval';
  static String oxygenTimeInterval = 'oxygenTimeInterval';

  static double height = 752.9411905502093;
  static double width = 752.9411905502093;

  static double staticHeight = 752.9411905502093;
  static double staticWidth = 423.5294196844927;

  static String isOverrideLanguageSetting = 'isOverrideLanguageSetting';

  static String hrCalibrationPrefKey = 'hrCalibrationPrefKey';
  static String sbpCalibrationPrefKey = 'sbpCalibrationPrefKey';
  static String dbpCalibrationPrefKey = 'dbpCalibrationPrefKey';
  static String e66CalibrationValue = 'e66CalibrationValue';
  static String measurementType = 'measurementType';
  static String unit = 'unit';
  static String rememberMe = 'rememberMe';
  static String storedUserId = 'storedUserId';
  static String storedPassword = 'storedPassword';

  static String home = 'home';
  static String profile = 'profile';
  static String deviceManagement = 'FindBracelet';
  static String connections = 'connections';
  static String settings = 'settings';
  static String cardio = 'cardio';
  static String activityDay = 'activityDay';
  static String activityWeekly = 'activityWeeklyMonthly';
  static String sleep = 'sleep';
  static String tag = 'tag';
  static String tagEditorList = 'tagEditorList';
  static String tagEditor = 'tagEditor';
  static String graph = 'graph';
  static String measurementHistory = 'measurementHistory';
  static String tagHistory = 'tagHistory';
  static String findBracelet = 'findBracelet';
  static String liftTheWrist = 'liftTheWrist';
  static String doNotDisturb = 'doNotDisturb';
  static String timeFormat = 'timeFormat';
  static String wearingMethod = 'wearingMethod';
  static String training = 'training';
  static String callEnable = 'callEnable';
  static String messageEnable = 'messageEnable';
  static String qqEnable = 'qqEnable';
  static String weChatEnable = 'weChatEnable';
  static String linkedInEnable = 'linkedInEnable';
  static String skypeEnable = 'skypeEnable';
  static String facebookMessengerEnable = 'facebookMessengerEnable';
  static String twitterEnable = 'twitterEnable';
  static String whatsAppEnable = 'whatsAppEnable';
  static String viberEnable = 'viberEnable';
  static String lineEnable = 'lineEnable';

  static String gmailEnable = 'gmailEnable';
  static String instagramEnable = 'instagramEnable';
  static String snapchatEnable = 'snapchatEnable';
  static String facebookEnable = 'facebookEnable';
  static String weiboEnable = 'weiboEnable';

  static String wightUnitKey = 'wightUnit';
  static String mHeightUnitKey = 'mHeightUnit';
  static String mDistanceUnitKey = 'mDistanceUnit';
  static String mTemperatureUnitKey = 'mTemperatureUnit';
  static String mTimeUnitKey = 'mTimeUnit';

  static String device = 'device';

  static String doNotAskMeAgainForMeasurementDialog =
      'doNotAskAgainForMeasurementDialog';

  static String doNotAskMeAgainForCameraMeasurementDialog =
      'doNotAskMeAgainForCameraMeasurementDialog';

  static num dbVersion = 2;

  static String prefHomeScreenItems = 'prefHomeScreenItems';

  static String prefSavedCaloriesTarget = 'prefSavedCaloriesTarget';

  static String prefSavedDistanceTarget = 'prefSavedDistanceTarget';

  static String prefSavedWeightTarget = 'prefSavedWeightTarget';

  static int homeScreenAnimationMilliseconds = 400;
  static String googleFit = 'googleFit';
  static String googleFitlastSync = 'googleFitlastSync';
  static String healthKit = 'healthKit';
  static String bracelet = 'bracelet';

  static String cardioMeasurement = 'cardioMeasurement';

  static String isAISelected = 'isAISelected';
  static String isTFLSelected = 'isTFLSelected';
  static String lastAppVersion = 'lastAppVersion';

  static var maximumBloodPressure = 200;

  static int maximumSecondsValue = 60;

  static const int hBand = 4;
  static var weightScale = 3;
  static const int e66 = 2;

  static const int zhBle = 1;
  static const int defaultValueofHeightinCM = 150;

  /// health kit constant strings
  static const String healthKitStep = 'Steps';
  static const String healthKitDistance = 'Distance';
  static const String healthKitHeight = 'Height';
  static const String healthKitSleep = 'Sleep';
  static const String healthKitHr = 'HeartRate';
  static const String healthKitWeight = 'BodyMass';
  static const String healthKitDBP = 'DiastolicBloodPressure';
  static const String healthKitSBP = 'SystolicBloodPressure';
  static const String healthKitBloodGlucose = 'BloodGlucose';
  static const String healthKitTemperature = 'BodyTemperature';
  static const String healthKitOxygen = 'OxygenSaturation';
  static const String healthKitActiveCalories = 'ActiveCalorieBurn';
  static const String healthKitRestingCalories = 'RestingCalorieBurn';

  static List googlefitType = [
    healthKitStep,
    healthKitDistance,
    healthKitHeight,
    healthKitSleep,
    healthKitHr,
    healthKitWeight,
    healthKitDBP,
    healthKitSBP,
    healthKitBloodGlucose,
    healthKitTemperature,
    healthKitOxygen,
    healthKitActiveCalories,
    healthKitRestingCalories,
  ];

  static Future<bool> isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static progressDialog(bool isLoading, BuildContext context) {
    var dialog = AlertDialog(
      content: Container(
        height: 40.0,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(padding: EdgeInsets.only(left: 15.0)),
              Text(stringLocalization.getText(StringLocalization.pleaseWait))
            ],
          ),
        ),
      ),
      contentPadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
    );
    if (!isLoading) {
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }
  }

  static resultInApi(var value, var isError) {
    var map = <String, dynamic>{'isError': isError, 'value': value};
    return map;
  }

  static Future navigatePush(Widget page, BuildContext context,
      {bool rootNavigation = false}) {
    var route = CupertinoPageRoute(builder: (context) => page);
    return navigatorKey.currentState!.push(route);
  }

  static navigatePushReplace(Widget page, BuildContext context,
      {bool rootNavigation = false}) {
    var route = CupertinoPageRoute(builder: (context) => page);
    navigatorKey.currentState!.pushReplacement(route);
    return Future.value();
  }

  static navigatePushAndRemove(Widget page, BuildContext context,
      {bool rootNavigation = false}) {
    var route = CupertinoPageRoute(builder: (context) => page);
    navigatorKey.currentState!
      ..pushAndRemoveUntil(route, (Route<dynamic> route) => false);
    return Future.value();
  }

  static validateEmail(String value) {
    var pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regex = RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool isNumeric(String s) {
    return double.tryParse('$s') != null;
  }

  static String encryptStr(String value) {
    var bytes = utf8.encode(value);
    return bytes.join(',');
  }

  static String? deCryptStr(String value) {
    var list = value.split(',');
    var intList = list.map((f) => int.parse(f.toString())).toList();
    return utf8.decode(intList);
  }

  // static Future chatConnectionEstablishing() async {
  //   var chatConnectionGlobal = ChatConnectionGlobal();
  //
  //   try {
  //     Timer.periodic(Duration(seconds: 5), (timer) async {
  //       if (ChatConnectionGlobal().connectionState == ChatConnectionState.DISCONNECTED) {
  //         await ChatConnectionGlobal().connectToHub();
  //       } else if (ChatConnectionGlobal().connectionState == ChatConnectionState.CONNECTING) {
  //         // do nothing;
  //       } else if (ChatConnectionGlobal().connectionState == ChatConnectionState.CONNECTED) {
  //         timer.cancel();
  //       }
  //     });
  //   } catch (e) {
  //     debugPrint('Exception at chatConnectionEstablishing $e');
  //   }
  // }

  static initScreenUtils(context) {
    // ScreenUtil.init(context, width: Constants.width, height: Constants.height, allowFontScaling: true);
  }
}

enum UnitTypeEnum {
  metric,
  imperial,
}

extension UnitExtension on UnitTypeEnum {
  int getValue() {
    switch (this) {
      case UnitTypeEnum.metric:
        return 0;
      case UnitTypeEnum.imperial:
        return 1;
    }
  }

  static UnitTypeEnum getUnitType(int val) {
    if (val == 1) {
      return UnitTypeEnum.metric;
    } else {
      return UnitTypeEnum.imperial;
    }
  }
}

// For Drawing Canvas
final double canvasSize = 300;
final double borderSize = 2;
final double strokeWidth = 16;
final int mnistSize = 28;
