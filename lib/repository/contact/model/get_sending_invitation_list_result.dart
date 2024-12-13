import 'package:json_annotation/json_annotation.dart';

part 'get_sending_invitation_list_result.g.dart';

@JsonSerializable()
class GetSendingInvitationListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'Data')
  List<GetSendingInvitationListData>? data;

  GetSendingInvitationListResult({
    this.result,
    this.response,
    this.message,
    this.data,
  });

  factory GetSendingInvitationListResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetSendingInvitationListResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetSendingInvitationListResultToJson(this);
}

@JsonSerializable()
class GetSendingInvitationListData extends Object {
  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'Picture')
  String? picture;

  @JsonKey(name: 'CreatedDatetime')
  String? createdDatetime;

  @JsonKey(name: 'ReceiverEmail')
  String? receiverEmail;

  @JsonKey(name: 'ReceiverPhone')
  String? receiverPhone;

  GetSendingInvitationListData({
    this.iD,
    this.userID,
    this.firstName,
    this.lastName,
    this.picture,
    this.createdDatetime,
    this.receiverEmail,
    this.receiverPhone,
  });

  factory GetSendingInvitationListData.fromJson(Map<String, dynamic> srcJson) =>
      _$GetSendingInvitationListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetSendingInvitationListDataToJson(this);
}
