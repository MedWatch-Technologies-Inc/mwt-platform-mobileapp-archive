class ListOfGroupParticipantsModel {
  late bool result;
  late int response;
  late List<GroupParticipantsData> data;

  ListOfGroupParticipantsModel(
      {required this.result, required this.response, required this.data});

  ListOfGroupParticipantsModel.fromJson(Map<String, dynamic> json) {
    result = json['Result'];
    response = json['Response'];
    if (json['Data'] != null) {
      data = <GroupParticipantsData>[];
      json['Data'].forEach((v) {
        data.add(new GroupParticipantsData.fromJson(v));
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

class GroupParticipantsData {
  int? id;
  late int userID;
  String? firstName;
  String? lastName;
  Null fullName;
  String? userName;
  Null userImage;
  bool? isActive;

  GroupParticipantsData(
      {this.id,
      required this.userID,
      this.firstName,
      this.lastName,
      this.fullName,
      this.userName,
      this.userImage,
      this.isActive});

  GroupParticipantsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['UserID'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    fullName = json['FullName'];
    userName = json['UserName'];
    userImage = json['UserImage'];
    isActive = json['IsActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['UserID'] = this.userID;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['FullName'] = this.fullName;
    data['UserName'] = this.userName;
    data['UserImage'] = this.userImage;
    data['IsActive'] = this.isActive;
    return data;
  }
}

// class ListOfGroupParticipantsModel {
//   bool result;
//   int response;
//   List<GroupParticipantsData> data;
//
//   ListOfGroupParticipantsModel({this.result, this.response, this.data});
//
//   ListOfGroupParticipantsModel.fromJson(Map<String, dynamic> json) {
//     result = json['Result'];
//     response = json['Response'];
//     if (json['Data'] != null) {
//       data = new List<GroupParticipantsData>();
//       json['Data'].forEach((v) {
//         data.add(new GroupParticipantsData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Result'] = this.result;
//     data['Response'] = this.response;
//     if (this.data != null) {
//       data['Data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class GroupParticipantsData {
//   int id;
//   int userID;
//   String firstName;
//   String lastName;
//   Null fullName;
//   String userName;
//   Null userImage;
//   bool isActive;
//
//   GroupParticipantsData(
//       {this.id,
//       this.userID,
//       this.firstName,
//       this.lastName,
//       this.fullName,
//       this.userName,
//       this.userImage,
//       this.isActive});
//
//   GroupParticipantsData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userID = json['UserID'];
//     firstName = json['FirstName'];
//     lastName = json['LastName'];
//     fullName = json['FullName'];
//     userName = json['UserName'];
//     userImage = json['UserImage'];
//     isActive = json['IsActive'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['UserID'] = this.userID;
//     data['FirstName'] = this.firstName;
//     data['LastName'] = this.lastName;
//     data['FullName'] = this.fullName;
//     data['UserName'] = this.userName;
//     data['UserImage'] = this.userImage;
//     data['IsActive'] = this.isActive;
//     return data;
//   }
// }
