import 'package:json_annotation/json_annotation.dart';

part 'add_tag_label_result.g.dart';

@JsonSerializable()
class AddTagLabelResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'ID')
  int? iD;

  AddTagLabelResult({
    this.result,
    this.message,
    this.iD,
  });

  factory AddTagLabelResult.fromJson(Map<String, dynamic> srcJson) =>
      _$AddTagLabelResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddTagLabelResultToJson(this);
}
