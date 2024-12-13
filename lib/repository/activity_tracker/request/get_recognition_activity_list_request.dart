import 'package:json_annotation/json_annotation.dart';

part 'get_recognition_activity_list_request.g.dart';

@JsonSerializable()
class GetRecognitionActivityListRequest extends Object {
  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'PageIndex')
  int? pageIndex;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'FromDate')
  String? fromDate;

  @JsonKey(name: 'ToDate')
  String? toDate;

  @JsonKey(name: 'IDs')
  List<int>? iDs;

  @JsonKey(name: 'FromDateStamp')
  String? fromDateStamp;

  @JsonKey(name: 'ToDateStamp')
  String? toDateStamp;

  GetRecognitionActivityListRequest({
    this.userID,
    this.pageIndex,
    this.pageSize,
    this.fromDate,
    this.toDate,
    this.iDs,
    this.toDateStamp,
    this.fromDateStamp,
  });

  factory GetRecognitionActivityListRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetRecognitionActivityListRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$GetRecognitionActivityListRequestToJson(this);
}
