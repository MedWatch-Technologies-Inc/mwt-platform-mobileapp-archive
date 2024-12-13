import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_history_model.dart';
import 'package:health_gauge/screens/WeightHistory/WHistoryRepository/WHResponse/w_history_model.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';

class WHistoryResponse {
  bool result;
  int response;
  List<WHistoryModel> data;

  WHistoryResponse({
    required this.result,
    required this.response,
    required this.data,
  });

  factory WHistoryResponse.fromJson(Map<String, dynamic> json) {
    return WHistoryResponse(
      result: JsonSerializableUtils.instance.checkBool(json['Result']),
      response: JsonSerializableUtils.instance.checkInt(json['Response']),
      data: json['Data'] is String
          ? []
          : (json['Data'] as List<dynamic>)
              .map((e) => WHistoryModel.fromJson(Map<String, dynamic>.from(e as Map)))
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
