import 'package:json_annotation/json_annotation.dart';

part 'get_tag_label_list_result.g.dart';

@JsonSerializable()
class GetTagLabelListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<GetTagLabelListData>? data;

  GetTagLabelListResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetTagLabelListResult.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetTagLabelListResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetTagLabelListResultToJson(this);
}

@JsonSerializable()
class GetTagLabelListData extends Object {
  @JsonKey(name: 'ID')
  int? iD;

  @JsonKey(name: 'LabelName')
  String? labelName;

  @JsonKey(name: 'MinRange')
  double? minRange;

  @JsonKey(name: 'MaxRange')
  double? maxRange;

  @JsonKey(name: 'DefaultValue')
  double? defaultValue;

  @JsonKey(name: 'PrecisionDigit')
  double? precisionDigit;

  @JsonKey(name: 'TotalRecords')
  int? totalRecords;

  @JsonKey(name: 'PageNumber')
  int? pageNumber;

  @JsonKey(name: 'PageSize')
  int? pageSize;

  @JsonKey(name: 'UnitName')
  String? unitName;

  @JsonKey(name: 'ImageName')
  String? imageName;

  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'FKTagLabelTypeID')
  int? fKTagLabelTypeID;

  @JsonKey(name: 'CreatedDateTime')
  String? createdDateTime;

  @JsonKey(name: 'CreatedDateTimeStamp')
  String? createdDateTimeStamp;

  @JsonKey(name: 'IsAutoLoad')
  bool? isAutoLoad;

  @JsonKey(name: 'Short_description')
  String shortDescription = '';

  GetTagLabelListData({
    this.iD,
    this.labelName,
    this.minRange,
    this.maxRange,
    this.defaultValue,
    this.precisionDigit,
    this.totalRecords,
    this.pageNumber,
    this.pageSize,
    this.unitName,
    this.imageName,
    this.userID,
    this.fKTagLabelTypeID,
    this.createdDateTime,
    this.createdDateTimeStamp,
    this.isAutoLoad,
    this.shortDescription = '',
  });

  factory GetTagLabelListData.fromJson(Map<String, dynamic> srcJson) =>
      _$GetTagLabelListDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GetTagLabelListDataToJson(this);
}
