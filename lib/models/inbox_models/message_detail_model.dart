import 'message_list_model.dart';

class MessageDetailModel {
  bool? result;
  InboxData? data;

  MessageDetailModel({this.result, this.data});

  MessageDetailModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    data = json['Data'] != null ? new InboxData.fromJson(json['Data']) : null;
  }

}

