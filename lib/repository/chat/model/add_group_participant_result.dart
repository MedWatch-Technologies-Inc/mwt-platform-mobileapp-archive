import 'package:json_annotation/json_annotation.dart';

part 'add_group_participant_result.g.dart';

@JsonSerializable()
class AddGroupParticipantResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  AddGroupParticipantResult({
    this.result,
    this.response,
    this.message,
  });

  factory AddGroupParticipantResult.fromJson(Map<String, dynamic> srcJson) =>
      _$AddGroupParticipantResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddGroupParticipantResultToJson(this);
}
