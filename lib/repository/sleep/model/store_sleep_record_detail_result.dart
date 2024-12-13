import 'package:json_annotation/json_annotation.dart';

part 'store_sleep_record_detail_result.g.dart';

@JsonSerializable()
class StoreSleepRecordDetailResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Message')
  String? message;

  @JsonKey(name: 'IDs')
  List<int>? id;

  StoreSleepRecordDetailResult({
    this.result,
    this.response,
    this.id,
    this.message,
  });

  factory StoreSleepRecordDetailResult.fromJson(Map<String, dynamic> srcJson) =>
      _$StoreSleepRecordDetailResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreSleepRecordDetailResultToJson(this);
}
