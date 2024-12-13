// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_third_party_data_type_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaveThirdPartyDataTypeRequest _$SaveThirdPartyDataTypeRequestFromJson(
        Map json) =>
    SaveThirdPartyDataTypeRequest(
      userId: json['user_id'] as String?,
      typeName: json['typeName'] as String?,
      value: json['value'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      valueId: json['valueId'] as String?,
      isGoogleFitData: json['isGoogleFitData'] as int?,
    );

Map<String, dynamic> _$SaveThirdPartyDataTypeRequestToJson(
        SaveThirdPartyDataTypeRequest instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'typeName': instance.typeName,
      'value': instance.value,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'valueId': instance.valueId,
      'isGoogleFitData': instance.isGoogleFitData,
    };
