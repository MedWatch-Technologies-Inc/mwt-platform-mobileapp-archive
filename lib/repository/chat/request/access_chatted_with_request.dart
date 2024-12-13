import 'package:json_annotation/json_annotation.dart';

part 'access_chatted_with_request.g.dart';

@JsonSerializable()
class AccessChattedWithRequest extends Object {
  @JsonKey(name: 'fromuserId')
  String? fromUserId;

  AccessChattedWithRequest({
    this.fromUserId,
  });

  factory AccessChattedWithRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$AccessChattedWithRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccessChattedWithRequestToJson(this);
}
