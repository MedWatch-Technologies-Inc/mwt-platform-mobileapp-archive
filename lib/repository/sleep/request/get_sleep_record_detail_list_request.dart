import 'package:json_annotation/json_annotation.dart';

part 'get_sleep_record_detail_list_request.g.dart';

@JsonSerializable()
class GetSleepRecordDetailListRequest extends Object {
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

  GetSleepRecordDetailListRequest({
    this.userID,
    this.pageIndex,
    this.pageSize,
    this.iDs,
    this.fromDate,
    this.toDate,
    this.toDateStamp,
    this.fromDateStamp,
  });

  factory GetSleepRecordDetailListRequest.fromJson(
          Map<String, dynamic> srcJson) =>
      _$GetSleepRecordDetailListRequestFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$GetSleepRecordDetailListRequestToJson(this);
}
