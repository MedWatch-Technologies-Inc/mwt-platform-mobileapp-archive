import 'package:json_annotation/json_annotation.dart';

part 'library_create_folder_event_request.g.dart';

@JsonSerializable()
class LibraryCreateFolderEventRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'LibraryID')
  int? libraryID;

  @JsonKey(name: 'FolderName')
  String? folderName;

  @JsonKey(name: 'FolderPath')
  String? folderPath;

  @JsonKey(name:'CreatedDateTimeStamp')
  int? createdDateTimeStamp;

  LibraryCreateFolderEventRequest({
    this.userID,
    this.libraryID,
    this.folderName,
    this.folderPath,
    this.createdDateTimeStamp
  });

  factory LibraryCreateFolderEventRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$LibraryCreateFolderEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$LibraryCreateFolderEventRequestToJson(this);
}
