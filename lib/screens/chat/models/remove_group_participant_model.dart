class RemoveGroupParticipantModel {
  late bool result;
  late int response;
  late String message;

  RemoveGroupParticipantModel(
      {required this.result, required this.response, required this.message});

  RemoveGroupParticipantModel.fromJson(Map<String, dynamic> json) {
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
}
