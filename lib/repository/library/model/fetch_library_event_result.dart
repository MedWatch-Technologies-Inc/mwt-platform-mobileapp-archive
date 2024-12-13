import 'package:json_annotation/json_annotation.dart';

part 'fetch_library_event_result.g.dart';

@JsonSerializable()
class FetchLibraryEventResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'Data')
  List<FetchLibraryEventData>? data;

  FetchLibraryEventResult({
    this.result,
    this.response,
    this.message,
    this.data,
  });

  factory FetchLibraryEventResult.fromJson(Map<String, dynamic> srcJson) =>
      _$FetchLibraryEventResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FetchLibraryEventResultToJson(this);
}

@JsonSerializable()
class FetchLibraryEventData extends Object {
  @JsonKey(name: 'LibraryID')
  int? libraryID;

  @JsonKey(name: 'VirtualFilePath')
  String? virtualFilePath;

  @JsonKey(name: 'PhysicalFilePath')
  String? physicalFilePath;

  @JsonKey(name: 'CreatedDateTime')
  String? createdDateTime;

  @JsonKey(name: 'ParentID')
  int? parentID;

  @JsonKey(name: 'FileSize')
  String? fileSize;

  @JsonKey(name: 'IsFolder')
  bool? isFolder;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  FetchLibraryEventData({
    this.libraryID,
    this.virtualFilePath,
    this.physicalFilePath,
    this.createdDateTime,
    this.parentID,
    this.fileSize,
    this.isFolder,
  });

  factory FetchLibraryEventData.fromJson(Map<String, dynamic> srcJson) =>
      _$FetchLibraryEventDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FetchLibraryEventDataToJson(this);
}
