import 'package:json_annotation/json_annotation.dart';

part 'remove_group_participant_result.g.dart';

@JsonSerializable()
class RemoveGroupParticipantResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  RemoveGroupParticipantResult({
    this.result,
    this.response,
    this.message,
  });

  factory RemoveGroupParticipantResult.fromJson(Map<String, dynamic> srcJson) =>
      _$RemoveGroupParticipantResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$RemoveGroupParticipantResultToJson(this);
}
