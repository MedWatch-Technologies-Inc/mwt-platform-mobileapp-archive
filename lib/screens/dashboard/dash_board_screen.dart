// ignore_for_file: unrelated_type_equality_checks, invalid_use_of_visible_for_testing_member, always_put_required_named_parameters_first, omit_local_variable_types

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/contact_models/pending_invitation_model.dart';
import 'package:health_gauge/models/contact_models/user_list_model.dart';
import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/infoModels/device_info_model.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/repository/auth/auth_repository.dart';
import 'package:health_gauge/repository/contact/contact_repository.dart';
import 'package:health_gauge/repository/contact/request/accept_reject_invitation_request.dart';
import 'package:health_gauge/repository/contact/request/delete_contact_request.dart';
import 'package:health_gauge/repository/sleep/request/store_sleep_record_detail_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/screens/BloodPressureHistory/bp_history_home.dart';
import 'package:health_gauge/screens/GraphHistory/BPGraphHistory/bp_graph_history_home.dart';
import 'package:health_gauge/screens/HeartRateHistory/hr_history_home.dart';
import 'package:health_gauge/screens/HelpModule/help_page.dart';
import 'package:health_gauge/screens/MeasurementHistory/m_history_home.dart';
import 'package:health_gauge/screens/OxygenHistory/o_history_home.dart';
import 'package:health_gauge/screens/chat/pages/chat_tab_page.dart';
import 'package:health_gauge/screens/dashboard/app_bar.dart';
import 'package:health_gauge/screens/dashboard/drawer/drawer.dart';
import 'package:health_gauge/screens/dashboard/helper_widgets/home_vital_item.dart';
import 'package:health_gauge/screens/dashboard/home_item_model.dart';
import 'package:health_gauge/screens/help_screen.dart';
import 'package:health_gauge/screens/map_screen/map_screen.dart';
import 'package:health_gauge/screens/setting_screen.dart';
import 'package:health_gauge/screens/weight_measurement/weight_measurement_screen.dart';
import 'package:health_gauge/services/analytics/sentry_analytics.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/utils/Synchronisation/sync_helper.dart';
import 'package:health_gauge/utils/Synchronisation/watch_sync_helper.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/cron_helper.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/buttons.dart';
import 'package:health_gauge/widgets/custom_snackbar.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:iirjdart/butterworth.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/app_service.dart';
import '../../repository/preference/preference_repository.dart';
import '../connection_screen.dart';
import '../profile_screen.dart';
import '../sign_in_screen.dart';
import '../terms_&_condition.dart';

import 'circal_list/circular_list.dart';

DeviceModel? connectedDeviceDash;
ValueNotifier<bool?> isDeviceConnected = ValueNotifier<bool?>(null);

class DashBoardScreen extends StatefulWidget {
  DashBoardScreen({Key? key}) : super(key: key);

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  String userId = '';
  String userEmail = '';

  static WeightMeasurementModel data = WeightMeasurementModel(); // weight measurement model
  double bMI = 0.0;

  //this is mac address of last connected device

  //this model is use for get battery level
  DeviceInfoModel? deviceInfoModel;

  double targetCalories = 2000;

  double pos_l = 0;
  bool closeShimmer = false;

  Timer? heartRateSecondsTimer;

  // bool socketError = false;

  ValueNotifier<bool> socketError = ValueNotifier(false);

  ValueNotifier<LineChartController?> controller = ValueNotifier(null);

  //endregion

  int sumOfDistanceForCalculatePPG = 0;

  ValueNotifier<int> selectedHeartRateSituation = ValueNotifier(0);

  int currentHRV = 0;
  int syncing = 0;

  // double weight = 0;
  double maxWeight = 200;

  String lastEcgMeasurementDetail = '';
  String lastWeightMeasurementDetail = '';

  bool isDarkMode = false;

  late ValueNotifier<String?> selectedWidgetNotifier = ValueNotifier('bloodPressure');

  ValueNotifier<bool?> isAnimatingNotifier = ValueNotifier<bool?>(false);

  ValueNotifier<UserModel?> user = ValueNotifier<UserModel?>(null);

  ValueNotifier<int> measurementDurationNotifier = ValueNotifier(30);

  // ValueNotifier<num?> heartRateNotifier = ValueNotifier(0);
  double heartRateAvaNotifier = 0;

