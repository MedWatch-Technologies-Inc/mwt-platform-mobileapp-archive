import 'package:json_annotation/json_annotation.dart';

part 'delete_contact_by_user_id_result.g.dart';

@JsonSerializable()
class DeleteContactByUserIdResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  DeleteContactByUserIdResult({
    this.result,
    this.response,
    this.message,
  });

  factory DeleteContactByUserIdResult.fromJson(Map<String, dynamic> srcJson) =>
      _$DeleteContactByUserIdResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeleteContactByUserIdResultToJson(this);
}
