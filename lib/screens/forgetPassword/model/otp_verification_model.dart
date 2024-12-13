class OTPVerificationModel {
  bool? result;
  int? response;
  String? message;

  OTPVerificationModel({this.result, this.response, this.message});

  OTPVerificationModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Result'] = result;
    data['Response'] = response;
    data['Message'] = message;
    return data;
  }
}
