import 'package:json_annotation/json_annotation.dart';

part 'access_chatted_with_result.g.dart';

@JsonSerializable()
class AccessChattedWithResult extends Object {
  @JsonKey(name: 'Result')
  bool? result;

  @JsonKey(name: 'Response')
  int? response;

  @JsonKey(name: 'Data')
  List<AccessChattedWithData>? data;

  AccessChattedWithResult({
    this.result,
    this.response,
    this.data,
  });

  factory AccessChattedWithResult.fromJson(Map<String, dynamic> srcJson) {
    if (srcJson.containsKey('Data') &&
        srcJson['Data'] != null &&
        srcJson['Data'] is String) {
      srcJson['Data'] = [];
    }
    return _$AccessChattedWithResultFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$AccessChattedWithResultToJson(this);
}

@JsonSerializable()
class AccessChattedWithData extends Object {
  @JsonKey(name: 'UserID')
  int? userID;

  @JsonKey(name: 'FirstName')
  String? firstName;

  @JsonKey(name: 'LastName')
  String? lastName;

  @JsonKey(name: 'Username')
  String? username;

  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'isGroup')
  int? isGroup = 0;

  @JsonKey(name: 'members')
  String? members = '';

  @JsonKey(name: 'toUserId')
  int? toUserId;

  @JsonKey(name: 'groupName')
  String? groupName;

  AccessChattedWithData({
    this.userID,
    this.firstName,
    this.lastName,
    this.username,
    this.groupName,
    this.toUserId,
    this.id,
    this.isGroup,
    this.members,
  });

  factory AccessChattedWithData.fromJson(Map<String, dynamic> srcJson) =>
      _$AccessChattedWithDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AccessChattedWithDataToJson(this);

  Map<String, dynamic> toJsonToInsertInDb() => {
        'id': id,
        'IsGroup': isGroup,
        'Members': members,
        'FromUserId': userID,
        'FromFirstName': firstName,
        'FromLastName': lastName,
        'ToUserId': toUserId,
        'GroupName': groupName,
        'userName': username,
      };

  AccessChattedWithData.fromMap(Map map) {
    try {
      if (check('id', map)) {
        id = map['id'];
      }
      if (check('IsGroup', map)) {
        isGroup = map['IsGroup'];
      }
      if (check('Members', map)) {
        members = map['Members'];
      }
      if (check('FromUserId', map)) {
        userID = map['FromUserId'];
      }
      if (check('FromFirstName', map)) {
        firstName = map['FromFirstName'];
      }
      if (check('FromLastName', map)) {
        lastName = map['FromLastName'];
      }
      if (check('ToUserId', map)) {
        toUserId = map['ToUserId'];
      }
      if (check('GroupName', map)) {
        groupName = map['GroupName'];
      }
      if (check('userName', map)) {
        username = map['userName'];
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  bool check(String key, Map? map) {
    if (map != null && map.containsKey(key) && map[key] != null) {
      if (map[key] is String && map[key] == 'null') {
        return false;
      }
      return true;
    }
    return false;
  }
}
