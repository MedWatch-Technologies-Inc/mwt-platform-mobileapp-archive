import 'package:json_annotation/json_annotation.dart';

part 'store_tag_record_detail_result.g.dart';

@JsonSerializable()
class StoreTagRecordDetailResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'ID')
  int? iD;

  StoreTagRecordDetailResult({
    this.result,
    this.message,
    this.iD,
  });

  factory StoreTagRecordDetailResult.fromJson(Map<String, dynamic> srcJson) =>
      _$StoreTagRecordDetailResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreTagRecordDetailResultToJson(this);
}
