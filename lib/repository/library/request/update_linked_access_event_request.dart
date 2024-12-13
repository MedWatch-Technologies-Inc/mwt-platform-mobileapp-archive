import 'package:json_annotation/json_annotation.dart';

part 'update_linked_access_event_request.g.dart';

@JsonSerializable()
class UpdateLinkedAccessEventRequest extends Object {
  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'FKLirabaryID')
  int? fKLirabaryID;

  @JsonKey(name: 'OptionCopyLinkAccess')
  int? optionCopyLinkAccess;

  UpdateLinkedAccessEventRequest({
    this.userID,
    this.fKLirabaryID,
    this.optionCopyLinkAccess,
  });

  factory UpdateLinkedAccessEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$UpdateLinkedAccessEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UpdateLinkedAccessEventRequestToJson(this);
}
