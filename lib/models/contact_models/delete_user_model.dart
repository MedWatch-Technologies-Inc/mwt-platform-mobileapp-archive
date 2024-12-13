import 'package:health_gauge/repository/contact/model/delete_contact_by_user_id_result.dart';

class DeleteUserModel {
  bool? result;
  int? response;
  String? message;

  DeleteUserModel({this.result, this.response, this.message});

  DeleteUserModel.fromJson(Map<String, dynamic> json) {
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

  static DeleteUserModel mapper(DeleteContactByUserIdResult obj) {
    var model = DeleteUserModel();
    model
      ..message = obj.message
      ..response = obj.response
      ..result = obj.result;
    return model;
  }
}
