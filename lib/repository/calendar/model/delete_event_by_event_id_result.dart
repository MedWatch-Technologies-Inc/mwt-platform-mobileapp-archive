import 'package:json_annotation/json_annotation.dart';

part 'delete_event_by_event_id_result.g.dart';

@JsonSerializable()
class DeleteEventByEventIdResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  DeleteEventByEventIdResult({
    this.result,
    this.iD,
    this.response,
    this.message,
  });

  factory DeleteEventByEventIdResult.fromJson(Map<String, dynamic> srcJson) =>
      _$DeleteEventByEventIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeleteEventByEventIdResultToJson(this);
}
