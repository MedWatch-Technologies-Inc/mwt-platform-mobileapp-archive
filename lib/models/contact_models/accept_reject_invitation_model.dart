import 'package:health_gauge/repository/contact/model/accept_or_reject_invitation_result.dart';

class AcceptOrRejectInvitationModel {
  bool? result;
  int? response;
  String? message;

  AcceptOrRejectInvitationModel({this.result, this.response, this.message});

  AcceptOrRejectInvitationModel.fromJson(Map<String, dynamic> json) {
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

  static AcceptOrRejectInvitationModel mapper(
      AcceptOrRejectInvitationResult obj) {
    var model = AcceptOrRejectInvitationModel();
    model
      ..result = obj.result
      ..response = obj.response
      ..message = obj.message;
    return model;
  }
}
