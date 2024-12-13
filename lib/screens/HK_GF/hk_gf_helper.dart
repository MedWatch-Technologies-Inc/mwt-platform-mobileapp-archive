import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:health_gauge/models/health_kit_or_google_fit_model.dart';
import 'package:health_gauge/repository/health_kit_or_google_fit/health_kit_google_fit_repository.dart';
import 'package:health_gauge/repository/health_kit_or_google_fit/request/save_third_party_data_type_request.dart';
import 'package:health_gauge/screens/HK_GF/helper_widgets/hk_gf_db_helper.dart';
import 'package:health_gauge/screens/HK_GF/helper_widgets/select_type_item.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HKGFHelper {
  static final HKGFHelper _instance = HKGFHelper();

  static HKGFHelper get instance => _instance;

  ValueNotifier<double> perActiveCalorie = ValueNotifier(0);
  ValueNotifier<double> perRestingCalorie = ValueNotifier(0);
  ValueNotifier<double> perWeight = ValueNotifier(0);
  ValueNotifier<double> perHeartRate = ValueNotifier(0);
  ValueNotifier<double> perSBP = ValueNotifier(0);
  ValueNotifier<double> perDBP = ValueNotifier(0);
  ValueNotifier<double> perDistance = ValueNotifier(0);
  ValueNotifier<double> perSleep = ValueNotifier(0);
  ValueNotifier<double> perStep = ValueNotifier(0);
  ValueNotifier<double> perBG = ValueNotifier(0);
  ValueNotifier<double> perTemperature = ValueNotifier(0);
  ValueNotifier<double> perOxygen = ValueNotifier(0);

  ValueNotifier<bool> hasData = ValueNotifier(true);
  RefreshController refreshController = RefreshController();
  ValueNotifier<List<HealthKitOrGoogleFitModel>> dataList = ValueNotifier([]);

  String get getUserID => preferences?.getString(Constants.prefUserIdKeyInt) ?? '';

  Future<bool> checkAuthentication() async {
    try {
      if (Platform.isAndroid) {
        var isGranted = await Permission.activityRecognition.isGranted;
        if (!isGranted) {
          isGranted = await Permission.activityRecognition.request() == PermissionStatus.granted;
        }
        if (isGranted) {
          var isAuthenticated = await connections.checkAuthForGoogleFit();
          if (!isAuthenticated) {
            return false;
          }
          return true;
        } else {
          return false;
        }
      }
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<void> fetchLocalData({
    required String typeName,
    bool isInIt = false,
    int limit = 50,
  }) async {
    try {
      if (isInIt) {
        hasData.value = true;
      }
      var healthKitOrGoogleFitData = await HKGFDBHelper.instance.getHealthKitDataByType(
        userID: getUserID,
        typeName: typeName,
        limit: limit,
        offset: isInIt ? 0 : dataList.value.length,
      );
      print('fetchLocalData :: healthKitOrGoogleFitData :: ${healthKitOrGoogleFitData.length}');
      if (healthKitOrGoogleFitData.length == limit) {
        hasData.value = true;
      } else {
        hasData.value = false;
      }
      if (isInIt) {
        dataList.value.clear();
      }
      dataList.value.addAll(healthKitOrGoogleFitData);
      print('fetchLocalData :: dataList :: ${dataList.value.length}');
      print('fetchLocalData :: dataList :: ${dataList.value.toString()}');
      dataList.notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      if (refreshController.isLoading) {
        refreshController.loadComplete();
      }
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
    }
  }

  Future<Map<String, dynamic>> fetchIndividualVital({required Vital vital, String? sDate, String? eDate}) async {
    var result = <String, dynamic>{};
    final formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
    var startDate = sDate ?? formatter.format(DateTime.now().subtract(Duration(days: 15)));
    var endDate = eDate ?? formatter.format(DateTime.now());
    switch (vital) {
      case Vital.step:
        result = await getStepData(startDate, endDate);
        break;
      case Vital.distance:
        result = await getDistanceData(startDate, endDate);
        break;
      case Vital.height:
        // TODO: Handle this case.
        break;
      case Vital.sleep:
        result = await getSleepData(startDate, endDate);
        break;
      case Vital.heartRate:
        result = await getHRData(startDate, endDate);
        break;
      case Vital.weight:
        result = await getWeightData(startDate, endDate);
        break;
      case Vital.diaBP:
        result = await getDBPData(startDate, endDate);
        break;
      case Vital.sysBP:
        result = await getSBPData(startDate, endDate);
        break;
      case Vital.bloodGlucose:
        result = await getBGData(startDate, endDate);
        break;
      case Vital.temperature:
        result = await getTemperatureData(startDate, endDate);
        break;
      case Vital.oxygen:
        result = await getOxygenData(startDate, endDate);
        break;
      case Vital.activeCalorie:
        result = await getActiveCaloriesData(startDate, endDate);
        break;
      case Vital.restingCalorie:
        result = await getRestingCaloriesData(startDate, endDate);
        break;
    }
    return result;
  }

  void fetchAllData(String startDate, String endDate) async {
    getWeightData(startDate, endDate);
    getHRData(startDate, endDate);
    getSBPData(startDate, endDate);
    getDBPData(startDate, endDate);
    getDistanceData(startDate, endDate);
    getSleepData(startDate, endDate);
    getStepData(startDate, endDate);
    getBGData(startDate, endDate);
    getTemperatureData(startDate, endDate);
    getOxygenData(startDate, endDate);
    getActiveCaloriesData(startDate, endDate);
    if (Platform.isIOS) {
      getRestingCaloriesData(startDate, endDate);
    }
  }

  Future<Map<String, dynamic>> getRestingCaloriesData(String startDate, String endDate) async {
    updatePercentage(Vital.restingCalorie, 0);
    var tempRestingCalories = await connections.readRestingEnergyBurnedDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempRestingCalories :: ${tempRestingCalories.length}');
    // print('HK_GF_Helper :: tempRestingCalories :: ${tempRestingCalories.toString()}');
    await insertHKGFData(tempRestingCalories, 'RestingCalorieBurn', Vital.restingCalorie);
    return {
      'type': Constants.healthKitRestingCalories,
      'list': tempRestingCalories,
    };
  }

  Future<Map<String, dynamic>> getActiveCaloriesData(String startDate, String endDate) async {
    updatePercentage(Vital.activeCalorie, 0);
    var tempActiveCalories = await connections.readActiveEnergyBurnedDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempActiveCalories :: ${tempActiveCalories.length}');
    // print('HK_GF_Helper :: tempActiveCalories :: ${tempActiveCalories.toString()}');
    await insertHKGFData(tempActiveCalories, 'ActiveCalorieBurn', Vital.activeCalorie);
    return {
      'type': Constants.healthKitActiveCalories,
      'list': tempActiveCalories,
    };
  }

  Future<Map<String, dynamic>> getWeightData(String startDate, String endDate) async {
    updatePercentage(Vital.weight, 0);
    var tempWeight = await connections.readBodyMassDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempWeight :: ${tempWeight.length}');
    // print('HK_GF_Helper :: tempWeight :: ${tempWeight.toString()}');
    await insertHKGFData(tempWeight, 'BodyMass', Vital.weight);
    return {
      'type': Constants.healthKitWeight,
      'list': tempWeight,
    };
  }

  Future<Map<String, dynamic>> getHRData(String startDate, String endDate) async {
    updatePercentage(Vital.heartRate, 0);
    var tempHR = await connections.readHeartRateDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempHR :: ${tempHR.length}');
    // print('HK_GF_Helper :: tempHR :: ${tempHR.toString()}');
    await insertHKGFData(tempHR, 'HeartRate', Vital.heartRate);
    return {
      'type': Constants.healthKitHr,
      'list': tempHR,
    };
  }

  Future<Map<String, dynamic>> getSBPData(String startDate, String endDate) async {
    updatePercentage(Vital.sysBP, 0);
    var tempSBP = await connections.readSystolicBloodPressureDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempSBP :: ${tempSBP.length}');
    // print('HK_GF_Helper :: tempSBP :: ${tempSBP.toString()}');
    await insertHKGFData(tempSBP, 'SystolicBloodPressure', Vital.sysBP);
    return {
      'type': Constants.healthKitSBP,
      'list': tempSBP,
    };
  }

  Future<Map<String, dynamic>> getDBPData(String startDate, String endDate) async {
    updatePercentage(Vital.diaBP, 0);
    var tempDBP = await connections.readDiastolicBloodPressureDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempDBP :: ${tempDBP.length}');
    // print('HK_GF_Helper :: tempDBP :: ${tempDBP.toString()}');
    await insertHKGFData(tempDBP, 'DiastolicBloodPressure', Vital.diaBP);
    return {
      'type': Constants.healthKitDBP,
      'list': tempDBP,
    };
  }

  Future<Map<String, dynamic>> getDistanceData(String startDate, String endDate,
      {bool showProgress = false}) async {
    updatePercentage(Vital.distance, 0);
    var tempDistance = await connections.readDistanceDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempDistance :: ${tempDistance.length}');
    // print('HK_GF_Helper :: tempDistance :: ${tempDistance.toString()}');
    await insertHKGFData(tempDistance, 'Distance', Vital.distance);
    return {
      'type': Constants.healthKitDistance,
      'list': tempDistance,
    };
  }

  Future<Map<String, dynamic>> getSleepData(String startDate, String endDate) async {
    updatePercentage(Vital.sleep, 0);
    print(startDate);
    print(endDate);
    var tempSleep = await connections.readSleepDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempSleep :: ${tempSleep.length}');
    // print('HK_GF_Helper :: tempSleep :: ${tempSleep.toString()}');
    await insertHKGFData(tempSleep, 'Sleep', Vital.sleep);
    return {
      'type': Constants.healthKitSleep,
      'list': tempSleep,
    };
  }

  Future<Map<String, dynamic>> getStepData(String startDate, String endDate) async {
    updatePercentage(Vital.step, 0);
    var tempStep = await connections.readStepDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempStep :: ${tempStep.length}');
    // print('HK_GF_Helper :: tempStep :: ${tempStep.toString()}');
    await insertHKGFData(tempStep, 'Steps', Vital.step);
    return {
      'type': Constants.healthKitStep,
      'list': tempStep,
    };
  }

  Future<Map<String, dynamic>> getBGData(String startDate, String endDate) async {
    updatePercentage(Vital.bloodGlucose, 0);
    var tempBG = await connections.readBloodGlucoseDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempBG :: ${tempBG.length}');
    // print('HK_GF_Helper :: tempBG :: ${tempBG.toString()}');
    await insertHKGFData(tempBG, 'BloodGlucose', Vital.bloodGlucose);
    return {
      'type': Constants.healthKitBloodGlucose,
      'list': tempBG,
    };
  }

  Future<Map<String, dynamic>> getTemperatureData(String startDate, String endDate) async {
    updatePercentage(Vital.temperature, 0);
    var tempTemperature = await connections.readBodyTemperatureDataFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempTemperature :: ${tempTemperature.length}');
    // print('HK_GF_Helper :: tempTemperature :: ${tempTemperature.toString()}');
    await insertHKGFData(tempTemperature, 'BodyTemperature', Vital.temperature);
    return {
      'type': Constants.healthKitTemperature,
      'list': tempTemperature,
    };
  }

  Future<Map<String, dynamic>> getOxygenData(String startDate, String endDate) async {
    updatePercentage(Vital.oxygen, 0);
    var tempOxygen = await connections.readOxygenSaturationFromHealthKitOrGoogleFit(
      startDate,
      endDate,
      showProgress: true,
    );
    print('HK_GF_Helper :: tempOxygen :: ${tempOxygen.length}');
    // print('HK_GF_Helper :: tempOxygen :: ${tempOxygen.toString()}');
    await insertHKGFData(tempOxygen, 'OxygenSaturation', Vital.oxygen);
    return {
      'type': Constants.healthKitOxygen,
      'list': tempOxygen,
    };
  }

  Future<void> insertHKGFData(List<dynamic> result, String typeName, Vital vital) async {
    try {
      if (result.isEmpty) {
        Future.delayed(Duration(seconds: 1), () {
          updatePercentage(vital, 100);
        });
        Future.delayed(Duration(seconds: 2), () {
          updatePercentage(vital, 101);
        });
        return;
      }
      var modelList = result.map((e) => HealthKitOrGoogleFitModel.fromMap(e)).toSet().toList();
      var mapList = modelList.map((e) => e.toMap()).toSet().toList();
      for (var element in mapList) {
        if (mapList.length < 10) {
          if (getPercentage(vital) < 70) {
            updatePercentage(vital, 2.5, add: 1);
          } else {
            updatePercentage(vital, 70);
          }
        }
        if (mapList.length < 20) {
          if (getPercentage(vital) < 70) {
            updatePercentage(vital, 2, add: 1);
          } else {
            updatePercentage(vital, 70);
          }
        }
        if (mapList.length < 50) {
          if (getPercentage(vital) < 70) {
            updatePercentage(vital, 1.5, add: 1);
          } else {
            updatePercentage(vital, 70);
          }
        }
        if (mapList.length < 100) {
          if (getPercentage(vital) < 70) {
            updatePercentage(vital, 0.5, add: 1);
          } else {
            updatePercentage(vital, 70);
          }
        }
        element['user_id'] = getUserID;
        element['typeName'] = typeName;
      }
      updatePercentage(vital, 80);
      await dbHelper.insertHealthKitOrGoogleFitDataList(mapList);
      updatePercentage(vital, 90);
    } catch (e) {
      print(e);
    } finally {
      Future.delayed(Duration(seconds: 1), () {
        updatePercentage(vital, 100);
      });
      Future.delayed(Duration(seconds: 2), () {
        updatePercentage(vital, 101);
      });
    }
  }

  double getPercentage(Vital vital) {
    switch (vital) {
      case Vital.step:
        return perStep.value;
      case Vital.distance:
        return perDistance.value;
      case Vital.height:
        // TODO: Handle this case.
        break;
      case Vital.sleep:
        return perSleep.value;
      case Vital.heartRate:
        return perHeartRate.value;
      case Vital.weight:
        return perWeight.value;
      case Vital.diaBP:
        return perDBP.value;
      case Vital.sysBP:
        return perSBP.value;
      case Vital.bloodGlucose:
        return perBG.value;
      case Vital.temperature:
        return perTemperature.value;
      case Vital.oxygen:
        return perOxygen.value;
      case Vital.activeCalorie:
        return perActiveCalorie.value;
      case Vital.restingCalorie:
        return perRestingCalorie.value;
    }
    return 0.0;
  }

  ValueNotifier<double> getPercentageNotifier(Vital vital) {
    switch (vital) {
      case Vital.step:
        return perStep;
      case Vital.distance:
        return perDistance;
      case Vital.height:
        // TODO: Handle this case.
        break;
      case Vital.sleep:
        return perSleep;
      case Vital.heartRate:
        return perHeartRate;
      case Vital.weight:
        return perWeight;
      case Vital.diaBP:
        return perDBP;
      case Vital.sysBP:
        return perSBP;
      case Vital.bloodGlucose:
        return perBG;
      case Vital.temperature:
        return perTemperature;
      case Vital.oxygen:
        return perOxygen;
      case Vital.activeCalorie:
        return perActiveCalorie;
      case Vital.restingCalorie:
        return perRestingCalorie;
    }
    return ValueNotifier(0.0);
  }

  void updatePercentage(Vital vital, double value, {int add = 0}) {
    switch (vital) {
      case Vital.step:
        add == 0 ? perStep.value = value : perStep.value += value;
        // print('HK/GF :: perStep :: ${perStep.value}');
        break;
      case Vital.distance:
        add == 0 ? perDistance.value = value : perDistance.value += value;
        // print('HK/GF :: perDistance :: ${perDistance.value}');
        break;
      case Vital.height:
        // TODO: Handle this case.
        break;
      case Vital.sleep:
        add == 0 ? perSleep.value = value : perSleep.value += value;
        // print('HK/GF :: perSleep :: ${perSleep.value}');
        break;
      case Vital.heartRate:
        add == 0 ? perHeartRate.value = value : perHeartRate.value += value;
        // print('HK/GF :: perHeartRate :: ${perHeartRate.value}');
        break;
      case Vital.weight:
        add == 0 ? perWeight.value = value : perWeight.value += value;
        // print('HK/GF :: perWeight :: ${perWeight.value}');
        break;
      case Vital.diaBP:
        add == 0 ? perDBP.value = value : perDBP.value += value;
        // print('HK/GF :: perDBP :: ${perDBP.value}');
        break;
      case Vital.sysBP:
        add == 0 ? perSBP.value = value : perSBP.value += value;
        // print('HK/GF :: perSBP :: ${perSBP.value}');
        break;
      case Vital.bloodGlucose:
        add == 0 ? perBG.value = value : perBG.value += value;
        // print('HK/GF :: perBG :: ${perBG.value}');
        break;
      case Vital.temperature:
        add == 0 ? perTemperature.value = value : perTemperature.value += value;
        // print('HK/GF :: perTemperature :: ${perTemperature.value}');
        break;
      case Vital.oxygen:
        add == 0 ? perOxygen.value = value : perOxygen.value += value;
        // print('HK/GF :: perOxygen :: ${perOxygen.value}');
        break;
      case Vital.activeCalorie:
        add == 0 ? perActiveCalorie.value = value : perActiveCalorie.value += value;
        // print('HK/GF :: perActiveCalorie :: ${perActiveCalorie.value}');
        break;
      case Vital.restingCalorie:
        add == 0 ? perRestingCalorie.value = value : perRestingCalorie.value += value;
        // print('HK/GF :: perRestingCalorie :: ${perRestingCalorie.value}');
        break;
    }
  }

  DateTime syncStartDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 15);
  DateTime syncEndDate = DateTime.now();
  bool isSyncing = false;

  void synchronizeHKGFData() async {
    syncEndDate = DateTime.now();
    if (syncEndDate.difference(syncStartDate).inMinutes < 15 || isSyncing) {
      return;
    }
    isSyncing = true;
    final formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
    var startDate = formatter.format(syncStartDate);
    var endDate = formatter.format(syncEndDate);
    print('Sync HealthKit/GoogleFit Request =============================');
    print('Sync HealthKit/GoogleFit $startDate -> $endDate');
    var futureList = [
      getActiveCaloriesData(startDate, endDate),
      getWeightData(startDate, endDate),
      getHRData(startDate, endDate),
      getSBPData(startDate, endDate),
      getDBPData(startDate, endDate),
      getDistanceData(startDate, endDate),
      getSleepData(startDate, endDate),
      getStepData(startDate, endDate),
      getBGData(startDate, endDate),
      getTemperatureData(startDate, endDate),
      getOxygenData(startDate, endDate),
    ];
    if (Platform.isIOS) {
      futureList.add(getRestingCaloriesData(startDate, endDate));
    }
    var result = await Future.wait(futureList);
    print('Sync HealthKit/GoogleFit Response =============================');
    if (result.isEmpty) {
      return;
    }
    var syncData = <HealthKitOrGoogleFitModel>[];
    for (var resultItem in result) {
      String resulType = resultItem['type'];
      List<dynamic> resulList = resultItem['list'];
      for (var element in resulList) {
        var index = syncData.indexWhere((e) => e.valueId == element['valueId']);
        // print('Sync HealthKit/GoogleFit :: ${element.toString()}');
        if (index == -1) {
          syncData.add(HealthKitOrGoogleFitModel(
            startTime: DateUtil().convertUtcToLocal(element['startTime']),
            endTime: DateUtil().convertUtcToLocal(element['endTime']),
            typeName: resulType,
            value: resulType == Constants.healthKitSleep
                ? DateUtil().getSleepMinitus(element)
                : double.parse(element['value'].toString()),
            valueId: element['valueId'],
          ));
        }
      }
    }
    print('Sync HealthKit/GoogleFit SyncData :: ${syncData.length}');
    if (syncData.isEmpty) {
      return;
    }
    var requestData = syncData
        .map((e) => SaveThirdPartyDataTypeRequest.fromHealthKitOrGoogleFitModel(
            getUserID, Platform.isAndroid, e))
        .toList();
    // print('Sync HealthKit/GoogleFit SyncData :: ${requestData.map(
    //   (e) => {"name": e.typeName, "value": e.value},
    // )}');
    if (requestData.isEmpty) {
      return;
    }
    await HealthKitGoogleFitRepository().saveThirdPartyDataType(requestData);
    syncStartDate = syncEndDate;
    isSyncing = false;
  }
}
