import 'package:json_annotation/json_annotation.dart';

part 'edit_tag_label_request.g.dart';

@JsonSerializable()
class EditTagLabelRequest extends Object {
  @JsonKey(name: 'UserID')
  String? userID;

  @JsonKey(name: 'ID')
  String? iD;

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

  @JsonKey(name: 'Short_description')
  String shortDescription = '';

  EditTagLabelRequest({
    this.userID,
    this.iD,
    this.imageName,
    this.unitName,
    this.labelName,
    this.minRange,
    this.maxRange,
    this.defaultValue,
    this.precisionDigit,
    this.fKTagLabelTypeID,
    this.isAutoLoad,
    this.shortDescription = '',
  });

  factory EditTagLabelRequest.fromJson(Map<String, dynamic> srcJson) =>
      _$EditTagLabelRequestFromJson(srcJson);

  Map<String, dynamic> toJson() => _$EditTagLabelRequestToJson(this);
}
