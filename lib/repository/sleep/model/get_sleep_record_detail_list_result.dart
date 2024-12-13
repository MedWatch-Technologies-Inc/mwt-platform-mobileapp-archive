import 'package:health_gauge/models/infoModels/sleep_info_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_sleep_record_detail_list_result.g.dart';

@JsonSerializable()
class GetSleepRecordDetailListResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<SleepInfoModel>? data;

  GetSleepRecordDetailListResult({
    this.result,
    this.response,
    this.data,
  });

  factory GetSleepRecordDetailListResult.fromJson(
      Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetSleepRecordDetailListResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetSleepRecordDetailListResultToJson(this);
}
