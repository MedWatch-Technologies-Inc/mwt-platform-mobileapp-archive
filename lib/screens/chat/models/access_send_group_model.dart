class AccessSendGroupModel {
  late bool result;
  late String senderUserName;
  late String groupName;
  late String message;

  AccessSendGroupModel(
      {required this.result,
      required this.senderUserName,
      required this.groupName,
      required this.message});

  AccessSendGroupModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    senderUserName = json['senderUserName'];
    groupName = json['groupName'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['senderUserName'] = this.senderUserName;
    data['groupName'] = this.groupName;
    data['Message'] = this.message;
    return data;
  }
}
