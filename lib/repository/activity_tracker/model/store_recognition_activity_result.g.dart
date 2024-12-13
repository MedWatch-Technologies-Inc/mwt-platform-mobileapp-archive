// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_recognition_activity_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreRecognitionActivityResult _$StoreRecognitionActivityResultFromJson(
        Map json) =>
    StoreRecognitionActivityResult(
      result: json['Result'] as bool?,
      response: json['Response'] as int?,
      message: json['Message'] as int?,
    );

Map<String, dynamic> _$StoreRecognitionActivityResultToJson(
        StoreRecognitionActivityResult instance) =>
    <String, dynamic>{
      'Result': instance.result,
      'Response': instance.response,
      'Message': instance.message,
    };
