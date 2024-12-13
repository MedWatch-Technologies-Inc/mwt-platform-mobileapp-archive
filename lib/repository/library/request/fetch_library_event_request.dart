import 'package:json_annotation/json_annotation.dart';

part 'fetch_library_event_request.g.dart';

@JsonSerializable()
class FetchLibraryEventRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'LibraryID')
  String? libraryID;

  FetchLibraryEventRequest({
    this.userID,
    this.libraryID,
  });

  factory FetchLibraryEventRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$FetchLibraryEventRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$FetchLibraryEventRequestToJson(this);
}
