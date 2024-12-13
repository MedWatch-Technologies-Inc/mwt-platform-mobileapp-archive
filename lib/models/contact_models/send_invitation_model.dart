import 'package:health_gauge/repository/contact/model/send_invitation_result.dart';

class SendInvitationModel {
  bool? result;
  int? response;
  String? message;

  SendInvitationModel({this.result, this.response, this.message});

  SendInvitationModel.fromJson(Map<String, dynamic> json) {
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

  static SendInvitationModel mapper(SendInvitationResult obj) {
    var model = SendInvitationModel();
    model
      ..response = obj.response
      ..result = obj.result
      ..message = obj.message;
    return model;
  }
}
