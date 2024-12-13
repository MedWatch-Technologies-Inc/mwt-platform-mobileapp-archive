
import 'package:health_gauge/models/temp_model.dart';
import 'package:health_gauge/models/bp_model.dart';
import 'package:health_gauge/models/measurement/measurement_history_model.dart';
import 'package:health_gauge/models/tag_note.dart';
import 'package:health_gauge/models/weight_measurement_model.dart';
import 'package:health_gauge/utils/date_utils.dart';
import 'package:intl/intl.dart';

import '../../repository/heart_rate_monitor/model/get_hr_data_response.dart';

class WeekAndMonthHistoryData {
      List distinctList;

     WeekAndMonthHistoryData({required this.distinctList});

  List<List<TempModel>> getOxygenAndTempData(){
    var list = <List<TempModel>>[];
    var tempList = <TempModel>[];
    DateTime date1;
    DateTime? date2;
    if(distinctList.length == 1){
      tempList.add(distinctList.first);
      list.add(tempList);
    }
    for(var i = 0; i < distinctList.length - 1; i++){
      date1 = DateFormat(DateUtil.yyyyMMddhhmm).parse(distinctList[i].date!);
      if(i != distinctList.length - 2) {
        date2 = DateFormat(DateUtil.yyyyMMddhhmm).parse(
            distinctList[i + 1].date!);
      }
      if(i == distinctList.length - 2){
        date2 = DateFormat(DateUtil.yyyyMMddhhmm).parse(
            distinctList[i + 1].date!);
        if(date1.day == date2.day) {
          tempList.add(distinctList[i]);
          tempList.add(distinctList[i+1]);
          list.add(tempList);
          tempList = [];
        } else {
          tempList.add(distinctList[i]);
          list.add(tempList);
          tempList = [];
          tempList.add(distinctList[i+1]);
          list.add(tempList);
        }

      } else if(date2 != null && date1.day == date2.day){
        tempList.add(distinctList[i]);
      } else {
        tempList.add(distinctList[i]);
        list.add(tempList);
        tempList = [];
      }
    }
    return list;
  }

  List<List<HrDataModel>> getHRData(){
        var list = <List<HrDataModel>>[];
        var tempList = <HrDataModel>[];
        DateTime date1;
        DateTime? date2;
        if(distinctList.length == 1){
          tempList.add(distinctList.first);
          list.add(tempList);
        }
        for(var i = 0; i < distinctList.length - 1; i++){
          date1 = DateFormat(DateUtil.yyyyMMddhhmm).parse(distinctList[i].date!);
          if(i != distinctList.length - 2) {
            date2 = DateFormat(DateUtil.yyyyMMddhhmm).parse(
                distinctList[i + 1].date!);
          }
          if(i == distinctList.length - 2){
            date2 = DateFormat(DateUtil.yyyyMMddhhmm).parse(
                distinctList[i + 1].date!);
            if(date1.day == date2.day) {
              tempList.add(distinctList[i]);
              tempList.add(distinctList[i+1]);
              list.add(tempList);
              tempList = [];
            } else {
              tempList.add(distinctList[i]);
              list.add(tempList);
              tempList = [];
              tempList.add(distinctList[i+1]);
              list.add(tempList);
            }

          } else if(date2 != null && date1.day == date2.day){
            tempList.add(distinctList[i]);
          } else {
            tempList.add(distinctList[i]);
            list.add(tempList);
            tempList = [];
          }
        }
        return list;
      }

      List<List<BPModel>> getBPData(){
        var list = <List<BPModel>>[];
        var tempList = <BPModel>[];
        DateTime date1;
        DateTime? date2;
        if(distinctList.length == 1){
          tempList.add(distinctList.first);
          list.add(tempList);
        }
        for(var i = 0; i < distinctList.length - 1; i++){
          date1 = DateFormat(DateUtil.yyyyMMddhhmm).parse(distinctList[i].date!);
          if(i != distinctList.length - 2) {
            date2 = DateFormat(DateUtil.yyyyMMddhhmm).parse(
                distinctList[i + 1].date!);
          }
          if(i == distinctList.length - 2){
            date2 = DateFormat(DateUtil.yyyyMMddhhmm).parse(
                distinctList[i + 1].date!);
            if(date1.day == date2.day) {
              tempList.add(distinctList[i]);
              tempList.add(distinctList[i+1]);
              list.add(tempList);
              tempList = [];
            } else {
              tempList.add(distinctList[i]);
              list.add(tempList);
              tempList = [];
              tempList.add(distinctList[i+1]);
              list.add(tempList);
            }

          } else if(date2 != null && date1.day == date2.day){
            tempList.add(distinctList[i]);
          } else {
            tempList.add(distinctList[i]);
            list.add(tempList);
            tempList = [];
          }
        }
        return list;
      }

