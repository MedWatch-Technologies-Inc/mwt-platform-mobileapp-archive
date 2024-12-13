import 'package:json_annotation/json_annotation.dart';

part 'get_tag_record_list_result.g.dart';

@JsonSerializable()
class GetTagRecordListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<GetTagRecordListData>? data;

  GetTagRecordListResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetTagRecordListResult.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetTagRecordListResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetTagRecordListResultToJson(this);
}

@JsonSerializable()
class GetTagRecordListData extends Object {
  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'FKTagLabelID')
  int? fKTagLabelID;

  @JsonKey(name: 'TagValue')
  double? tagValue;

  @JsonKey(name: 'Note')
  String? note;

  @JsonKey(name: 'FKUserID')
  int? fKUserID;

  @JsonKey(name: 'TypeName')
  String? typeName;

  @JsonKey(name: 'TotalRecords')
  int? totalRecords;

  @JsonKey(name: 'PageNumber')
  int? pageNumber;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'CreatedDateTime')
  String? createdDateTime;

  @JsonKey(name: 'hdnTagValue')
  int? hdnTagValue;

  @JsonKey(name: 'CreatedDateTimeTimestamp')
  String? createdDateTimeTimestamp;

  @JsonKey(name: 'AttachFiles')
  List<dynamic>? attachFiles;

  GetTagRecordListData(
    this.iD,
    this.fKTagLabelID,
    this.tagValue,
    this.note,
    this.fKUserID,
    this.typeName,
    this.totalRecords,
    this.pageNumber,
    this.pageSize,
    this.createdDateTime,
    this.hdnTagValue,
    this.createdDateTimeTimestamp,
    this.attachFiles,
  );

  factory GetTagRecordListData.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTagRecordListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTagRecordListDataToJson(this);
}
