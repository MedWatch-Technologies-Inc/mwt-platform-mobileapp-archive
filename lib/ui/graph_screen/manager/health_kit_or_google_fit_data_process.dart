import 'dart:io';

import 'package:health_gauge/models/health_kit_or_google_fit_model.dart';
import 'package:health_gauge/repository/health_kit_or_google_fit/health_kit_google_fit_repository.dart';
import 'package:health_gauge/repository/health_kit_or_google_fit/request/save_third_party_data_type_request.dart';
import 'package:health_gauge/services/logging/logging_service.dart';
import 'package:health_gauge/ui/graph_screen/manager/process_graph_item_data.dart';
import 'package:health_gauge/utils/constants.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/gloabals.dart';
import 'package:intl/intl.dart';

import '../item_value.dart';

class HealthKitOrGoogleFitDataProcess extends ProcessGraphItemData {
  final DateTime startDate;
  final DateTime endDate;
  final String userId;

  HealthKitOrGoogleFitDataProcess({required this.startDate, required this.endDate, required this.userId,required String fieldName, required bool isEnableNormalize}) : super(startDate:startDate, endDate:endDate,userId:userId,fieldName:fieldName,isEnableNormalize:isEnableNormalize);

  @override
  Future <List<ItemValue>> getItemDataHistory() async {
    var healthData;
    final formatter = DateFormat(DateUtil.yyyyMMddHHmmss);
    var tempData = <HealthKitOrGoogleFitModel>[];
    var valueList = <ItemValue>[];
    try{
      switch(fieldName) {
        case Constants.healthKitWeight : {
        healthData = await connections.readBodyMassDataFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
        }
        case Constants.healthKitHr : {
        healthData =
        await connections.readHeartRateDataFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
      }
        case Constants.healthKitSBP: {
        healthData = await connections
            .readSystolicBloodPressureDataFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
      }
        case Constants.healthKitDBP: {
        healthData = await connections
            .readDiastolicBloodPressureDataFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
      }
        case Constants.healthKitDistance: {
        healthData = await connections.readDistanceDataFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
      }
        case Constants.healthKitSleep: {
          print("healthKitSleep_000 ${startDate}  ==> ${endDate}");

          healthData = await connections.readSleepDataFromHealthKitOrGoogleFit(
              formatter.format(startDate), formatter.format(endDate));
        break;
      }
        case Constants.healthKitStep: {
        healthData = await connections.readStepDataFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
      }
        case Constants.healthKitBloodGlucose: {
        healthData =
        await connections.readBloodGlucoseDataFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
      }
        case Constants.healthKitTemperature: {
        healthData =
        await connections.readBodyTemperatureDataFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
      }
        case Constants.healthKitOxygen: {
        healthData =
        await connections.readOxygenSaturationFromHealthKitOrGoogleFit(
            formatter.format(startDate), formatter.format(endDate));
        break;
      }
    }
      print('Data:- $healthData');
      if(healthData != null) {
        for (var element in healthData) {
          var index = tempData.indexWhere((element1) =>
          element1.valueId == element['valueId']);
          if (index == -1) {
            tempData.add(HealthKitOrGoogleFitModel(
                startTime: DateUtil().convertUtcToLocal(element['startTime']),
                endTime: DateUtil().convertUtcToLocal(element['endTime']),
                typeName: fieldName,
                value:  fieldName == Constants.healthKitSleep ? DateUtil().getSleepMinitus(element)
                    : double.parse(element['value'].toString()),
                valueId: element['valueId']
            ));
          }
        }
        // if (tempData.isNotEmpty) {
        //   HealthKitGoogleFitRepository().saveThirdPartyDataType(tempData
        //       .map((e) =>
        //       SaveThirdPartyDataTypeRequest.fromHealthKitOrGoogleFitModel(
        //           userId, Platform.isAndroid, e))
        //       .toList());
        // }
      }
    } catch(e) {
     LoggingService().printLog(message: e.toString(), tag: 'getting health kit data for graph');
    }
    // List list = await dbHelper.getHealthKitOrGoogleFitDataForGraph(startDate.toString(),endDate.toString(),userId.toString(),fieldName) ?? [];
   if(fieldName == Constants.healthKitSleep) {
     valueList =
         tempData.map((e) => ItemValue.fromMap(e.toMap(), 'value', 'endTime', 'startTime', isSleep: true))
             .toList();
   } else {
     valueList =
         tempData.map((e) => ItemValue.fromMap(e.toMap(), 'value', 'startTime', 'endTime'))
             .toList();
   }
    switch(fieldName) {
      case Constants.healthKitWeight :{
       if(UnitExtension.getUnitType(weightUnit) == UnitTypeEnum.imperial){
         for(var item in valueList){
           // item.fieldName = (item.fieldName ?? 0) * 2.205;
           item.fieldName = (item.fieldName ?? 0) * 2.20462;
         }
       }
       break;
       }
      case Constants.healthKitTemperature : {
        if(tempUnit == 1){
          for(var item in valueList){
            item.fieldName = ((item.fieldName ?? 0) * 9/5) + 32;
          }
        }
        break;
      }
      case Constants.healthKitBloodGlucose : {
        if(bloodGlucoseUnit == 0) {
          for (var item in valueList) {
            item.fieldName = (item.fieldName ?? 0) / 18;
          }
        }
        break;
      }
      case Constants.healthKitDistance : {
        if(distanceUnit == 1) {
          for (var item in valueList) {
            item.fieldName = (item.fieldName ?? 0) * 0.6214;
          }
        }
        break;
      }
      }
    return valueList;
  }

}