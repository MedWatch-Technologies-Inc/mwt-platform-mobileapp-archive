import 'package:health_gauge/screens/OxygenHistory/OTRepository/OTResponse/ot_h_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ot_h_response.g.dart';

@JsonSerializable()
class OTHistoryResponse extends Object {
  @JsonKey(name: 'Result')
  bool result;

  @JsonKey(name: 'Response')
  int response;

  @JsonKey(name: 'Data')
  List<OTHistoryModel> data;

  OTHistoryResponse(
      this.result,
      this.response,
      this.data,
      );

  factory OTHistoryResponse.fromJson(Map<String, dynamic> srcJson)
  {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$GetOTHDataResponseFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$GetOTHDataResponseToJson(this);
}