      List<List<TagNote>> getTagData(){
        var list = <List<TagNote>>[];
        var tempList = <TagNote>[];
        DateTime date1;
        DateTime? date2;
        if(distinctList.length == 1){
          tempList.add(distinctList.first);
          list.add(tempList);
        }
        for(var i = 0; i < distinctList.length - 1; i++){
          date1 = DateFormat(DateUtil.yyyyMMddhhmmss).parse(distinctList[i].date!);
          if(i != distinctList.length - 2) {
            date2 = DateFormat(DateUtil.yyyyMMddhhmmss).parse(
                distinctList[i + 1].date!);
          }
          if(i == distinctList.length - 2){
            date2 = DateFormat(DateUtil.yyyyMMddhhmmss).parse(
                distinctList[i + 1].date!);
            if(date1.day == date2.day) {
              tempList.add(distinctList[i]);
              tempList.add(distinctList[i+1]);
              list.add(tempList);
              tempList = [];
            } else {
              tempList.add(distinctList[i]);
              list.add(tempList);
              tempList = [];
              tempList.add(distinctList[i+1]);
              list.add(tempList);
            }

          } else if(date2 != null && date1.day == date2.day){
            tempList.add(distinctList[i]);
          } else {
            tempList.add(distinctList[i]);
            list.add(tempList);
            tempList = [];
          }
        }
        return list;
      }

      List<List<WeightMeasurementModel>> getWeightData(){
        var list = <List<WeightMeasurementModel>>[];
        var tempList = <WeightMeasurementModel>[];
        DateTime date1;
        DateTime? date2;
        if(distinctList.length == 1){
          tempList.add(distinctList.first);
          list.add(tempList);
        }
        for(var i = 0; i < distinctList.length - 1; i++){
          date1 = distinctList[i].date!;
          if(i != distinctList.length - 2) {
            date2 = distinctList[i + 1].date!;
          }
          if(i == distinctList.length - 2){
            date2 = distinctList[i + 1].date!;
            if(date1.day == date2!.day) {
              tempList.add(distinctList[i]);
              tempList.add(distinctList[i+1]);
              list.add(tempList);
              tempList = [];
            } else {
              tempList.add(distinctList[i]);
              list.add(tempList);
              tempList = [];
              tempList.add(distinctList[i+1]);
              list.add(tempList);
            }

          } else if(date2 != null && date1.day == date2.day){
            tempList.add(distinctList[i]);
          } else {
            tempList.add(distinctList[i]);
            list.add(tempList);
            tempList = [];
          }
        }
        return list;
      }


      List<List<MeasurementHistoryModel>> getMeasurementData(){
        var list = <List<MeasurementHistoryModel>>[];
        var tempList = <MeasurementHistoryModel>[];
        DateTime date1;
        DateTime? date2;
        if(distinctList.length == 1){
          tempList.add(distinctList.first);
          list.add(tempList);
        }
        for(var i = 0; i < distinctList.length - 1; i++){
          date1 = DateFormat(DateUtil.yyyyMMddhhmmss).parse(distinctList[i].date!);
          if(i != distinctList.length - 2) {
            date2 = DateFormat(DateUtil.yyyyMMddhhmmss).parse(
                distinctList[i + 1].date!);
          }
          if(i == distinctList.length - 2){
            date2 = DateFormat(DateUtil.yyyyMMddhhmmss).parse(
                distinctList[i + 1].date!);
            if(date1.day == date2.day) {
              tempList.add(distinctList[i]);
              tempList.add(distinctList[i+1]);
              list.add(tempList);
              tempList = [];
            } else {
              tempList.add(distinctList[i]);
              list.add(tempList);
              tempList = [];
              tempList.add(distinctList[i+1]);
              list.add(tempList);
            }

          } else if(date2 != null && date1.day == date2.day){
            tempList.add(distinctList[i]);
          } else {
            tempList.add(distinctList[i]);
            list.add(tempList);
            tempList = [];
          }
        }
        return list;
      }
}