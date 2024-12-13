import 'package:json_annotation/json_annotation.dart';

part 'delete_shared_event_request.g.dart';

@JsonSerializable()
class DeleteSharedEventRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'LibraryID')
  String? libraryID;

  DeleteSharedEventRequest(
    this.userID,
    this.libraryID,
  );

  factory DeleteSharedEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$DeleteSharedEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DeleteSharedEventRequestToJson(this);
}
