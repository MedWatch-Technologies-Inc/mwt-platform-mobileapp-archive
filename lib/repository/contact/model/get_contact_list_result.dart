import 'package:json_annotation/json_annotation.dart';

part 'get_contact_list_result.g.dart';

@JsonSerializable()
class GetContactListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'isFromDb')
  bool? isFromDb;

  @JsonKey(name: 'Data')
  List<GetContactListData>? data;

  GetContactListResult({
    this.result,
    this.response,
    this.message,
    this.data,
  });

  factory GetContactListResult.fromJson(Map<String, dynamic> srcJson) =>
      _$GetContactListResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetContactListResultToJson(this);
}

@JsonSerializable()
class GetContactListData extends Object {
  @JsonKey(name: 'ContactID')
  int? contactID;

  @JsonKey(name: 'SenderUserID')
  int? senderUserID;

  @JsonKey(name: 'ReceiverUserID')
  int? receiverUserID;

  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'Email')
  String? email;

  @JsonKey(name: 'Phone')
  String? phone;

  @JsonKey(name: 'Username')
  String? username;

  @JsonKey(name: 'Picture')
  String? picture;

  @JsonKey(name: 'IsAccepted')
  bool? isAccepted;

  @JsonKey(name: 'CreatedDatetime')
  String? createdDatetime;

  @JsonKey(name: 'AcceptedDate')
  String? acceptedDate;

  GetContactListData({
    this.contactID,
    this.senderUserID,
    this.receiverUserID,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.username,
    this.picture,
    this.isAccepted,
    this.createdDatetime,
    this.acceptedDate,
  });

  factory GetContactListData.fromJson(Map<String, dynamic> srcJson) =>
      _$GetContactListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetContactListDataToJson(this);
}
