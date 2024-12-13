class SendMessageModel {
  bool? result;
  List<int>? iD;
  int? response;
  String? message;

  SendMessageModel({this.result, this.iD, this.response, this.message});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    iD = json['ID'].cast<int>();
    response = json['Response'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['ID'] = this.iD;
    data['Response'] = this.response;
    data['Message'] = this.message;
    return data;
  }
}