class SendResponseMessageModel {
  bool? result;
  List<int>? iD;
  String? message;

  SendResponseMessageModel({this.result, this.iD, this.message});

  SendResponseMessageModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    iD = json['ID'].cast<int>();
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['ID'] = this.iD;
    data['Message'] = this.message;
    return data;
  }
}