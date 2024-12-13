import 'package:json_annotation/json_annotation.dart';

part 'calendar_event_data_result.g.dart';

@JsonSerializable()
class CalendarEventDataResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'Message')
  String? message;

  CalendarEventDataResult({
    this.result,
    this.response,
    this.iD,
    this.message,
  });

  factory CalendarEventDataResult.fromJson(Map<String, dynamic> srcJson) =>
      _$CalendarEventDataResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CalendarEventDataResultToJson(this);
}
