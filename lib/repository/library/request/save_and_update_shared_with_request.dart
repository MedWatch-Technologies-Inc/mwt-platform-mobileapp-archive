import 'package:json_annotation/json_annotation.dart';

part 'save_and_update_shared_with_request.g.dart';

@JsonSerializable()
class SaveAndUpdateSharedWithRequest extends Object {
  @JsonKey(name: 'SharedMessage')
  String? sharedMessage;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'FKLirabaryID')
  int? fKLirabaryID;

  @JsonKey(name: 'FKSharedUserID')
  List<int>? fKSharedUserID;

  @JsonKey(name: 'Accessspicefire')
  int? accessspicefire;

  @JsonKey(name: 'SavedAccessID')
  List<int>? savedAccessID;

  @JsonKey(name: 'SavedAccessChanged')
  List<int>? savedAccessChanged;

  @JsonKey(name: 'SharedDateTimeStamp')
  int? sharedDateTimeStamp;

  SaveAndUpdateSharedWithRequest({
    this.sharedMessage,
    this.userID,
    this.fKLirabaryID,
    this.fKSharedUserID,
    this.accessspicefire,
    this.savedAccessID,
    this.savedAccessChanged,
    this.sharedDateTimeStamp
  });

  factory SaveAndUpdateSharedWithRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$SaveAndUpdateSharedWithRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SaveAndUpdateSharedWithRequestToJson(this);
}
