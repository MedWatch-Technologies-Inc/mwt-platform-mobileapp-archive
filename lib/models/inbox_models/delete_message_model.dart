class DeleteMessageModel {
  bool? result;
  String? message;

  DeleteMessageModel({this.result, this.message});

  DeleteMessageModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Message'] = this.message;
    return data;
  }
}