class ResetOldPasswordModel {
  bool? result;
  int? response;
  String? message;

  ResetOldPasswordModel({this.result, this.response, this.message});

  ResetOldPasswordModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Response'] = this.response;
    data['Message'] = this.message;
    return data;
  }
}