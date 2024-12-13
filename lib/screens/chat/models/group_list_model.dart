class GroupListModel {
  late bool result;
  late int response;
  late List<Data> data;

  GroupListModel(
      {required this.result, required this.response, required this.data});

  GroupListModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = <Data>[];
      json['Data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Result'] = this.result;
    data['Response'] = this.response;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? groupName;
  String? groupParticipants;
  String? maskedGroupName;

  Data({this.id, this.groupName, this.groupParticipants, this.maskedGroupName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    groupName = json['GroupName'];
    groupParticipants = json['GroupParticipants'];
    maskedGroupName = json['MaskedGroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['GroupName'] = this.groupName;
    data['GroupParticipants'] = this.groupParticipants;
    data['MaskedGroupName'] = this.maskedGroupName;
    return data;
  }
}
