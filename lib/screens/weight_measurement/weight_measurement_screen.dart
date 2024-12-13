import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health_gauge/models/user_model.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/repository/preference/preference_repository.dart';
import 'package:health_gauge/repository/user/request/edit_user_request.dart';
import 'package:health_gauge/repository/user/user_repository.dart';
import 'package:health_gauge/repository/weight/request/get_weight_measurement_list_request.dart';
import 'package:health_gauge/repository/weight/request/store_weight_measurement_request.dart';
import 'package:health_gauge/repository/weight/weight_repository.dart';
import 'package:health_gauge/screens/WeightHistory/HelperWidgets/weight_toggle.dart';
import 'package:health_gauge/screens/WeightHistory/w_history_helper.dart';
import 'package:health_gauge/screens/WeightHistory/w_history_home.dart';
import 'package:health_gauge/screens/weight_measurement/weight_scale_result.dart';
import 'package:health_gauge/utils/Synchronisation/watch_sync_helper.dart';
import 'package:health_gauge/utils/concave_decoration.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:health_gauge/value/app_color.dart';
import 'package:health_gauge/value/string_localization_support/string_localization.dart';
import 'package:health_gauge/widgets/custom_toggle_container.dart';
import 'package:health_gauge/widgets/custom_dialog.dart';
import 'package:health_gauge/widgets/text_utils.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightMeasurementScreen extends StatefulWidget {
  UserModel? user;

  WeightMeasurementScreen({this.user});

  @override
  _WeightMeasurementScreenState createState() => _WeightMeasurementScreenState();
}

