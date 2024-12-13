import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';

class MHistoryResponse {
  bool result;
  int response;
  List<MHistoryModel> data;

  MHistoryResponse({
    required this.result,
    required this.response,
    required this.data,
  });

  factory MHistoryResponse.fromJson(Map<String, dynamic> json) {
    return MHistoryResponse(
      result: JsonSerializableUtils.instance.checkBool(json['Result']),
      response: JsonSerializableUtils.instance.checkInt(json['Response']),
      data: json['Data'] is String
          ? []
          : (json['Data'] as List<dynamic>)
              .map((e) => MHistoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'response': response,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
