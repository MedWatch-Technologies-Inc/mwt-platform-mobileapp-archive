import 'package:health_gauge/utils/json_serializable_utils.dart';

class MTResponse {
  bool? result;
  int? response;
  MTModel? data;

  MTResponse({
    required this.result,
    required this.response,
    required this.data,
  });

  factory MTResponse.fromJson(Map<String, dynamic> json) {
    return MTResponse(
      result: JsonSerializableUtils.instance.checkBool(json['Result']),
      response: JsonSerializableUtils.instance.checkInt(json['Response']),
      data: MTModel.fromJson(json['Data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Result': result,
      'Response': response,
      'Data': data,
    };
  }
}

class MTModel {
  int userID;
  int bpTimestamp;
  int hrTimestamp;
  int otTimestamp;

  MTModel({
    required this.userID,
    required this.bpTimestamp,
    required this.hrTimestamp,
    required this.otTimestamp,
  });

  factory MTModel.fromJson(Map<String, dynamic> json) {
    return MTModel(
      userID: JsonSerializableUtils.instance.checkInt(json['userid']),
      bpTimestamp: JsonSerializableUtils.instance.checkInt(json['bpTimestamp']),
      hrTimestamp: JsonSerializableUtils.instance.checkInt(json['hrTimestamp']),
      otTimestamp: JsonSerializableUtils.instance.checkInt(json['oxygenTimestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userID,
      'bpTimestamp': bpTimestamp,
      'hrTimestamp': hrTimestamp,
      'oxygenTimestamp': otTimestamp,
    };
  }

//
}
