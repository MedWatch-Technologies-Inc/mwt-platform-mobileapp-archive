class DeleteDataModel {
  bool? result;
  int? iD;
  int? response;
  String? message;

  DeleteDataModel({this.result, this.iD, this.response, this.message});

  DeleteDataModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    iD = json['ID'];
    response = json['Response'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Result'] = result;
    data['ID'] = iD;
    data['Response'] = response;
    data['Message'] = message;
    return data;
  }
}
