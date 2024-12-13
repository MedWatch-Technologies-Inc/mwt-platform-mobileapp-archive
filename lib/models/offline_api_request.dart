import 'dart:convert';

class OfflineAPIRequest {
  int? oarId;
  Map<String, dynamic>? reqData;
  String? url;
  OfflineAPIRequest({
    this.oarId,
    required this.reqData,
    required this.url,
  });

  factory OfflineAPIRequest.fromJson(Map<String, dynamic> jsonData) {
    return OfflineAPIRequest(
      reqData: json.decode(jsonData['reqData']),
      url: jsonData['url'],
      oarId: jsonData['oarId'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oarId': oarId,
      'reqData': json.encode(reqData),
      'url': url,

    };
  }
}
