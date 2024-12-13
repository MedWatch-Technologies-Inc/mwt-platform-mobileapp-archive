import 'package:json_annotation/json_annotation.dart';

part 'store_motion_record_detail_result.g.dart';

@JsonSerializable()
class StoreMotionRecordDetailResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'ID')
  List<int>? iD;

  @JsonKey(name: 'Message')
  String? message;

  StoreMotionRecordDetailResult({
    this.result,
    this.response,
    this.iD,
    this.message,
  });

  factory StoreMotionRecordDetailResult.fromJson(
          Map<String, dynamic> srcJson) =>
      _$StoreMotionRecordDetailResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreMotionRecordDetailResultToJson(this);
}
