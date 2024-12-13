import 'package:json_annotation/json_annotation.dart';

part 'get_list_event_request.g.dart';

@JsonSerializable()
class GetListEventRequest extends Object {
  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'pageSize')
  int? pageSize;

  @JsonKey(name: 'pageNumber')
  int? pageNumber;

  @JsonKey(name: 'MessageTypeid')
  int? messageTypeId;

  GetListEventRequest({
    this.userID,
    this.pageSize,
    this.pageNumber,
    this.messageTypeId,
  });

  factory GetListEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GetListEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetListEventRequestToJson(this);
}
