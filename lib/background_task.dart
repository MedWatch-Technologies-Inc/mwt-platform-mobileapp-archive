// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:health_gauge/models/device_model.dart';
import 'package:health_gauge/models/measurement/ecg_info_reading_model.dart';
import 'package:health_gauge/models/measurement/ppg_info_reading_model.dart';
import 'package:health_gauge/repository/measurement/measurement_repository.dart';
import 'package:health_gauge/repository/measurement/request/add_measurement_request.dart';
import 'package:health_gauge/utils/connections.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/gloabals.dart';

/// Added by: Akhil
/// Added on: July/29/2020
/// This class is responsible for performing ppg every hour
class BackgroundTask implements HourlyPPGListener {
  List ppgPointList = [];
  List ecgPointList = [];
  double ppgValueX = 0.0;
  double ecgValueX = 0.0;
  late String userId;
  late Connections connections;

  BackgroundTask({required this.userId, required this.connections});

  EcgInfoReadingModel? ecgInfoModel;
  PpgInfoReadingModel? ppgInfoModel;
  List ecgElapsedList = [];
  List ppgElapsedList = [];
  var startTimePpg;
  var endTimePpg;

  DeviceModel? connectedDevice;

  /// Added by: Akhil
  /// Added on: July/29/2020
  /// This function checks the connection with device,if connected then take measurement
  void startMeasurement() async {
    if (connections != null) {
      connections.hourlyPPGListener = this;
      connectedDevice = await connections.checkAndConnectDeviceIfNotConnected();
      if (connectedDevice != null) {
        connections.startMeasurement();
      }
    }
  }

  /// Added by: Akhil
  /// Added on: July/29/2020
  /// This is abstract class function which receives ppg data from device
  @override
  void onResponsePPG(PpgInfoReadingModel ppgInfoReadingModel) {
    startTimePpg = ppgInfoReadingModel.startTime;
    if (ppgValueX + 1 <= Constants.maximumReadCount) {
      endTimePpg = ppgInfoReadingModel.endTime;
      ppgInfoModel = ppgInfoReadingModel;
      ppgValueX++;
      if (ppgInfoReadingModel != null && ppgInfoReadingModel.point != null) {
        ppgPointList.add(ppgInfoReadingModel.point);
      }
      print(
          'condition $ppgValueX = ${ecgValueX >= Constants.maximumReadCount}');
    } else {
      check();
    }
  }

  @override
  void onResponseEcg(EcgInfoReadingModel ecgInfoReadingModel) {
    if (ecgValueX + 1 <= Constants.maximumReadCount) {
      ecgValueX++;
      print(
          'condition $ppgValueX = ${ppgValueX >= Constants.maximumReadCount}');
      if (ecgInfoReadingModel != null &&
          ecgInfoReadingModel.ecgPointY != null) {
        ecgPointList.add(ecgInfoReadingModel.ecgPointY);
      }
    } else {
      ecgInfoModel = ecgInfoReadingModel;
      check();
    }
  }