class _WeightMeasurementScreenState extends State<WeightMeasurementScreen>
    with SingleTickerProviderStateMixin {
  bool isOpened = false; // to check list is open or not
  bool isOpened2 = false;
  bool isWeightMeasuring =
      false; // to start or end the circular roatating feature around the weight
  String measuringStatus = stringLocalization.getText(
      StringLocalization.deviceNotConnected); // stores the measuring status of weight scale device
  String emptyData = '--.--'; //string to show when data is null
  ValueNotifier<double> weight = ValueNotifier<double>(50.0); //weight of user
  ValueNotifier<String> strWeightValue = ValueNotifier<String>('--.--'); //weight of user
  ValueNotifier<String> lastWeightMeasurementDay = ValueNotifier<String>('');
  double bMI = 15.4; // BMI of user
  static WeightMeasurementModel data = WeightMeasurementModel();

  // weight measurement model
  WeightScaleResult weightScaleResult = WeightScaleResult(); // weight scale result object
  WeightMeasurementModel lastWeightMeasurement = WeightMeasurementModel();
  bool isFirst =
      false; // to maintain that weight scale measurement data is stored only once in database

  String? userId; // user ID
  TextEditingController? weightTextEditController =
      TextEditingController(); // text controller for entering weight
  bool isInsertWeightInDatabase = false; // to check whether value is inserted in database or not
  String unit = strings.metric; // initial unit
  late String unitString; // unit in strings
  late UserModel userInsert; // user model
  Timer? _timer; // timer to generate seconds
  int countTime = 0;
  late int tempWeightUnit;

  int timerCount = 0; // counts the seconds

  // 0 for automatic and 1 for manual
  int weightConnectType =
      preferences?.getInt(Constants.weightConnectionType) ?? 0; // weight connection type

  ValueNotifier<List<List<dynamic>>> measurementDataList = ValueNotifier<List<List<dynamic>>>([]);
  bool isWeightDeviceConnected = false;

  var angle = 1.0;

  bool isIncompleteWeight = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () async {
      await getPreferences();
      if (!isWeightDeviceConnected && weightConnectType == 0) {
        connections.startScan(Constants.weightScale, isForWeightScale: true);
        //getWeightScaleData();
        connections.changeWeightScaleUnit(
            UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric ? 1 : 2);
      }
      // getWeightDataOfDay();
      unitString = UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric
          ? strings.metric
          : strings.imperial;
      userInsert = widget.user ?? UserModel();
      tempWeightUnit = weightUnit;
      measurementDataList.value = updateList(data);
      userId = globalUser?.userId;
      WeightMeasurementList();
    });
    super.initState();
  }

  Future<void> WeightMeasurementList() async {
    try {
      var response = await WeightRepository().getWeightMeasurementList(
          GetWeightMeasurementListRequest(userID: userId, pageIndex: 1, pageSize: 100, iDs: []));
      if (response.getData != null &&
          response.getData!.data != null &&
          response.getData!.data!.isNotEmpty) {
        var list = response.getData!.data!;
        var tempList = <GetWeightMeasurementListRequest>[];
        print("WeightAPI Data");
        for (var element in list) {
          print("WeightAPI Datas");
          print(element.toJson());
          var weightdata = GetWeightMeasurementListRequest.fromJson(element.toJson());

          tempList.add(weightdata);
          await dbHelper.insertUpdateWeightData(weightdata.toJson());
        }
      }
    } catch (e) {
    } finally {}
  }

  // List of all the data we are getting from weight scale device
  List<List<dynamic>> updateList(WeightMeasurementModel data) {
    var tempWeightList = <List<dynamic>>[];
    if (bMI != 0.0) {
      tempWeightList.add([
        'asset/bmi_icon.png',
        'Body Mass Index',
        bMI.toStringAsFixed(2),
      ]);
    }
    if (data.fatRate != null && data.fatRate != 0.0) {
      tempWeightList.add([
        'asset/bfr_icon.png',
        'Body Fat Ratio',
        '${data.fatRate!.toStringAsFixed(2)} %',
      ]);
    }
    if (data.muscle != null && data.muscle != 0.0) {
      tempWeightList.add([
        'asset/muscleRate.png',
        'Muscle Rate',
        '${data.muscle!.toStringAsFixed(2)} %',
      ]);
    }
    if (data.moisture != null && data.moisture != 0.0) {
      tempWeightList.add([
        'asset/bodyWater.png',
        'Body Water',
        '${data.moisture!.toStringAsFixed(2)} %',
      ]);
    }
    if (data.boneMass != null && data.boneMass != 0.0) {
      var strWeight = '--.--';
      var strUnit = UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric
          ? 'kg'
          : stringLocalization.getText(StringLocalization.lb);
      if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
        strWeight = (data.boneMass! * 2.20462).toStringAsFixed(2).padLeft(2, '0');
        // strWeight = (data.boneMass! * 2.205).toStringAsFixed(2).padLeft(2, '0');
      } else {
        strWeight = (data.boneMass!).toStringAsFixed(2).padLeft(2, '0');
      }
      tempWeightList.add([
        'asset/boneMass.png',
        'Bone Mass',
        '$strWeight $strUnit',
      ]);
    }

    if (data.bMR != null && data.bMR != 0.0) {
      tempWeightList.add([
        'asset/bmr.png',
        'Basal Metabolic',
        '${data.bMR!.toStringAsFixed(0)} kcal',
      ]);
    }

    if (data.proteinRate != null && data.proteinRate != 0.0) {
      tempWeightList.add([
        'asset/proteinRate.png',
        'Protein Rate',
        '${data.proteinRate!.toStringAsFixed(2)} %',
      ]);
    }

    if (data.visceralFat != null && data.visceralFat != 0.0) {
      tempWeightList.add([
        'asset/bfr_icon.png',
        'Visceral Fat Index',
        '${data.visceralFat!.toString()}',
      ]);
    }
    return tempWeightList;
  }

  bool errorWeight = false;
  FocusNode weightFocusNode = new FocusNode();
  bool openKeyboardWeight = false;
  String weightErrorMessage = 'Enter Weight';

  @override
  void dispose() {
    weightTextEditController?.dispose();
    if (isWeightDeviceConnected) {
      connections.disconnectWeightDevice();
    }
    super.dispose();
  }

  /// Added by Shahzad
  /// Added on 4th dec 2020
  /// New Weight scale App bar design
  @override
  Widget build(BuildContext context) {
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
            leading: IconButton(
              key: Key('weightMeasurementScreenBackButton'),
              padding: EdgeInsets.only(left: 10),
              onPressed: () {
                if (isWeightDeviceConnected) {
                  connections.disconnectWeightDevice();
                }
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
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#111B1A')
                : AppColor.backgroundColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  key: Key('weightHistoryScreen'),
                  padding: EdgeInsets.only(right: 7, left: 0),
                  icon: Image.asset(
                    Theme.of(context).brightness == Brightness.dark
                        ? 'asset/history_dark.png'
                        : 'asset/history.png',
                    height: 31,
                    width: 33,
                  ),
                  onPressed: () {
                    Constants.navigatePush(
                      WHistoryHome(),
                      context,
                    );
                    // Constants.navigatePush(
                    //     WeightMeasurementHistory(user: userInsert), context);
                  },
                ),
                Expanded(
                  child: Body1AutoText(
                    text: stringLocalization.getText(StringLocalization.weightMeasurement),
                    fontSize: 18.sp,
                    color: HexColor.fromHex('62CBC9'),
                    fontWeight: FontWeight.bold,
                    align: TextAlign.center,
                    minFontSize: 12,
                    // maxLine: 1,
                  ),
                ),
              ],
            ),
            actions: [
              weightConnectType == 1
                  ? IconButton(
                      padding: EdgeInsets.only(right: 7),
                      icon: isWeightDeviceConnected
                          ? Image.asset(
                              Theme.of(context).brightness == Brightness.dark
                                  ? 'asset/ble_enable_dark.png'
                                  : 'asset/ble_enable.png',
                              height: 32,
                              width: 32,
                            )
                          : Image.asset(
                              Theme.of(context).brightness == Brightness.dark
                                  ? 'asset/ble_disable_dark.png'
                                  : 'asset/ble_disable.png',
                              height: 32,
                              width: 32,
                            ),
                      onPressed: () {
                        isIncompleteWeight = false;
                        if (!isWeightDeviceConnected) {
                          connections.startScan(Constants.weightScale, isForWeightScale: true);
                          connections.changeWeightScaleUnit(
                              UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric ? 1 : 2);
                        }
                        if (mounted) {
                          setState(() {});
                        }
                      },
                    )
                  : Container(),
              IconButton(
                key: Key('addWeightIcon'),
                padding: EdgeInsets.only(right: 15),
                icon: Image.asset(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'asset/addWeight_dark.png'
                      : 'asset/addWeight.png',
                  height: 33,
                  width: 33,
                ),
                onPressed: () {
                  addWeightDialog(onClickAdd: () async {
                    weightUnit = tempWeightUnit;
                    await preferences?.setInt(Constants.wightUnitKey, weightUnit);
                    if (!errorWeight) {
                      openKeyboardWeight = false;
                      Navigator.of(context, rootNavigator: true).pop();
                      weight.value = double.parse(weightTextEditController!.text);
                      var weightData = WeightMeasurementModel();
                      if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
                        weight.value = double.parse(weightTextEditController!.text) / 2.20462;
                      }
                      globalUser!.weightUnit = weightUnit;
                      globalUser!.weight = weight.value.toString();
                      dbHelper.insertUser(globalUser!.toJsonForInsertUsingSignInOrSignUp(), globalUser!.id.toString());
                      userInsert = globalUser!;
                      WatchSyncHelper().dashData.weight = weight.value;
                      weightData.weightSum = weight.value;
                      bMI = calculateBMI(weightData.weightSum!);
                      weightData.bMI = bMI;
                      data = weightData;
                      lastWeightMeasurementDay.value = 'Within a day';
                      weightTextEditController?.clear();
                      measurementDataList.value = updateList(weightData);
                      var userId = preferences?.getString(Constants.prefUserIdKeyInt) ?? '';
                      await PreferenceRepository().storePreferenceSettings(userId);
                      insertMeasurementData(weightData);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
      body: bodyLayout(),
    );
  }

  /// Added by Shahzad
  /// Added on 4th dec 2020
  /// New Weight scale body design
  Widget bodyLayout() {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? HexColor.fromHex('#111B1A')
          : AppColor.backgroundColor,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            height: 210.h,
            margin: EdgeInsets.only(top: 24.h),
            child: Center(
              child: smallCircle(210.h, 186.h, 12.h, weightWidget(), true),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: measurementDataList,
              builder: (BuildContext context, List<List<dynamic>> value, Widget? child) {
                return ListView.builder(
                    itemCount: measurementDataList.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 49.h,
                        margin: EdgeInsets.only(
                            left: 33.w,
                            right: 33.w,
                            top: 17.h,
                            bottom: index == measurementDataList.value.length - 1 ? 31.h : 0.0),
                        padding: EdgeInsets.only(right: 24.w),
                        decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? HexColor.fromHex('#111B1A')
                                : AppColor.backgroundColor,
                            borderRadius: BorderRadius.circular(10.h),
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
                          child: Row(children: [
                            Expanded(
                              child: Image.asset(
                                measurementDataList.value[index][0],
                                height: 33.h,
                                width: 33.h,
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5.w),
                                child: Body1AutoText(
                                    text: measurementDataList.value[index][1],
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white.withOpacity(0.8)
                                        : HexColor.fromHex('#384341'),
                                    fontSize: 16.sp,
                                    minFontSize: 10
                                    // maxLine: 1,
                                    ),
                              ),
                              flex: 5,
                            ),
                            Expanded(
                              child: Body1AutoText(
                                text: measurementDataList.value[index][2],
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white.withOpacity(0.8)
                                    : HexColor.fromHex('#384341'),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                align: TextAlign.right,
                                minFontSize: 6,
                                // maxLine: 1,
                              ),
                              flex: 2,
                            ),
                          ]),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Added by Shahzad
  /// Added on 4th dec 2020
  /// Generic method to generate circle on screen
  Widget smallCircle(
      double outerRadius, double innerRadius, double width, Widget widget, bool isWeight) {
    return Container(
      height: outerRadius,
      width: outerRadius,
      decoration: ConcaveDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(outerRadius / 2)),
          depression: 3,
          colors: [
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.8)
                : HexColor.fromHex('#D1D9E6'),
            Theme.of(context).brightness == Brightness.dark
                ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                : Colors.white,
          ]),
      child: Stack(
        alignment: Alignment.center,
        children: [
          progressIndicator(innerRadius, width, isWeight),
          Container(
            margin: EdgeInsets.all(12.h),
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? HexColor.fromHex('#D1D9E6').withOpacity(0.1)
                    : Colors.white,
                blurRadius: 2,
                spreadRadius: 0,
                offset: Offset(-2, -2),
              ),
              BoxShadow(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black.withOpacity(0.75)
                    : HexColor.fromHex('#D1D9E6'),
                blurRadius: 2,
                spreadRadius: 0,
                offset: Offset(2, 2),
              ),
            ]),
            child: Stack(
              children: [
                Material(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? HexColor.fromHex('#111B1A')
                      : AppColor.white,
                  borderRadius: BorderRadius.circular(innerRadius),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(Theme.of(context).brightness == Brightness.dark
                        ? 'asset/weight_background_dark.png'
                        : 'asset/weight_background.png'),
                  ),
                ),
                Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
                  widget,
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Added by Shahzad
  /// Added on 7th dec 2020
  /// Weight widget to show weight details on circle
  Widget weightWidget() {
    return Container(
      width: 186.h,
      height: 186.h,
      child: Column(
        children: [
          SizedBox(height: 25.24.h),
          SizedBox(
            height: 80.h,
            width: 80.h,
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'asset/weight_large_icon_dark.png'
                  : 'asset/weight_large_icon.png',
            ),
          ),
          Container(
            width: 100.w,
            height: 31.5.h,
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: weight,
                builder: (BuildContext context, double value, Widget? child) {
                  return Body1AutoText(
                    text: weightText(),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                    align: TextAlign.center,
                    minFontSize: 10,
                    // maxLine: 1,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 5.h),
          ValueListenableBuilder(
            valueListenable: lastWeightMeasurementDay,
            builder: (BuildContext context, value, Widget? child) {
              return Container(
                height: (lastWeightMeasurementDay.value.trim().isEmpty) ? 0 : 17.h,
                width: 80.h,
                child: Center(
                  child: Body1AutoText(
                    text: lastWeightMeasurementDay.value,
                    fontSize: 12.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                        : HexColor.fromHex('#384341'),
                    // maxLine: 1,
                    align: TextAlign.center,
                    minFontSize: 8,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Added by Shahzad
  /// Added on 4th dec 2020
  /// Widget to show progress color on circle
  Widget progressIndicator(double rad, double width, bool isWeight) {
    if (isWeight && isWeightMeasuring) {
      return Container(
        height: rad,
        width: rad,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CircularProgressIndicator(
          strokeWidth: 22.h,
          valueColor: AlwaysStoppedAnimation<Color>(HexColor.fromHex('62CBC9')),
        ),
      );
    }
    return Container();
  }

  String weightText() {
    var strUnit = UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.metric
        ? 'kg'
        : stringLocalization.getText(StringLocalization.lb);
    try {
      if (UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial) {
        strWeightValue.value = (weight.value * 2.20462).toStringAsFixed(1);
      } else {
        strWeightValue.value = (weight.value).toStringAsFixed(1);
      }
    } catch (e) {
      print(e);
    }
    strWeightValue.value = '${strWeightValue.value} $strUnit';
    return strWeightValue.value;
  }

  void setWeightScaleUserDetails(UserModel? user) async {
    try {
      if (user != null) {
        var height = 0;
        var weight = 0;
        height = double.parse(user.height ?? '150').toInt();
        weight = double.parse(user.weight ?? '50').round();
        var userDetails = {
          'sex': user.gender == 'M' ? 1 : 2,
          'height': height,
          'weight': weight,
          'age': calculateAge(user.dateOfBirth!),
        };
        connections.setWeightScaleUserDetails(userDetails);
      }
    } catch (e) {
      print(e);
    }
  }

  Future checkForUser(WeightMeasurementModel weightMeasurementModel) async {
    try {
      if (lastWeightMeasurement.weightSum != null) {
        var weightDifference =
            (lastWeightMeasurement.weightSum! - weightMeasurementModel.weightSum!).abs();
        if (weightDifference >= 5) {
          saveDataDialog(onClickYes: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await insertMeasurementData(weightMeasurementModel);
          });
        } else {
          await insertMeasurementData(weightMeasurementModel);
        }
      } else {
        await insertMeasurementData(weightMeasurementModel);
      }
    } on Exception catch (e) {
      print(e);
    }
    return Future.value();
  }

  void addWeightDialog({required GestureTapCallback onClickAdd}) {
    var dialogWeight = tempWeightUnit;
    showDialog(
            context: context,
            useRootNavigator: true,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
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
                            ]),
                        padding: EdgeInsets.only(top: 27.h, left: 26.w, right: 26.w),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25.h,
                                child: Body1AutoText(
                                  text: StringLocalization.of(context)
                                      .getText(StringLocalization.weight),
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                      : HexColor.fromHex('#384341'),
                                  minFontSize: 10,
                                  // maxLine: 1,
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                    top: 16.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Body1AutoText(
                                          text: StringLocalization.of(context)
                                              .getText(StringLocalization.addWeightDescription),
                                          maxLine: 1,
                                          fontSize: 16.sp,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? HexColor.fromHex('#FFFFFF').withOpacity(0.87)
                                              : HexColor.fromHex('#384341')),
                                      SizedBox(height: 12.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              //height: 48.h,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).brightness ==
                                                          Brightness.dark
                                                      ? HexColor.fromHex('#111B1A')
                                                      : AppColor.backgroundColor,
                                                  borderRadius: BorderRadius.circular(10.h),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? HexColor.fromHex('#D1D9E6')
                                                              .withOpacity(0.1)
                                                          : Colors.white.withOpacity(0.7),
                                                      blurRadius: 4,
                                                      spreadRadius: 0,
                                                      offset: Offset(-4, -4),
                                                    ),
                                                    BoxShadow(
                                                      color: Theme.of(context).brightness ==
                                                              Brightness.dark
                                                          ? Colors.black.withOpacity(0.75)
                                                          : HexColor.fromHex('#9F2DBC')
                                                              .withOpacity(0.15),
                                                      blurRadius: 4,
                                                      spreadRadius: 0,
                                                      offset: Offset(4, 4),
                                                    ),
                                                  ]),
                                              child: GestureDetector(
                                                key: Key('weightDialog'),
                                                onTap: () {
                                                  errorWeight = false;
                                                  weightFocusNode.requestFocus();
                                                  openKeyboardWeight = true;
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                                                  decoration: openKeyboardWeight
                                                      ? ConcaveDecoration(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(10.h)),
                                                          depression: 7,
                                                          colors: [
                                                              Theme.of(context).brightness ==
                                                                      Brightness.dark
                                                                  ? Colors.black.withOpacity(0.5)
                                                                  : HexColor.fromHex('#D1D9E6'),
                                                              Theme.of(context).brightness ==
                                                                      Brightness.dark
                                                                  ? HexColor.fromHex('#D1D9E6')
                                                                      .withOpacity(0.07)
                                                                  : Colors.white,
                                                            ])
                                                      : BoxDecoration(
                                                          borderRadius: BorderRadius.all(
                                                              Radius.circular(10.h)),
                                                          color: Theme.of(context).brightness ==
                                                                  Brightness.dark
                                                              ? HexColor.fromHex('#111B1A')
                                                              : AppColor.backgroundColor,
                                                        ),
                                                  child: IgnorePointer(
                                                    ignoring: openKeyboardWeight ? false : true,
                                                    child: TextFormField(
                                                      focusNode: weightFocusNode,
                                                      controller: weightTextEditController,
                                                      style: TextStyle(fontSize: 16.0.sp),
                                                      decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          focusedBorder: InputBorder.none,
                                                          enabledBorder: InputBorder.none,
                                                          errorBorder: InputBorder.none,
                                                          disabledBorder: InputBorder.none,
                                                          hintText: errorWeight
                                                              ? weightErrorMessage
                                                              : StringLocalization.of(context)
                                                                  .getText(
                                                                      StringLocalization.weight),
                                                          hintStyle: TextStyle(
                                                              color: errorWeight
                                                                  ? HexColor.fromHex('FF6259')
                                                                  : Theme.of(context).brightness ==
                                                                          Brightness.dark
                                                                      ? Colors.white
                                                                          .withOpacity(0.38)
                                                                      : HexColor.fromHex('7F8D8C'),
                                                              fontSize: 16.sp)),
                                                      keyboardType: TextInputType.number,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 17.w),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: 48.h,
                                              child: WeightToggle(
                                                  selectedUnit: dialogWeight,
                                                  unitText1: StringLocalization.of(context)
                                                      .getText(StringLocalization.kg),
                                                  unitText2: StringLocalization.of(context)
                                                      .getText(StringLocalization.lb),
                                                  width: 62.w,
                                                  unit1Selected: () {
                                                    if (dialogWeight != 1) {
                                                      dialogWeight = 1;
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    }
                                                  },
                                                  unit2Selected: () {
                                                    if (dialogWeight != 2) {
                                                      dialogWeight = 2;
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    }
                                                  }),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 30.h),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: GestureDetector(
                                                  key: Key('addWeightButton'),
                                                  child: Container(
                                                    height: 34.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(30.h),
                                                        color: HexColor.fromHex('#00AFAA'),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Theme.of(context).brightness ==
                                                                    Brightness.dark
                                                                ? HexColor.fromHex('#D1D9E6')
                                                                    .withOpacity(0.1)
                                                                : Colors.white,
                                                            blurRadius: 5,
                                                            spreadRadius: 0,
                                                            offset: Offset(-5, -5),
                                                          ),
                                                          BoxShadow(
                                                            color: Theme.of(context).brightness ==
                                                                    Brightness.dark
                                                                ? Colors.black.withOpacity(0.75)
                                                                : HexColor.fromHex('#D1D9E6'),
                                                            blurRadius: 5,
                                                            spreadRadius: 0,
                                                            offset: Offset(5, 5),
                                                          ),
                                                        ]),
                                                    child: Container(
                                                      decoration: ConcaveDecoration(
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(30.h),
                                                          ),
                                                          depression: 10,
                                                          colors: [
                                                            Colors.white,
                                                            HexColor.fromHex('#D1D9E6'),
                                                          ]),
                                                      child: Center(
                                                        child: Text(
                                                          stringLocalization
                                                              .getText(StringLocalization.add)
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 14.sp,
                                                            fontWeight: FontWeight.bold,
                                                            color: Theme.of(context).brightness ==
                                                                    Brightness.dark
                                                                ? HexColor.fromHex('#111B1A')
                                                                : Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    errorWeight = false;
                                                    validateWeight();
                                                    if (!errorWeight) {
                                                      tempWeightUnit = dialogWeight;
                                                      onClickAdd();
                                                    } else {
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    }
                                                  })),
                                          SizedBox(width: 17.w),
                                          Expanded(
                                            child: GestureDetector(
                                              key: Key('cancelWeightButton'),
                                              child: Container(
                                                height: 34.h,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30.h),
                                                    color: HexColor.fromHex('#FF6259')
                                                        .withOpacity(0.8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? HexColor.fromHex('#D1D9E6')
                                                                .withOpacity(0.1)
                                                            : Colors.white,
                                                        blurRadius: 5,
                                                        spreadRadius: 0,
                                                        offset: Offset(-5, -5),
                                                      ),
                                                      BoxShadow(
                                                        color: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? Colors.black.withOpacity(0.75)
                                                            : HexColor.fromHex('#D1D9E6'),
                                                        blurRadius: 5,
                                                        spreadRadius: 0,
                                                        offset: Offset(5, 5),
                                                      ),
                                                    ]),
                                                child: Container(
                                                  decoration: ConcaveDecoration(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(30.h),
                                                      ),
                                                      depression: 10,
                                                      colors: [
                                                        Colors.white,
                                                        HexColor.fromHex('#D1D9E6'),
                                                      ]),
                                                  child: Center(
                                                    child: Text(
                                                      stringLocalization
                                                          .getText(StringLocalization.cancel)
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).brightness ==
                                                                Brightness.dark
                                                            ? HexColor.fromHex('#111B1A')
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                weightTextEditController?.clear();
                                                weightErrorMessage = 'Enter Weight';
                                                errorWeight = false;
                                                openKeyboardWeight = false;
                                                // tempWeightUnit = dialogWeight;
                                                // weightUnit = tempWeightUnit;
                                                Navigator.of(context, rootNavigator: true).pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 25.h,
                              )
                            ])));
              });
            },
            barrierDismissible: false)
        .then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  bool validateWeightRegex(String value) {
    Pattern pattern = r'^[0-9]{1,3}(\.[0-9]{1,2})?$';
    var regex = new RegExp(pattern.toString());
    return regex.hasMatch(value);
  }

  validateWeight() {
    if (weightTextEditController != null && weightTextEditController!.text.isEmpty) {
      errorWeight = true;
    }
    if (weightTextEditController != null) {
      if (!validateWeightRegex(weightTextEditController!.text)) {
        errorWeight = true;
        weightErrorMessage = 'Enter valid weight';
        weightTextEditController!.text = '';
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  saveDataDialog({required GestureTapCallback onClickYes}) {
    var dialog = CustomDialog(
      title: 'Weight measured is different',
      subTitle: 'Do you want to save data?',
      maxLine: 2,
      secondaryButton: stringLocalization.getText(StringLocalization.no).toUpperCase(),
      onClickNo: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
      onClickYes: onClickYes,
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

  Future insertMeasurementData(WeightMeasurementModel weightMeasurementModel) async {
    try {
      //  postWeightDataInHealthKitOrGoogleFit(weightMeasurementModel);
      weightMeasurementModel.isSync = 0;
      if (userId == null) {
        await getPreferences();
      }
      globalUser?.weight = weightMeasurementModel.weightSum!.toStringAsFixed(2);

      saveProfileData();
      weightMeasurementModel.date = DateTime.now();
      bMI = weightMeasurementModel.bMI!;

      if (bMI < 1) {
        WeightMeasurementDialog();

        bMI = calculateBMI(weightMeasurementModel.weightSum!);
        weightMeasurementModel.bMI = bMI;
        measurementDataList.value = updateList(weightMeasurementModel);
        //setState(() {});
      }
      var map = weightMeasurementModel.toJson();
      map['UserId'] = userId;
      map['UserID'] = userId;
      var value = await dbHelper.insertUpdateWeightData(map);
      weightMeasurementModel.id = value;
      await postWeightDataToApi(weightMeasurementModel);
      isInsertWeightInDatabase = false;
      isFirst = false;
      if (mounted) {
        setState(() {});
      }
      // Future.delayed(Duration(seconds: 1)).then((value) {
      //   CustomSnackBar.buildSnackbar(context, 'Saved weight measurement successfully', 3);
      // });
      //  isInsertWeightInDatabase = true;
      lastWeightMeasurement = data;
    } on Exception catch (e) {
      print(e);
    }
    return Future.value();
  }

  void WeightMeasurementDialog() {
    var dialog = CustomInfoDialog(
      subTitle: StringLocalization.of(context).getText(StringLocalization.weightMeasurementDialog),
      primaryButton: StringLocalization.of(context).getText(StringLocalization.ok),
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

  Future<void> postWeightDataToApi(WeightMeasurementModel weightMeasurementModel) async {
    var isInternet = await Constants.isInternetAvailable();
    if (userId != null && userId!.isNotEmpty && !userId!.contains('Skip') && isInternet) {
      var map = <String, dynamic>{
        'userId': userId!,
        'weightsum': weightMeasurementModel.weightSum ?? 0,
        'bMI': weightMeasurementModel.bMI ?? 0,
        'fatRate': weightMeasurementModel.fatRate,
        'muscle': weightMeasurementModel.muscle,
        'moisture': weightMeasurementModel.moisture,
        'boneMass': weightMeasurementModel.boneMass,
        'subcutaneousFat': weightMeasurementModel.subcutaneousFat,
        'bMR': weightMeasurementModel.bMR,
        'proteinRate': weightMeasurementModel.proteinRate,
        'visceralFat': weightMeasurementModel.visceralFat,
        'physicalAge': weightMeasurementModel.physicalAge,
        'standardWeight': weightMeasurementModel.standardWeight,
        'weightControl': weightMeasurementModel.weightControl,
        'fatMass': weightMeasurementModel.fatMass,
        'weightWithoutFat': weightMeasurementModel.weightWithoutFat,
        'muscleMass': weightMeasurementModel.muscleMass,
        'proteinMass': weightMeasurementModel.proteinMass,
        'fatlevel': weightMeasurementModel.fatLevel,
        'CreatedDateTime': weightMeasurementModel.date.toString(),
        'CreatedDateTimeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      try {
        final result = await WeightRepository()
            .storeWeightMeasurement([StoreWeightMeasurementRequest.fromJson(map)]);
        if (result.hasData) {
          if (result.getData!.result ?? false) {
            if (result.getData!.iD != null) {
              weightMeasurementModel.idForApi = result.getData!.iD![0];
              weightMeasurementModel.isSync = 1;
              var dbMap = weightMeasurementModel.toJson();
              dbMap['UserID'] = userId;
              dbHelper.insertUpdateWeightData(dbMap);
            }
          }
        } else {}
        // await PostWeightMeasurementData()
        //     .callApi(
        //         Constants.baseUrl + 'StoreWeightMeasurement', jsonEncode(map))
        //     .then((result) async {
        //   if (result['ID'] is int) {
        //     weightMeasurementModel.idForApi = result['ID'];
        //     weightMeasurementModel.isSync = 1;
        //     Map<String, dynamic> dbMap = weightMeasurementModel.toJson();
        //     dbMap['UserID'] = userId;
        //     dbHelper.insertUpdateWeightData(dbMap);
        //   }
        // });
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  calculateAge(DateTime birthDate) {
    var currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    var month1 = currentDate.month;
    var month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = currentDate.day;
      var day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  Future<void> getPreferences() async {
    preferences ??= await SharedPreferences.getInstance();
    weightUnit = preferences?.getInt(Constants.wightUnitKey) ?? 1;
    userId = preferences?.getString(Constants.prefUserIdKeyInt);
    if (userId != null) {
      dbHelper.getUser(userId!).then((value) {
        if (value != null) {
          widget.user = value;
          setWeightScaleUserDetails(value);
        }
      });
    }
    weight.value = double.tryParse(widget.user?.weight ?? '50') ?? 50.0;
    bMI = calculateBMI(weight.value);
    var lastRecordList = await WHistoryHelper().getLastRecord();
    if (lastRecordList.isNotEmpty) {
      var lastRecord = lastRecordList.first;
      var lastRecordDate = lastRecord.createdDateTimeStamp;
      lastWeightMeasurementDay.value =
          DateUtil().getDateDifferenceMilli(milliseconds: lastRecordDate);
    }
  }

  // void getWeightDataOfDay() async {
  //   await getPreferences();
  //   if (userId != null) {
  //     await dbHelper
  //         .getLastSavedWeightData(userId!)
  //         .then((List<WeightMeasurementModel> weightMeasurementModelList) {
  //       if (weightMeasurementModelList.isNotEmpty) {
  //         data = weightMeasurementModelList.first;
  //         lastWeightMeasurement = weightMeasurementModelList.first;
  //         bMI = data.bMI!;
  //         weight = data.weightSum!;
  //         if (data.date != null) {
  //           lastWeightMeasurementDay = DateUtil().getDateDifference(data.date!);
  //         }
  //         measurementDataList = updateList(data);
  //       }
  //       measurementDataList = updateList(data);
  //       if (mounted) {
  //         setState(() {});
  //       }
  //     });
  //   }
  // }

  double calculateBMI(double weight) {
    var bMI = 15.4;
    try {
      if (widget.user != null && widget.user!.height != null) {
        var ht = double.parse(widget.user!.height!) / 100;
        bMI = (weight / (ht * ht));
        print(bMI);
      }
    } on Exception catch (e) {
      print(e);
    }
    return bMI;
  }

  Future<void> saveProfileData() async {
    var isInternet = await Constants.isInternetAvailable();
    if (globalUser != null && globalUser!.userId != null) {
      await dbHelper.insertUser(
          globalUser!.toJsonForInsertUsingSignInOrSignUp(), globalUser!.userId!);
    }
    if (isInternet) {
      // postDataToAPI();
    }
  }
}
