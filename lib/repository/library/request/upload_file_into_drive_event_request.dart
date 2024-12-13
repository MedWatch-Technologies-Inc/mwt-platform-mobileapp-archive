import 'package:json_annotation/json_annotation.dart';

part 'upload_file_into_drive_event_request.g.dart';

@JsonSerializable()
class UploadFileIntoDriveEventRequest extends Object {
  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'LibraryID')
  int? libraryID;

  @JsonKey(name: 'UploadFile')
  String? uploadFile;

  @JsonKey(name:'CreatedDateTimeStamp')
  int? createdDateTimeStamp;

  UploadFileIntoDriveEventRequest({
    this.userID,
    this.libraryID,
    this.uploadFile,
    this.createdDateTimeStamp
  });

  factory UploadFileIntoDriveEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$UploadFileIntoDriveEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$UploadFileIntoDriveEventRequestToJson(this);
}
