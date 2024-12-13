import 'package:json_annotation/json_annotation.dart';

part 'get_motion_record_list_request.g.dart';

@JsonSerializable()
class GetMotionRecordListRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'PageIndex')
  int? pageIndex;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'IDs')
  List<dynamic>? iDs;

  @JsonKey(name: 'FromDate')
  String? fromDate;

  @JsonKey(name: 'ToDate')
  String? toDate;

  @JsonKey(name: 'FromDateStamp')
  String? fromDateStamp;

  @JsonKey(name: 'ToDateStamp')
  String? toDateStamp;

  GetMotionRecordListRequest({
    this.userID,
    this.pageIndex,
    this.pageSize,
    this.iDs,
    this.fromDate,
    this.toDate,
    this.fromDateStamp,
    this.toDateStamp,
  });

  factory GetMotionRecordListRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GetMotionRecordListRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetMotionRecordListRequestToJson(this);
}
