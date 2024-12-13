import 'package:json_annotation/json_annotation.dart';

part 'get_tag_label_list_request.g.dart';

@JsonSerializable()
class GetTagLabelListRequest extends Object {
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

  GetTagLabelListRequest({
    this.userID,
    this.pageIndex,
    this.pageSize,
    this.fromDate,
    this.toDate,
    this.iDs,
    this.fromDateStamp,
    this.toDateStamp,
  });

  factory GetTagLabelListRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTagLabelListRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTagLabelListRequestToJson(this);
}
