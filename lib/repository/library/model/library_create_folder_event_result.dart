import 'package:json_annotation/json_annotation.dart';

part 'library_create_folder_event_result.g.dart';

@JsonSerializable()
class LibraryCreateFolderEventResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  LibraryCreateFolderEventResult({
    this.result,
    this.response,
    this.message,
    this.iD,
    this.createdDateTimeStamp,
  });

  factory LibraryCreateFolderEventResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$LibraryCreateFolderEventResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LibraryCreateFolderEventResultToJson(this);
}
