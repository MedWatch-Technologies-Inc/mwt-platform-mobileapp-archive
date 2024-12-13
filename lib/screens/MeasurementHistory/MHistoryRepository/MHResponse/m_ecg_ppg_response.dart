import 'package:health_gauge/screens/MeasurementHistory/MHistoryRepository/MHResponse/m_ecg_ppg_model.dart';
import 'package:health_gauge/utils/json_serializable_utils.dart';

class MECGPPGResponse {
  bool result;
  int response;
  MECGPPGModel mECGPPGModel;

  MECGPPGResponse({
    required this.result,
    required this.response,
    required this.mECGPPGModel,
  });

  factory MECGPPGResponse.fromJson(Map<String, dynamic> json) {
    return MECGPPGResponse(
      result: JsonSerializableUtils.instance.checkBool(json['result']),
      response: JsonSerializableUtils.instance.checkInt(json['response']),
      mECGPPGModel: MECGPPGModel.fromJson(json['Data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'response': response,
      'data': mECGPPGModel.toJson(),
    };
  }
}
