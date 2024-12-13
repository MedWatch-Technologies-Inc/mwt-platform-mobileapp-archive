import 'package:json_annotation/json_annotation.dart';

part 'accept_or_reject_invitation_result.g.dart';

@JsonSerializable()
class AcceptOrRejectInvitationResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  AcceptOrRejectInvitationResult({
    this.result,
    this.response,
    this.message,
  });

  factory AcceptOrRejectInvitationResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$AcceptOrRejectInvitationResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AcceptOrRejectInvitationResultToJson(this);
}
