import 'package:json_annotation/json_annotation.dart';

part 'get_tag_record_list_request.g.dart';

@JsonSerializable()
class GetTagRecordListRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'PageIndex')
  int? pageIndex;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'FromDate')
  String? fromDate;

  @JsonKey(name: 'ToDate')
  String? toDate;

  @JsonKey(name: 'IDs')
  List<dynamic>? iDs;

  @JsonKey(name: 'FromDateStamp')
  String? fromDateStamp;

  @JsonKey(name: 'ToDateStamp')
  String? toDateStamp;

  GetTagRecordListRequest({
    this.userID,
    this.pageIndex,
    this.pageSize,
    this.fromDate,
    this.toDate,
    this.iDs,
    this.fromDateStamp,
    this.toDateStamp,
  });

  factory GetTagRecordListRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTagRecordListRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTagRecordListRequestToJson(this);
}
