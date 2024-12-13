import 'package:json_annotation/json_annotation.dart';

part 'send_invitation_result.g.dart';

@JsonSerializable()
class SendInvitationResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  SendInvitationResult({
    this.result,
    this.response,
    this.message,
  });

  factory SendInvitationResult.fromJson(Map<String, dynamic> srcJson) =>
      _$SendInvitationResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SendInvitationResultToJson(this);
}
