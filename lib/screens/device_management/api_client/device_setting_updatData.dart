import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UpdateDataRequest extends Object {
  @JsonKey(name: 'ID')
  int? ID;

  @JsonKey(name: 'FKUserID')
  int? FKUserID;

  @JsonKey(name: 'EditedByUserID')
  int? EditedByUserID;

  @JsonKey(name: 'wearing_method')
  String? wearing_method;

  @JsonKey(name: 'hr_monitoring_status')
  bool? hr_monitoring_status;

  @JsonKey(name: 'hr_monitoring_time_interval')
  num? hr_monitoring_time_interval;

  @JsonKey(name: 'bp_monitoring_status')
  bool? bp_monitoring_status;

  @JsonKey(name: 'bp_monitoring_time_interval')
  num? bp_monitoring_time_interval;

  @JsonKey(name: 'lift_wrist_bright')
  bool? lift_wrist_bright;

  @JsonKey(name: 'do_not_disturb')
  bool? do_not_disturb;

  @JsonKey(name: 'brightness')
  String? brightness;

  @JsonKey(name: 'temperature_monitoring_status')
  bool? temperature_monitoring_status;

  @JsonKey(name: 'temperature_monitoring_time_interval')
  num? temperature_monitoring_time_interval;

  @JsonKey(name: 'oxygen_monitoring_status')
  bool? oxygen_monitoring_status;

  @JsonKey(name: 'oxygen_monitoring_time_interval')
  num? oxygen_monitoring_time_interval;

  UpdateDataRequest({
    this.ID,
    this.FKUserID,
    this.EditedByUserID,
    this.wearing_method,
    this.hr_monitoring_status,
    this.hr_monitoring_time_interval,
    this.bp_monitoring_status,
    this.bp_monitoring_time_interval,
    this.lift_wrist_bright,
    this.do_not_disturb,
    this.brightness,
    this.temperature_monitoring_status,
    this.temperature_monitoring_time_interval,
    this.oxygen_monitoring_status,
    this.oxygen_monitoring_time_interval,
  });

  factory UpdateDataRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$UpdateDataRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UpdateDataRequestToJson(this);
}

UpdateDataRequest _$UpdateDataRequestFromJson(Map json) => UpdateDataRequest(
      ID: json['ID'] as int?,
      FKUserID: json['FKUserID'] as int?,
      EditedByUserID: json['EditedByUserID'] as int?,
      wearing_method: json['wearing_method'] as String?,
      hr_monitoring_status: json['hr_monitoring_status'] as bool?,
      hr_monitoring_time_interval: json['hr_monitoring_time_interval'] as num?,
      bp_monitoring_status: json['bp_monitoring_status'] as bool?,
      bp_monitoring_time_interval: json['bp_monitoring_time_interval'] as num?,
      lift_wrist_bright: json['lift_wrist_bright'] as bool?,
      do_not_disturb: json['do_not_disturb'] as bool?,
      brightness: json['brightness'] as String?,
      temperature_monitoring_status: json['temperature_monitoring_status'] as bool?,
      temperature_monitoring_time_interval: json['temperature_monitoring_time_interval'] as num?,
      oxygen_monitoring_status: json['oxygen_monitoring_status'] as bool?,
      oxygen_monitoring_time_interval: json['oxygen_monitoring_time_interval'] as num?,
    );

Map<String, dynamic> _$UpdateDataRequestToJson(UpdateDataRequest instance) => <String, dynamic>{
      'ID': instance.ID,
      'FKUserID': instance.FKUserID,
      'EditedByUserID': instance.EditedByUserID,
      'wearing_method': instance.wearing_method,
      'hr_monitoring_status': instance.hr_monitoring_status,
      'hr_monitoring_time_interval': instance.hr_monitoring_time_interval,
      'bp_monitoring_status': instance.bp_monitoring_status,
      'bp_monitoring_time_interval': instance.bp_monitoring_time_interval,
      'lift_wrist_bright': instance.lift_wrist_bright,
      'do_not_disturb': instance.do_not_disturb,
      'brightness': instance.brightness,
      'temperature_monitoring_status': instance.temperature_monitoring_status,
      'temperature_monitoring_time_interval': instance.temperature_monitoring_time_interval,
      'oxygen_monitoring_status': instance.oxygen_monitoring_status,
      'oxygen_monitoring_time_interval': instance.oxygen_monitoring_time_interval,
    };
