// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

part of 'HRdata.dart';

HRdata _$HRdataFromJson(Map json) {
  return HRdata(hartRate: json["HartRate"], timestamp: json["TimeStamp"]);
}

Map<String, dynamic> _$HRdataToJson(HRdata instance) => <String, dynamic>{
      'HartRate': instance.hartRate,
      'TimeStamp': instance.timestamp,
    };
