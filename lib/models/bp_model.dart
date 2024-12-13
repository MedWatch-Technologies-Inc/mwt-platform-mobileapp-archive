import 'package:health_gauge/utils/date_utils.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';

class BPModel{
  num? id;
  num? idForApi;
  String? userId;
  String? date;
  num? bloodDBP;
  num? bloodSBP;

  BPModel.clone(BPModel model){
    id = model.id;
    idForApi = model.idForApi;
    userId = model.userId;
    date = model.date;
    bloodDBP = model.bloodDBP;
    bloodSBP = model.bloodSBP;
  }
  BPModel.fromMap(Map map){
    if(map['id'] is num){
      id = map['id'];
    }
    if(map['idForApi'] is num){
      idForApi = map['idForApi'];
    }
    if(map['userId'] is String){
      userId = map['userId'];
    }


    if(map['bloodDBP'] is num){
      bloodDBP = map['bloodDBP'];
    }
    if(map['bloodSBP'] is num){
      bloodSBP = map['bloodSBP'];
    }
    if((bloodSBP??0) < (bloodDBP??0)){
      bloodDBP = map['bloodSBP'];
      bloodSBP = map['bloodDBP'];
    }
    date = DateUtil.parse(map['bloodStartTime'])?.millisecondsSinceEpoch.toString();
    date ??= DateUtil.parse(map['date'])?.millisecondsSinceEpoch.toString();
  }

  Map<String,dynamic> toMap(){
    return {
      'idForApi':idForApi,
      'userId':userId,
      'date':date,
      'bloodDBP':bloodDBP,
      'bloodSBP':bloodSBP
    };
  }
}