  Future check() async {
    if (ecgValueX >= Constants.maximumReadCount &&
        ppgValueX >= Constants.maximumReadCount) {
      connections.stopMeasurement();

      var recordId = await saveMeasurementDataToLocalStorage(isSync: false);

      bool isInternet = await Constants.isInternetAvailable();
      if (userId != null &&
          userId.isNotEmpty &&
          !userId.contains('Skip') &&
          isInternet) {

        var isGlucoseData = preferences?.getBool(Constants.isGlucoseData) ?? false  ;
        var IsResearcher =  globalUser!.isResearcherProfile! && isGlucoseData;
        print('isECGPPG ${IsResearcher}');
        var map = {
          'birthdate': '',
          'data': [
            {
              'bg_manual': 0,
              'demographics': {
                'age': 0,
                'gender': '',
                'height': 0,
                'weight': 0
              },
              'device_id': '',
              'device_type': '',
              'dias_healthgauge': 0,
              'o2_manual': 0,
              'schema': '',
              'sys_healthgauge': 0,
              'username': '',
              'model_id': 'PROTO_1',
              'isAISelected' : preferences!.getBool(Constants.isAISelected) ?? false,
              'IsResearcher': IsResearcher,
              'userID': userId,
              'raw_ecg': ecgPointList,
              'raw_ppg': ppgPointList,
              'raw_times': [],
              'hrv_device': ecgInfoModel!.hrv,
              'dias_device': ecgInfoModel!.approxDBP,
              'hr_device': ecgInfoModel!.approxHr,
              'sys_device': ecgInfoModel!.approxSBP,
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'sys_manual': 0,
              'dias_manual': 0,
              'hr_manual': 0, //ecgInfoModel.approxHr,
              'ecg_elapsed_time': [],
              'ppg_elapsed_time': [startTimePpg, endTimePpg],
              'isForHourlyHR': true,
              'IsCalibration': false,
              'isForTimeBasedPpg': true,
              'IsFromCamera': false,
            },
          ]
        };
        final estimatedResult = await MeasurementRepository()
            .getEstimate(AddMeasurementRequest.fromJson(map));
        try {
          var value = 0;
          if (estimatedResult.hasData) {
            if (estimatedResult.getData!.value != null &&
                estimatedResult.getData!.value is List &&
                estimatedResult.getData!.value[0] != null &&
                estimatedResult.getData!.value[0] is int) {
              value = estimatedResult.getData!.value[0];
            } else if (estimatedResult.getData!.value != null &&
                estimatedResult.getData!.value is int) {
              value = estimatedResult.getData!.value;
            } else if (estimatedResult.getData!.iD != null &&
                estimatedResult.getData!.iD is int) {
              value = estimatedResult.getData!.iD!;
            }
            recordId = await saveMeasurementDataToLocalStorage(
              apiId: value,
              recordId: recordId,
              isSync: true,
            );
          }
        } catch (e) {
          print(e);
        }
        // PostMeasurementData()
        //     .callApi(Constants.baseUrl + "estimate", jsonEncode(map))
        //     .then((result) async {
        //   if (!result["isError"]) {
        //     try {
        //       int value = 0;
        //       if (result["value"] is List && result["value"][0] is int) {
        //         value = result["value"][0];
        //       }
        //       if (result["value"] is int) {
        //         value = result["value"];
        //       }
        //       if (result is Map &&
        //           result["ID"] != null &&
        //           result["ID"] is int) {
        //         value = result["ID"];
        //       }
        //       recordId = await saveMeasurementDataToLocalStorage(
        //         apiId: value,
        //         recordId: recordId,
        //         isSync: true,
        //       );
        //       print("record $recordId");
        //     } catch (e) {
        //       print(e);
        //     }
        //   }
        //   return;
        // });
      }
    }
  }

  Future saveMeasurementDataToLocalStorage(
      {int? apiId, int? recordId, bool? isSync}) async {
    try {
      String strEcgList = '';
      String strPpgList = '';
      for (double value in ecgPointList) {
        strEcgList += value.toString() + ',';
      }
      if (strEcgList.isNotEmpty) {
        strEcgList = strEcgList.substring(0, strEcgList.length - 1);
        print('ecg $strEcgList');
      }

      for (double value in ppgPointList) {
        strPpgList += value.toString() + ',';
      }
      if (strPpgList.isNotEmpty) {
        strPpgList = strPpgList.substring(0, strPpgList.length - 1);
        print('ppg $strPpgList');
      }
      //endregion

      var strEcgTimeList = '';
      var strPpgTimeList = '';
      for (double value in ecgElapsedList) {
        strEcgTimeList += value.toString() + ',';
      }
      if (strEcgTimeList.isNotEmpty) {
        strEcgTimeList = strEcgTimeList.substring(0, strEcgTimeList.length - 1);
      }

      for (double value in ppgElapsedList) {
        strPpgTimeList += value.toString() + ',';
      }
      if (strPpgTimeList.isNotEmpty) {
        strPpgTimeList = strPpgTimeList.substring(0, strPpgTimeList.length - 1);
      }

      if (userId == null) {
        return Future.value();
      }
      Map<String, dynamic> map = ecgInfoModel!.toMap();
      map['ppgValue'] = ppgInfoModel!.point;
      map['user_Id'] = userId;
      map['date'] = DateTime.now().toString();
      map['ecg'] = strEcgList;
      map['ppg'] = strPpgList;
      map['tHr'] = 0;
      map['tSBP'] = 0;
      map['tDBP'] = 0;
      map['aiSBP'] = 0;
      map['aiDBP'] = 0;
      map['IsSync'] = 0;
      map['isForTimeBasedPpg'] = 1;
      if (apiId != null) {
        map['IdForApi'] = apiId;
      }
      if (recordId != null) {
        map['id'] = recordId;
      }
      var result = await dbHelper.insertMeasurementData(map, userId);
      return result;
    } on Exception catch (e) {
      print('Exception in ppg background task $e');
    }
  }
}
