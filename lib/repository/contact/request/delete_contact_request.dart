import 'package:json_annotation/json_annotation.dart';

part 'delete_contact_request.g.dart';

@JsonSerializable()
class DeleteContactRequest extends Object {
  @JsonKey(name: 'ContactFromUserID')
  String? contactFromUserID;

  @JsonKey(name: 'ContactToUserId')
  String? contactToUserId;

  DeleteContactRequest({
    this.contactFromUserID,
    this.contactToUserId,
  });

  factory DeleteContactRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$DeleteContactRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeleteContactRequestToJson(this);
}
