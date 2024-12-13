import 'package:json_annotation/json_annotation.dart';

part 'add_tag_label_request.g.dart';

@JsonSerializable()
class AddTagLabelRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'ImageName')
  String? imageName;

  @JsonKey(name: 'UnitName')
  String? unitName;

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

  @JsonKey(name: 'FKTagLabelTypeID')
  int? fKTagLabelTypeID;

  @JsonKey(name: 'IsAutoLoad')
  bool? isAutoLoad;

  @JsonKey(name: 'CreatedDateTimeStamp')
  int? createdDateTimeStamp;

  @JsonKey(name: 'Short_description')
  String shortDescription = '';

  AddTagLabelRequest({
    this.userID,
    this.imageName,
    this.unitName,
    this.labelName,
    this.minRange,
    this.maxRange,
    this.defaultValue,
    this.precisionDigit,
    this.fKTagLabelTypeID,
    this.isAutoLoad,
    this.createdDateTimeStamp,
    this.shortDescription = '',
  });

  factory AddTagLabelRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$AddTagLabelRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddTagLabelRequestToJson(this);
}
