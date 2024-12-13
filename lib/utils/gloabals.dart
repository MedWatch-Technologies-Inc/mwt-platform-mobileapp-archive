import 'dart:async';
import 'package:flutter/material.dart';
import 'package:health_gauge/models/ppg_reminder_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/resources/values/app_images.dart';
import 'package:health_gauge/screens/GraphHistory/graph_history_home.dart';
import 'package:health_gauge/screens/connection_screen.dart';
import 'package:health_gauge/screens/dashboard/dash_board_screen.dart';
import 'package:health_gauge/screens/help_screen.dart';
import 'package:health_gauge/screens/home/home_screeen.dart';
import 'package:health_gauge/screens/measurement_screen/measurement_screen.dart';
import 'package:health_gauge/screens/tag/tag_list_screen.dart';
import 'package:health_gauge/socket/socket_helper.dart';
import 'package:health_gauge/utils/Strings.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../background_task.dart';
import 'connections.dart';
import 'constants.dart';
import 'database_helper.dart';



String screen = Constants.home;
UserModel? globalUser;
// bool isEdit = false;
int feet = 5;
int inch = 0;
int centimetre = 150;
double pound = 110;
double kg = 50;
bool isMyTablet = false;
bool bleSyncRunning = (false);
ValueNotifier<bool> bleReadingRunning = ValueNotifier<bool>(false);

double maxPound = 1;
double maxKg = 1;
final dbHelper = DatabaseHelper.instance;


SharedPreferences? preferences;
ValueNotifier<bool?> enableDarkModeNotifier = ValueNotifier(null);

/// Added by: chandresh
/// Added at: 04-06-2020
/// Global keys for tabs: home, graph, measurement and help
GlobalKey<HomeScreenState> homeScreenStateKey = GlobalKey();
GlobalKey<DashBoardScreenState> dashBoardGlobalKey = GlobalKey();
GlobalKey<MeasurementScreenState> measurementGlobalKey = GlobalKey();
GlobalKey<TagListScreenState> tagSelectScreenGlobalKey = GlobalKey();
GlobalKey<HelpScreenState> helpwScreenGlobalKey = GlobalKey();
ValueNotifier<bool> isAISelected = ValueNotifier<bool>(false);
ValueNotifier<bool> isTflSelected = ValueNotifier<bool>(false);

int weightUnit = UnitTypeEnum.metric.getValue();
int heightUnit = UnitTypeEnum.metric.getValue();
int tempUnit = 0;
int distanceUnit = 0;
int timeUnit = 0;
int bloodGlucoseUnit = 0;
Strings strings = Strings();

late StringLocalization stringLocalization;
Connections connections = Connections();
GlobalKey<ConnectionScreenState> connectionScreenKey = GlobalKey();
bool? isFromSignUp;
GlobalKey<GraphHistoryHomeState> graphScreenGlobalKey = GlobalKey();

ValueNotifier<bool> isSocketConnected = ValueNotifier(false);
ValueNotifier<bool> isHRdata   = ValueNotifier(false);

SocketHelper? instanceOfSocket;

AppImages images = AppImages();
PpgReminderModel ppgReminderModel = PpgReminderModel();
Timer? timer;

List<int> avaHR = [];
var navigatorKey =GlobalKey<NavigatorState>();
SocketHelper initSocket(String ipAddress) {
  instanceOfSocket = SocketHelper('http://$ipAddress:3000');

  return instanceOfSocket!;
}


void ppgReminder(String userId, Connections connection) {
  timer = Timer.periodic(Duration(seconds: 1), (timer) {
    var date = DateTime.now();
    if (date.second == 0) {
//        List daysList = ppgReminderModel.days.map((item) => item["day"]).toList();
      var currentTime = TimeOfDay(hour: date.hour, minute: date.minute);
      if ((ppgReminderModel.interval?.contains(currentTime) ?? false) ||
          currentTime == ppgReminderModel.startTime ||
          currentTime == ppgReminderModel.endTime) {
        BackgroundTask(userId: userId, connections: connection)
            .startMeasurement();
      }
    }
  });
}

bool check(String key, Map map) {
  if (map[key] != null) {
    if (map[key] is String && map[key] == 'null') {
      return false;
    }
    return true;
  }
  return false;
}