  //endregion

  DateTime? lastDataFetchedTime;

  bool showHistory = false;

  //region ECG
  num ecgValueX = 200;
  List ecgPointList = [];

  num firstPointECG = 0;
  num secondPointECG = 0;
  List ecgAvgList = [];
  List<Entry> valuesForEcgGraph = [];

  //endregion

  //region PPG
  num ppgValueX = 200;
  num firstPointPPG = 0;
  num secondPointPPG = 0;

  List ppgPointList = [];
  List ppgAvgList = [];
  List filteredPPGList = [];

  Butterworth butterworth = Butterworth();
  Butterworth butterWorthLowPass = Butterworth();
  List<Entry> valuesForPpgGraph = [];

  //endregion

  DateTime lastRecordDate = DateTime.now();

  bool isFetchedSportData = false;
  bool isFetchedSleepData = false;
  bool isFetchedHeartRate = false;
  bool isFetchedTempData = false;
  bool loaderIsShowing = false;
  late int measurementType;
  AnimationController? animationCtrl;

  @override
  void initState() {
    if (Platform.isAndroid) {
      CronHelper.instance.schedule();
    }
    if (Platform.isAndroid) {
      butterWorthLowPass.lowPass(3, 200, 90);
      // butterWorthLowPass?.lowPass(300,256,250);
    } else {
      butterWorthLowPass.lowPass(3, 800, 84);
    }
    initializeConnection();
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (timer.tick > 60 || connectedDeviceDash != null) {
        timer.cancel();
      }
    });

    Future.delayed(Duration(seconds: 4), () {
      closeShimmer = true;
      if (mounted) {
        setState(() {});
      }
    });

    checkAndRedirectToProfileScreen();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshBuilder();
      WatchSyncHelper().dashData.resetData();
      initializeData();
      if (isDeviceConnected.value ?? true) {
        // SyncHelper().initWatchConfig();
        refreshBuilder();
      }
    });
    super.initState();
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
  }

  void initializeData() async {
    await initInternetProcess();
    fetchUserDetails();
    await getPreferences();
    syncDataToApi();
    SyncHelper().syncDataFromServer();
  }

  void initializeConnection() async {
    var deviceModel = await connections.checkAndConnectDeviceIfNotConnected();
    if (deviceModel != null) {
      preferences?.setString(
          Constants.connectedDeviceAddressPrefKey, jsonEncode(deviceModel.toMap()));
      connectedDeviceDash = deviceModel;
      connections.sdkType = deviceModel.sdkType ?? Constants.e66;
      connectedDeviceDash!.sdkType = deviceModel.sdkType ?? Constants.e66;
      isDeviceConnected.value = true;
      refreshBuilder();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkAndRedirectToProfileScreen() async {
    try {
      Future.delayed(Duration(milliseconds: 300)).then(
        (value) async {
          if (isFromSignUp != null && isFromSignUp!) {
            isFromSignUp = false;
            Constants.navigatePush(
              ProfileScreen(),
              context,
              rootNavigation: false,
            ).then(
              (value) {
                screen = Constants.home;
                dbHelper.getUser(userId).then(
                  (value) {
                    this.user.value = value;
                    savePreferences();
                  },
                );
              },
            );
          }
        },
      );
    } on Exception catch (e) {
      debugPrint('Exception in checkAndRedirectToProfileScreen $e');
    }
  }

  @override
  void didChangeDependencies() {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    super.didChangeDependencies();
  }

  void syncDataToApi() async {
    await getPreferences();
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet && userId.isNotEmpty && !userId.contains('Skip')) {
      syncContacts();
      syncInvitations();
    }
  }

  void onClickBluetoothBtn() {
    try {
      print('sleep_data ${StoreSleepRecordDetailRequest().toJson()}');
      Constants.navigatePush(
              ConnectionScreen(
                connectedDevice: connectedDeviceDash,
                key: connectionScreenKey,
                sdkType: Constants.e66,
                title: 'Bluetooth',
              ),
              context,
              rootNavigation: false)
          .then(
        (value) async {
          screen = Constants.home;
          await connections.checkAndConnectDeviceIfNotConnected().then((value) {
            connectedDeviceDash = value;
            connectedDeviceDash!.sdkType = value?.sdkType ?? Constants.e66;
            connections.sdkType = value?.sdkType ?? Constants.e66;
            isDeviceConnected.value = value != null;
          });
          if (connectedDeviceDash == null) {
            deviceInfoModel = null;
            connectedDeviceDash = null;
          }

          savePreferences();
          refreshBuilder();
          if (mounted) {}
        },
      );
    } on Exception catch (e) {
      debugPrint('Exception in bluetooth btn $e');
    }
  }

  void onClickChat() async {
    try {
      Constants.navigatePush(
        ChatTabPageEnter(int.parse(userId)),
        context,
        rootNavigation: false,
      );
    } catch (e) {}
  }

  void onClickHistory() {
    try {
      showHistory = !showHistory;
      setState(() {});
    } on Exception catch (e) {
      debugPrint('Exception in on click History $e');
    }
  }

  void onClickMeasurementHistory() {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      Constants.navigatePush(MHistoryHome(), context).then((value) => screen = Constants.home);
    } on Exception catch (e) {
      debugPrint('Exception in on click measurement history $e');
    }
  }

  void onClickHeartRateHistory() {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      Constants.navigatePush(HRHistoryHome(), context).then((value) => screen = Constants.home);
    } on Exception catch (e) {
      debugPrint('Exception in on click temperature history $e');
    }
  }

  void onClickBloodPressureHistory() {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      Constants.navigatePush(BPHistoryHome(), context).then((value) => screen = Constants.home);
    } on Exception catch (e) {
      debugPrint('Exception in on click temperature history $e');
    }
  }

  void onClickSPO2History() {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      Constants.navigatePush(OHistoryHome(), context).then((value) => screen = Constants.home);
    } on Exception catch (e) {
      debugPrint('Exception in on click Oxygen history $e');
    }
  }

  void onClickWeightScreen() async {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      await Constants.navigatePush(
              WeightMeasurementScreen(
                user: globalUser,
              ),
              context)
          .then((value) {
        // savePreferences();
      });
      screen = Constants.home;

      if (mounted) {
        setState(() {});
      }
    } on Exception catch (e) {
      debugPrint('Exception in on click weight screen $e');
    }
  }

  void refreshBuilder() {
    selectedWidgetNotifier.notifyListeners();
    setState(() {});
    return;
  }

  void onClickSettingScreen() async {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      await Constants.navigatePush(
              SettingScreen(
                deviceInfoModel: deviceInfoModel,
                user: globalUser,
              ),
              context,
              rootNavigation: false)
          .then((value) {
        if (mounted) {
          setState(() {});
        }
      });
      screen = Constants.home;

      savePreferences();
    } on Exception catch (e) {
      printMessage('onClickSettingScreen $e');
    }
  }

  void onClickProfile() {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      if (userId.contains('Skip')) {
        var dialog = AlertDialog(
          title: Text(StringLocalization.of(context).getText(StringLocalization.appName)),
          content: Text(StringLocalization.of(context)
              .getText(StringLocalization.pleaseLoginFirstToUseThisFeature)),
          actions: <Widget>[
            FlatBtn(
              onPressed: () async {
                await AppService.getInstance.logoutUser();
                Constants.navigatePushAndRemove(SignInScreen(), context, rootNavigation: true);
              },
              text: StringLocalization.of(context).getText(StringLocalization.ok),
            ),
            FlatBtn(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              text: StringLocalization.of(context).getText(StringLocalization.cancel),
            ),
          ],
        );
        showDialog(
          context: context,
          useRootNavigator: true,
          builder: (context) => dialog,
        );
      } else {
        Constants.navigatePush(
          ProfileScreen(),
          context,
          rootNavigation: false,
        ).then((value) {
          screen = Constants.home;
          dbHelper.getUser(userId).then((value) {
            user.value = value;
          });
          if (mounted) {
            setState(() {});
          }
        });
      }
    } on Exception catch (e) {
      printMessage('onClickProfile');
    }
  }

  void onClickTermsAndCondition() {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      Constants.navigatePush(
        TermsAndCondition(
          title: StringLocalization.of(context).getText(StringLocalization.termsAndConditions),
        ),
        context,
      ).then((value) => screen = Constants.settings);
    } on Exception catch (e) {
      printMessage('onClickTermsAndCondition $e');
    }
  }

  void onClickSignOut() {
    try {
      if (mounted) {
        Navigator.of(context).pop();
      }
      logoutDialog();
    } on Exception catch (e) {
      printMessage('onClickSignOut $e');
    }
  }

  void printMessage(String exceptionMethod) {
    debugPrint('Exception in $exceptionMethod');
  }

  void onClickHelpBtn() {
    try {
      // Constants.navigatePush(
      //     HelpScreen(
      //       title: 'Help',
      //     ),
      //     context,
      //     rootNavigation: false);
      Constants.navigatePush(HelpPage(), context, rootNavigation: false);
    } on Exception catch (e) {
      debugPrint('Exception in Help btn $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, width: 375.0, height: 812.0, allowFontScaling: true);
    isDarkMode = Theme.of(context).brightness == Brightness.dark;

    var homeScreenItems = [];
    homeScreenItems = [
      'bloodPressure',
      'heartRate',
      'hrv',
      'weight',
    ];

    return SafeArea(
      top: false,
      bottom: Platform.isIOS,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: ValueListenableBuilder(
              valueListenable: isDeviceConnected,
              builder: (context, value, widget) {
                return AppBarForDashBoard(
                  userId: userId,
                  userEmail: userEmail,
                  isDeviceConnected: value ?? false,
                  onTapBluetoothBtn: onClickBluetoothBtn,
                  onTapHelpBtn: onClickHelpBtn,
                  onTapChatBtn: onClickChat,
                );
              }),
        ),
        drawer: DrawerForDashboard(
          userEmail: userEmail,
          userNotifier: user,
          onClickSettingScreen: onClickSettingScreen,
          onClickProfile: onClickProfile,
          onClickTermsAndCondition: onClickTermsAndCondition,
          onClickSignOut: onClickSignOut,
          onClickHistory: onClickHistory,
          onClickMeasurementHistory: onClickMeasurementHistory,
          onClickWeightScreen: onClickWeightScreen,
          onClickHeartRateHistory: onClickHeartRateHistory,
          onClickBloodPressureHistory: onClickBloodPressureHistory,
          onClickSPO2History: onClickSPO2History,
          showHistory: showHistory,
          onUOFAClick: (bool isEnable) {},
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
          ),
          child: ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Center(
                child: Body1AutoText(
                  text: 'Health And Wellness Dashboard',
                  fontSize: 16.sp,
                  minFontSize: 14.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.87)
                      : HexColor.fromHex('#384341'),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              if (homeScreenItems.contains('bloodPressure')) ...[
                ValueListenableBuilder(
                  valueListenable: WatchSyncHelper().dashData.sysN,
                  builder: (BuildContext context, num value, Widget? child) {
                    return HomeVitalItem(
                      homeItemModel: HomeItemModel(
                        iconPath: 'asset/HomeItem/home_BP.png',
                        isAiModeSelected: isAISelected.value,
                        details: getItemDetails('bloodPressure'),
                      ),
                      homeItemModel1: HomeItemModel(title: '', iconPath: ''),
                      onTap: () {
                        Constants.navigatePush(BPGraphHistoryHome(), context)
                            .then((value) => screen = Constants.home);
                      },
                    );
                  },
                ),
              ],
              if (homeScreenItems.contains('heartRate') && homeScreenItems.contains('hrv')) ...[
                ValueListenableBuilder(
                  valueListenable: WatchSyncHelper().dashData.hrN,
                  builder: (BuildContext context, num value, Widget? child) {
                    return HomeVitalItem(
                      homeItemModel: HomeItemModel(
                          title: homeHRValue,
                          iconPath: 'asset/HomeItem/home_HR.png',
                          isAiModeSelected: isAISelected.value,
                          details: getItemDetails('heartRate'),
                          fontTitleSize: 13.0,
                          fontDetailSize: 11.0,
                          iconSize: 24),
                      homeItemModel1: HomeItemModel(
                        title: homeHRVValue,
                        iconPath: 'asset/strees_55.png',
                        isAiModeSelected: isAISelected.value,
                        details: getItemDetails('hrv'),
                        iconSize: 32.0,
                        fontTitleSize: 13.0,
                        fontDetailSize: 11.0,
                      ),
                      onTap: () {
                        Constants.navigatePush(HRHistoryHome(), context)
                            .then((value) => screen = Constants.home);
                      },
                    );
                  },
                ),
              ],
              if (homeScreenItems.contains('heartRate') && !homeScreenItems.contains('hrv')) ...[
                ValueListenableBuilder(
                  valueListenable: WatchSyncHelper().dashData.hrN,
                  builder: (BuildContext context, num value, Widget? child) {
                    return HomeVitalItem(
                      homeItemModel: HomeItemModel(
                        title: homeHRValue,
                        iconPath: 'asset/HomeItem/home_HR.png',
                        isAiModeSelected: isAISelected.value,
                        details: getItemDetails('heartRate'),
                      ),
                      homeItemModel1: HomeItemModel(iconPath: ''),
                      onTap: () {
                        Constants.navigatePush(HRHistoryHome(), context)
                            .then((value) => screen = Constants.home);
                      },
                    );
                  },
                ),
              ],
              if (homeScreenItems.contains('hrv') && !homeScreenItems.contains('heartRate')) ...[
                ValueListenableBuilder(
                  valueListenable: WatchSyncHelper().dashData.hrvN,
                  builder: (BuildContext context, num value, Widget? child) {
                    return HomeVitalItem(
                      homeItemModel: HomeItemModel(
                        title: homeHRVValue,
                        iconPath: 'asset/strees_55.png',
                        isAiModeSelected: isAISelected.value,
                        details: getItemDetails('hrv'),
                      ),
                      homeItemModel1: HomeItemModel(iconPath: ''),
                      onTap: () {},
                      showGraph: false,
                    );
                  },
                ),
              ],
              CircularList(
                userNotifier: user,
                connectedDevice: connectedDeviceDash,
                selectedWidgetNotifier: selectedWidgetNotifier,
                isAnimatingNotifier: isAnimatingNotifier,
                measurementDurationNotifier: measurementDurationNotifier,
                hrGraphNotifier: controller,
                onClickBloodPressureWidget: () {},
                onClickHRV: () {},
                onClickHRWidget: () {},
                onClickWeightWidget: () {},
                onClickOxygenWidget: () {},
                onClickHRSmallCircle: (_) => () {},
                isAiModeSelected: isAISelected.value,
                currentHrNotifier: WatchSyncHelper().dashData.hrN,
                currentSysNotifier: WatchSyncHelper().dashData.sysN,
                currentDiaNotifier: WatchSyncHelper().dashData.diaN,
                currentHRVNotifier: WatchSyncHelper().dashData.hrvN,
                currentWeightNotifier: WatchSyncHelper().dashData.weightN,
                currentOxygenNotifier: WatchSyncHelper().dashData.oxygenN,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> getItemDetails(String type) {
    switch (type) {
      case 'bloodPressure':
        return [
          homeSys,
          homeDys,
        ];

      case 'heartRate':
        return [
          homeHrSTR,
        ];
      case 'hrv':
        return [
          homeHRV,
        ];

      default:
        return <String>[];
    }
  }

  String get homeHRV => 'HR Variability';

  String get homeHRVValue => '${WatchSyncHelper().dashData.hrv}';

  String get homeHrSTR => 'Heart Rate';

  String get homeHRValue => '${WatchSyncHelper().dashData.hr}';

  String get homeSys => 'Systolic : ${WatchSyncHelper().dashData.sys.toStringAsFixed(0)}';

  String get homeDys => 'Diastolic : ${WatchSyncHelper().dashData.dia.toStringAsFixed(0)}';

  void logoutDialog() {
    var dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                      : HexColor.fromHex('#DDE3E3').withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(-5, -5)),
              BoxShadow(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#000000').withOpacity(0.75)
                      : HexColor.fromHex('#384341').withOpacity(0.9),
                  blurRadius: 5,
                  spreadRadius: 0,
                  offset: Offset(5, 5))
            ]),
        padding: EdgeInsets.only(top: 20, left: 16, right: 10),
        // height: 128,
        width: 309,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Body1AutoText(
                      text: stringLocalization.getText(StringLocalization.logOutConfirmMsg),
                      maxLine: 2,
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                          : HexColor.fromHex('#384341'),
                      minFontSize: 16,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: TextButton(
                          key: Key('dialogYes'),
                          onPressed: () async {
                            var tokenValue = preferences?.getString('firebaseMessagingToken') ?? '';
                            LoggingService().unSetUserInfo();
                            SentryAnalytics().unsetUserScope();
                            await AppService.getInstance.logoutUser();
                            Constants.navigatePushAndRemove(
                                SignInScreen(
                                  token: tokenValue,
                                ),
                                context,
                                rootNavigation: true);
                          },
                          child: SizedBox(
                            height: 23,
                            child: AutoSizeText(
                              stringLocalization.getText(StringLocalization.yes).toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: HexColor.fromHex('#00AFAA'),
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                          child: SizedBox(
                            height: 23,
                            child: AutoSizeText(
                              stringLocalization.getText(StringLocalization.cancel).toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: HexColor.fromHex('#00AFAA'),
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) => dialog,
      barrierColor: Theme.of(context).brightness == Brightness.dark
          ? AppColor.color7F8D8C.withOpacity(0.6)
          : AppColor.color384341.withOpacity(0.6),
      barrierDismissible: false,
    );
  }

  void syncContacts() async {
    try {
      var contactList = await dbHelper.getLocalDeletedContacts(int.parse(userId));
      for (var contact in contactList) {
        await postDeletedContacts(contact);
      }
    } catch (e) {
      debugPrint('Exception at DashBoardScreen $e');
    }
  }

  void syncInvitations() async {
    try {
      var invitations =
          await dbHelper.getOfflineAcceptedOrRejectedInvitationList(int.parse(userId));
      for (var invitation in invitations) {
        await postInvitationResponse(invitation);
      }
    } catch (e) {
      debugPrint('Exception at DashBoardScreen $e');
    }
  }

  Future postInvitationResponse(InvitationList invitation) async {
    if (userId.contains('Skip')) {
      return Future.value();
    }
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      var acceptRejectRequest = AcceptRejectInvitationRequest(
        contactID: invitation.contactID.toString(),
        isAccepted: invitation.isAccepted.toString(),
      );
      var request = await ContactRepository().acceptOrRejectInvitation(acceptRejectRequest);
      if (request.hasData) {
        if (request.getData!.result!) {
          await dbHelper.deleteInvitation(invitation.contactID ?? 0);
        }
      }
      // var result = await AcceptOrRejectInvitation().callApi(invitation.contactID??0, invitation.isAccepted??false);
      // if (result?.result??false) {
      //   await dbHelper.deleteInvitation(invitation.contactID??0);
      // }
    }
  }

  Future postDeletedContacts(UserData contact) async {
    if (userId.contains('Skip')) {
      return Future.value();
    }
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      var request = DeleteContactRequest(
          contactFromUserID: userId, contactToUserId: contact.fKReceiverUserID.toString());
      var contactResult = await ContactRepository().deleteContactByUserId(request);
      if (contactResult.hasData) {
        if (contactResult.getData!.result!) {
          await dbHelper.deleteContact(contact.id ?? 0);
        }
      }
      // var result = await DeleteContactFromGroup().callApi(int.parse(userId), contact.fKReceiverUserID??0);
      // if (result?.result??false) {
      //   await dbHelper.deleteContact(contact.id??0);
      // }
    }
  }

  Future<void> getPreferences() async {
    preferences ??= await SharedPreferences.getInstance();
    getUnitFromPreferences();
    userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    userEmail = preferences?.getString(Constants.prefUserEmailKey) ?? '';
    dbHelper.getUser(userId).then((value) {
      user.value = value;
      globalUser = value;
    });
    setUnitInNative();

    var time = preferences?.getInt('backupTime') ?? 0;
    if (time == null) {
      preferences?.setInt('backupTime', 0);
    }
  }

  void setUnitInNative() {
    try {
      connections.changeWeightScaleUnit(weightUnit + 1);
      var map = {
        'weightUnit': weightUnit,
        'heightUnit': heightUnit,
        'tempUnit': tempUnit,
        'distanceUnit': distanceUnit,
        'timeUnit': timeUnit
      };
      connections.setUnits(map);
    } catch (e) {
      debugPrint('Exception at DashBoardScreen $e');
    }
  }

  Future<void> callApiForGettingLatestAuthToken(
      {required String userName, required String pass}) async {
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      var deviceToken = preferences?.getString('firebaseMessagingToken') ?? '';
      var signInResult = await AuthRepository().userLogin(userName, pass, deviceToken);
      if (signInResult.hasData) {
        if (signInResult.getData!.result ?? false) {
          var userModel = UserModel.mapper(signInResult.getData!.data!);
          globalUser = userModel;
          preferences?.setString(Constants.prefUserIdKeyInt, userModel.userId ?? '');
          preferences?.setString(Constants.prefUserName, userModel.userName ?? '');
          preferences?.setString(Constants.prefUserPasswordKey, Constants.encryptStr(pass));
        }
      }
    }
  }

  void checkInternet() async {}

  Future initInternetProcess() async {
    var isInternet = await Constants.isInternetAvailable();
    if (isInternet) {
      preferences ??= await SharedPreferences.getInstance();
      var userName = preferences?.getString(Constants.prefUserName) ?? '';
      var pass = preferences?.getString(Constants.prefUserPasswordKey) ?? '';
      final decrypted = Constants.deCryptStr(pass) ?? '';
      if (!userId.contains('Skip')) {
        await callApiForGettingLatestAuthToken(userName: userName, pass: decrypted);
        userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
      }
    }
    // Constants.progressDialog(true, context);
  }

  void fetchUserDetails() async {
    try {
      final userDetailResult =
          await UserRepository(baseUrl: Constants.baseUrl).getUSerDetailsByUserID(userId);
      if (userDetailResult.hasData) {
        if (userDetailResult.getData!.result ?? false) {
          var tempUser = UserModel.mapper(userDetailResult.getData!.data!);
          globalUser = tempUser;
          dbHelper.insertUser(globalUser!.toJsonForInsertUsingSignInOrSignUp(), userId);
          if (preferences != null) {
            preferences?.setInt(
                Constants.measurementType, userDetailResult.getData!.data!.userMeasurementTypeID!);
          }
        }
      }
      configureResearcherProfile();
    } catch (e) {
      print(e);
    }
  }

  void popTillThis() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    savePreferences();
    getUnitFromPreferences();
  }

  void getUnitFromPreferences() {
    weightUnit = preferences?.getInt(Constants.wightUnitKey) ?? UnitTypeEnum.metric.getValue();
    heightUnit = preferences?.getInt(Constants.mHeightUnitKey) ?? UnitTypeEnum.metric.getValue();
    tempUnit = preferences?.getInt(Constants.mTemperatureUnitKey) ?? 0;
    distanceUnit = preferences?.getInt(Constants.mDistanceUnitKey) ?? 0;
    timeUnit = preferences?.getInt(Constants.mTimeUnitKey) ?? 0;
  }

  void savePreferences() {
    try {
      savePreferenceInServer();
    } catch (e) {
      debugPrint('Exception at DashBoardScreen $e');
    }
  }

  Future savePreferenceInServer() async {
    var userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
    final storeResult = await PreferenceRepository().storePreferenceSettings(userId);
    return Future.value();
  }

  void showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  List<DeviceModel> deviceList = [];

  Future<void> connectToHG(DeviceModel deviceModel) async {
    var isConnected = await connections.isConnected(deviceModel.sdkType ?? Constants.e66);
    print('initialConnection  isConnected 1 :: $isConnected');
    if (!isConnected) {
      connections.connectToDevice(deviceModel).then((value) {
        if (value) {
          print('initialConnection  connectToDevice 1 :: $value');
          connectedDeviceDash = deviceModel;
          connectedDeviceDash!.sdkType = deviceModel.sdkType ?? Constants.e66;
          connections.sdkType = deviceModel.sdkType ?? Constants.e66;
          isDeviceConnected.value = true;
          setState(() {});
        }
      });
      await Future.delayed(Duration(seconds: 7));
      var isConnected = await connections.isConnected(deviceModel.sdkType ?? Constants.e66);
      print('initialConnection  isConnected 2 :: $isConnected');
      if (isConnected) {
        connectedDeviceDash = deviceModel;
        connectedDeviceDash!.sdkType = deviceModel.sdkType ?? Constants.e66;
        connections.sdkType = deviceModel.sdkType ?? Constants.e66;
        isDeviceConnected.value = true;
        setState(() {});
      }
    }
  }

  bool isThisHG(DeviceModel deviceModel) {
    var name = (deviceModel.deviceName ?? deviceModel.friendlyName ?? '').toLowerCase();
    if (name.isNotEmpty) {
      return name.startsWith('hg') || name.startsWith('healthgauge') || name.contains('hg');
    }
    return false;
  }
}
