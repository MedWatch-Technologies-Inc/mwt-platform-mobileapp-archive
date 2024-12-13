import 'package:health_gauge/utils/json_serializable_utils.dart';

class OTSaveResponse {
  bool result;
  int response;
  List<dynamic> ids;

  OTSaveResponse({
    required this.result,
    required this.response,
    required this.ids,
  });


  factory OTSaveResponse.fromJson(Map<String, dynamic> json) {
    return OTSaveResponse(
      result: JsonSerializableUtils.instance.checkBool(json['Result'],defaultValue: false),
      response: JsonSerializableUtils.instance.checkInt(json['Response'],defaultValue: 204),
      ids: (json['ID'] ?? []) as List<dynamic>,
    );
  }
}
