import 'package:health_gauge/utils/json_serializable_utils.dart';

class BPSaveResponse {
  bool result;
  List<int> ids;
  String message;

  BPSaveResponse({
    required this.result,
    required this.ids,
    required this.message,
  });

  factory BPSaveResponse.fromJson(Map<String, dynamic> json) {
    return BPSaveResponse(
      result: JsonSerializableUtils.instance.checkBool(json['Result']),
      ids: json['ID'] == null ? [] : (json['ID'] as List).map((e) => e as int).toList(),
      message: json['Message'],
    );
  }
//
}
