class CreateFolderModel {
  bool? result;
  int? iD;
  int? response;
  String? message;

  CreateFolderModel({this.result, this.iD, this.response, this.message});

  CreateFolderModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    iD = json['ID'];
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